function [q_table, pos_table] = generateArcLegGaitTable_bodyBased(leg, pivot_body, ...
                                        arc_deg, step_height, stride_length, ...
                                        steps_per_cycle, n_cycles)
% One arc segment for a leg (curved walking), using a fixed cycle count.
% All positions are returned in body frame.

    % Initial foot position
    foot_init = leg.poses.standing.footPos(:);
    rel       = foot_init(1:2) - pivot_body;
    R_leg     = norm(rel);
    base_z    = foot_init(3);
    theta0    = atan2(rel(2), rel(1));
    arc_rad   = deg2rad(arc_deg);

    % Allow fallback if n_cycles not supplied
    if nargin < 7
        arc_len = R_leg * arc_rad;
        n_cycles = max(1, ceil(arc_len / stride_length));
    end

    arc_rad_per_cycle = arc_rad / n_cycles;

    q_table   = [];
    pos_table = [];

    for cycle = 1:n_cycles
        theta_start   = theta0 + (cycle - 1) * arc_rad_per_cycle;
        theta_end     = theta_start + arc_rad_per_cycle;

        theta_forward  = linspace(theta_start, theta_end, steps_per_cycle/2);
        theta_backward = fliplr(theta_forward);

        for j = 1:steps_per_cycle
            phase = (j - 1) / steps_per_cycle;
            if phase < 0.5
                idx = round(phase * 2 * (steps_per_cycle/2));
                idx = max(1, min(idx, steps_per_cycle/2));
                theta = theta_forward(idx);
                z     = base_z + step_height * sin(pi * phase * 2);
            else
                idx = round((phase - 0.5) * 2 * (steps_per_cycle/2));
                idx = max(1, min(idx, steps_per_cycle/2));
                theta = theta_backward(idx);
                z     = base_z;
            end

            x_pivot = R_leg * cos(theta);
            y_pivot = R_leg * sin(theta);
            pos_xy  = pivot_body + [x_pivot; y_pivot];
            pos_body = [pos_xy; z];

            try
                q = leg.ik(pos_body);
            catch
                warning("IK failed for %s at pos [%%.1f %%.1f %%.1f]", ...
                        leg.name, pos_body(1), pos_body(2), pos_body(3));
                q = nan(1,4);
            end

            q_table   = [q_table; q];
            pos_table = [pos_table; pos_body'];
        end
    end
end