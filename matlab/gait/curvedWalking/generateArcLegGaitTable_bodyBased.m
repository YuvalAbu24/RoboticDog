function [q_table, pos_table] = generateArcLegGaitTable_bodyBased(leg, pivot_body, ...
                                        arc_deg, step_height, stride_length, steps_per_cycle)
% One arc segment for a leg (curved walking), computed from pivot relative to body.
% All positions are returned in body frame, respecting stride length limits.

    % === Arc geometry ===
    foot_init = leg.poses.standing.footPos(:);      % [x; y; z]
    rel = foot_init(1:2) - pivot_body;              % vector from pivot to foot
    R_leg = norm(rel);                              % radius
    base_z = foot_init(3);                          % standing Z
    theta0 = atan2(rel(2), rel(1));                 % start angle
    arc_rad = deg2rad(arc_deg);                     % total arc in radians

    % === Total arc length ===
    arc_len = R_leg * arc_rad;

    % === Number of gait cycles needed ===
    n_cycles = max(1, ceil(arc_len / stride_length));
    arc_rad_per_cycle = arc_rad / n_cycles;         % arc covered per gait cycle

    % === Initialize outputs ===
    q_table = [];
    pos_table = [];

    for cycle = 1:n_cycles
        % Arc segment for this cycle
        theta_start = theta0 + (cycle - 1) * arc_rad_per_cycle;
        theta_end   = theta_start + arc_rad_per_cycle;

        % Forward (swing) and backward (stance) arc
        theta_forward  = linspace(theta_start, theta_end, steps_per_cycle/2);
        theta_backward = fliplr(theta_forward);

        for i = 1:steps_per_cycle
            phase = (i - 1) / steps_per_cycle;

            if phase < 0.5
                idx = round(phase * 2 * (steps_per_cycle/2));
                idx = max(1, min(idx, steps_per_cycle/2));
                theta = theta_forward(idx);
                z = base_z + step_height * sin(pi * phase * 2);
            else
                idx = round((phase - 0.5) * 2 * (steps_per_cycle/2));
                idx = max(1, min(idx, steps_per_cycle/2));
                theta = theta_backward(idx);
                z = base_z;
            end

            % Position in pivot frame
            x_pivot = R_leg * cos(theta);
            y_pivot = R_leg * sin(theta);

            % Position in body frame
            pos_xy = pivot_body + [x_pivot; y_pivot];
            pos_body = [pos_xy; z];

            % Inverse Kinematics
            try
                q = leg.ik(pos_body);
            catch
                warning("IK failed for %s at pos [%.1f %.1f %.1f]", ...
                    leg.name, pos_body(1), pos_body(2), pos_body(3));
                q = nan(1,4);
            end

            q_table = [q_table; q];
            pos_table = [pos_table; pos_body'];
        end
    end
end
