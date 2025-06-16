% Test generateLegGaitTable

clear; clc;
dog = QuadrupedRobot();

n = 50;
stride = 80;
stepHeight = 40;
offset = 0.0;  % try 0.25 for trot

[q_table, pos_table] = generateLegGaitTable(dog.legs.LF, n, stride, stepHeight, offset);


% Plot joint angles
figure;
plot(rad2deg(q_table));
legend('q1','q2','q3','q4');
xlabel('Time Step');
ylabel('Joint Angle (deg)');
title('Joint Angles - Right Front Leg');

% % Optional: animate
% for i = 1:n
%     % dog.legs.LH.teach(q_table(i,:));
%     dog.legs.LH.robot.plot(q_table(i,:));
%     % pause(0.0005);
% end

