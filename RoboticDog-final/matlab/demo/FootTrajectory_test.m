% Test script: testFootTrajectory.m
clear; clc;
dog = QuadrupedRobot();

stride = 80;     % mm
stepHeight = 40; % mm
n = 50;          % steps to simulate

leg = dog.legs.LH;  % choose leg

trajectory = zeros(n,3);
for i = 1:n
    phase = mod((i-1)/n, 1.0);
    trajectory(i,:) = planFootTrajectory(phase, stride, stepHeight, leg);
    % disp(phase)
    % disp('')
    
end

figure;
plot3(trajectory(:,1), trajectory(:,2), trajectory(:,3), 'o-');
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Foot Trajectory - Right Front Leg');
view(3);

fprintf(' %s foot \n', leg.name);
fprintf('Z min = %.2f, Z max = %.2f\n', min(trajectory(:,3)), max(trajectory(:,3)));
fprintf('X min = %.2f, X max = %.2f\n', min(trajectory(:,1)), max(trajectory(:,1)));
