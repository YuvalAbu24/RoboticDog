robot = QuadrupedRobot();
some_gait = generateCurvedWalkingGait_Option2_bodyBased(robot, ...
    400, 180, 5, 80, 30, 'left', 40);
visualizeTurningGait(robot, gait);