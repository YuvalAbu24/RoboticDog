
dog = QuadrupedRobot();
traj = interpolatePoseTransition(dog, 'sitting', 'standing', 40);
figure;
for i = 1:40
    clf;
    hold on;
    dog.legs.LF.robot.plot(traj.LF(i,:), 'delay', 0); hold on;
    dog.legs.RF.robot.plot(traj.RF(i,:), 'delay', 0); hold on;
    dog.legs.LH.robot.plot(traj.LH(i,:), 'delay', 0); hold on;
    dog.legs.RH.robot.plot(traj.RH(i,:), 'delay', 0); hold on;

    title(sprintf('Pose Transition Step %d/40', i));
    drawnow;
end
