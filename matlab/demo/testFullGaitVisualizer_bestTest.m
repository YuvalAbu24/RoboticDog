% File: testFullGaitVisualizer.m
clear; clc;

dog = QuadrupedRobot();

% Gait settings
gait_type   = 'trot';  % 'walk' or 'trot'
n_steps     = 40;
stride      = 80;
step_height = 40;
n_cycles    = 3;  % number of full gait cycles

% Generate gait table
gait = generateFullGaitTable(dog, gait_type, n_steps, stride, step_height);

% Video export
save_video = true;
video_filename = ['quadruped_', gait_type, '_gait.mp4'];

if save_video
    video = VideoWriter(video_filename, 'MPEG-4');
    video.FrameRate = 15;
    open(video);
end

% Setup figure
fig = figure('Name', ['Quadruped Gait: ', upper(gait_type)]);
view_angle = [-30, 20];
workspace = [-250 250 -250 250 -300 0];

for cycle = 1:n_cycles
    for i = 1:n_steps
        clf;
        axis equal;
        axis(workspace);
        grid on;
        view(view_angle);
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(['Quadruped Gait: ', upper(gait_type)]);

        % Plot all four legs (no special options)
        dog.legs.LF.robot.plot(gait.LF(i,:), 'delay', 0); hold on;
        dog.legs.RF.robot.plot(gait.RF(i,:), 'delay', 0); hold on;
        dog.legs.LH.robot.plot(gait.LH(i,:), 'delay', 0); hold on;
        dog.legs.RH.robot.plot(gait.RH(i,:), 'delay', 0); hold on;

        drawnow;

        if save_video
            frame = getframe(fig);
            writeVideo(video, frame);
        end
    end
end

if save_video
    close(video);
    fprintf('✅ Video saved: %s\n', video_filename);
end
