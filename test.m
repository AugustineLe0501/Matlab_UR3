clear all
clc

load('ur3_q.mat');
qMatrix = q(1,:);
for i= 1:10:1850
    qMatrix = [qMatrix;q(i,:)];
end

ip = input('What is the IP address of the Pi: ');

wrapper = Wrapper(ip);
wrapper.SetTotalTime(15);
wrapper.SendJointsPosition(qMatrix);
