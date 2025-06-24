from gpiozero import Button
from signal import pause
import time

PIN = 16  # BCM pin

def on_rising():
    print("Edge detected! State is: HIGH")

def on_falling():
    print(" Edge detected! State is: LOW")

# Setup button (normally closed, so pull_up=True)
switch = Button(PIN, pull_up=True, bounce_time=0.05)

# Attach callbacks
switch.when_released = on_rising   # rising edge (LOW → HIGH)
switch.when_pressed  = on_falling  # falling edge (HIGH → LOW)

print("Waiting for edge detection on pin", PIN)


try:
    pause()  # Keeps the program alive for callbacks
except KeyboardInterrupt:
    print("\nExiting.")
finally:
    switch.close()
    print("GPIO cleaned up.")
