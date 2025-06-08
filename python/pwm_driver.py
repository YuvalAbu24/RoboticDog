# pwm_driver.py
import time
from adafruit_servokit import ServoKit

class PWMDriver:
    def __init__(self):
        # Setup for PCA9685 at address 0x41 with 16 channels
        self.kit = ServoKit(channels=16, address=0x41)

        # Set PWM pulse width range for all 12 joints (channels 0–11)
        for ch in range(12):
            self.kit.servo[ch].set_pulse_width_range(min_pulse=450, max_pulse=2450)

    def set_pwm_batch(self, pwm_values):
        """
        Send a list of 12 PWM values to servos (in microseconds).
        :param pwm_values: list of 12 values (range 450 – 2450)
        """
        if len(pwm_values) != 12:
            raise ValueError("Expected 12 PWM values.")

        for ch, pwm_us in enumerate(pwm_values):
            pwm_us = max(450, min(2450, pwm_us))  # Clamp just in case
            self.kit.servo[ch].pulse_width = pwm_us

    def shutdown(self):
        """ Disable all active signals to servos (set to None) """
        for ch in range(12):
            self.kit.servo[ch].pulse_width = None
