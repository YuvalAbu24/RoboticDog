clear; clc;
robot = QuadrupedRobot();

% Parameters
gait_type = 'walk';         % or 'trot'
stride = 80;                % mm
step_height = 40;           % mm
distance_mm = 1000;         % walk 1 meter
fps = 30;

walkFixedDistance(robot, gait_type, stride, step_height, distance_mm, fps);
