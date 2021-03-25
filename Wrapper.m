classdef Wrapper < handle
    properties (Access = private)
        client; 
        ipAddress;
        jointName;
        timeTolerance;
        totalTime;
        sub2JointState;
        count;
    end
    
    methods (Access = public)
        function self = Wrapper(ip)
            ip = input('What is the IP address of the Pi: ','s');
            if isempty(ip)
                rosinit();
            else
                self.ipAddress = ip;
                rosinit(self.ipAddress);
            end
            self.count = 1;
            self.totalTime = 10;
            self.timeTolerance = 0.05;
            self.jointName = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};
            self.sub2JointState = rossubscriber('joint_states','sensor_msgs/JointState');
            self.client = rosactionclient('/scaled_pos_joint_traj_controller/follow_joint_trajectory');
            waitForServer(self.client);
        end
        
        function delete(self)
            rosshutdown;
        end
        
        % This function use to send the joints position to UR3 
        function SendJointsPosition(self,jointPosition)
            currentJointPosition = transpose(self.sub2JointState.LatestMessage.Position);
            currentJointPosition([1 3]) = currentJointPosition([3 1]);
            if (max(abs(currentJointPosition - jointPosition(1,:))) > 0.1)
                disp('You need to send the first joint position in the trajectory near the current joint position')
                return
            end
            
            goal = rosmessage('control_msgs/FollowJointTrajectoryGoal');
            
            goal.GoalTimeTolerance = rosduration(self.timeTolerance);
            goal.Trajectory.JointNames = self.jointName;
            goal.Trajectory.Header.Seq = self.count;
            
            for i=1:1:size(jointPosition,1)
                jointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
                jointSend.Positions = jointPosition(i,:);
                time = (self.totalTime/size(jointPosition,1))*i;
                jointSend.TimeFromStart = rosduration(1) + rosduration(time);
                
                goal.Trajectory.Points = [goal.Trajectory.Points; jointSend];
            end
                        
            goal.Trajectory.Header.Stamp = rostime('Now','system');
            sendGoal(self.client,goal);
            self.count = self.count+1;
        end
        
        % Set total time to execute the trajectory
        function SetTotalTime(self,time)
            self.totalTime = time;
        end
        
        % Return JointsPosition
        function jointPosition = GetJointsPosition(self)
            temp = transpose(self.sub2JointState.LatestMessage.Position);
            temp([1 3]) = temp([3 1]);
            jointPosition = temp;
        end
    end
end 
