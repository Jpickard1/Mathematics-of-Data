function [A] = computeA(X,r,metric)
% computeA(X,r) generates an affinity matrix from input data.
%
%   The data, X, is expected to be m x n, where the m rows are 
%   the observations and the n columns are the features. The 
%   algorithm is as follows:
%   
%   (1) Center the data matrix X, Xc
%   (2) Compute the SVD of Xc = USV^T
%   (3) Construct P from r columns of U
%   (4) Construct A, the distance between rows of P using metric d
% 
% Auth: Cooper Stansbury
% Date: Dec 6, 2022

% center data
Xc = X - mean(X);

% take the SVD of Xc
[U, S, V] = svd(Xc,'econ');

% construct P
P = U(:,1:r);

% construct A
dists = pdist(P, metric);
A = squareform(dists);

end

