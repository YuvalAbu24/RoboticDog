% File: ik/generalInverseKinematics.m
function branches = generalInverseKinematics(pos, isLeft, isFront)
    % Choose the correct IK logic block based on configuration
    px=pos(1);
    py=pos(2);
    pz=pos(3);
    if isLeft && isFront
        [b1, b2, b3, b4] = InverseKinematic_FL(px, py, pz);
    elseif isLeft && ~isFront
        [b1, b2, b3, b4] = InverseKinematic_HL(px, py, pz);
    elseif ~isLeft && isFront
        [b1, b2, b3, b4] = InverseKinematic_FR(px, py, pz);
    else
        [b1, b2, b3, b4] = InverseKinematic_HR(px, py, pz);
    end

    branches = {b1, b2, b3, b4};
end
