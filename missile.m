% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
% .
% . missile.m
% .
% . This function inputs the initial X, Y, Z positions, the initial mass,
% . initial thrust, the initial pitch(theta) and yaw(phi) angles, and
% . the thrust burn time of each rocket.
% . It then outputs the thrust and the X, Y and Z positions and components
% . of velocity for each time step using Euler's method for solving ODEs.
% .
% . called: [T,X,Y,Z,U,V,W]=missile(X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn)
% .
% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

function[T,X,Y,Z,U,V,W]=missile(X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn)

%missile radius
r=0.2;
%gravity
g=9.81;
%air density
rho=1.2;
%missile area
A=pi*r^2;
%time step
dt=0.005;

%initial conditions
T=0;
U=0;
V=0;
W=0;
X=X0;
Y=Y0;
Z=Z0;
%initial step
n=1;
load('terrain.mat');
%terrain altitude
j=interp2(x_terrain, y_terrain, h_terrain, X0, Y0);

%while the missile is higher than the terrain altitide(while the 
%missile has not crashed)
while Z(n)>j
    T(n+1)=T(n)+dt;
    %find the current X, Y, Z thrust components using thrust.m
    [Th_x, Th_y, Th_z] = thrust(T(n), Thmag0, theta, phi, Tburn, U(n), V(n), W(n));
    %find the current mass of the missile using mass.m
    [m] = mass(T(n), m0, mf, Tburn);
    Vmag=sqrt(U(n)^2+V(n)^2+W(n)^2);
    %fin the current drag coefficient using drag_coeff.m
    [Cd] = drag_coeff(Vmag);
    %solve for the next time step using euler's method to solve the
    %governing ODEs
    U(n+1)=U(n)+dt*(Th_x/m)-dt*((Cd*rho*A/2/m*U(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)));
    V(n+1)=V(n)+dt*(Th_y/m)-dt*((Cd*rho*A/2/m*V(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)));
    W(n+1)=W(n)+dt*(Th_z/m)-dt*((Cd*rho*A/2/m*W(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)))-dt*g;
    X(n+1)=X(n)+U(n+1)*dt;
    Y(n+1)=Y(n)+V(n+1)*dt;
    Z(n+1)=Z(n)+W(n+1)*dt;
    %new time step
    n=n+1;
    %new terrain altitude
    j=interp2(x_terrain, y_terrain, h_terrain, X(n), Y(n));
end