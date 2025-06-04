% File: testShowPose.m
clear; clc;

% Load the robot
dog = QuadrupedRobot();

% Pose name: use 'standing', 'sitting', or 'lying'
pose_name = 'lying';

% Show each leg in its pose
figure;
title(['Quadruped Pose: ', pose_name]);
hold on;

legs = fieldnames(dog.legs);
for i = 1:numel(legs)
    leg_id = legs{i};
    leg = dog.legs.(leg_id);

    if isfield(leg.poses, pose_name)
        q = leg.poses.(pose_name).jointAngles;
        leg.robot.plot(q, 'delay', 0);  % ⬅️ Default behavior
        hold on;
    else
        warning('Pose "%s" not found for leg "%s"', pose_name, leg_id);
    end
end
