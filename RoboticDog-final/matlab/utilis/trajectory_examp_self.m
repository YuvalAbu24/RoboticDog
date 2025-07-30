body=[0,0];
leg=[-134.3,142];
r=300;
pivot=body+[0,r];

Rin=norm(pivot-leg);
alpha=asin(-134.3/Rin);
theta0=-alpha-pi/2;
theta_final=theta0+deg2rad(20)-pi/2;
theta=linspace(theta0,theta_final,20);
x_pivot=pivot(1) + Rin*cos(theta);
y_pivot=pivot(2) + Rin*sin(theta);

figure;
plot(body(1), body(2), 'bo','LineWidth',1.5); hold on;
plot(leg(1), leg(2), 'ko','LineWidth',1.5);  % Circle center
plot(pivot(1), pivot(2), 'go','LineWidth',1.5);  % Circle center
plot(x_pivot, y_pivot, 'g.-', 'MarkerFaceColor', 'r');  % Circle center
axis equal;
legend('body','leg','pivot')
grid on;
xlabel('X'); ylabel('Y');
title('Circular Trajectory');