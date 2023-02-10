n = 100;
d = 2;
X = rand(n,2*d);    % half the state is the position, half the state is the component velocity
numNeighbors = 5;
T = 1000;
A = cell(T, 1);
for t=1:T
    pause(0.05)
    % Update positions
    [X, A{t}] = updatePosition(X, numNeighbors);
    % Draw positions
    subplot(1,2,1);
    scatter(X(:,1), X(:,2), '.'); title('Flock');
    xlim([-10, 10]);
    ylim([-10, 10]);
    subplot(1,2,2); title('Network');
    g = digraph(A{t});
    plot(g); title('Adjacency Matrix');
end


%% Functions

function [Xnew, A] = updatePosition(X, numNeighbors)
    d = size(X,2)/2;
    D = squareform(pdist(X));
    D(D==0) = Inf;
    Xnew = X;
    A = zeros(size(X, 1));
    for i=1:size(X,1)
        % Select neighbors
        [~, I] = mink(D(i,:), numNeighbors);
        Xneighbors = X(I, :);
        xi = X(i,:);
        % Construct network
        A(i,I) = 1;
        % Center of Mass
        v1 = centerOfMass(Xneighbors, xi, 100);
        % Similarity
        v2 = noCollisions(Xneighbors, xi, 0.1);
        % Match velocity
        v3 = matchVelocity(Xneighbors, xi, 100);
        % Stay near origin
        % v4 = goHome(xi);
        % v = v4;
        v = v1 + v2 + v3; % + v4;
        % v = v1 + v2;
        Xnew(i,d+1:end) = v + X(i,d+1:end);
        Xnew(i,1:d) = Xnew(i,1:d) + Xnew(i,d+1:end);
    end
end

function dv = centerOfMass(X, xi, factor)
    d = size(X,2)/2;
    CM = sum(X(1:d),1)/size(X,1);
    dv = (CM - xi(1:d)) / factor;
end

function dv = noCollisions(X, xi, tol)
    d = size(X,2)/2;
    dv = zeros(1, d);
    for j=1:size(X,1)
        if i ~= j && norm(xi(1:d) - X(j,1:d), 2) < tol
            dv = dv - (X(j,1:d) - xi(1:d));
        end
    end
end

function dv = matchVelocity(X, xi, factor)
    d = size(X,2)/2;
    MV = (sum(X(:,d+1:end),1) - xi(d+1:end))/(size(X,1) - 1);
    dv = (MV - xi(d+1:end)) / factor;
end

function dv = goHome(xi)
    x = xi(1:(length(xi)/2));
    n = norm(x,2);
    L = 10;     % Max value
    x0 = 5;     % approximate midpoint
    k = 1;
    dvAbs = L / (1 + exp(k * (n - x0)));
    dv = dvAbs * x;
end

