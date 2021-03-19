## MPC Lecture Notes

# unconstrained prediction

We want to find an appropriate sequence of control inputs to make a system <img src="https://render.githubusercontent.com/render/math?math=x_{k%2B1}=Ax_k%2BBu_k"> 
stable. So that by adding a feedback law e.g. <img src="https://render.githubusercontent.com/render/math?math=u_{k}=Kx_k"> we place the closed loop 
eigenvalues in the LHP <img src="https://render.githubusercontent.com/render/math?math=eig(A%2BBK)<0">.

Even though the <img src="https://render.githubusercontent.com/render/math?math=A,B">. and the states <img src="https://render.githubusercontent.com/render/math?math=x^{(i)}">
may not be known exactly, using a feedback loop can still make the system stable.
