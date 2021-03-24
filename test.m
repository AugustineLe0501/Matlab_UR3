clear all
clc

load('ur3_q.mat');
qMatrix = q(1,:);
for i= 1:10:1850
    qMatrix = [qMatrix;q(i,:)];
end

wrapper = Wrapper();
pause(0.3);
wrapper.SendJointsPosition(qMatrix);