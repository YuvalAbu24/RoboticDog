function exportGaitToPWM(gait, filename)
% Converts a gait (joint angles in radians) to PWM values and saves as CSV.
% Adds a delay column based on max joint movement per step.
%
% Input:
%   gait     - struct with fields LF, RF, LH, RH, each [N x 4]
%   filename - string, output CSV file name

    MS_PER_DEG = 3;  % conservative estimate for most servos ( based on servo timing check)

    % === Step 1: Extract joint angles in degrees ===
    LF_deg = rad2deg(gait.LF(:,2:4));
    RF_deg = rad2deg(gait.RF(:,2:4));
    LH_deg = rad2deg(gait.LH(:,2:4));
    RH_deg = rad2deg(gait.RH(:,2:4));

    % === Step 2: Combine into single [N x 12] matrix ===
    joint_deg = [LF_deg, RF_deg, LH_deg, RH_deg];

    % === Step 3: Per-joint offset (calibration to real robot) ===
    offsets = [...
        0, 0, 0,  ... LF1, LF2, LF3
        0, 0, 0,  ... RF1, RF2, RF3
        0, 0, 0,  ... LH1, LH2, LH3
        0, 0, 0]; ... RH1, RH2, RH3

    % LF_deg(:,1)=LF_deg(:,1)-offsets(1);
    % 
    % RF_deg(:,1)=RF_deg(:,1)-offsets(4);
    % 
    % LH_deg(:,1)=180-LH_deg(:,1);
    % RH_deg(:,1)=180-RH_deg(:,1);
    % joint_deg = [LF_deg, RF_deg, LH_deg, RH_deg];


    joint_deg = joint_deg - offsets;

    

    % === Step 4: Clamp to [0, 180] ===
    over_max = joint_deg > 180;
    under_min = joint_deg < 0;

    if any(over_max(:))
        warning('Some joint angles exceeded 180° and were clamped.');
        joint_deg(over_max) = 180;
    end
    if any(under_min(:))
        warning('Some joint angles went below 0° and were clamped.');
        joint_deg(under_min) = 0;
    end

    % === Step 5: Map to PWM ===
    %pwm_min = 450;
    %pwm_max = 2450;

    %pwm = pwm_min + (joint_deg / 180) * (pwm_max - pwm_min);

    % === Step 6: Compute Delay Column ===
    % Compute max angle change between consecutive rows
    angle_diff = abs(diff(joint_deg));          % [N-1 x 12]
    max_change_per_step = max(angle_diff, [], 2);  % [N-1 x 1]

    % Delay in ms for each step (same length as pwm-1)
    delay_ms = max(max_change_per_step * MS_PER_DEG, 20);  % Enforce minimum 20ms delay

    % For last step (no next row), repeat last delay
    delay_ms = [delay_ms; delay_ms(end)];

    % === Step 7: Append delay as 13th column ===
    angle_with_delay = [joint_deg, round(delay_ms)];

    % === Step 8: Export to CSV ===
    writematrix(angle_with_delay, filename);

    fprintf(" Gait exported to PWM CSV with delays: %s\n", filename);
end

% example usage:
% Suppose you already have a gait struct from MATLAB:

% exportGaitToPWM(gait, 'walk_pwm.csv');
