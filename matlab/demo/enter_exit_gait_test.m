clear; clc;
robot = QuadrupedRobot();

runPoseSequence(robot, ["lying", "sitting"], 2);
enterGait(robot, 2);

stride = 100;          % mm stride
step_height = 40;      % mm lift
distance = 500;        % mm total distance
fps = 30;

walkFixedDistance(robot, 'walk', stride, step_height, distance, fps);

exitGait(robot, 2);
