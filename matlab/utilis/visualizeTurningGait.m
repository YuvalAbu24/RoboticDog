function visualizeTurningGait(robot, gait_table)
    leg_ids = fieldnames(gait_table);
    colors = struct('LF','r', 'RF','g', 'LH','b', 'RH','m');

    figure('Name','Turning Gait Foot Trajectories'); clf;
    hold on;
    grid on;
    axis equal;
    xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
    title('Foot Trajectories During Turn-in-Place');
    view(3);

    % Ground plane
    plane_z = -176.8;
    surf([-300 300; -300 300], [-300 -300; 300 300], ...
         plane_z * ones(2), 'FaceAlpha', 0.1, ...
         'EdgeColor', 'none', 'FaceColor', [0.5 0.5 0.5]);

    for i = 1:numel(leg_ids)
        leg_id = leg_ids{i};
        q_list = gait_table.(leg_id);
        leg = robot.legs.(leg_id);

        foot_positions = zeros(size(q_list,1), 3);
        for j = 1:size(q_list,1)
            q = q_list(j,:);
            T = leg.robot.fkine(q);
            foot_positions(j,:) = T.t';
        end

        plot3(foot_positions(:,1), foot_positions(:,2), foot_positions(:,3), ...
              '-o', 'Color', colors.(leg_id), 'DisplayName', leg_id);
    end

    legend show;
end
