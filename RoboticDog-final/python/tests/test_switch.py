# switch_test.py (gpiozero version)
from gpiozero import Button
from signal import pause
import time

SWITCH_PIN = 26  # BCM GPIO pin
switch = Button(SWITCH_PIN, pull_up=True)

print(" Waiting for switch  (CTRL+C to exit)...")

def print_state():
    if switch.is_pressed:
        print(" Switch is CLOSED (resting)")
    else:
        print(" Switch is OPEN (pressed)")

try:
    while True:
        print_state()
        time.sleep(0.2)

except KeyboardInterrupt:
    print("\n Exiting.")
