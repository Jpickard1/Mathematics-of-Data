% Auth: Joshua Pickard
%       jpic@umich.edu
% Date: February 2, 2023

n = 10;
p = 0.2;
A = erdos_renyi_network(n,p*nchoosek(n,2));
D = diag(sum(A));
L = D - A;

tspan  = [1, 10];
[t, x] = ode45(@concensusODE, tspan, x0);

function dt = concensusODE(L, x);
    dt = 
    dx = dv;
    dy = -L * x;
end

