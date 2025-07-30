import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import time
import csv
from pwm_driver import PWMDriver

def play_pwm_gait(csv_file, loop=False):
    driver = PWMDriver()

    try:
        with open(csv_file, 'r') as f:
            reader = csv.reader(f)
            rows = [list(map(float, row)) for row in reader]

        print(f" Loaded {len(rows)} rows from {csv_file}")
        
        while True:
            for step_num, row in enumerate(rows):
                pwm_values = row[:12]
                delay_ms = row[12]

                # Send to servos
                driver.set_pwm_batch(pwm_values)

                print(f"Step {step_num+1}/{len(rows)} | Delay: {delay_ms} ms")
                time.sleep(delay_ms / 1000.0)

            if not loop:
                break

    except KeyboardInterrupt:
        print(" Interrupted by user.")

    finally:
        driver.shutdown()
        print(" Servos released.")


if __name__ == "__main__":
    play_pwm_gait("/home/user_admin/roboticDog/RoboticDog-final/python/gaits/final_walking_sequence.csv", loop=False)
    #play_pwm_gait("/home/user_admin/roboticDog/RoboticDog-final2/python/gaits/somePoints/final_walking_gait.csv", loop=False)
