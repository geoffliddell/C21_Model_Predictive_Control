% For the example in L2. Find the LQR

%State space system model : A, B, C, D = 0
A = [1.1 2; 0 0.95];
B = [0 0.0787]';
C = [-1 1];

[~, n_states] = size(A);
[~, n_inputs] = size(B);

N = 4;

% check the gains calculated by solving a discrete-time ricatti eqn
[P, K_star, L] = idare(A, B, Q, R, [], [])

Q = C' * C;
K = -K_star;
% in unconstrained_prediction, we found these gains, the first of which
% is clearly very close to the LQ optimal gain found using 'idare'
% K = [-4.35631266363735,-18.6888852331645;1.63828521764884,1.23793554378262;1.41406607723812,2.97665687995813;0.593457919815946,1.83257648059660];
R = 0.01;

% check what the cost-to-go is by solving a lyapunov equation using cvx.
% Could also use function 'dlyap'?

% From 'help dylap':
%     X = dlyap(A,Q,[],E) solves the generalized discrete Lyapunov equation:
%  
%         A*X*A' - E*X*E' + Q = 0


cvx_begin sdp
variable Qhat(2,2)
minimize 0
subject to
    Qhat == semidefinite(n_states)
    Qhat - (A + B*K)' * Qhat * (A + B*K) == Q + K' * R * K
cvx_end

%Qhat represents the infinite horizon cost-to-go, which can then be added
%to the finite-horizon prediction to find a predictive controller.


