%State space system model : A, B, C, D = 0
A = [-2 1; 0 1];
B = [1 1]';
C = [1 1];

K = [2 -1];

R = 1;
Q = C' * C;

cvx_begin sdp

variable Qhat(2,2)

minimize 0

subject to
    Qhat - (A + B*K)'*Qhat*(A + B*K) == Q + K'*R*K
    
cvx_end
    
