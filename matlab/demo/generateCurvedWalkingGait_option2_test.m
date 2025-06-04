robot = QuadrupedRobot();
gait = generateCurvedWalkingGait_Option2_bodyBased(robot, ...
    300, 90, 5, 40, 40, 'left', 30);
visualizeTurningGait(robot, gait);
