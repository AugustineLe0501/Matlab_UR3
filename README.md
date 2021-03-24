# This is the wrapper to control UR3 by Matlab in Robotics subject

Step 1: Download these files and add into your Assignment directory.

Step 2: Open matlab and check your trajectory in simulation beforeing send it through the robot.

Step 3: Connect your computer with Router.

Step 4: Open External Control on teach pendant.
* Go to file => Load program => ur_ros_driver.
* Hit the "play button" at the bottom left of the teach tendant.

Step 5: Initialize Wrapper.
* Command into Matlab terminal: "wrapper = Wrapper();" 

Step 6: Send a trajectory.
* Command into Matlab terminal: "wrapper.SendJointsPosition(q);"
* Where "q" is a trajectory matrix(n,6).
* Note: the first joints position must be near the current joint position of the robot.

Test the package:
* Do Step 3 and 4 then run Test.m file on Matlab
