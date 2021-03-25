# This is the wrapper to control UR3 by Matlab in Robotics subject

Step 1: Download these files and add into your Assignment directory.

Step 2: Open matlab and check your trajectory in simulation before sending it through the robot.

Step 3: Connect your computer with Router.

Step 4: Open External Control on teach pendant.
* Go to file => Load program => ur_ros_driver.
* Hit the "play button" at the bottom left of the teach tendant.

Step 5: Initialize Wrapper.
* Command into Matlab terminal: "wrapper = Wrapper('192.168.X.XXX');"
* Where "192.168.X.XXX" is the IP address of the Raspery Pi. 

Step 6: Set the total time to run the traijectory
* Command into Matlab terminal: "wrapper.SetToTalTime(time);"
* Where "time" is in second.
* The default time is 10 seconds

Step 7: Send a trajectory.
* Command into Matlab terminal: "wrapper.SendJointsPosition(q);"
* Where "q" is a trajectory matrix(n,6). 
* Note: the first joints position must be near the current joint position of the robot.
* Command to Matlab terminal "wrapper.GetJointsPosition();" to get the current joint position of the robot.

Test the package:
* Use the teach pendant to change the joints position into (69.3, -143.9, -95.9, -29.8, -87.2, 0) degree
* Do Step 3 and 4 then run Test.m file on Matlab
