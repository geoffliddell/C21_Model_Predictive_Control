clear all 
clc

A = [1 0.1; 0 2];
B = [0 0.5]';
C = [1 0];

[~, n_states] = size(A);
[~, n_inputs] = size(B);

N = 3;

% size of M is going to be horizon+1 * states x states
% can't be bothered with pre-allocating...
M = {};
M_inv = {};
for i = 1:N+1
    M{i,1} = A^(i-1);
    clong{1,i} = A^-(i-1);
    ctall{i,1} = A^(i-1);
end

clong = clong(1,1:(end-1));
ctall = ctall([1, 1:(end-1)], 1);


Chat = {};
for j = 1:N+1
    for i = 1:N
        if i == 1
            Chat{j,i} = ctall{j,1} * clong{1,i} * B * 0;
        else
            Chat{j,i} = ctall{j,1} * clong{1,i} * B;
        end
        
        if i > j 
            Chat{j,i} = Chat{j,i} * 0;
        end
    end
end

Ql = C' * C;
Q = blkdiag(Ql, Ql, Ql, Ql);

Chat = cell2mat(Chat);
M = cell2mat(M);

H = Chat' * Q * Chat + (1 * eye(3));
Fdash = (M' * Q * Chat)
G = M' * Q * M
