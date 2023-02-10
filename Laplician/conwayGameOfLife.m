% Auth: Joshua Pickard
%       jpic@umich.edu
% Date: February 2, 2023

%% TODO: Set initial conditions

T = 100;
for t=1:T
    drawLife(X);
    X = updateLife(X);
end

%% Functions

function drawLife(X)
    
end