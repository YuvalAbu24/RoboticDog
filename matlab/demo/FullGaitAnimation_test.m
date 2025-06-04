% File: testFullGaitAnimation.m
clear; clc;

% Create robot
dog = QuadrupedRobot();

% Gait parameters
gait_type   = 'walk';    % 'walk' or 'trot'
n_steps     = 20;
stride      = 80;        % mm
step_height = 40;        % mm

% Generate gait table
gait = generateFullGaitTable(dog, gait_type, n_steps, stride, step_height);

% Setup figure
figure;
axis equal;
view(3);
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title(['Full Gait Animation - ', upper(gait_type)]);

% Animate
for i = 1:n_steps
    % For each leg, update its pose
    dog.legs.LF.teach(gait.LF(i,:));
    hold on
    dog.legs.RF.teach(gait.RF(i,:));
    hold on
    dog.legs.LH.teach(gait.LH(i,:));
    hold on
    dog.legs.RH.teach(gait.RH(i,:));

    drawnow;
    % pause(0.01);  % Adjust for smoother playback
end
