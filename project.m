% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
% .
% .  project.m
% .
% .  MAE 8: Introduction to Matlab Final Project
% .
% .  Author:  Robert Ketchum
% .
% .  This project simulates the trajectory, mach number, altitude, and
% .  acceleration of seven missiles on a mountenous terrain. To see the
% .  flight statistics of any one rocket, type "m#_flight_stats", where #
% .  represents the missile ID from 1 to 7.
% .
% .
% .  Note: to run this, ensure that terrain.mat, missile_data.txt,
% .  missile.m, mass.m, drag_coeff.m, thrust.m, and
% .  read_input.m are in the directory.
% .
% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .



close all  % Close all files
clear all  % Clear all variables
clc        % Clear command line

format long;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 1: load data and getting ready for calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input_filename = 'missile_data.txt';
%load the missile data

colors=['y','m','c','r','g','b','k'];
%create a vector with colors for plotting

load('terrain.mat');
%load the terrain

%create a figure showing the terrain. We will plot the rockets here later
figure(1); hold on;
surf(x_terrain/1000,y_terrain/1000,h_terrain/1000); 
shading interp;
xlabel('x (km)'); ylabel('y (km)'); zlabel('z (km)');
view(3); axis([0 30 0 30 0 3.5]); grid on;
title('Projectile of Missiles on A Terrain');
hold off;

%%%%%%%%%%%%%%%%%%%%%
%Part 2: computations
%%%%%%%%%%%%%%%%%%%%%

%note: entire loop runs once for each missile
for M_id=1:7
    fd = 0;
    
    %read input data from read_input.m
    [X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn]=read_input(input_filename,...
        M_id);
    
    %solve for missile trajectory, thrust, and velocity using missile.m
    [T,X,Y,Z,U,V,W] = missile(X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn);
    height=interp2(x_terrain, y_terrain, h_terrain, X(end), Y(end));

    %magnitude of velocity
    Vmag = sqrt(U.^2+V.^2+W.^2);
    
    %find acceleration and the g-force at each point in time
    Ac=0;
    Norm=0;
    for n=1:length(Z)-1
        Ac(n)=(Vmag(n+1)-Vmag(n))/0.005;
        Norm(n)=Ac(n)/9.81;
    end
    
    %mach number
    Ma = Vmag/340;
    
    %plot the trajectory of each missile
    figure(1); hold on;
    plot3(X(end)/1000, Y(end)/1000, height/1000,'pentagram', ...
    'MarkerFaceColor', colors(M_id), 'MarkerEdgeColor', ...
    colors(M_id), 'Markersize', 8);
    plot3(X/1000,Y/1000,Z/1000,colors(M_id));
    hold off;

    %plot the mach number and g-force
    figure(2);
    subplot(2,1,1);
    hold on;
    plot(T,Ma,colors(M_id));
    subplot(2,1,2);
    hold on;
    plot(T(1:end-1),Norm,colors(M_id));
    hold off;

    %create a data structure named flight_stat which stores notable data
    flight_stat(M_id).missile_ID = M_id;
    flight_stat(M_id).landing_time = T(end);

    %plot the mach number vs. altitude
    figure(3);
    hold on;
    yu(M_id)=plot(Ma,Z/1000, colors(M_id));
    for n=1:length(Z)-1
        %flight distance
        fd=fd+sqrt((X(n+1)-X(n))^2+(Y(n+1)-Y(n))^2+(Z(n+1)-Z(n))^2);
        flight_stat(M_id).travel_distance=fd;
        
        %mark where the missile breaks the sound barrier
        if(Ma(n)>=1 && Ma(n+1)<=1)
            plot(Ma(n),Z(n)/1000,[colors(M_id) 'o']); 
        elseif(Ma(n)<=1 && Ma(n+1)>=1)
            plot(Ma(n),Z(n)/1000,[colors(M_id) 'o']); 
        end
    end
    hold off;
    
    %add flight data at maximum height to data structures
    flight_stat(M_id).max_height_position=[X(find(max(Z)==Z)) ...
        Y(find(max(Z)==Z)) Z(find(max(Z)==Z))];
    flight_stat(M_id).max_height_Ma=Ma(find(max(Z)==Z));
    flight_stat(M_id).max_height_Acc=Ac(find(max(Z)==Z));

    %add flight data at crash to data structures
    vel(M_id)=Vmag(end);
    flight_stat(M_id).landing_location=[X(end) Y(end) Z(end)];
    flight_stat(M_id).landing_Ma=Ma(end);
    flight_stat(M_id).landing_Acc=Ac(end);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 3: Plotting and displaying results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%legends for position plot
figure(1);
hold on;
legend('terrain','Impact 1','Flight Path 1', 'Impact 2', ...
    'Flight Path 2','Impact 3','Flight Path 3','Impact 4', ...
    'Flight Path 4','Impact 5','Flight Path 5','Impact 6', ...
    'Flight Path 6','Impact 7','Flight Path 7');
hold off;

%legends for mach number plot
figure(2);
subplot(2,1,1);
hold on;
title('Time vs Mach Number');
xlabel('Time (s)');ylabel('Mach Number');
legend('Missile 1', 'Missile 2','Missile 3','Missile 4', ...
    'Missile 5','Missile 6','Missile 7');
grid on
hold off;

%legends for acceleration plot
subplot(2,1,2);
hold on;
title('Time vs Acceleration Normalized by Gravity');
xlabel('Time (s)');ylabel('Acceleration / Gravity');
legend('Missile 1', 'Missile 2','Missile 3','Missile 4', ...
    'Missile 5','Missile 6','Missile 7');
grid on
hold off;

%legends for mach number v altitude plot
figure(3);
hold on;
title('Mach Number vs Altitude');
xlabel('Mach Number');ylabel('Altitude [km]');
legend([yu],{'Missile 1', 'Missile 2','Missile 3','Missile 4', ...
    'Missile 5','Missile 6','Missile 7'});
grid on
hold off;

%creates a data structure with the flight statistics
m1_flight_stats = flight_stat(1);
m2_flight_stats = flight_stat(2);
m3_flight_stats = flight_stat(3);
m4_flight_stats = flight_stat(4);
m5_flight_stats = flight_stat(5);
m6_flight_stats = flight_stat(6);
m7_flight_stats = flight_stat(7);