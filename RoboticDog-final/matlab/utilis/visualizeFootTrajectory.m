function visualizeFootTrajectory(gait_table, leg_id)
    % gait_table: struct returned by generateFullGaitTable()
    % leg_id: string like 'LF', 'RH', etc.

    q_list = gait_table.(leg_id);
    n = size(q_list, 1);

    % Get robot model
    robot = QuadrupedRobot();
    leg = robot.legs.(leg_id);

    % Collect end-effector positions
    foot_positions = zeros(n, 3);
    for i = 1:n
        q = q_list(i, :);
        T = leg.robot.fkine(q);
        foot_positions(i, :) = T.t';
    end

    % Plot
    figure('Name', ['Foot Trajectory - ', leg_id]);
    plot3(foot_positions(:,1), foot_positions(:,2), foot_positions(:,3), '-o');
    xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
    title(['Foot Trajectory for ', leg_id, ' Leg']);
    grid on; axis equal;
    view(3);
end
