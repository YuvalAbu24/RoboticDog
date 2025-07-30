function gait = enterGait(robot, duration, fps)
    if nargin < 3, fps = 30; end
    if nargin < 2, duration = 2; end

    steps = round(duration * fps);
    legs = fieldnames(robot.legs);
    gait = struct();

    % Build interpolation
    q_traj = struct();
    for i = 1:numel(legs)
        leg_id = legs{i};
        leg = robot.legs.(leg_id);
        q_start = leg.robot.getpos();
        q_goal  = leg.poses.standing.jointAngles;
        q_traj.(leg_id) = interpolatePoseTransition(q_start, q_goal, steps);
        gait.(leg_id) = [];  % Initialize gait output
    end

    % Setup figure only once
    fig = figure('Name', 'Enter Gait'); clf;
    axis equal; grid on; hold on;
    view([-30 20]);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([-200 200]); ylim([-200 200]); zlim([-250 -50]);
    title('Gait Entry');

    % Animate and record joint angles
    for s = 1:steps
        cla;
        for i = 1:numel(legs)
            leg_id = legs{i};
            leg = robot.legs.(leg_id);
            q = q_traj.(leg_id)(s, :);

            % Plot
            leg.robot.plot(q, 'delay', 0, 'noname'); hold on;

            % Store
            gait.(leg_id) = [gait.(leg_id); q];
        end
        drawnow;
    end
end
