n = 100;
d = 3;
X = rand(n,2*d);    % half the state is the position, half the state is the component velocity
T = randi([0, 1], n, 1);
t0 = find(T == 0);
t1 = find(T == 1);

for t=1:100
    % Draw positions
    scatter3(X(t0,1), X(t0,2), X(t0,3), '.b'); hold on;
    scatter3(X(t1,1), X(t1,2), X(t1,3), '.r'); hold off;
    %xlim([-10, 10]);
    %ylim([-10, 10]);
    pause(0.1)
    % Update positions
    X = updatePosition(X, T);
end

%% Functions

function Xnew = updatePosition(X, T)
    d = size(X,2)/2;
    Xnew = X;
    for i=1:size(X,1)
        % Center of Mass
        v1 = centerOfMass(X, i, 10, T);
        % No Collisions
        v2 = noCollisions(X, i, 0.1, T);
        % Match velocity
        v3 = matchVelocity(X, i, 100);
        v = v1 + v2 + v3;
        % v = v1 + v2;
        Xnew(i,d+1:end) = v + X(i,d+1:end);
        Xnew(i,1:d) = Xnew(i,1:d) + Xnew(i,d+1:end);
    end
end

% Move towards other team
function dv = centerOfMass(X, i, factor, T)
    d = size(X,2)/2;
    t = find(T == T(i));
    CM = sum(X(t,1:d),1)/length(t);
    dv = (CM - X(i,1:d)) / factor;
end

% Don't collide with own team
function dv = noCollisions(X, i, tol, T)
    d = size(X,2)/2;
    dv = zeros(1, d);
    t = find(T ~= T(i));
    for j=1:length(t)
        if i ~= t(j) && norm(X(i,1:d) - X(t(j),1:d), 2) < tol
            dv = dv - (X(t(j),1:d) - X(i,1:d));
        end
    end
end

function dv = matchVelocity(X, i, factor)
    d = size(X,2)/2;
    MV = (sum(X(:,d+1:end),1) - X(i,d+1:end))/(size(X,1) - 1);
    dv = (MV - X(i,d+1:end)) / factor;
end

