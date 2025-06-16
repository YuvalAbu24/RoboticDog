# pwm_driver.py
import time
from adafruit_servokit import ServoKit

class PWMDriver:
    def __init__(self):
        # Setup for PCA9685 at address 0x41 with 16 channels
        self.kit = ServoKit(channels=16, address=0x41)

        # Set PWM pulse width range for all 12 joints (channels 0–11)
        for ch in range(12):
            self.kit.servo[ch].set_pulse_width_range(min_pulse=500, max_pulse=2500)

    def set_pwm_batch(self, angle_values):
        """
        Send a list of 12 PWM values to servos (in microseconds).
        :param angle_values: list of 12 values (range 500 – 2500)
        """
        if len(angle_values) != 12:
            raise ValueError("Expected 12 PWM values.")

        for ch, angle in enumerate(angle_values):
            angle = max(0, min(180, angle))  # Clamp just in case
            print(f"channel {ch}: angle= {angle}")
            self.kit.servo[ch].angle = angle

    def shutdown(self):
        """ Disable all active signals to servos (set to None) """
        for ch in range(12):
            self.kit.servo[ch].angle = None
