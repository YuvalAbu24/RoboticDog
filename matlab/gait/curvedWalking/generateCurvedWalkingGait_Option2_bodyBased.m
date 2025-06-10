function gait = generateCurvedWalkingGait_Option2_bodyBased(robot, pivotDistance, total_deg, chunk_deg, ...
                                                  outer_stride, step_height, turning_side, steps_per_cycle)
% Curved walking using body-relative circular arcs (global cycle count) with trot phase shifts.
% Inputs:
%   robot           - QuadrupedRobot object
%   pivotDistance   - Distance from body center to turning center (always +Y)
%   total_deg       - Total rotation in degrees
%   chunk_deg       - Turning angle per gait chunk (e.g., 5 deg)
%   outer_stride    - Maximum stride length for outer legs (mm)
%   step_height     - Z lift (mm)
%   turning_side    - "left" or "right"
%   steps_per_cycle - Resolution (samples per cycle)
% Output:
%   gait - Struct of joint angle tables (equal lengths per leg)

    if nargin < 8
        steps_per_cycle = 40;
    end

    legs = fieldnames(robot.legs);
    % Phase shift for trot
    phase_shift = struct('LF', 0.0, 'RH', 0.0, 'RF', 0.5, 'LH', 0.5);

    % How many chunks and actual per-chunk angle
    n_chunks = ceil(total_deg / chunk_deg);
    actual_chunk_deg = total_deg / n_chunks;

    % Determine sign for pivot relative to body
    sign_dir = strcmp(turning_side, 'left') * 2 - 1;
    pivot_body = [0; sign_dir * pivotDistance];

    % Pre-compute radius and arc lengths for each leg
    R_leg = zeros(numel(legs),1);
    arc_len = zeros(numel(legs),1);
    for i = 1:numel(legs)
        leg_id = legs{i};
        leg = robot.legs.(leg_id);
        footPos = leg.poses.standing.footPos(:);

        % Determine if inner or outer
        is_left  = contains(leg_id, 'L');
        is_inner = xor(strcmp(turning_side, 'left'), ~is_left);
        y_off    = abs(footPos(2));

        if is_inner
            R_leg(i) = pivotDistance - y_off;
        else
            R_leg(i) = pivotDistance + y_off;
        end
        arc_len(i) = R_leg(i) * deg2rad(actual_chunk_deg);
    end

    % Global cycle count so no per-cycle stride exceeds outer_stride
    n_cycles = max(1, ceil(max(arc_len) / outer_stride));

    gait = struct();
    for i = 1:numel(legs)
        leg_id = legs{i};
        leg    = robot.legs.(leg_id);

        % Per-cycle stride for this leg
        stride_leg = arc_len(i) / n_cycles;

        % Generate one chunk (with fixed n_cycles)
        [q_leg, ~] = generateArcLegGaitTable_bodyBased(leg, pivot_body, ...
            actual_chunk_deg, step_height, stride_leg, steps_per_cycle, n_cycles);

        % Apply trot phase shift
        pts = size(q_leg,1);
        shift = round(phase_shift.(leg_id) * pts);
        q_leg = circshift(q_leg, shift, 1);

        % Repeat for all chunks
        gait.(leg_id) = repmat(q_leg, n_chunks, 1);
    end
end
