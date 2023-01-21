function [tau, ind] = oht(Y)
% oht(Y) returns the optimal hard threshold for an unknown noise
% distribution
%
%   The data, Y, is expected to be m x n, where the m rows are 
%   the observations and the n columns are the features.
% 
% Auth: Cooper Stansbury
% Date: Jan 17, 2023

beta = size(Y,1) / size(Y,2); 
omega = 0.56*beta^3 - 0.95*beta^2 + 1.82*beta + 1.43; 
[U S V] = svd(Y); 
tau = omega * (median(diag(S)))
ind = find(diag(S)>tau, 1, 'last'); 

end

