% COORDINATION/ANTI-COORDINATION GAME
%   n players
%   e games
%   3-player games (3-way hypergraph)
%
% RULES: Each round consists of every player giving thumbs up or down. If
%   all 3 players give the same response, each player gets +1 points. If
%   player A deviates and B and C, then player A gets +2 and players B and
%   C get -1.
%
% OBSERVING THE SYSTEM:
%   SITUATION 1: We can monitor the scores of each player (STATE) but we
%      can't monitor the hypergraph of which games players participate in.
%      Determine the hypergraph structure by monitoring scores.
%   SITUATION 2: We know which players participate in which games, and we
%       can monitor the scores of k players after each round. Determine the
%       scores of each player after each round from information on only k.
%
% STATE: After each round, the scores of individual players are known, but
%   at no point can we monitor who is playing in which game.
%
% Auth: Joshua Pickard
%       jpic@umich.edu
% Date: February 2, 2023




HG = HAT.uniformErdosRenyi(10,5,3);
HG.plot()