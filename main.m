close all; clear all; clc;
%% Example of rotation the seismogram in sac format
% 2 option of rotational
%   + ZNE to ZRT
%   + ZNE to LQT: using ZRT to rotate to LQT
% ===========================================================================================
fne='FM.CT01..BHE.D.2019.244.155421.SAC';
fnn='FM.CT01..BHN.D.2019.244.155421.SAC';
fnz='FM.CT01..BHZ.D.2019.244.155421.SAC';
% set the time period to calculation
tstart = 0; %in sec 
tend = 180; % set = -9999 if use time to end of seismogram
% % P wave velocity beneath the station can taken at 1D velocity model
v0 = 5.8; %km/s - commonly at 0 km
% Load sac data using readsac function - output as structure data
de = readsac(fne);dn = readsac(fnn);dz = readsac(fnz);
% reading the stream
E = de.trace;
N = dn.trace;
Z = dz.trace;
% other parameters
dt = de.delta; % time step of stream
% Now we fake the time series
time = 0:dt:dt*(max([length(E),length(N),length(Z)])-1);
% ========= taken time period to test =====================================
nstart=ceil(tstart/dt);
%
if (nstart==0) nstart = 1;
else nstart = nstart;
end
%
if (tend==-9999) tend=time(end);
else tend = tend;
end
nstop=ceil(tend/dt);
tle = nstop - nstart;
% new timer
t = time(nstart:nstop);
% new data
dumE = E(nstart:nstop);dumN = N(nstart:nstop);dumZ = Z(nstart:nstop);
%% ZRT Rotating
dumR=-dumN.*cosd(dz.baz) - dumE.*sind(dz.baz);
dumT= dumN.*sind(dz.baz) - dumE.*cosd(dz.baz);
%% LQT Rotating
% Estimate the incident angle as 0 km.
% use taup to get P wave incident angle: 
% p=`taup_time -mod ak135 -h $EVDP -ph P -deg $GCARC -rayp`
% % velocity as 0 km can taken at 1D velocity model
v0 = v0;
p = dz.t0; % I assign the ray parameter in sac file as t0 flag
i = asind(p*v0); %incident angle (arcoording to Z component)
% Rotate
dumL = dumZ.*cosd(i) - dumN.*sind(i)*sind(dz.baz) - dumE.*sind(i)*cosd(dz.baz);
dumQ = dumZ.*sind(i) + dumN.*cosd(i)*sind(dz.baz) + dumE.*sind(i)*cosd(dz.baz);
%% Write data out to sac format using mkscac
% Fran�ois Beauducel (2021). RDSAC and MKSAC: read and write SAC seismic data file (https://github.com/IPGP/sac-matlab), GitHub. Retrieved February 24, 2021.
writesacout(dumR,dumT,dumL,dumQ,dz,fnz);
%% Plot ting section
fn = strrep(fnz,'.','_');
h=figure('Name',['Seismogram_rotate_',fn(1:7),'_',fn(16:30)],...
    'Numbertitle','off','Units','normalized','Position',[0 0 1.0 1.0]);
hold on;
subplot(1,7,3);
plot(dumE,t,'LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('E')
x1=xlim;y1=ylim; %gets current limits
%
subplot(1,7,2);
plot(dumN,t,'LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('N')
xlim(x1);ylim(y1); % Apply subplot limitation
%
subplot(1,7,1);
plot(dumZ,t,'LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('Z')
xlim(x1);ylim(y1); % Apply subplot limitation
%
subplot(1,7,4);
plot(dumR,t,'r','LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('R')
xlim(x1);ylim(y1); % Apply subplot limitation
%
subplot(1,7,5);
plot(dumT,t,'r','LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('T')
xlim(x1);ylim(y1); % Apply subplot limitation
%
subplot(1,7,6);
plot(dumL,t,'g','LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('L')
xlim(x1);ylim(y1); % Apply subplot limitation
%
subplot(1,7,7);
plot(dumQ,t,'g','LineWidth',1.2);grid on;
axis ij
t1 = ylabel('Time (sec)','fontweight','bold','fontsize',14);
t2 = xlabel('Amplitude','fontweight','bold','fontsize',14);
t1.Color='blue';t1.FontName='Times New Roman';
t2.Color='blue';t2.FontName='Times New Roman';
title('Q')
xlim(x1);ylim(y1); % Apply subplot limitation
%
st = suptitle('Seismic traces rotation into 2 type of coordinates');
st.FontName = 'Times New Roman';
st.FontSize = 16;
st.FontWeight = 'Bold';
st.Color = 'Blue';
%
img =['Seismogram_rotate_',fn(1:7),'_',fn(16:30),'.tiff']
print('-dtiff','-r500',img);
close(h)