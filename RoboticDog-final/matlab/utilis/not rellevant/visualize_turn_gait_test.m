robot = QuadrupedRobot();
gait = generateTurningGaitTable(robot, 'trot', 40, 40, 45);  % 90° turn over 40 steps

 visualizeTurningGait(robot, gait);
visualizeFootTrajectory(gait.LF, 'LF')