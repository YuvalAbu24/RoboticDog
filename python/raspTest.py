from adafruit_servokit import ServoKit
import time
kit= ServoKit(channels=16, address=0x41)
for ch in range(12):
    kit.servo[ch].set_pulse_width_range(min_pulse=500, max_pulse=2500)


sit=[90,235-90,-90+180,183-90,-55+100,90,90-8,95-84,125,180-90,85+86,-125+180]
lie=[90,250-90,-137.8+180,183-90,-70+100,137.8,90-8,110-90,137.8,180-90,70+90,-137.8+180]
#stand=[90,225-90,-60+180,183-90,-45+100,60,90-8,135-85,60,180-90,45+80,-60+180]
stand1=[90,130,110,93,50,70,82,50,70,90,129,110]
#stand2=[90+5,207-90,-80+180,183-90,-27+100,80,90-8,153-84,80,180-90,27+86,-80+180]
offsetCheck=[]
while True:
    for i in range(12):
        #kit.servo[11].angle =0 # Set initial angles to 'sit' position
        kit.servo[i].angle = stand1[i]
        time.sleep(0.02)
        #print(f"channel {i}: angle= {stand[i]}") 
        print(f"channel {i}: angle= {kit.servo[i].angle}")  # Print the angle for verification
""""    
kit.servo[0].angle = lie[0]
kit.servo[1].angle = lie[1]
kit.servo[2].angle = lie[2]

kit.servo[3].angle = lie[3]
kit.servo[4].angle = lie[4]
kit.servo[5].angle = lie[5]
kit.servo[6].angle = lie[6]
kit.servo[7].angle = lie[7]
kit.servo[8].angle = lie[8]
kit.servo[9].angle = lie[9]
kit.servo[10].angle = lie[10]
kit.servo[11].angle = lie[11]"""
"""angle0=90
angle1=180
angle2=0
angle3=93
angle4=0
angle5=180
angle6=82
angle7=5
angle8=180
angle9=90
angle10=170
angle11=0
#kit.servo[0].angle = sit[0]
kit.servo[0].angle = 90
print(f"channel 0: angle= {kit.servo[0].angle}")  # Print the angle for verification
#kit.servo[1].angle = sit[1]
kit.servo[0].angle = 180
print(f"channel 1: angle= {kit.servo[1].angle}")  # Print the angle for verification
#kit.servo[2].angle = sit[2]
kit.servo[0].angle = 0
print(f"channel 2: angle= {kit.servo[2].angle}")  # Print the angle for verification
kit.servo[3].angle = angle3
print(f"channel 3: angle= {kit.servo[3].angle}")  # Print the angle for verification
kit.servo[4].angle = angle4
print(f"channel 4: angle= {kit.servo[4].angle}")  # Print the angle for verification
kit.servo[5].angle = angle5
print(f"channel 5: angle= {kit.servo[5].angle}")  # Print the angle for verification    
kit.servo[6].angle = angle6
print(f"channel 6: angle= {kit.servo[6].angle}")  # Print the angle for verification
kit.servo[7].angle = angle7
print(f"channel 7: angle= {kit.servo[7].angle}")  # Print the angle for verification
kit.servo[8].angle = angle8
print(f"channel 8: angle= {kit.servo[8].angle}")  # Print the angle for verification
kit.servo[9].angle = angle9
print(f"channel 9: angle= {kit.servo[9].angle}")  # Print the angle for verification
kit.servo[10].angle = angle10
print(f"channel 10: angle= {kit.servo[10].angle}")  # Print the angle for verification  
kit.servo[11].angle = angle11
print(f"channel 11: angle= {kit.servo[11].angle}")  # Print the angle for verification"""