import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import RPi.GPIO as GPIO
import time
from gait_player import GaitPlayer
# from voice_handler import get_command  # future

SWITCH_PIN = 16  # BCM
state = "IDLE"   # could be "IDLE", "ACTIVE"

def switch_callback(channel):
    global state
    pin_state = GPIO.input(SWITCH_PIN)
    
    if pin_state == GPIO.LOW:
        print(" Switch ON → Going ACTIVE")
        state = "ACTIVE"
    else:
        print(" Switch OFF → Going IDLE")
        state = "IDLE"

def setup():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(SWITCH_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    # Register both rising and falling edge callbacks
    GPIO.add_event_detect(SWITCH_PIN, GPIO.BOTH, callback=switch_callback, bouncetime=100)

def go_to_sitting():
    print(" Sitting pose triggered...")
    # Call gait or pose function here
    # e.g., player.play_gait("sitting_pose.csv")

def go_to_standing():
    print(" Standing pose triggered...")
    # e.g., player.play_gait("standing_pose.csv")

def main_loop():
    global state
    setup()

    # Initial state check
    if GPIO.input(SWITCH_PIN) == GPIO.HIGH:
        state = "IDLE"
        go_to_sitting()
    else:
        state = "ACTIVE"
        go_to_standing()

    try:
        while True:
            if state == "ACTIVE":
                # Run main voice command loop (stub for now)
                print(" Listening for commands...")
                time.sleep(2)
            else:
                print(" Idle mode.")
                time.sleep(1)

    except KeyboardInterrupt:
        print(" Exiting.")
    finally:
        GPIO.cleanup()
if __name__ == "__main__":
    main_loop()