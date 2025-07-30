function q_traj = interpolatePoseTransition(q1, q2, n_steps)
    q1 = q1(:)';
    q2 = q2(:)';
    q_traj = zeros(n_steps, numel(q1));
    for i = 1:n_steps
        alpha = (i - 1) / (n_steps - 1);
        q_traj(i, :) = (1 - alpha) * q1 + alpha * q2;
    end
end
