% File: gait/generateLegGaitTable.m
function [q_table, pos_table] = generateLegGaitTable(leg, n_steps, strideLength, stepHeight, phase_offset)
% Generates joint angle table for one leg over one gait cycle
% Inputs:
%   leg          - RoboticLeg object
%   n_steps      - Number of time steps (resolution)
%   strideLength - Total X range of foot motion (mm)
%   stepHeight   - Height of foot lift during swing (mm)
%   phase_offset - [0, 1) phase shift for gait coordination
%
% Outputs:
%   q_table      - [n_steps x 4] matrix of joint angles in radians
%   pos_table    - [n_steps x 3] foot position used for IK

    q_table = zeros(n_steps, 4);
    pos_table = zeros(n_steps, 3);

    for i = 1:n_steps
        % Normalized gait phase (0 to 1)
        phase = mod((i-1)/n_steps + phase_offset, 1.0);

        % Compute foot position in body frame
        pos = planFootTrajectory(phase, strideLength, stepHeight, leg);

        % Store position
        pos_table(i,:) = pos;

        % Compute inverse kinematics
        q = leg.ik(pos);

        % Store joint angles
        q_table(i,:) = q;
    end
end
