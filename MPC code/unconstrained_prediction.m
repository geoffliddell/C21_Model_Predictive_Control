%State space system model : A, B, C, D = 0
A = [1.1 2; 0 0.95];
B = [0 0.0787]';
C = [-1 1];

[~, n_states] = size(A);
[~, n_inputs] = size(B);

N = 4;

% size of M is going to be horizon+1 * states x states
% can't be bothered with pre-allocating...
M= [];
for n = 0:N
    M((n*n_states + 1):((n+1)*n_states), (1:n_states)) = A^n
end

%form each row of Chat individually
Chat = zeros(n_states, n_inputs*(N));
X = zeros(n_states, 0);
for n = 1:(N)
    X = [(A^(n-1) * B) , X];
    ncol_X = size(X, 2);
    Chat((n_states*n + 1):(n_states*(n+1)), :)  = [ X, zeros(n_states,  (n_inputs*(N) - ncol_X))]; 
end
clear X;


% Cost function
Q = C' * C;
R = 0.01;

Qt = zeros((N+1)*n_states);
for n = 0:(N)
    Qt((n_states*n + 1):(n_states*(n+1)), (n_states*n + 1):(n_states*(n+1))) = Q;
end
clear n;

%% 
% unconstrained quadratic cost
H = (Chat' * Qt * Chat) + (R * eye(N));
F = Chat' * Qt * M;
G = M' * Qt * M;

K = -(H\F);
K_0 = K(1,:);



% %% 
% % simulate the uncontrolled system from x0 = (0.5, -0.5)
% x0 = [0.5 -0.5]';
% 
% x = x0;
% y = C * x0;
% for k = 1:10
%     x_k = A * x(:,k);
%     x(:,(k + 1)) = x_k;
%     y(k+1) = C * x_k;
% end
% 
% 
% stairs(y)

% now plot closed loop response with feedback given by K_0 * x_k
x = x0;
u = K_0 * x;
for k = 1:10
    x_k = (A + B*K_0) * x(:,k);
    x(:,(k + 1)) = x_k;
    u(k+1) = K_0 * x_k;
    
    % find the new
    
end

%output
y = C * x;

% also include the predictions for u_1|k, u_2|k and so on
u_pred = [K * x0];
x_pred = x0;
for k = 1:(N)
    x_k = A * x_pred(:,k) + B * u_pred(k)
    x_pred(:,(k+1)) = x_k;
end
y_pred = C * x_pred;

subplot(2,1,1)
stairs(y); xlabel('k'), ylabel('y')
hold on
stairs(y_pred, 'r')

subplot(2,1,2)
stairs(u); ylabel('u')
hold on
stairs(u_pred, 'r')