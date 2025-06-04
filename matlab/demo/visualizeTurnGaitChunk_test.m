robot = QuadrupedRobot();
gait = generateChunkedTurningGaitTable(robot, 'trot', 20, 30, 5, 30);  % 30° turn, in 6° steps
visualizeTurningGait(robot, gait);

% shows only one cunk - 5 deg here. 