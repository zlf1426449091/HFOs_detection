clc;clear;close all;
set(0,'defaultfigurecolor','w');
load('G:\´ó´´\chenkelong_R\prefilterHFO.mat');

fs = 2560;
for i = 1:10
    figure(i)
    sample1 = filterRHFO(i,:);
    n = length(sample1);
    sample1_fft = fft(sample1);
    sample1_fft_shift = fftshift(sample1_fft);
    
    fshift = (-n/2:n/2-1)*(fs/n); % zero-centered frequency range
    plot(fshift,abs(sample1_fft_shift))
end
