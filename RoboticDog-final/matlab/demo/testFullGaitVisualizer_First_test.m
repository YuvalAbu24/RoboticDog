% File: testFullGaitVisualizer.m
clear; clc;
 %%%%%   ||||cant plot 'trot' yet... ||||||   %%%%

dog = QuadrupedRobot();

% Gait settings
gait_type   = 'walk';  % walk or 'trot'
n_steps     = 40;
stride      = 80;
step_height = 40;
n_cycles    = 3;  % how many gait cycles to simulate

% Generate gait table
gait = generateFullGaitTable(dog, gait_type, n_steps, stride, step_height);

% Video writer setup
video_filename = ['quadruped_', gait_type, '_gait.mp4'];
video = VideoWriter(video_filename, 'MPEG-4');
video.FrameRate = 15;  % control speed
open(video);

% Setup figure
fig = figure('Name','Quadruped Gait Visualizer');
axis equal;
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
view([-30, 20]);
xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
title(['Quadruped Gait: ', upper(gait_type)]);

for ii = 1:n_cycles
    for i = 1:n_steps
        clf;  % clear figure each frame
        axis equal; grid on;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        view([-30, 20]);
        xlim([-200, 200]); ylim([-200, 200]); zlim([-250, -100]);
        title(['Quadruped Gait: ', upper(gait_type)]);
        
        % Plot all legs
        dog.legs.LF.robot.plot(gait.LF(i,:), 'delay', 0); hold on;
        dog.legs.RF.robot.plot(gait.RF(i,:), 'delay', 0); hold on;
        dog.legs.LH.robot.plot(gait.LH(i,:), 'delay', 0); hold on;
        dog.legs.RH.robot.plot(gait.RH(i,:), 'delay', 0); hold on;
      
        drawnow;
        frame = getframe(fig);
        writeVideo(video, frame);
        % pause(0.001)
    end
end

close(video);
fprintf('Video saved to: %s\n', video_filename);


