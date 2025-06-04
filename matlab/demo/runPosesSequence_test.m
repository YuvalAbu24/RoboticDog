% runPoseSequence_test

clear all; clc;
robot = QuadrupedRobot();
runPoseSequence(robot, ["lying", "sitting", "standing"], 6, 30, true, "pose_demo.mp4");
% runPoseSequence(robot, ["lying", "sitting", "standing"], 6, 30, true); -> no video name
%  runPoseSequence(robot, ["lying", "sitting", "standing"], 6, 30); ->  no video
  


