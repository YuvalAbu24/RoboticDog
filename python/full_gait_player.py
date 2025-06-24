import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
import csv
from pwm_driver import PWMDriver
from threading import Event

class GaitPlayer:
    def __init__(self):
        self.driver = PWMDriver()
        self.stop_event = Event()

    def stop(self):
        self.stop_event.set()
        self.driver.shutdown()  # Ensures servos are released immediately

    def play_gait(self, csv_path, loop=False):
        """
        Plays gait from CSV (12 PWM values + 1 delay per row).
        """
        self.stop_event.clear()  # Clear previous stop state
        with open(csv_path, 'r') as f:
            reader = csv.reader(f)
            pwm_rows = [list(map(float, row)) for row in reader]

        print(f" Playing gait from {csv_path} with {len(pwm_rows)} steps")

        try:
            while not self.stop_event.is_set():
                for row in pwm_rows:
                    
                    if self.stop_event.is_set():
                        print(" Gait stopped mid-play")
                        return  # Exit early

                    pwm_values = row[:12]
                    delay_ms = row[12]
                    self.driver.set_pwm_batch(pwm_values)
                    time.sleep(delay_ms / 1000.0)

                if not loop:
                    break

        except KeyboardInterrupt:
            print(" Gait playback interrupted by user.")
        finally:
            self.driver.shutdown()