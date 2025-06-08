import time
import csv
from adafruit_servokit import ServoKit

class PWMPlayer:
    def __init__(self, address=0x41, pwm_min=450, pwm_max=2450):
        self.kit = ServoKit(channels=16, address=address)
        self.pwm_min = pwm_min
        self.pwm_max = pwm_max

        # Configure pulse width range for all 12 channels
        for ch in range(12):
            self.kit.servo[ch].set_pulse_width_range(pwm_min, pwm_max)

    def play_gait(self, csv_path, loop=False):
        """
        Plays the gait from the CSV file.
        Each row = 12 PWM values + 1 delay in milliseconds.
        """
        with open(csv_path, 'r') as f:
            reader = csv.reader(f)
            pwm_rows = [list(map(int, row)) for row in reader]

        print(f"🔁 Playing gait from {csv_path} with {len(pwm_rows)} steps")

        try:
            while True:
                for row in pwm_rows:
                    pwm_values = row[:12]
                    delay_ms = row[12]

                    for ch, pwm in enumerate(pwm_values):
                        pwm = max(self.pwm_min, min(self.pwm_max, pwm))  # Clamp
                        self.kit.servo[ch].pulse_width = pwm

                    time.sleep(delay_ms / 1000.0)  # Convert to seconds

                if not loop:
                    break
        except KeyboardInterrupt:
            print("⏹ Gait playback interrupted by user.")

