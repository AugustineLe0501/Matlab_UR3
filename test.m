clear all
clc

load('ur3_q.mat');
qMatrix = q(1,:);
for i= 1:30:1850
    qMatrix = [qMatrix;q(i,:)];
end

wrapper = Wrapper();
wrapper.SetTotalTime(15);
wrapper.SendJointsPosition(qMatrix);
