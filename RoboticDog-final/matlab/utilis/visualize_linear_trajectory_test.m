robot = QuadrupedRobot();
gait = generateFullGaitTable(robot, 'trot', 40, 80, 30);  % 40 steps, 80 mm stride, 30 mm height

visualizeFootTrajectory(gait, 'LF');
