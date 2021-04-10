clc;
clear;
close all;
%% ��ȡ���ݲ��˲�
A = dir('G:\��\chenkelong_mat');
filterRHFO = []; 
HFO = [];
local = [];
for k = 3:size(A, 1) %�л� ÿ��ͨ��
    str = strcat(A(k).folder, '\', A(k).name);%�����ݱ�Ϊϵͳ�ɶ���ʽ
    data = load(str); 
    sname = fieldnames(data);    
    sname = sname{1};   
    data = data.eeg;%��ȡ����ͨ��   
    [hfolocal, HFOsegment, filterRsegment, number] = fastrippleSTE(data, k - 2);
    HFO = [HFO; HFOsegment]; 
    filterRHFO = [filterRHFO; filterRsegment];
    local = [local hfolocal];
end

% �ҵ�localȫΪ0����,Ȼ��ɾ��
temp_sum = sum(local,1);
temp_index = find(temp_sum == 0);
local(:, temp_index) = [];

save('G:\��\chenkelong_R\prehfolocal.mat','local');% ����HFO����
save('G:\��\chenkelong_R\preHFO.mat','HFO');
save('G:\��\chenkelong_R\prefilterHFO.mat','filterRHFO');