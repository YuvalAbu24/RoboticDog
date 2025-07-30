# gait_trigger.py
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))) 
import time
from gpiozero import Button
from signal import pause
from gait_player import GaitPlayer

# === CONFIG ===
SWITCH_PIN = 16  # BCM pin
GAIT_FILE = 'python/gaits/full_mission_sequence.csv'  # Adjust path as needed
REPEAT = False  # Play only once

# === Setup ===
switch = Button(SWITCH_PIN, pull_up=True, bounce_time=0.05)

def on_triggered():
    print(" Switch triggered — starting gait!\n")
    player = GaitPlayer()
    player.play_gait(GAIT_FILE, loop=REPEAT)

def main():
    print(" Waiting for switch (normally closed)...")
    switch.when_released = on_triggered  # Trigger when switch goes from LOW to HIGH

    try:
        pause()  # Wait indefinitely for events
    except KeyboardInterrupt:
        print("\n Interrupted by user.")
    finally:
        switch.close()
        print(" GPIO cleaned up.")

if __name__ == '__main__':
    main()
