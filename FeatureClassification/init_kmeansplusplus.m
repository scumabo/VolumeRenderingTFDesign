function vec = init_kmeansplusplus(lut, k)
%initial evenly divide the isovalues based on num of clussters
global N_ISOS;
global MAX_ISO;


X = 1: N_ISOS;
D = inf(N_ISOS, 1);
% The k-means++ initialization.
rand('seed', 1);
C = X(:,1+round(rand*(size(X,2)-1)));   %% pick a random number first
for i = 2:k
    D = min(D, lut(X, C(i-1)));
    %   D = D.^2;
    %   p = D/sum(D);
    %  a = D(end);
    candidate = X(:,find(rand < D/D(end)));
    C(:,i) = candidate(ceil(rand*size(candidate,2)));
    %C(:,i) = X(:, find(D == max(D)));
end

vec = C';