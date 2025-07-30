function gait = generateCurvedWalkingGait_Option1(robot, turn_direction, ...
        total_angle_deg, chunk_angle_deg, pivot_distance, outer_stride, step_height, steps_per_cycle)

    if nargin < 8
        steps_per_cycle = 40;
    end

    % Validate direction
    if ~ismember(turn_direction, {'left', 'right'})
        error('turn_direction must be ''left'' or ''right''');
    end

    % Setup
    legs = fieldnames(robot.legs);
    n_chunks = ceil(total_angle_deg / chunk_angle_deg);
    gait = struct();
    for i = 1:numel(legs)
        gait.(legs{i}) = [];
    end

    % Define leg sides
    if strcmp(turn_direction, 'left')
        inner_legs = {'LF', 'LH'};
        outer_legs = {'RF', 'RH'};
    else
        inner_legs = {'RF', 'RH'};
        outer_legs = {'LF', 'LH'};
    end

    % Y offset of legs (assumed symmetric)
    leg_y_offset = abs(robot.legs.LF.poses.standing.footPos(2));  % 142 mm

    % Radius to inner/outer leg
    R_inner = pivot_distance - leg_y_offset;
    R_outer = pivot_distance + leg_y_offset;

    if R_inner <= 0
        error('pivot_distance is too small relative to leg y offset (%d mm)', leg_y_offset);
    end

    % Compute arc lengths per chunk
    arc_inner = deg2rad(chunk_angle_deg) * R_inner;
    arc_outer = deg2rad(chunk_angle_deg) * R_outer;

    % Scale stride for each leg per chunk
    stride_inner = outer_stride * (R_inner / R_outer);
    stride_outer = outer_stride;

    % Phase shifts for trot gait
    phase_shift = struct('LF', 0, 'RH', 0, 'RF', 0.5, 'LH', 0.5);

    % === Main loop over chunks ===
    for chunk = 1:n_chunks
        for i = 1:numel(legs)
            leg_id = legs{i};
            leg = robot.legs.(leg_id);

            % Decide stride
            if ismember(leg_id, inner_legs)
                stride = stride_inner;
            else
                stride = stride_outer;
            end

            % Get gait segment
            [q_leg, ~] = generateLegGaitTable(leg, steps_per_cycle, stride, step_height, phase_shift.(leg_id));

            % Append to total gait
            gait.(leg_id) = [gait.(leg_id); q_leg];
        end
    end

    disp("Curved walking gait (Option 1) generated:");
    disp("→ Turn direction: " + turn_direction);
    disp("→ Total angle: " + total_angle_deg + " deg");
    disp("→ Chunks: " + n_chunks);
    disp("→ Inner stride: " + round(stride_inner, 2) + " mm");
    disp("→ Outer stride: " + outer_stride + " mm");
end
