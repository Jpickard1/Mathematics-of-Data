%% Laplaican Convergence
%
% Auth: Joshua Pickard
%       jpic@umich.edu
% Date: January 31, 2023

% TODO: Vary structure of A to see how it changes convergence
A = [0 1 1 0;
     1 0 0 0;
     1 0 0 1;
     0 0 1 0];
D = diag(sum(A));
L = D - A;

% Solve system 
x0     = 10 * rand(size(A,1),1);
tspan  = [1, 10];
[t, x] = ode45(@concensusODE, tspan, x0);

figure;
subplot(1,2,1); hold on; title('Network Structure')
plot(graph(A));
subplot(1,2,2); hold on; title('Dynamics')
plot(t, x);
legend()

function dy = concensusODE(x, L)
    dy = -L * x;
end
