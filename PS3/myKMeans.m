function [clusters] = myKMeans(D, k)
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
% Auth: ...
% Date: ...

    % TODO: fill in the kmeans algorithm.
    disp("TODO: Fill in myKMeans implementation.")
    centers = zeros(k, 1);  % Save cluster centers
    [n, m] = size(D);
    clusters = zeros(n, 1); % Save cluster assignments of data

    % ''randomly'' choose the centers
    for i=1:k
        centers(i) = i;
    end

    dists = squareform(pdist(D));
    itrs = 0;
    while itrs < 10
        itrs = itrs + 1;
        % Assign all data to the cluster with the closest center
        for i=1:n
            [~, assignedCluster] = min(dists(i, centers));
            clusters(i) = assignedCluster;
        end
        % Update the center of each cluster
        for i=1:k
            clusterPoints = find(clusters == i); % 
            clusterData = D(clusterPoints,:);
            meanPoint = mean(clusterData, 1);

            clusterDataAndMean = [clusterData; meanPoint];
            clusterDists = squareform(pdist(clusterDataAndMean));
            
            distToMean = clusterDists(1:end-1,end);
            [~, minPoint] = min(distToMean);

            centers(i) = clusterPoints(minPoint);
        end
    end

end 
