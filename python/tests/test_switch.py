# switch_test.py
import RPi.GPIO as GPIO
import time

SWITCH_PIN = 17  # GPIO pin you're using

GPIO.setmode(GPIO.BCM)
GPIO.setup(SWITCH_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

print("📟 Waiting for switch (CTRL+C to exit)...")

try:
    while True:
        state = GPIO.input(SWITCH_PIN)
        if state == GPIO.HIGH:
            print("🔘 Switch is OPEN (pressed)")
        else:
            print("🔒 Switch is CLOSED (resting)")
        time.sleep(0.2)
except KeyboardInterrupt:
    print("\n🧼 Exiting.")
finally:
    GPIO.cleanup()
