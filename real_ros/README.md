# Kinova gen3

## Installation
Get ros_kortex
```
git clone git@github.com:Kinovarobotics/ros_kortex.git
```
to run Kinova on gazebo
```
roslaunch kortex_driver kortex_driver.launch
```
this will open the kinova robot (ISR-Vislab robot) + the rviz (add RobotModel to show the robot in real time)

## Usage
### Control in velocity (joint)
```
rostopic pub  /my_gen3/in/joint_locity kortex_driver/Base_JointSpeeds "joint_speeds:
- joint_identifier: 0
  value: 0.2
  duration: 0
duration: 0"
```
### Control in velocity (cartesian)
```
rostopic pub /my_gen3/in/cartean_velocity kortex_driver/TwistCommand "reference_frame: 0
twist: {linear_x: 0.0, linear_y: 0.0, linear_z: 0.05, angular_x: 0.0, angular_y: 0.0,
  angular_z: 0.0}
duration: 0" 
```
### Mocap
Get Mocap Repo
```
cd catkin_ws/src
git clone git@github.com:NunoDuarte/mocap_optitrack.git
```
Compile 
```
cd catkin_ws
catkin_make
```
Source it!
```
source devel/setup.bash
```
Run it
```
roslaunch mocap_optitrack mocap.launch
```
(optional) you can configure it
```
gedit catkin_ws/src/mocap_optitrack/config/mocap.yaml
```
(optional) add new rigid bodies
```yaml
rigid_bodies:
    '$id':
        pose: $name/pose
        pose2d: $name/ground_pose
        odom: $name/Odom
        child_frame_id: $name/base_link
        parent_frame_id: world
```        
Specify $id and $name

## Real Kinova
- connect to the robot
- launch kortex driver
```
roslaunch kortex_driver kortex_driver.launch
```
