# test_pwm_driver.py

import time
from pwm_driver import PWMDriver

driver = PWMDriver()

try:
    print("Sending neutral pose (1500 µs to all servos)...")
    driver.set_pwm_batch([1500] * 12)
    time.sleep(2)

    print("Sending max pose (2450 µs)...")
    driver.set_pwm_batch([2500] * 12)
    time.sleep(2)

    print("Sending min pose (450 µs)...")
    driver.set_pwm_batch([500] * 12)
    time.sleep(2)

except KeyboardInterrupt:
    print("Interrupted by user.")

finally:
    print("Shutting down servos.")
    driver.shutdown()
