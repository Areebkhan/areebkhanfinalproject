%Solving the Poisson's equation with Gauss Seidel Method with the given conditions in the problem statement. 
% Areeb Khan 1286665 SOR Method
clear all; clc; 

%% Given Conditions 
ax = 0;
ay = 0;
bx = 2*pi;
by = 2*pi; 
MI=input('Input Number of X Intenal Nodes='); % Number of points on the internal nodes for N and M%
NI=input('Input Number of Y Intenal Nodes='); 
lamda=input('Input Value for lamda=');
tic;% starting the timer
M=NI+2; %Number of points including exterior boundary points for Ne and Me%
N=MI+2; 
% this generates the x and y values that will be used to calculate 
xvalues = linspace(0,2*pi,M);
yvalues = linspace(0,2*pi,N);

F = Functionak(xvalues,yvalues);
% F=zeros(M,N);uncomment it for F=0
  
% Bounds for the Equation 

Er=10^-10 ; %Value of error for system convergence
U=zeros(M,N);
W=zeros(M,N);
%% Defining Boundary Conditions for "top" and "bottom"

% Bottom boundary condition
U(1,:) = xvalues.*(xvalues-ax).^2; %((xvalues - ax).^2 ) .* sin( pi *(xvalues - ax) / (2*(bx-ax)) ) ;
W(1,:)=U(1,:);

% Top boundary condition
U(N,:) = ((xvalues - ax).^2 ) .* cos(xvalues) ; %cos(pi*(xvalues-ax)).*cosh(bx-xvalues);
W(N,:)=U(N,:);

%Right hand side boundary condition
U(:,N) = (xvalues.*(xvalues-ax).^2)+((yvalues-ay)/(by-ay)).*(( ((xvalues - ax).^2 ) .* cos( (pi *(xvalues) / (bx)) ))-( xvalues.*(xvalues-ax).^2));
W(:,N)=U(:,N);
Error = zeros(N,M-2);

% place these known values in the solution grid 

%% Left and Right Boundary points 
%   Using the given neumann condition yields special cases of the Gauss-siedel iteration that can be used along entire "side" boundaries. 
%   F and U is computed in solution grid 
% Multipliers that are used in the iterations. 
L=2*pi;
DX = L/(MI+1); 
DX = 1/DX.^2;
DY = L/(NI+1); 
DY = 1/DY.^2;
DEN= -2*(DX+DY); 

EI=10; %Initial guess for error
ER=10^-10;  %Value of error for system convergence
Iterations=0; %Initial value of iteration to start the counter
%Performing Gauss Seidel Approximations 
save('Variables.mat') %Saves variables to file for checkpointing
% check for diagonal dominance of elements 

%%
load('Variables.mat')
abs(DEN) >= abs(2*DX+2*DY)
while EI>ER;
  if Iterations > 10000 
     save('Variables.mat')
 end
%Left Nuemann conditions
for i = 2:M-1; 
     
    W(i,1) = U(i,1);
    U(i,1) = (F(i,1) - (2*DX)*U(i,2) - DY*U(i-1,1) - DY*U(i+1,1) )/DEN;
    Error(i,1) = abs((U(i,1) - W(i,1)) / U(1,1));
end 

%% Gauss-Siedel iterating the general U equation%

for j = 2:N-1;
    for i = 2:M-1;
        W(i,j) = U(i,j);
        U(i,j) =(  F(i,j) - DX*U(i,j-1) - DX*U(i,j+1)- DY*U(i-1,j) - DY*U(i+1,j) )/DEN;
        U(i,j)=lamda*U(i,j)+(1-lamda)*W(i,j);
        Error(i,j)= abs((U(i,j) - W(i,j)) / U(i,j));
    end
end
EI=abs(max(max(((W-U)./W)))); 
Iterations=Iterations+1;
end 
TotalIterations=Iterations
Time=toc %stops the timer
figure 
subplot(1,2,1),surf(U),xlabel('x axis'),ylabel('y axis'),title('F=cos(x)sin(y)'); %F=0 for part 2

subplot(1,2,2),contour(U),xlabel('x axis'),ylabel('y axis'),title('F=cos(x)sin(y)');
