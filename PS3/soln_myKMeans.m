function [clusters] = soln_myKMeans(D, k, itrs)
% MYKMEANS: This function implements the K-Means algorithm
%    
%   INPUTS:
%       k: number of clusters in the data
%       D: n x m data matrix where each row (n) is one sample containing
%       (m) features in the columns
%
%   OUTPUT:
%       cluters: a n x 1 vector where the ith entry indicates which cluster
%       the ith row of D is assigned to.
%
%   EXAMPLE:
%       D = rand(100, 2); k = 3; soln_myKMeans(D, k, 10)
%
% Auth: ...
% Date: ...

% Get size of data matrix
[n, f] = size(D);

% Compute distances between all samples
dists = squareform(pdist(D));

centers = randi([1 n], k, 1);
clusters = zeros(n,1);
clustersNew = ones(n,1); centersNew = ones(k,1);
itr = 0;
while sum(clusters == clustersNew) ~= n && sum(centers == centersNew) ~= n && itr < itrs
    % Save results from previous iteration
    clusters = clustersNew;
    centers = centersNew;
    % Assign all samples to clusters
    for i=1:n
        % Check minimum distance to any cluster centers
        [~, c] = min(dists(i,centers));
        % Update cluster assignment for loop i
        clustersNew(i) = c;
    end
    % Update cluster centers
    for i=1:k
        % Select samples in cluster i
        samples = find(clusters == i);
        % Get data of samples in cluster i
        Di = D(samples,:);
        % Compute mean value in cluster i
        mu = mean(Di,1);
        % Compute distances of all samples in cluster i to the average
        distI = squareform(pdist([Di; mu]));
        % Get distances from all samples in cluster i to mu
        dMu = distI(end,1:end-1);
        [~, ci] = min(dMu);
        % Set new cluster center
        centersNew(i) = samples(ci);
    end
    itr = itr + 1;
end
clusters = clustersNew;
end
