% File: core/RoboticLeg.m
classdef RoboticLeg
    properties
        isLeft
        isFront
        robot
        name
        side
        q_home
        T_symbolic
        neutralPos  % [x, y, z] in body frame- standing pos
        poses; % pre defined positions
        q_current;

    end

    methods
        function obj = RoboticLeg(isLeft, isFront, name)
            obj.isLeft = isLeft;
            obj.isFront = isFront;
            obj.name = name;
            obj.side = obj.getSideStr();

            alpha_sign = isLeft * 2 - 1;  % +1 for left, -1 for right
            hip_offset = (isFront * 2 - 1) * 134.3;

            % Define links
            J1 = Link('d', 0, 'a', 100, 'alpha', pi/2 * alpha_sign);
            J2 = Link('d', hip_offset, 'a', 0, 'alpha', pi/2);
            J3 = Link('d', 42, 'a', 125, 'alpha', 0);
            J4 = Link('d', 0, 'a', 125, 'alpha', 0);

            obj.robot = SerialLink([J1 J2 J3 J4], 'name', name);
            obj.robot.base = eye(4);

            % Set neutral (standing) foot position
            if isFront
                x = +134.3;
            else
                x = -134.3;
            end

            if isLeft
                y = +142;
            else
                y = -142;
            end

            z = -176.8;

            obj.neutralPos = [x, y, z];



            % Set correct q_home per leg
            if isLeft && isFront
                obj.q_home = [ pi/2, pi/2, -3*pi/4, -pi/2 ];
            elseif ~isLeft && isFront
                obj.q_home = [-pi/2, pi/2, -pi/4,  pi/2 ];
            elseif isLeft && ~isFront
                obj.q_home = [ pi/2, pi/2, 3*pi/4,  pi/2 ];
            else  % Right Hind
                obj.q_home = [-pi/2, pi/2,  pi/4, -pi/2 ];
            end

            obj.T_symbolic = obj.buildSymbolicTransform();

            obj = obj.assignDefaultPoses();
        end


        function teach(obj, q)
            obj.robot.teach(q, 'view', 'x', 'jointdiam', 1.5);
        end

        function T = buildSymbolicTransform(obj)
            syms c1 s1 c2 s2 c3 s3 c4 s4 real

            % alpha_sign = obj.isLeft * 2 - 1;  % +1 for left, -1 for right
            hip_offset = obj.getHipOffset();

            if obj.isLeft
                % For left legs
                A1 = [c1  0  s1  100*c1;
                    s1  0 -c1  100*s1;
                    0  1   0      0;
                    0  0   0      1];
            else
                % For right legs
                A1 = [c1   0 -s1  100*c1;
                    s1   0  c1  100*s1;
                    0  -1   0       0;
                    0   0   0       1];
            end


            A2 = [c2 0 s2 0;
                s2 0 -c2 0;
                0 1 0 hip_offset;
                0 0 0 1];

            A3 = [c3 -s3 0 125*c3;
                s3 c3 0 125*s3;
                0 0 1 42;
                0 0 0 1];

            A4 = [c4 -s4 0 125*c4;
                s4 c4 0 125*s4;
                0 0 1 0;
                0 0 0 1];

            T = simplify(A1 * A2 * A3 * A4);
        end

        function [q, branches] = ik(obj, pos)
            [branches_all] = generalInverseKinematics(pos, obj.isLeft, obj.isFront);

            % Preferred branch ID per leg
            if obj.isFront && obj.isLeft
                branch_id = 3;   % supposed to be 3
            elseif obj.isFront && ~obj.isLeft
                branch_id = 2;    % supposed to be 2 (1 and 4 doesnt work)
            elseif ~obj.isFront && obj.isLeft
                branch_id = 4; % supposed to be 4
            else
                branch_id = 1; % supposed to be 1 (working- 2,3)
            end

            [q, branches] = obj.selectBranch(branches_all, pos, branch_id);
            % ---- NEW: record current angles whenever ik is called ----
             obj.q_current = q;
        end


        function [q_final, branches_all] = selectBranch(obj, branches, pos_desired, preferredBranch)
            syms c1 s1 c2 s2 c3 s3 c4 s4 real
            T = obj.T_symbolic;

            preferred_err = Inf;
            best_err = Inf;

            q_final = branches{preferredBranch};
            branches_all = branches;  % just pass them through

            for i = 1:4
                q = branches{i};

                symbols = [c1, s1, c2, s2, c3, s3, c4, s4];
                values  = [cos(q(1)), sin(q(1)), ...
                    cos(q(2)), sin(q(2)), ...
                    cos(q(3)), sin(q(3)), ...
                    cos(q(4)), sin(q(4))];

                T_eval = double(subs(T, symbols, values));
                pos_actual_sym = T_eval(1:3,4);
                pos_actual_num = obj.robot.fkine(q).t;

                disp("== Leg: " + obj.name + " | Branch: " + i + " ==");
                disp("Symbolic Position: "); disp(pos_actual_sym');
                disp("Numeric FK Position: "); disp(pos_actual_num');
                disp("Difference: "); disp(norm(pos_actual_sym - pos_actual_num));

                err = norm(pos_actual_sym - pos_desired(:));

                if i == preferredBranch
                    preferred_err = err;
                end

                if err < best_err
                    best_err = err;
                end
            end

            if preferred_err > 0.5
                warning("Leg '%s': preferred branch %d has FK error = %.3f mm (best = %.3f mm)", ...
                    obj.name, preferredBranch, preferred_err, best_err);
            end
        end



        function offset = getHipOffset(obj)
            offset = (obj.isFront * 2 - 1) * 134.3;
        end

        function s = getSideStr(obj)
            if obj.isLeft
                s = "left";
            else
                s = "right";
            end
        end

        function obj = assignDefaultPoses(obj)
            % Assign fixed poses with hardcoded foot positions
            % Use short ID like 'LF', 'RF', etc.
            if obj.isLeft && obj.isFront
                leg_name = 'LF';
            elseif ~obj.isLeft && obj.isFront
                leg_name = 'RF';
            elseif obj.isLeft && ~obj.isFront
                leg_name = 'LH';
            else
                leg_name = 'RH';
            end

            poses = struct();     % ✅ define here

            % Define foot positions for each pose based on leg identity
            switch leg_name
                case 'LF'
                    poses.standing = [134.3,  142, -176.8];
                    poses.sitting  = [120.0,  142, -160.0];   % front more forward
                    poses.lying    = [ 134,  142, -90.0];    % spread + up

                case 'RF'
                    poses.standing = [134.3, -142, -176.8];
                    poses.sitting  = [120.0, -142, -160.0];
                    poses.lying    = [ 134, -142, -90.0];

                case 'LH'
                    poses.standing = [-134.3,  142, -176.8];
                    poses.sitting  = [-80.0,   160, -100.0];  % more tucked like lying
                    poses.lying    = [-134.0,   142, -90.0];

                case 'RH'
                    poses.standing = [-134.3, -142, -176.8];
                    poses.sitting  = [-80.0,  -160, -100.0];
                    poses.lying    = [-134.0,  -142, -90.0];
            end


            % Compute IK for each foot pos
            names = fieldnames(poses);
            for i = 1:numel(names)
                name = names{i};
                pos = poses.(name);
                q = obj.ik(pos);  % use IK to compute joint angles

                obj.poses.(name).footPos = pos;
                obj.poses.(name).jointAngles = q;
            end
        end

    end
end
