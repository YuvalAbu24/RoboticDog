% front left inverse kinematic
function [branch1,branch2,branch3,branch4]=InverseKinematic_FL(px,py,pz)

disp('')
disp('front left foot :')
disp('')

% define symbolic robot forward kinematic
syms c1 s1 c2 s2 c3 s3 c4 s4
%front left:
A1_0_fl=[c1 0 s1 100*c1;s1 0 -c1 100*s1;0 1 0 0;0 0 0 1];
A2_1_fl=[c2 0 s2 0;s2 0 -c2 0;0 1 0 134.3;0 0 0 1];
A3_2_fl=[c3 -s3 0 125*c3;s3 c3 0 125*s3;0 0 1 42;0 0 0 1];
A4_3_fl=[c4 -s4 0 125*c4;s4 c4 0 125*s4;0 0 1 0;0 0 0 1];
A_fl=simplify(A1_0_fl*A2_1_fl*A3_2_fl*A4_3_fl);

A=subs(A_fl,s1,sin(pi/2));
A=subs(A,c1,cos(pi/2));
% disp(A)


%%  usefull equations 
X=A(1,4);
Y=A(2,4);
Z=A(3,4);

%% THETA 2
%from the dog's face view with trigo we got that -->
a=42;
c_square=(py-100)^2+pz^2;
D=sqrt(c_square-a^2);

alpha=atan2(-pz,(py-100));
beta_1=atan2(D,a);
beta_2=atan2(-D,a);

theta2_1=-alpha-beta_1+pi/2;  % final version fr
theta2_2=-alpha-beta_2+pi/2;  % final version fr


if rad2deg(theta2_1)>180
    theta2_1=2*pi-theta2_1;
end

disp('theta 2_1 is:')
disp(rad2deg(theta2_1))

if rad2deg(theta2_2)>180
    theta2_2=2*pi-theta2_2;
end

disp('theta 2_2 is:')
disp(rad2deg(theta2_2))
%% THETA 4
% i did the comparison analyticlly
cosinus4=(D^2+(px-134.3)^2-2*125^2)/(2*125^2);
sinus4=sqrt(1-cosinus4^2);

theta4_1=atan2(sinus4,cosinus4);
disp('theta 4_1 is:')
disp(rad2deg(theta4_1))
theta4_2=atan2(-sinus4,cosinus4);
disp('theta 4_2 is:')
disp(rad2deg(theta4_2))

%% Theta 3
% all the calculations are in the notebook...

% X=subs(X,c2,cos(theta2_1));
% X=subs(X,s2,sin(theta2_1));
% X=subs(X,c4,cos(theta4_1));
% X=subs(X,s4,sin(theta4_1));
% 
% Y=subs(Y,c2,cos(theta2_1));
% Y=subs(Y,s2,sin(theta2_1));
% Y=subs(Y,c4,cos(theta4_1));
% Y=subs(Y,s4,sin(theta4_1));
% 
% Z=subs(Z,c2,cos(theta2_1));
% Z=subs(Z,s2,sin(theta2_1));
% Z=subs(Z,c4,cos(theta4_1));
% Z=subs(Z,s4,sin(theta4_1));

c5=px-134.3;
b5_1=125+125*cos(theta4_1);
b5_2=125+125*cos(theta4_2);
a5_1=125*sin(theta4_1);
a5_2=125*sin(theta4_2);

theta3_1_1=(atan2(b5_1,a5_2)+atan2(-sqrt(a5_2^2+b5_1^2-c5^2),c5)); % KNEE FORWARD, outside leg plain
disp('theta theta3_1_1 is:')
disp(rad2deg(theta3_1_1))
theta3_1_2=atan2(b5_1,a5_1)+atan2(-sqrt(a5_1^2+b5_1^2-c5^2),c5); % knee backward, outside leg plain
disp('theta theta3_1_2 is:')
disp(rad2deg(theta3_1_2))

theta3_2_1=atan2(b5_2,a5_2)+atan2(sqrt(a5_2^2+b5_2^2-c5^2),c5); % knee backwrads- preffered branch
disp('theta theta3_2_1 is:')
disp(rad2deg(theta3_2_1))
theta3_2_2=(atan2(b5_2,a5_1)+atan2(sqrt(a5_1^2+b5_2^2-c5^2),c5));% kneee forward 
disp('theta theta3_2_2 is:')
disp(rad2deg(theta3_2_2))

% making sure all values between -pi -> pi
% % if theta2_1 > pi
% %     theta2_1=theta2_1-(2*pi);
% % end
% % if theta2_1< -pi
% %     theta2_1=theta2_1+(2*pi);
% % end
% % if theta2_1==-pi
% %     theta2_1=pi;
% % end
% % 
% % 
% % if theta3_1_1 > pi
% %     theta3_1_1=theta3_1_1-(2*pi);
% % end
% % if theta3_1_1< -pi
% %     theta3_1_1=theta3_1_1+(2*pi);
% % end
% % if theta3_1_1==-pi
% %     theta3_1_1=pi;
% % end
% % 
% % 
% % if theta4_2 > pi
% %     theta4_2=theta4_2-(2*pi);
% % end
% % if theta4_2< -pi
% %     theta4_2=theta4_2+(2*pi);
% % end
% % if theta4_2==-pi
% %     theta4_2=pi;
% % end
% % 
% % 
% % if theta3_1_2 > pi
% %     theta3_1_2=theta3_1_2-(2*pi);
% % end
% % if theta3_1_2< -pi
% %     theta3_1_2=theta3_1_2+(2*pi);
% % end
% % if theta3_1_2 ==-pi
% %     theta3_1_2=pi;
% % end  
% % 
% % 
% % if theta4_1 > pi
% %     theta4_1=theta4_1-(2*pi);
% % end
% % if theta4_1< -pi
% %     theta4_1=theta4_1+(2*pi);
% % end
% % if theta4_1==-pi
% %     theta4_1=pi;
% % end
% % 
% % 
% % if theta2_2 > pi
% %     theta2_2=theta2_2-(2*pi);
% % end
% % if theta2_2< -pi
% %     theta2_2=theta2_2+(2*pi);
% % end
% % if theta2_2==-pi
% %     theta2_2=pi;
% % end
% % 
% % 
% % if theta3_2_1 > pi
% %     theta3_2_1=theta3_2_1-(2*pi);
% % end
% % if theta3_2_1< -pi
% %     theta3_2_1=theta3_2_1+(2*pi);
% % end
% % if theta3_2_1==-pi
% %     theta3_2_1=pi;
% % end
% % 
% % 
% % if theta3_2_2 > pi
% %     theta3_2_2=theta3_2_2-(2*pi);
% % end
% % if theta3_2_2< -pi
% %     theta3_2_2=theta3_2_2+(2*pi);
% % end
% % if theta3_2_2==-pi
% %     theta3_2_2=pi;
% % end
%% Branches

disp('first branch')
disp([rad2deg(pi/2),rad2deg(theta2_1),rad2deg(theta3_1_1),rad2deg(theta4_2)])
disp('')
disp('second branch')
disp([rad2deg(pi/2),rad2deg(theta2_1),rad2deg(theta3_1_2),rad2deg(theta4_1)])
disp('')
disp('third branch')
disp([rad2deg(pi/2),rad2deg(theta2_2),rad2deg(theta3_2_1),rad2deg(theta4_2)])
disp('')
disp('fourth branch')
disp([rad2deg(pi/2),rad2deg(theta2_2),rad2deg(theta3_2_2),rad2deg(theta4_1)])
disp('')

branch1=[pi/2,theta2_1,theta3_1_1,theta4_2];
branch2=[pi/2,theta2_1,theta3_1_2,theta4_1];
branch3=[pi/2,theta2_2,theta3_2_1,theta4_2];
branch4=[pi/2,theta2_2,theta3_2_2,theta4_1];
end


