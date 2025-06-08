# gait_trigger.py
import time
import RPi.GPIO as GPIO
from python.gait_player import GaitPlayer

# === CONFIG ===
SWITCH_PIN = 17  # GPIO pin number (BCM)
GAIT_FILE = 'python/gaits/walk_pwm.csv'
REPEAT = True  # Set to False to play only once

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
        player = GaitPlayer(GAIT_FILE)
        player.play_loop(repeat=REPEAT)
    except KeyboardInterrupt:
        print("\n Interrupted by user.")
    finally:
        GPIO.cleanup()
        print(" GPIO cleaned up.")

if __name__ == '__main__':
    main()
