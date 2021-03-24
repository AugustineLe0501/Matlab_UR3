classdef Wrapper < handle
    properties (Access = private)
        client;
        goal;   
        jointName;
        goalTolerance;
        pathTolerance;
        timeTolerance;
        
        sub2JointState;
        count;
    end
    
    methods (Access = public)
        function self = Wrapper()
            rosinit();
            self.count = 1;
            self.goalTolerance = 0.02;
            self.pathTolerance = 0.02;
            self.timeTolerance = 0.1;
            self.jointName = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};
            self.sub2JointState = rossubscriber('joint_states','sensor_msgs/JointState');
        end
        
        function delete(self)
            rosshutdown;
        end
        
        % This function use to send the joints position to UR3 
        function SendJointPosition(self,jointPosition)
            currentJointPosition = transpose(self.sub2JointState.LatestMessage.Position);
            currentJointPosition([1 3]) = currentJointPosition([3 1]);
            if (max(abs(currentJointPosition - jointPosition(1,:))) > 0.1)
                disp('You need to send the first joint position in the trajectory near the current joint position')
                return
            end
            
            [self.client, self.goal] = rosactionclient('/scaled_pos_joint_traj_controller/follow_joint_trajectory');
            self.goal.Trajectory.JointNames = self.jointName;
            self.goal.Trajectory.Header.Seq = self.count;
            self.goal.Trajectory.Header.Stamp = rostime('Now','system');
            
            for i=1:size(jointPosition,1)
                jointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
                jointSend.Positions = jointPosition(i,:);
                jointSend.TimeFromStart = rosduration(0.5) + rosduration(0.15*i);
                
                self.goal.Trajectory.Points = [self.goal.Trajectory.Points; jointSend];
            end
            sendGoal(self.client,self.goal);
            self.count = self.count+1;
        end
        
        % Tolerance ( developing ) 
%         function SetGoalTolerance(self,tolerance)
%             self.goalTolerance = tolerance;
%         end 
%         function SetPathTolerance(self,tolerance)
%             self.pathtolerance = tolerance;
%         end
%         function SetTimeTolerance(self,tolerance)
%             self.timeTolerance = tolerance;
%         end
        
        % Return JointsPosition
        function jointPosition = GetJointsPosition(self)
            temp = transpose(self.sub2JointState.LatestMessage.Position);
            temp([1 3]) = temp([3 1]);
            jointPosition = temp;
        end
    end
end 