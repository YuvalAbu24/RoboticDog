function traj = interpolatePoseTransition1(robot, pose_from, pose_to, n_steps)
    if nargin < 4
        n_steps = 30;
    end

    traj = struct();  % output joint trajectory per leg

    leg_names = fieldnames(robot.legs);

    for i = 1:numel(leg_names)
        leg_id = leg_names{i};
        leg = robot.legs.(leg_id);

        q_start = leg.poses.(pose_from).jointAngles;
        q_end   = leg.poses.(pose_to).jointAngles;

        % Interpolate linearly in joint space
        q_interp = zeros(n_steps, numel(q_start));
        for j = 1:n_steps
            t = (j-1)/(n_steps-1);
            q_interp(j,:) = (1-t)*q_start + t*q_end;
        end

        traj.(leg_id) = q_interp;
    end
end
