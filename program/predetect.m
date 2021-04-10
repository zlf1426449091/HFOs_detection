clc;
clear;
close all;
%% 读取数据并滤波
A = dir('G:\大创\chenkelong_mat');
filterRHFO = []; 
HFO = [];
local = [];
for k = 3:size(A, 1) %切换 每条通道
    str = strcat(A(k).folder, '\', A(k).name);%将数据变为系统可读形式
    data = load(str); 
    sname = fieldnames(data);    
    sname = sname{1};   
    data = data.eeg;%读取整条通道   
    [hfolocal, HFOsegment, filterRsegment, number] = fastrippleSTE(data, k - 2);
    HFO = [HFO; HFOsegment]; 
    filterRHFO = [filterRHFO; filterRsegment];
    local = [local hfolocal];
end

% 找到local全为0的列,然后删除
temp_sum = sum(local,1);
temp_index = find(temp_sum == 0);
local(:, temp_index) = [];

save('G:\大创\chenkelong_R\prehfolocal.mat','local');% 保存HFO数据
save('G:\大创\chenkelong_R\preHFO.mat','HFO');
save('G:\大创\chenkelong_R\prefilterHFO.mat','filterRHFO');