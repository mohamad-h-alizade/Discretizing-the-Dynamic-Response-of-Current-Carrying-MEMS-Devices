clear 
clc
close all
clf

%% Change amp to achieve different inputs. amp = [0.1, 0.2, 0.3]
amp = 0.2;
Ts = 0.15;
T = [10*Ts, 5*Ts, 2*Ts, 1.1*Ts, Ts, 0.9*Ts, 0.5*Ts, 0.1*Ts];

%% defining parameters with sysms
x = sym('x', [2,1]);
x_dot = sym('x_dot', [2, 1]);
syms u;

x_equ = [0.2; 0];
u_equ = 0.16;

x_dot(1) = x(2);
x_dot(2) = -x(1) - x(2) + u/(1-x(1));

%% Taking jacobian and subbing it. 
A = jacobian(x_dot, x);
B = jacobian(x_dot, u);

A = double(subs(A, [x; u], [x_equ; u_equ]))
B = double(subs(B, [x; u], [x_equ; u_equ]))

%% Finding the Eigen values of A
Poles = eig(A)

%% Computing the output
mdl = 'non_linear_system.slx';
open_system(mdl)
sim(mdl);

%% Bode's diagrams
for t=T
    
    G = tf([1.25*t^2],[1, -(2-t), 1-t+3/4*t^2]);
    bode(G)
    hold on
end
legend('10Ts','5Ts','2Ts','1.1Ts','Ts','0.9Ts','0.5Ts','0.1Ts')
