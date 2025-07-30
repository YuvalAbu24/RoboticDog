function gait_full = walkFixedDistance(robot, gait_type, stride, step_height, distance_mm, fps)
    %=== Defaults ===
    if nargin < 6
        fps = 30;
    end

    % Estimate one gait cycle length
    one_cycle_distance = stride;  % stride length = distance per cycle
    n_cycles = ceil(distance_mm / one_cycle_distance);

    % Resolution per cycle
    steps_per_cycle = 40;  % can adjust for smoothness
    total_steps = steps_per_cycle * n_cycles;

    % Generate one cycle of joint angles
    gait_single = generateFullGaitTable(robot, gait_type, steps_per_cycle, stride, step_height);

    % Repeat joint angles across cycles
    leg_ids = fieldnames(robot.legs);
    gait_full = struct();
    for i = 1:numel(leg_ids)
        leg_id = leg_ids{i};
        gait_full.(leg_id) = repmat(gait_single.(leg_id), n_cycles, 1);
    end

    %=== Animation (suppressed) ===
%    fig = figure('Name', 'Fixed Distance Gait');
%    axis equal; grid on;
%    xlabel('X'); ylabel('Y'); zlabel('Z');
%    view([-30, 20]);
%    xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
%    title(sprintf('Walk Forward: %.2f m (%s gait)', distance_mm/1000, gait_type));
%
%    for i = 1:total_steps
%        clf;
%        axis equal; grid on;
%        xlabel('X'); ylabel('Y'); zlabel('Z');
%        view([-30, 20]);
%        xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
%        title(sprintf('Step %d / %d', i, total_steps));
%
%        for j = 1:numel(leg_ids)
%            leg_id = leg_ids{j};
%            leg = robot.legs.(leg_id);
%            q = gait_full.(leg_id)(i, :);
%            leg.robot.plot(q, 'delay', 0); hold on;
%        end
%
%        drawnow;
%        pause(1/fps);
%    end

    % Final message
    disp("Finished walking " + distance_mm + " mm using '" + gait_type + "' gait.");
end