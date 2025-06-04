function [q_best, branches_all] = computeIKForLeg(legID, pos)
    arguments
        legID (1,:) char
        pos (1,3) double
    end

    % Identify leg configuration
    switch upper(legID)
        case 'LF'
            isLeft = true; isFront = true; branch_preferred = 3;
        case 'RF'
            isLeft = false; isFront = true; branch_preferred = 2;
        case 'LH'
            isLeft = true; isFront = false; branch_preferred = 4;
        case 'RH'
            isLeft = false; isFront = false; branch_preferred = 1;
        otherwise
            error('Invalid legID "%s". Use one of: LF, RF, LH, RH.', legID);
    end

    % Get all 4 IK branches
    px = pos(1); py = pos(2); pz = pos(3);
    if isLeft && isFront
        [b1, b2, b3, b4] = InverseKinematic_FL(px, py, pz);
    elseif ~isLeft && isFront
        [b1, b2, b3, b4] = InverseKinematic_FR(px, py, pz);
    elseif isLeft && ~isFront
        [b1, b2, b3, b4] = InverseKinematic_HL(px, py, pz);
    else
        [b1, b2, b3, b4] = InverseKinematic_HR(px, py, pz);
    end
    branches_all = {b1, b2, b3, b4};

    % Select preferred branch
    q_best = branches_all{branch_preferred};

    % Check error via FK (optional for debug)
    T = RoboticLeg(isLeft, isFront, 'temp').buildSymbolicTransform();
    syms c1 s1 c2 s2 c3 s3 c4 s4 real
    symbols = [c1, s1, c2, s2, c3, s3, c4, s4];
    values  = [cos(q_best(1)), sin(q_best(1)), ...
               cos(q_best(2)), sin(q_best(2)), ...
               cos(q_best(3)), sin(q_best(3)), ...
               cos(q_best(4)), sin(q_best(4))];

    T_eval = double(subs(T, symbols, values));
    pos_actual = T_eval(1:3,4);
    err = norm(pos_actual - pos(:));
    disp("== Leg: " + legID + " | Branch: " + branch_preferred);

    if err > 0.5
        warning("Leg %s: preferred branch %d has FK error = %.2f mm", ...
            legID, branch_preferred, err);
    end
end
