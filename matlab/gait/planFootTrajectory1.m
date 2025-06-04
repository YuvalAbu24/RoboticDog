function pos = planFootTrajectory1(phase, stride, stepHeight, leg)
    % Center phase at neutral position (middle of stance)
    phase = mod(phase + 0.75, 1.0);  % Shift by 0.75 so we start from neutral

    % Get neutral foot position
    x0 = leg.neutralPos(1);  % You can hardcode or get from robot if not available
    y0 = leg.neutralPos(2);
    z0 = leg.neutralPos(3);

    % Set stride and lift ranges
    x_front = x0 + stride/2;
    x_rear  = x0 - stride/2;

    if phase < 0.5
        % Stance phase (foot on ground, moving back)
        s = phase / 0.5;
        x = x_front - s * (x_front - x_rear);
        z = z0;
    else
        % Swing phase (foot in air, moving forward with height)
        s = (phase - 0.5) / 0.5;
        x = x_rear + s * (x_front - x_rear);
        z = z0 + stepHeight * sin(pi * s);
    end

    pos = [x, y0, z];
end
