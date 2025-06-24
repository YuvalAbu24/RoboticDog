import RPi.GPIO as GPIO
import time

PIN =16

def callback(channel):
    state= GPIO.input(PIN)
    print("edge detected! State is:", "HIGH" if  state else "LOW")

GPIO.setmode(GPIO.BCM)
GPIO.setup(PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

try:
    GPIO.add_event_detect(PIN, GPIO.BOTH, callback=callback, bouncetime=50)
except RuntimeError as e:
    print(" failed to add event detection:", e)
    GPIO.cleanup()
    exit(1)

print("Waiting for edge detection ")

try:
    while True:
        time.sleep(1)  # Keep the script running to detect edges
except KeyboardInterrupt:
    print("\nExiting.")
finally:
    GPIO.cleanup()
    print("GPIO cleaned up.")