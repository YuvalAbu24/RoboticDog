function [q_table, pos_table] = generateArcLegGaitTable1(leg, R_leg, arc_deg, stride_length, step_height, ...
                                                        steps_per_cycle, phase_offset)
% Generate gait trajectory for a single leg walking along an arc.
%
% Inputs:
%   leg            - RoboticLeg object
%   R_leg          - Arc radius for this leg (mm)
%   arc_deg        - Arc to walk in degrees (this chunk) 
%   stride_length  - X-direction stride for this leg (approx)
%   step_height    - Z-direction foot lift (mm)
%   steps_per_cycle - Number of time steps per cycle
%   phase_offset   - Gait phase offset [0,1)
%
% Outputs:
%   q_table        - [steps x 4] joint angles
%   pos_table      - [steps x 3] foot positions (relative to body)

    arc_rad = deg2rad(arc_deg);
    total_arc_length = R_leg * arc_rad;

    % Determine how many cycles are needed to complete the arc
    n_cycles = ceil(total_arc_length / stride_length);
    actual_stride = total_arc_length / n_cycles;  % per-cycle stride length

    q_table = [];
    pos_table = [];

    for c = 1:n_cycles
        for i = 1:steps_per_cycle
            % Gait phase with offset
            phase = mod((i-1)/steps_per_cycle + phase_offset, 1.0);

            % --- Plan arc foot trajectory ---
            theta = arc_rad * ((c-1) + (i-1)/steps_per_cycle) / n_cycles;

            % Lateral (XY) position on the arc
            x = R_leg * sin(theta);
            y = R_leg * (1 - cos(theta));  % relative to center of arc (circular path)

            % Convert to position relative to body
            pos_xy = [x; y];

            % Z trajectory
            if phase < 0.5  % swing
                phase_swing = phase * 2;
                z = leg.poses.standing.footPos(3) + step_height * sin(pi * phase_swing);
            else  % stance
                z = leg.poses.standing.footPos(3);
            end

            % Final position in body frame
            pos = [pos_xy; z];

            % IK
            q = leg.ik(pos);

            % Append
            pos_table = [pos_table; pos'];
            q_table = [q_table; q];
        end
    end
end
