clear; clc;
robot = QuadrupedRobot();

% Turn 90 degrees in place using trot
runPoseSequence(robot, ["lying", "sitting", "standing"], 2);
enterGait(robot, 2);
turnInPlace(robot, 'trot', 90, 30, 2);  % 90° in 2 cycles
exitGait(robot, 2);
