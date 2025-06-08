function [q_table, pos_table] = generateArcLegGaitTable(leg, R_leg, arc_deg, stride_length, step_height, ...
                                                        steps_per_cycle, phase_offset, ...
                                                        pivot_distance, turning_side)
% Generate gait trajectory for a single leg walking along an arc.
% All positions are converted into body frame for IK.

% Inputs:
%   leg             - RoboticLeg object
%   R_leg           - Arc radius for this leg (mm)
%   arc_deg         - Arc to walk in degrees (this chunk)
%   stride_length   - Max stride length for this leg
%   step_height     - Foot clearance during swing (mm)
%   steps_per_cycle - Steps per gait cycle
%   phase_offset    - Gait phase offset [0-1)
%   pivot_distance  - Distance from body center to center of turn (mm)
%   turning_side    - 'left' or 'right'

% Outputs:
%   q_table   - [steps x 4] joint angles
%   pos_table - [steps x 3] foot positions in body frame

    % Determine turning direction: +1 for left, -1 for right
    sign_dir = strcmp(turning_side, 'left') * 2 - 1;

    % Convert arc
    arc_rad = deg2rad(arc_deg);
    total_arc_len = R_leg * arc_rad;

    % Number of gait cycles needed
    n_cycles = ceil(total_arc_len / stride_length);
    arc_rad_per_cycle = arc_rad / n_cycles;

    % Setup output
    q_table = [];
    pos_table = [];

    % Leg base pose
    base_z = leg.poses.standing.footPos(3);
    base_xy = leg.poses.standing.footPos(1:2);  % [x; y] in body frame

    % Pivot point (in body frame): along ±Y
    pivot = [0; sign_dir * pivot_distance];

    % Compute arc parameters for this leg
    rel_to_pivot = base_xy - pivot;           % vector from pivot to leg
    R_actual = norm(rel_to_pivot);            % radius of arc
    theta0 = atan2(rel_to_pivot(2), rel_to_pivot(1));  % starting angle

    for c = 1:n_cycles
        for i = 1:steps_per_cycle
            % Gait phase
            phase = mod((i-1)/steps_per_cycle + phase_offset, 1.0);

            % Angular offset for this step
            theta = theta0 + sign_dir * arc_rad_per_cycle * ((c-1) + (i-1)/steps_per_cycle);

            % Foot position in body frame (XY)
            x = pivot(1) + R_actual * cos(theta);
            y = pivot(2) + R_actual * sin(theta);

            % Foot Z trajectory
            if phase < 0.5
                z = base_z + step_height * sin(pi * phase * 2);
            else
                z = base_z;
            end

            pos = [x; y; z];

            % Inverse kinematics
            try
                q = leg.ik(pos);
            catch
                warning("⚠️ IK failed for leg %s at pos = [%.2f, %.2f, %.2f]", ...
                        leg.name, pos(1), pos(2), pos(3));
                q = nan(1, 4);
            end

            q_table = [q_table; q];
            pos_table = [pos_table; pos'];
        end
    end
end
