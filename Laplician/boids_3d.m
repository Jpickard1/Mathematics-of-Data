n = 100;
d = 3;
X = rand(n,2*d);    % half the state is the position, half the state is the component velocity

for t=1:100
    % Draw positions
    scatter3(X(:,1), X(:,2), X(:,3),'.')
    %xlim([-10, 10]);
    %ylim([-10, 10]);
    pause(0.1)
    % Update positions
    X = updatePosition(X);
end

%% Functions

function Xnew = updatePosition(X)
    d = size(X,2)/2;
    Xnew = X;
    for i=1:size(X,1)
        % Center of Mass
        v1 = centerOfMass(X, i, 100);
        % Similarity
        v2 = noCollisions(X, i, 0.1);
        % Match velocity
        v3 = matchVelocity(X, i, 100);
        v = v1 + v2 + v3;
        % v = v1 + v2;
        Xnew(i,d+1:end) = v + X(i,d+1:end);
        Xnew(i,1:d) = Xnew(i,1:d) + Xnew(i,d+1:end);
    end
end

function dv = centerOfMass(X, i, factor)
    d = size(X,2)/2;
    CM = sum(X(1:d),1)/size(X,1);
    dv = (CM - X(i,1:d)) / factor;
end

function dv = noCollisions(X, i, tol)
    d = size(X,2)/2;
    dv = zeros(1, d);
    for j=1:size(X,1)
        if i ~= j && norm(X(i,1:d) - X(j,1:d), 2) < tol
            dv = dv - (X(j,1:d) - X(i,1:d));
        end
    end
end

function dv = matchVelocity(X, i, factor)
    d = size(X,2)/2;
    MV = (sum(X(:,d+1:end),1) - X(i,d+1:end))/(size(X,1) - 1);
    dv = (MV - X(i,d+1:end)) / factor;
end

