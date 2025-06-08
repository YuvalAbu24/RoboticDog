function gait = generateCurvedWalkingGait_Option2_bodyBased(robot, pivotDistance, total_deg, chunk_deg, ...
                                                  outer_stride, step_height, turning_side, steps_per_cycle)
% Curved walking using body-relative circular arcs.
% Inputs:
%   robot           - QuadrupedRobot object
%   pivotDistance   - Distance from body center to turning center (always +Y)
%   total_deg       - Total rotation in degrees
%   chunk_deg       - Turning angle per gait chunk (e.g., 5 deg)
%   outer_stride    - Stride length for outer legs (mm)
%   step_height     - Z lift (mm)
%   turning_side    - "left" or "right"
%   steps_per_cycle - Resolution
% Output:
%   gait - Struct of joint angle tables

    if nargin < 8
        steps_per_cycle = 40;
    end

    legs = fieldnames(robot.legs);
    gait = struct();

    % Phase shift like trot
    phase_shift = struct('LF', 0.0, 'RH', 0.0, ...
                         'RF', 0.5, 'LH', 0.5);

    % How many chunks
    n_chunks = ceil(total_deg / chunk_deg);
    actual_chunk_deg = total_deg / n_chunks;

    for i = 1:numel(legs)
        leg_id = legs{i};
        leg = robot.legs.(leg_id);
        pos = leg.poses.standing.footPos(:);  % [x; y; z]

        is_left = contains(leg_id, 'L');
        is_inner = xor(strcmp(turning_side, 'left'), ~is_left);

        y_offset = abs(pos(2));  % 142 mm
        if is_inner
            R_leg = pivotDistance - y_offset;
        else
            R_leg = pivotDistance + y_offset;
        end

        % Total arc length for this chunk
        arc_len = deg2rad(actual_chunk_deg) * R_leg;

        % Choose stride
        if is_inner
            stride = arc_len;
        else
            stride = outer_stride;
        end

        sign_dir = strcmp(turning_side, 'left') * 2 - 1;
        pivot_body = [0; sign_dir * pivotDistance];  % pivot always on +Y

        [q_leg, ~] = generateArcLegGaitTable_bodyBased(leg, pivot_body, ...
            actual_chunk_deg, step_height, stride, steps_per_cycle);

        % Repeat chunk
        gait.(leg_id) = repmat(q_leg, n_chunks, 1);
    end
end
