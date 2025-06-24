# main_control_loop.py

import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
from threading import Event, Thread
from gpiozero import Button
from full_gait_player import GaitPlayer
from voice_listener import get_last_command, start_voice_listener

# === PATH CONFIG ===
GAIT_DIR = "/home/user_admin/roboticDog/RoboticDog-full/python/gaits/"

# === GPIO ===
SWITCH_PIN = 26

# === SYSTEM STATES ===
state = "IDLE"
pose_state = "standing"
command_ready = True

# === THREADING ===
stop_event = Event()
player = None
gait_thread = None

last_pose_state=None
# === SWITCH CALLBACKS ===
def on_switch_on():
    global state
    print(" Switch ON, ACTIVE")
    state = "ACTIVE"

def on_switch_off():
    global state
    print(" Switch OFF, IDLE")
    state = "IDLE"

# === BEHAVIOR HANDLERS ===
def play_gait(file_name, on_finish_pose=None):
    global player, gait_thread, command_ready, pose_state

    def _run():
        global command_ready, pose_state
        player.play_gait(os.path.join(GAIT_DIR, file_name), loop=False)
        command_ready = True
        if on_finish_pose:
            pose_state = on_finish_pose

    if player:
        player.stop()
    player = GaitPlayer()
    command_ready = False
    gait_thread = Thread(target=_run)
    gait_thread.start()

def interrupt_current_gait():
    global player, gait_thread, command_ready, pose_state
    """pose_state="standing" """# need to remember deleting this
    if player:
        
        player.stop()
        print(" Gait interrupted!")
        if gait_thread:
            gait_thread.join(timeout=2)
        player = None
        gait_thread = None
        pose_state = "standing"
        command_ready = True
        print(" Returned to STANDING")

def go_to_sitting():
    global pose_state
    print(" Going to sitting...")
    """play_gait("stand_sit_gait.csv", on_finish_pose="sitting")"""
    pose_state="sitting" #need to remember to delete this line
def go_to_standing(from_pose):
    global pose_state
    if from_pose == "sitting":
        """ gait_file = "sit_stand_gait.csv """
        print("go standing from sitting")
    elif from_pose == "lying":
        """gait_file = "lie_stand_gait.csv"""
        print("go standing from lying")
    else:
        print(" Invalid transition to stand")
        return
    print(" Going to standing...")
    """play_gait(gait_file, on_finish_pose="standing")"""
    pose_state="standing" #need to remember to delete this line

# === SETUP ===
def setup_switch():
    print(" Setting up GPIO switch")
    switch = Button(SWITCH_PIN, pull_up=True, bounce_time=0.005)
    switch.when_pressed = on_switch_off
    switch.when_released = on_switch_on
    return switch

# === MAIN LOOP ===
def main_loop():
    global state, pose_state, command_ready , last_pose_state , player, gait_thread

    switch = setup_switch()
    start_voice_listener()

    # Initial state check
    if switch.is_pressed:
        state = "IDLE"
        pose_state = "standing"
        go_to_sitting()
    else:
        state = "ACTIVE"
        pose_state = "standing"
        print(" ACTIVE mode: waiting for commands")

    try:
        while not stop_event.is_set():
            if state == "IDLE":
                if player:
                    interrupt_current_gait()
                    
                if pose_state != "sitting" and last_pose_state!="sitting":
                    go_to_sitting()
                last_pose_state = pose_state
                
                time.sleep(1)
                continue

            if state == "ACTIVE":
                

                command = get_last_command()
                if not command:
                    time.sleep(0.2)
                    continue

                print(f" Command received: {command}")

                if  command == "stop"  :
                    
                    interrupt_current_gait()
                    
                if not command_ready:
                    time.sleep(0.5)
                    continue    

                if command == "sit" and pose_state in ["standing", "lying"]:
                    if pose_state == "standing":
                        """play_gait("stand_sit_gait.csv", on_finish_pose="sitting")"""
                        print("stand_sit_gait")
                        pose_state="sitting" #need to remember to delete this line

                        
                    elif pose_state == "lying":
                        """play_gait("lie_sit_gait.csv", on_finish_pose="sitting")"""
                        print("lie_sit_gait")
                        pose_state="sitting" #need to remember to delete this line

                elif command == "lie down" and pose_state in ["sitting", "standing"]:
                    if pose_state == "sitting":
                        """play_gait("sit_lie_gait.csv", on_finish_pose="lying")"""
                        print("sit_lie_gate")
                        pose_state="lying" #need to remember to delete this line
                    elif pose_state == "standing":
                        """play_gait("stand_lie_gait.csv", on_finish_pose="lying")"""
                        print("stand_lie_gate")
                        pose_state="lying" #need to remember to delete this line

                elif command == "stand" and pose_state in ["sitting", "lying"]:
                    go_to_standing(from_pose=pose_state)

                elif command == "walk" and pose_state == "standing":
                    """play_gait("walk.csv", on_finish_pose="standing")"""
                    print("walking gait")
                    
                    pose_state="standing" #need to remember to delete this line

                elif command == "turn around" and pose_state in ["standing", "walking"]:
                    """play_gait("turn.csv", on_finish_pose="standing")"""
                    print("turn gait")  
                    
                    pose_state="standing" #need to remember to delete this line

                elif command == "full gait" and pose_state == "standing":
                    play_gait("full_mission_sequence.csv", on_finish_pose="standing")
                    print("full gate ")
                    pose_state = "standing" #need to remember to delete this line
                

                else:
                    if command!= "stop":
                        print(f" Invalid command '{command}' from pose '{pose_state}'")

            time.sleep(0.1)

    except KeyboardInterrupt:
        print(" KeyboardInterrupt — Shutting down.")
        stop_event.set()
        if player:
            player.stop()

    finally:
        switch.close()
        print(" GPIO cleaned up.")

# === ENTRY POINT ===
if __name__ == "__main__":
    main_loop()