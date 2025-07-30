function pos = planFootTrajectory(phase, strideLength, stepHeight, leg)
    % Computes the 3D foot position based on gait phase (0–1)
    % relative to the robot's body center.
    % Inputs:
    %   phase        ∈ [0,1)
    %   strideLength ∈ mm, total forward+backward X motion
    %   stepHeight   ∈ mm, peak lift from neutral Z
    %   leg: RoboticLeg object with .neutralPos = [x0, y0, z0]

    % Make sure phase is in [0,1)
    phase = mod(phase + 0.75, 1.0);


    % Neutral position (e.g. standing pose)
    x0 = leg.neutralPos(1);
    y0 = leg.neutralPos(2);
    z0 = leg.neutralPos(3);

    % Split phase into swing/stance
    if phase < 0.5
        % === Swing phase ===
        % Move X forward (from back to front)
        swing_phase = phase / 0.5;  % maps [0,0.5) → [0,1]
        x = x0 - strideLength/2 + swing_phase * strideLength;

        % Parabolic Z trajectory (0 at start/end, max at mid)
        z = z0 + stepHeight * 4 * swing_phase * (1 - swing_phase); % known prabolic equation. when swing_phase is 0 or 1 z=nutralPos, max(z) when swing_phase=0.5.
    else
        % === Stance phase ===
        % Move X backward (from front to back)
        stance_phase = (phase - 0.5) / 0.5;  % maps [0.5,1) → [0,1]
        x = x0 + strideLength/2 - stance_phase * strideLength;

        % Z stays flat (foot on ground)
        z = z0;
    end

    % Y doesn't change — it's lateral leg offset
    pos = [x, y0, z];
end
