clear; clc;
dog = QuadrupedRobot();

gait_type = 'trot';       % or 'walk'
n_steps = 50;             % trajectory resolution
stride = 80;              % mm
step_height = 40;         % mm

gait = generateFullGaitTable(dog, gait_type, n_steps, stride, step_height);

% Visualize one leg's motion
leg_id = 'LF';  % try 'LF', 'LH', 'RH' as well
figure;
dog.legs.(leg_id).robot.plot(gait.(leg_id));
