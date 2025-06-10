robot = QuadrupedRobot();
gait = generateCurvedWalkingGait_Option2_bodyBased(robot, ...
    400, 90, 5, 100, 40, 'left', 30);
visualizeTurningGait(robot, gait);

