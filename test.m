clear all
clc

load('ur3_q.mat');
qMatrix = q(1,:);
for i= 1:10:1850
    qMatrix = [qMatrix;q(i,:)];
end

wrapper = Wrapper('192.168.x.xxx');
wrapper.SetTotalTime(15);
wrapper.SendJointsPosition(qMatrix);