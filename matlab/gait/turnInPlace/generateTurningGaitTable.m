function gait = generateTurningGaitTable(robot, gait_type, n_steps, step_height, total_turn_deg)
    % Generates a turning gait by rotating foot positions around body center.
    % only for one chunk of the full rotation
    % Assumes equal split between stance and swing.

    legs = fieldnames(robot.legs);
    gait = struct();

    % Convert total angle to radians
    total_angle_rad = deg2rad(total_turn_deg);

    % Phase shifts for trot gait (0 and 180 degrees out of phase)
    if strcmp(gait_type, 'trot')
        phase_shift = struct('LF', 0, 'RH', 0, 'RF', 0.5, 'LH', 0.5);
    else
        error("Only 'trot' turning gait implemented for now.");
    end

    % How much to rotate each leg over the gait
    swing_arc = total_angle_rad;

    % For each leg
    for i = 1:numel(legs)
        leg_id = legs{i};
        leg = robot.legs.(leg_id);
        q_traj = zeros(n_steps, 4);

        % Get base foot position (standing pose)
        base_pos = leg.poses.standing.footPos(:);
        R = norm(base_pos(1:2));              % radius from body center
        base_angle = atan2(base_pos(2), base_pos(1));  % polar angle

        % Compute angle increment
        arc_angles = linspace(0, swing_arc, n_steps/2);  % only for swing

        % Phase offset (in steps)
        offset = phase_shift.(leg_id);
        offset_steps = round(offset * n_steps);

        for j = 1:n_steps
            % Time with phase offset
            idx_shifted = mod(j - 1 + offset_steps, n_steps) + 1;

            % Determine if in swing or stance
            if idx_shifted <= n_steps/2
                % === Swing phase ===
                theta = base_angle + arc_angles(idx_shifted);
                x = R * cos(theta);
                y = R * sin(theta);
                phase_t = (idx_shifted - 1) / (n_steps/2 - 1);  % [0,1]
                z = base_pos(3) + step_height * sin(pi * phase_t);  % smooth arc
            else
                % === Stance phase ===
                x = base_pos(1);
                y = base_pos(2);
                z = base_pos(3);
            end

            pos_target = [x; y; z];
            [q, ~] = leg.ik(pos_target);
            q_traj(j, :) = q;
        end

        gait.(leg_id) = q_traj;
    end
end
