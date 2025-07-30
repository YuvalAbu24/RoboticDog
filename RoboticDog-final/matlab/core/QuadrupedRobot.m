% File: core/QuadrupedRobot.m
classdef QuadrupedRobot
    properties
        legs
    end

    methods
        function obj = QuadrupedRobot()
            % Construct the four legs with correct side and position
            obj.legs.LF = RoboticLeg(true,  true,  'Left Front');
            obj.legs.RF = RoboticLeg(false, true,  'Right Front');
            obj.legs.LH = RoboticLeg(true,  false, 'Left Hind');
            obj.legs.RH = RoboticLeg(false, false, 'Right Hind');
        end

        function teachAll(obj)
            figure;
            hold on;
            leg_names = fieldnames(obj.legs);

            % Plot each leg
            for i = 1:numel(leg_names)
                leg = obj.legs.(leg_names{i});
                leg.teach(leg.q_home);
            end
            hold off;

            % === Make Full Screen ===
            screenSize = get(0, 'ScreenSize');
            set(gcf, 'Position', screenSize);

            % === Customize Teach Panel Positions ===
            children = get(gcf, 'Children');

            positions = {
                [1,325,140,350],     % Top-left (LF)
                [1300,399,140,350],  % Top-right (RF)
                [1,1,140,350],       % Bottom-left (LH)
                [1300,1,140,350]     % Bottom-right (RH)
                };

            panel_idx = 1;
            for i = 1:length(children)
                if strcmp(get(children(i), 'Type'), 'uipanel') && ...
                        strcmp(get(children(i), 'Title'), 'Teach')
                    set(children(i), 'Position', positions{panel_idx});
                    panel_idx = panel_idx + 1;
                end
            end

            % === Add Labels ===
            text(1, 1, 'Backward Left Leg',   'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
            text(0, 0, 'Forward Right Leg',   'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
            text(0, 1, 'Backward Right Leg',  'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
            text(1, 0, 'Forward Left Leg',    'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');

            title('All Legs in Teach Panels (Standing Pose)');
        end


        function q_home_deg = getHomePositionsDeg(obj)
            leg_names = fieldnames(obj.legs);
            q_home_deg = struct();

            for i = 1:numel(leg_names)
                leg_name = leg_names{i};
                q_rad = obj.legs.(leg_name).q_home;
                q_home_deg.(leg_name) = rad2deg(q_rad);
            end
        end


        function moveLegTo(obj, legID, pos)
            % Moves a single leg to a desired end-effector position
            q = obj.legs.(legID).ik(pos);
            obj.legs.(legID).teach(q);
        end

        function moveAllToHome(obj)
            % Moves all legs to their respective home positions
            figure;
            hold on;
            leg_names = fieldnames(obj.legs);
            for i = 1:numel(leg_names)
                leg = obj.legs.(leg_names{i});
                leg.robot.plot(leg.q_home, 'view', 'x', 'jointdiam', 1.5);
            end
            hold off;
            title('Quadruped Standing Pose (All Legs at Home)');
        end
    end
end
