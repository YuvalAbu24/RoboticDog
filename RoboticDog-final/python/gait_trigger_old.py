# gait_trigger.py
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
import RPi.GPIO as GPIO
from gait_player import GaitPlayer

# === CONFIG ===
SWITCH_PIN = 16  # GPIO pin number (BCM)
''' need to pay attention and replace the path if needed'''

GAIT_FILE = 'RoboticDog-main/RoboticDog-main/python/gaits/full_mission_sequence.csv'
REPEAT = False  # Set to False to play only once

def wait_for_trigger():
    print(" Waiting for trigger (normally closed switch)...")
    while GPIO.input(SWITCH_PIN) == GPIO.LOW:
        time.sleep(0.01)
    print(" Switch triggered — starting gait!\n")

def main():
    # Setup GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(SWITCH_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    try:
        wait_for_trigger()
        player = GaitPlayer()
        player.play_gait(GAIT_FILE, loop=REPEAT)
    except KeyboardInterrupt:
        print("\n Interrupted by user.")
    finally:
        GPIO.cleanup()
        print(" GPIO cleaned up.")

if __name__ == '__main__':
    main()
