% File: demo/simulate_robot.m
% tests
clear; clc;

%% setup and plot all legs
dog = QuadrupedRobot();
dog.teachAll();

%% not working together

% Define end-effector targets
targets.LF = [134.3, 142, -176.8];
targets.RF = [134.3, -142, -176.8];
targets.LH = [-134.3, 142, -176.8];
targets.RH = [-134.3, -142, -176.8];

% Move each leg
leg_names = fieldnames(targets);
for i = 1:length(leg_names)
    name = leg_names{i};
    dog.moveLegTo(name, targets.(name));
end

%% one leg external check: for example back right leg
x=-134.3;
y=-142;
z=-176.8;
[q_best, branches_all]=computeIKForLeg('RH', [x, y, z]); % rad

%%
