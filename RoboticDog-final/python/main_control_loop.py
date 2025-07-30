import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
from gpiozero import Button
from signal import pause
from threading import Event, Thread
from gait_player import GaitPlayer

SWITCH_PIN = 26  # BCM
GAIT_FILE = 'RoboticDog-main/python/gaits/full_mission_sequence.csv'
REPEAT = False

state = "IDLE"
stop_event = Event()

player = None
gait_thread = None

def on_switch_on():
    global state
    print("🔛 Switch ON → ACTIVE mode")
    state = "ACTIVE"

def on_switch_off():
    global state
    print("🔴 Switch OFF → IDLE mode")
    state = "IDLE"

def go_to_sitting():
    print("🪑 Going to sitting pose...")
    # Optional: play sitting gait here

def go_to_standing():
    print("🧍 Going to standing pose...")
    # Optional: play standing gait here

def setup():
    print("🔧 Setting up switch")
    switch = Button(SWITCH_PIN, pull_up=True, bounce_time=0.01)
    switch.when_pressed = on_switch_off
    switch.when_released = on_switch_on
    return switch

def main_loop():
    global state, player, gait_thread
    switch = setup()

    last_state = None  # Track previous state to detect changes

    # Initial state check
    if switch.is_pressed:
        state = "IDLE"
    else:
        state = "ACTIVE"

    try:
        while not stop_event.is_set():
            if state != last_state:
                print(f"🔁 State change: {last_state} → {state}")

                if state == "IDLE":
                    # Stop gait
                    if player:
                        print("⏹ Stopping gait player...")
                        player.stop()
                        gait_thread.join(timeout=2)
                        player = None
                        gait_thread = None

                    # Run sitting transition
                    go_to_sitting()

                elif state == "ACTIVE":
                    # Run standing transition
                    go_to_standing()

                    # Start gait
                    print("▶️ Starting gait player...")
                    player = GaitPlayer()
                    gait_thread = Thread(target=player.play_gait, args=(GAIT_FILE, REPEAT))
                    gait_thread.start()

                last_state = state

            # Wait and monitor for further changes
            time.sleep(0.1)

    except KeyboardInterrupt:
        print("🔌 KeyboardInterrupt received")
        stop_event.set()
        if player:
            player.stop()
            if gait_thread and gait_thread.is_alive():
                gait_thread.join(timeout=2)

    finally:
        switch.close()
        print("🧹 GPIO cleaned up.")

if __name__ == "__main__":
    main_loop()
