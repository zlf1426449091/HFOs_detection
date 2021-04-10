function [hfolocal,HFOsegment,filterRsegment,number] = rippleSTE(data,k)
%% STE 此处显示有关此函数的摘要
%   此处显示详细说明
%hfolocal第一行为起始点坐标，第二行为末尾点，第三行为中点，第四行为通道号，第五行为hfo图片起始点
%% 预处理
wname = 'sym4';%选择小波db sym 
t = wpdec(data, 4, wname, 'shannon');
d16 = wprcoef(t, 16) ;
d17 = wprcoef(t, 17);
Rdata = d16 + d17;%Ripple范围80-250Hz（小波包重构至80-240Hz）
%d18 = wprcoef(t,18) ;
%d9 = wprcoef(t,9);
% FRdata=d18+d9;%FRipple范围250-500Hz（小波包重构至240-480Hz）
s = Rdata - mean(Rdata);%零均值化 加速CNN收敛
average = mean(abs(s));
s(s > 30 * average) = 30 * average;% 防止出现大幅超出均值的信号
s(s < -30 * average) = -30 * average;
s = s / max(abs(s));%归一化
framelength = 25;%一帧10毫秒，25个点
%% 计算短时能量并画图
ste = zeros(1, floor(length(s) / framelength));
for i=1:length(s) / framelength
    tmp=s((i - 1) * framelength + 1: i * framelength);      
    ste(i) = sum(tmp.^2);
end
%     amp=12*std(ste,0,2);
%     amp = max(ste)/4;
amp = 8 * std(ste);
vad = ste > amp;%vad为各帧是否为hfo的判别 vad = [1 0 1 1 0 0...] 1为大于阈值的帧
%% 能量断点补充
%判断短时能量连续超过阈值的帧数，小于3则认为不是HFO
Frame = length(vad);
count = zeros(1, Frame);

n1 = 1;%将帧片段[1 0 1]填充为[1 1 1]
while n1 <= Frame - 2
    if vad(n1) == 1 && vad(n1 + 1) == 0 && vad(n1 + 2) == 1
        vad(n1 + 1) = 1;
        n1 = n1 + 2;
    else
        n1 = n1 + 1;
    end
end

n1 = 1;
while n1 <= Frame - 3%将帧片段[1 0 0 1]填充为[1 1 1 1]
    if vad(n1) == 1 && vad(n1 + 1) == 0 && vad(n1 + 2) == 0 && vad(n1 + 3) == 1
        vad(n1 + 1) = 1;
        vad(n1 + 2) = 1;
        n1 = n1 + 3;
    else
        n1 = n1 + 1;
    end
end

if vad(1) == 1
    count(1) = 1;
else
    count(1) = 0;
end

n1 = 2;
while n1 <= Frame
  if vad(n1) == 1
     count(n1) = count(n1 - 1) + 1;
     n1 = n1 + 1;
  else
     count(n1) = 0;
     n1 = n1 + 1;
  end
end

for i=1: Frame
    if count(i) < 3
       vad(i) = 0;
    else
       vad(i) = 1;
       vad(i - 1) = 1;
       vad(i - 2) = 1;
    end
end
%% 起点终点帧修改
for n1 = 3: Frame - 2
    if vad(n1) * vad(n1 - 1) == 0 && vad(n1) * vad(n1 + 1) == 1
        if ste(n1 - 1) > 2 * ste(n1 - 2)
           vad(n1 - 1) = 1;
        end
    end
    if vad(n1) * vad(n1 + 1) == 0 && vad(n1) * vad(n1 - 1) == 1
         if ste(n1 + 1) > 2 * ste(n1 + 2) && ste(n1 + 1)>amp / 2
           vad(n1 + 1) = 1;
        end
    end
end
%% 记录始末位置
local=[];%第一行起始，第二行终止
local1 = 1;
local2 = 1;
if vad(1) == 1
    local(1, 1) = 1;
    local1 = local1 + 1;
end
for i = 2: Frame - 1
    if vad(i) * vad(i - 1) == 0 && vad(i) * vad(i + 1) == 1%帧片段[0 0 1] 1位置为起点
        local(1,local1) = (i - 1) * framelength + 1;
        local1 = local1 + 1;
    else if vad(i) * vad(i + 1) == 0 && vad(i) * vad(i - 1) == 1%帧片段[1 1 0] 1位置为终点
        local(2, local2) = i * framelength;
        local2 = local2 + 1;
        end
    end
end
if vad(Frame) == 1
    local(2, local2) = Frame * framelength;
end
%% 两个距离过近认为是一个
for i=2: local1 - 1
    if local(1, i) - local(2, i - 1) < 64 && local(2, i) - local(1, i - 1)<256
        local(1, i) = 0;
        local(2, i - 1) = 0;
    end
end

startpoint = [];
endpoint = [];
tag = [];
m1 = 1; 
m2 = 1;
for i = 1: local1 - 1
    if local(1, i) ~= 0
       startpoint(1, m1) = local(1, i);
       m1 = m1 + 1;
    end
    if local(2, i) ~= 0
        endpoint(1, m2) = local(2, i);
       m2 = m2 + 1;
    end
end

number = m2 - 1;
HFOsegment = [];
filterRsegment = [];
for i = 1: number
    center = ceil((startpoint(1, i) + endpoint(1, i)) / 2);
    tag(1, i) = center;
    if center >= 1280 && center <= size(data, 2)-1280
        r = data(center - 1279: center + 1280);%等于筛选了1s的片段
        R = Rdata(center-1279: center + 1280);
        picstart(1, i) = center - 1279;
    else
        if center < 1280  %防止其位于始末段
            r = data(1: 2560);
            R = Rdata(1: 2560);
            picstart(1, i) = 1;
        else
            r = data(size(data, 2) - 2559: end);
            R = Rdata(size(data, 2) - 2559: end);
            picstart(1, i) = center - 2559;
        end
    end
    filterRsegment = [filterRsegment; R];
    HFOsegment = [HFOsegment; r];
end
if isempty(startpoint)
    hfolocal = zeros(5, 1);
else
    hfolocal(1,:) = startpoint;
    hfolocal(2,:) = endpoint;
    hfolocal(3,:) = tag;
    hfolocal(4,:) = k;
    hfolocal(5,:) = picstart;
end