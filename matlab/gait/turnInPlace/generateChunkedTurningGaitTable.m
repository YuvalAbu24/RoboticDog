function gait = generateChunkedTurningGaitTable(robot, gait_type, step_height, total_turn_deg, chunk_deg, steps_per_chunk)
% Generates a turning gait by breaking the full turn into smaller arcs.
% This improves stability and allows for smoother and more accurate control.
%
% Example usage:
% gait = generateChunkedTurningGaitTable(robot, 'trot', 40, 30, 6, 40);

    % Compute number of chunks
    n_chunks = ceil(total_turn_deg / chunk_deg);
    legs = fieldnames(robot.legs);

    % Initialize empty gait table for all legs
    gait = struct();
    for i = 1:numel(legs)
        gait.(legs{i}) = [];
    end

    % Generate and concatenate small gait arcs
    for i = 1:n_chunks
        % Angle of this chunk (final chunk might be smaller)
        remaining = total_turn_deg - (i - 1) * chunk_deg;
        this_chunk_deg = min(chunk_deg, remaining);

        % Generate gait for this arc
        gait_chunk = generateTurningGaitTable(robot, gait_type, steps_per_chunk, step_height, this_chunk_deg);

        % Concatenate into full gait
        for j = 1:numel(legs)
            leg_id = legs{j};
            gait.(leg_id) = [gait.(leg_id); gait_chunk.(leg_id)];
        end
    end
end
