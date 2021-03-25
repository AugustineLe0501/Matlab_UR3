clear all
clc

load('ur3_q.mat');
qMatrix = q(1,:);
for i= 1:5:1850
    qMatrix = [qMatrix;q(i,:)];
end

wrapper = Wrapper();
wrapper.SendJointsPosition(qMatrix);