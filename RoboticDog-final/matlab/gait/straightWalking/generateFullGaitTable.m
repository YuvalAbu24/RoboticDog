% File: gait/generateFullGaitTable.m
function gait_table = generateFullGaitTable(robot, gait_type, n_steps, stride, step_height)
    if nargin < 5
        error('Usage: generateFullGaitTable(robot, gait_type, n_steps, stride, step_height)');
    end

    % Define gait phase offsets
    switch lower(gait_type)
        case 'walk'
            phase_map = struct('LF', 0.0, 'RF', 0.5, 'LH', 0.75, 'RH', 0.25);
        case 'trot'
            phase_map = struct('LF', 0.0, 'RF', 0.5, 'LH', 0.5, 'RH', 0.0);
        otherwise
            error("Unsupported gait type '%s'. Use 'walk' or 'trot'", gait_type);
    end

    % Prepare output structure
    leg_names = fieldnames(robot.legs);
    gait_table = struct();

    % Iterate over legs
    for i = 1:numel(leg_names)
        leg_id = leg_names{i};
        leg = robot.legs.(leg_id);
        phase_offset = phase_map.(leg_id);

        joint_traj = zeros(n_steps, 4);  % 4 joints per leg

        for j = 1:n_steps
            % Compute global phase and apply offset
            phase = mod((j-1)/n_steps + phase_offset, 1.0);

            % Get end-effector pos
            pos = planFootTrajectory(phase, stride, step_height, leg);

            % Get joint angles
            q = leg.ik(pos);
            joint_traj(j, :) = q;
        end

        gait_table.(leg_id) = joint_traj;
    end
end
