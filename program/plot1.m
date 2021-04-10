clc;clear;close all;
set(0,'defaultfigurecolor','w');

load('G:\大创\chenkelong_R\prefilterHFO.mat');
load('G:\大创\chenkelong_R\preHFO.mat');
%   load('K:\label_pre\LIUJIANGLING\03_06\prehfolocal.mat');
%   load('K:\label_pre\LIUJIANGLING\03_06\preHFO.mat');
%   load('K:\label_pre\LIUJIANGLING\03_06\prefilterRHFO.mat');
%   load('K:\label_pre\LIUJIANGLING\03_06\prefilterFRHFO.mat');

fs=2560;

for i = 1:10
    R = HFO(i,:);
    r = filterRHFO(i,:);
    tms = (0:numel(r)-1)/fs;
    %     R = (i,:);
    
    %     FR = filterFRHFO(i,:);
    [wt1,f1] = cwt(r, fs,'VoicesPerOctave',20,'NumOctaves',4, 'TimeBandwidth',20);
    [wt2,f2] = cwt(R, fs,'VoicesPerOctave',20,'NumOctaves',4, 'TimeBandwidth',20);
    figure(i)
    subplot(411);
    plot(R,'Color',[0 0 0.498]);
    subplot(413);
    plot(r,'Color',[0 0 0.498]);
    
    subplot(412);
    %     plot(FR,'Color',[0 0 0.498]);
    %     subplot(414);
    imagesc(abs(wt2));
    colorbar;
    colormap(jet);
    subplot(414);
    imagesc(tms, f1, abs(wt1));
    colorbar;
    colormap(jet);
    set(gca,'YDir','normal')
end
