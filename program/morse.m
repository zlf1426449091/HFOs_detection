% load('K:\Unsupervised clustering\channle\R\prefilterHFO.mat');
%   fs=2560;
% for i = 1:10
%     R = filterRHFO(i,:);
% %      [wt,f] = cwt(R, fs,'VoicesPerOctave',10,'NumOctaves',5, 'TimeBandwidth',60);
%     [wt,f] = cwt(R, fs,'voices',32,'ExtendSignal',0);
%     figure(i)
%     imagesc(abs(wt));
%     set(gca,'YDir','normal');
%     colormap(jet);
%     end


% clc
% clear all
% close all
% % 原始信号
%   load('M:\Unsupervised clustering\channle\R\prefilterHFO.mat');
% fs=2560;
% F=500;
% t=0:1/fs:1;
% for i = 1:50
%     R = filterRHFO(i,:);
%     % 连续小波变换
% %     wavename='morse';
%     wavename='cmor3-3';
%     totalscal=1024;
%     Fc=centfrq(wavename); % 小波的中心频率
%     c=2*Fc*totalscal;
%     scals=c./(1:totalscal);
%     f=scal2frq(scals,wavename,1/fs); % 将尺度转换为频率
%     coefs=cwt(R,scals,wavename); % 求连续小波系数
%     Nf=length(f);
%     len1= floor(F*Nf/(fs/2));
%     figure(i)
% %     imagesc(t,f,abs(coefs));
%     subplot(211);
%     plot(R,'Color',[0 0 0.498]);  
%     subplot(212);
%     imagesc(t,f(1:len1),abs(coefs(1:len1,:)));
%     set(gca,'YDir','normal')
%     colorbar;
%     colormap(jet);
%     xlabel('时间 t/s');
%     ylabel('频率 f/Hz');
%     title('小波时频图');
% end


clc
clear all
close all
% 原始信号
load('M:\Unsupervised clustering\channle\R\prefilterHFO.mat');
fs=2560;
F=500;
t=0:1/fs:1;
for i = 1:2
    R = filterRHFO(i,:);
    % 连续小波变换
%     wavename='morse';
%     wavename='cmor3-3';
%     totalscal=1024;
%     Fc=centfrq(wavename); % 小波的中心频率
%     c=2*Fc*totalscal;
%     scals=c./(1:totalscal);
%     f=scal2frq(scals,wavename,1/fs); % 将尺度转换为频率
%     coefs=cwt(R,scals,wavename); % 求连续小波系数
    [st_matrix_R,st_times,st_frequencies] = st(R,0,500,1/fs,1);
%     Nf=length(f);
%     len1= floor(F*Nf/(fs/2));
%     figure
%     imagesc(t,f,abs(coefs));
%     imagesc(t,f(1:len1),abs(coefs(1:len1,:)));
%      set(gca,'YDir','normal')
%     set(gca,'YDir',[1 2])
%     colorbar;
%     xlabel('时间 t/s');
%     ylabel('频率 f/Hz');
%     title('小波时频图');
%     contourf(st_times,st_frequencies,abs(st_matrix_R));
    figure
    imagesc(st_times,st_frequencies,abs(st_matrix_R));
    set(gca,'YDir','normal')
%      set(gca,'YDir',[1 2])
    colorbar;
    colormap(jet);
end



% clc
% clear
% close all
% fs = 2560;
% F=500;
% t=0:1/fs:1;
% load('M:\Unsupervised clustering\channle\R\prefilterHFO.mat');
% for i = 1:2
%     chirp = filterRHFO(i,:);
%     figure
%     [st_matrix_R,st_times,st_frequencies] = st(chirp);
%     imagesc(st_times,st_frequencies,abs(st_matrix_R))
%     imcontour(abs(st_matrix_R))
% %     imagesc(st_times,st_frequencies,abs(st_matrix_R))
%     set(gca,'YDir','normal')
%  %      set(gca,'YDir',[1 2])
%     colorbar;
%     %contourf(st_times,st_frequencies,abs(st_matrix_R));
% end

% clear;
% f=50;       % 基波信号频率
% fs=512;    % 采样频率
% T=1/fs;    % 采样时间间隔
% N=512;     % 采样点数
% n=0:1:N-1;
% t=n/fs;
% x=cos(2*f*pi*t)+ 0.75*cos(3*f*pi*t)+ 0.57*cos(8*f*pi*t)+ 0.84*cos(5*f*pi*t);   %原始信号
% figure(1)
% plot(t,x);
% title('原始信号波形');
% xlabel('时间');
% ylabel('幅值');
% [st,t,f] = st(x,1,300,1600,1);
% figure(2);mesh(abs(st));
% xlabel('时间');
% ylabel('频率');
% zlabel('幅值');
% A=abs(st);
% [fr,I]=max(A,[],2);
% figure(3);           
% plot(fr);
