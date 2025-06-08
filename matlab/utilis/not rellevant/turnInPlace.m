function turnInPlace(robot, gait_type, turn_deg, step_height, n_cycles)
    steps_per_cycle = 40;
    total_steps = steps_per_cycle * n_cycles;
    gait_one = generateTurningGaitTable(robot, gait_type, steps_per_cycle, step_height, turn_deg / n_cycles);

    % Repeat across cycles
    legs = fieldnames(robot.legs);
    gait_full = struct();
    for i = 1:numel(legs)
        leg_id = legs{i};
        gait_full.(leg_id) = repmat(gait_one.(leg_id), n_cycles, 1);
    end

    % === Animation ===
    fig = figure('Name', 'Turning Gait');
    axis equal; grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view([-30, 20]);
    xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
    title(sprintf('Turn In Place: %.0f deg (%s gait)', turn_deg, gait_type));

    for i = 1:total_steps
        clf;
        axis equal; grid on;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        view([-30, 20]);
        xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
        title(sprintf('Turning... Step %d / %d', i, total_steps));

        for j = 1:numel(legs)
            leg_id = legs{j};
            leg = robot.legs.(leg_id);
            q = gait_full.(leg_id)(i, :);
            leg.robot.plot(q, 'delay', 0); hold on;
        end

        drawnow;
        pause(0.033);  % ~30 FPS
    end

    disp(" Finished turning " + turn_deg + " degrees using '" + gait_type + "' gait.");
end
