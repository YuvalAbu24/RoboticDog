import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
from gpiozero import Button
from signal import pause
from threading import Event, Thread
from gait_player import GaitPlayer

# from voice_handler import get_command  # for future integration

SWITCH_PIN = 26  # BCM
GAIT_FILE = 'RoboticDog-main/python/gaits/full_mission_sequence.csv'
REPEAT = False

state = "IDLE"   # can be "IDLE" or "ACTIVE"
stop_event = Event()

player = None
gait_thread = None

# === CALLBACKS ===
def on_switch_on():
    global state
    print("Switch ON, Going ACTIVE")
    state = "ACTIVE"

def on_switch_off():
    global state
    print("Switch OFF, Going IDLE")
    state = "IDLE"

# === BEHAVIOR HANDLERS ===
def go_to_sitting():
    print("Sitting pose triggered...")

def go_to_standing():
    print("Standing pose triggered...")

# === SETUP ===
def setup():
    print("Setting up switch (GPIO Zero)")
    switch = Button(SWITCH_PIN, pull_up=True, bounce_time=0.005)
    switch.when_pressed = on_switch_off   # HIGH → LOW
    switch.when_released = on_switch_on   # LOW → HIGH
    return switch

# === MAIN LOOP ===
def main_loop():
    global state, player, gait_thread
    switch = setup()

    # Initial state check
    if switch.is_pressed:
        state = "IDLE"
        go_to_sitting()
    else:
        state = "ACTIVE"
        go_to_standing()

    try:
        while not stop_event.is_set():
            if state == "ACTIVE":
                if player is None or gait_thread is None or not gait_thread.is_alive():
                    print("Starting gait player...")
                    player = GaitPlayer()
                    gait_thread = Thread(target=player.play_gait, args=(GAIT_FILE, REPEAT))
                    gait_thread.start()
                else:
                    print("Gait already running...")
                time.sleep(1)

            elif state == "IDLE":
                if player:
                    print("Stopping gait player...")
                    player.stop()
                    gait_thread.join(timeout=2)
                    player = None
                    gait_thread = None
                go_to_sitting()
                time.sleep(1)

    except KeyboardInterrupt:
        print("Exiting via KeyboardInterrupt.")
        stop_event.set()
        if player:
            player.stop()
            if gait_thread and gait_thread.is_alive():
                gait_thread.join(timeout=2)

    finally:
        switch.close()
        print("GPIO cleaned up.")
