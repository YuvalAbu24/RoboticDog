function gait = runPoseSequence(robot, pose_names, total_time, fps, save_video, video_filename)
    % === Defaults ===
    if nargin < 4, fps = 30; end
    if nargin < 3, total_time = 6; end
    if nargin < 5, save_video = false; end
    if nargin < 6, video_filename = 'pose_sequence.mp4'; end

    n_transitions = numel(pose_names) - 1;
    time_per_transition = total_time / n_transitions;
    steps_per_transition = round(time_per_transition * fps);

    % === Setup display ===
    fig = figure('Name', 'Pose Sequencer'); clf;
    axis equal; grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view([-30, 20]);
    xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -50]);
    title('Quadruped Pose Sequencer');

    % === Setup video writer ===
    if save_video
        vw = VideoWriter(video_filename, 'MPEG-4');
        vw.FrameRate = fps;
        open(vw);
    end

    legs = fieldnames(robot.legs);
    gait = struct();

    % Initialize empty arrays
    for l = 1:numel(legs)
        gait.(legs{l}) = [];
    end

    % === Transition through poses ===
    for idx = 1:n_transitions
        from_pose = pose_names(idx);
        to_pose   = pose_names(idx + 1);

        % Precompute interpolation
        q_traj = struct();
        for l = 1:numel(legs)
            leg_id = legs{l};
            leg = robot.legs.(leg_id);
            q1 = leg.poses.(from_pose).jointAngles;
            q2 = leg.poses.(to_pose).jointAngles;
            q_traj.(leg_id) = interpolatePoseTransition(q1, q2, steps_per_transition);
        end

        % Animate and store
        for step = 1:steps_per_transition
            clf;
            axis equal; grid on;
            xlabel('X'); ylabel('Y'); zlabel('Z');
            view([-30, 20]);
            xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -50]);
            title(['Pose: ', from_pose, ' → ', to_pose]);

            for l = 1:numel(legs)
                leg_id = legs{l};
                leg = robot.legs.(leg_id);
                q = q_traj.(leg_id)(step, :);

                % Append to output gait
                gait.(leg_id) = [gait.(leg_id); q];

                % Plot
                leg.robot.plot(q, 'delay', 0); hold on;
            end

            drawnow;

            % Save frame if needed
            if save_video
                frame = getframe(fig);
                writeVideo(vw, frame);
            end
        end
    end

    % Close video
    if save_video
        close(vw);
        fprintf("Video saved to: %s\n", video_filename);
    end
end
