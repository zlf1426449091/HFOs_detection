clc,clear,close all;

%�����ݴ����һ��ͨ����

%liujiangling

[hdr, data] =edfread('G:\��\chenkelong\kelong~ chen_71b545d9-dca8-4866-a4cb-96da60394e51_10min01.edf');
for i = 1:size(data,1)
    eeg=data(i,:);
    eeg = resample(eeg,2560,4096);
    if i <=9
        save(strcat('G:\��\chenkelong_mat\','channel_0',num2str(i),'.mat'),'eeg');
    else
        save(strcat('G:\��\chenkelong_mat\','channel_',num2str(i),'.mat'),'eeg');
    end
end
