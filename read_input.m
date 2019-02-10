% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
% .
% . read_input.m
% .
% . This function reads the text file "missile_data.txt" and searches for
% . data under the column M_id.
% .
% .
% . called: [X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn]=read_input(input_filename,M_id)
% .
% . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

function[X0,Y0,Z0,m0,mf,Thmag0,theta,phi,Tburn]=read_input(input_filename,M_id)

%import data to matlab
importdata(input_filename);

%open the text file
fileid=fopen('missile_data.txt', 'r');
format='%s';
%scan the data
data=textscan(fileid,format);
%store data as a cell
cell=data{1,1};
%close the file
fclose(fileid);
%create a matrix for putting in data
matA=zeros(10,7);
%convert the wanted data to a matrix
for n=(51:120)
    num=str2num(cell{n,1});
    matA(n-50)=num;
end
matB=matA';

%search for data based on our missile id and save it
if (M_id==1)||(M_id==2)||(M_id==3)||(M_id==4)||(M_id==5)||(M_id==6)||(M_id==7)
    X0=matB(M_id+7);
    Y0=matB(M_id+14);
    Z0=matB(M_id+21);
    m0=matB(M_id+28);
    mf=matB(M_id+35);
    Thmag0=matB(M_id+42);
    theta=matB(M_id+49);
    phi=matB(M_id+56);
    Tburn=matB(M_id+63);
else
    X0=NaN;
    Y0=NaN;
    Z0=NaN;
    m0=NaN;
    mf=NaN;
    Thmag0=NaN;
    theta=NaN;
    phi=NaN;
    Tburn=NaN;
    error('Invalid input; M_id must be an integer between 1 and 7')
end