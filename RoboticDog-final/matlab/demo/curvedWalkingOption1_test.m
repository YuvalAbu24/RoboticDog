robot = QuadrupedRobot();

% Parameters
turn_direction = 'left';       % or 'right'
total_angle_deg = 30;          % total curve to walk
chunk_angle_deg = 5;           % how much to turn per segment
pivot_distance = 400;          % distance from body center to curve center
outer_stride = 80;             % mm
step_height = 40;              % mm
steps_per_cycle = 40;

% Generate gait
gait = generateCurvedWalkingGait_Option1(robot, turn_direction, ...
    total_angle_deg, chunk_angle_deg, pivot_distance, ...
    outer_stride, step_height, steps_per_cycle);

% Visualize
visualizeTurningGait(robot, gait);  % reuse the existing tool
visualizeFootTrajectory(gait, 'LF')

