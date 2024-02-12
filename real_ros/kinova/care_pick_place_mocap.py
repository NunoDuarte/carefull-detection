#!/usr/bin/env python

# in the terminal do "source catkin/devel/setup.bash
# to add the kortex_driver to the directory
from kortex_driver.msg import Base_JointSpeeds
from kortex_driver.msg import JointSpeed
from kortex_driver.msg import TwistCommand
from kortex_driver.msg import Twist
from geometry_msgs.msg import PoseStamped
from control_msgs.msg import GripperCommandActionGoal
from scipy.signal import savgol_filter

import rospy
from std_msgs.msg import Float64MultiArray
from std_msgs.msg import Float32
import numpy as np
import tf
import math
import time
import sys
import signal
import decimal
import operator

FREQ = 200
# initializations
last_cup = ''
last_robot = ''
active_cup = False
active_robot = False
once_1 = True
once_2 = True

eig = np.zeros((2, 2))
eig[0] = np.array([-0.0857, 0.9963])
eig[1] = np.array([-0.1729, 0.9849])
E = []
B = []
Data = []
Data_vel = []


def winner_take_all(b, b_d):
    B_d = np.array([0.0, 0.0])
    index, value = max(enumerate(b_d), key=operator.itemgetter(1))

    if b[index] == 0:
        for i in (0, 1):
            B_d[i] = 0
        return

    if index == 0:
        v = 1
    elif index == 1:
        v = 0

    z = (b_d[index] + b_d[v]) / 2

    for i in (0, 1):
        B_d[i] = b_d[i] - z

    S = 0.0

    for i in (0, 1):
        if b[i] != 0 or B_d[i] > 0:
            S = S + B_d[i]

    B_d[index] = B_d[index] - S
    return B_d


class CarePickandPlaceMocap:

    def __init__(self):
        self.init_ros()
        self.init_params()
        self.robot_base = rospy.Subscriber("/Robot_1/pose", PoseStamped, self.tf_base)
        self.red_cup = rospy.Subscriber("/Cup_2/pose", PoseStamped, self.tf_redcup, queue_size=1)
        self.gripperMsg = GripperCommandActionGoal()

        print('Starting node..')
        rospy.sleep(1)

        # init params for classifier carefulness
        self.b = np.array([0.5, 0.5])
        self.b_d = np.array([0.0, 0.0])
        self.epsilon = 0.5  # adaptation rate

        self.get_robot_pos()
        print(self.end_effector_position)
        print(self.end_efector_orientation)

        # open gripper
        self.gripper_open = 0
        self.gripperMsg.goal.command.position = self.gripper_open
        self.GripperPub.publish(self.gripperMsg)

        # starting position
        leave = False
        while not leave:
            # go to initial pose
            start = np.array([0.5, 0, 0.4])
            self.set_pose(start)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        rospy.sleep(1)

        # Run Carefulness Detection (acceleration approach)
        i = 0
        close = False
        act = False
        while not close:
            if active_cup and active_robot:
                cup = self.cup.pose.position

                cup_pose = np.zeros(3)
                cup_pose[0] = np.abs(np.round(cup.x - self.cup_initial.x, 3))
                cup_pose[1] = np.abs(np.round(cup.y - self.cup_initial.y, 3))
                cup_pose[2] = np.abs(np.round(cup.z - self.cup_initial.z, 3))
                # compute the vector distance
                cup_shift = float(math.sqrt(cup_pose[0]**2 + cup_pose[1]**2 + cup_pose[2]**2))

                if len(str(self.cup.header.stamp.nsecs)) == 7:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + ".00" + str(self.cup.header.stamp.nsecs))
                elif len(str(self.cup.header.stamp.nsecs)) == 8:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + ".0" + str(self.cup.header.stamp.nsecs))
                else:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + "." + str(self.cup.header.stamp.nsecs))
                diff_time = float(time - self.time_initial)
                if not act:
                    print('time', diff_time)

                # get at least one past point
                if i > 1:
                    vel = np.abs((cup_shift - cup_past_shift) / (diff_time - cup_past_time))
                    if not act:
                        print('velocity', vel)

                    # ignore, object is static
                    if vel == 0.0:
                        Data = []
                        Data_vel = []
                        i = 0
                    else:
                        Data.append(cup_shift)
                        Data_vel.append(vel)

                    if not act and len(Data) == 25:
                        pose_smooth = savgol_filter(Data, 25, 5)
                        vel_smooth = savgol_filter(Data_vel, 25, 5)

                        is_okay = self.classifier(vel_smooth, pose_smooth)

                        if is_okay:
                            print(B[-1])
                            act = True

                    if act and vel == 0.0 and cup_pose[2] < 0.03:
                        # if you have one option go to robot
                        if B[-1][0][0] > 0.8:
                            self.robot_not()
                        elif B[-1][0][1] > 0.8:
                            self.robot_careful()
                        close = True

                cup_past_shift = cup_shift
                cup_past_time = diff_time

                i = i + 1

            rospy.sleep(0.02)
            rospy.spin
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)

    def robot_not(self, ):

        # tilt down
        leave = False
        start = np.array([0.55, 0, 0.2])
        while not leave:
            self.set_pose_down(start)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_orientation()
                self.publish_robot_desired(vel_cmd)
                print("1- Difference between desired orientation and actual\n" + str(np.round(
                    np.linalg.norm(self.desired_orientation - self.quat_to_euler(self.end_efector_orientation)),
                    2)))
                if (np.round(
                        np.linalg.norm(self.desired_orientation - self.quat_to_euler(self.end_efector_orientation)),
                        2)) < 0.1:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # go to cup
        leave = False
        found_object = False
        while not leave:
            if active_cup and active_robot:
                cup = self.cup.pose.position
                kuka = self.kuka.pose.position

                # get the distance between object and hand
                diff = np.zeros(3)
                diff[0] = np.abs(np.round(kuka.x - cup.x, 3))
                diff[1] = -1*np.round(kuka.y - cup.y, 3)
                diff[2] = np.abs(np.round(cup.z - kuka.z, 3))
                distance = math.sqrt(diff[0]**2 + diff[1]**2 + diff[2]**2)
                print('distance', diff)

                # apply limits of handover
                if diff[0] > 0.75 or diff[2] < 0.0:
                    # stop robot
                    vel_cmd = [0, 0, 0, 0, 0, 0]
                    self.publish_robot_desired(vel_cmd)
                    rospy.sleep(1)
                else:
                    # reach my hand
                    if not found_object:
                        hand = diff
                        # raise the gripper a bit higher and take into account the gripper
                        hand[0] = hand[0]
                        hand[1] = hand[1] + 0.05
                        hand[2] = hand[2] + 0.18
                        found_object = True
                    else:
                        self.set_pose(hand)
                        self.get_robot_pos()
                        if self.ee_real_logged:
                            vel_cmd = self.calculate_robot_desired_attractor()
                            self.publish_robot_desired(vel_cmd)
                            print("2- Difference between desired position and actual\n" + str(
                                np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                            if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                                leave = True

            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        rospy.sleep(1)

        # grasp cup
        self.gripper_open = 0.8
        self.gripperMsg.goal.command.position = self.gripper_open
        self.GripperPub.publish(self.gripperMsg)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)

        # move cup
        leave = False
        while not leave:
            approx = np.array([0.57, -0.5, 0.3])
            self.set_pose(approx)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        rospy.sleep(1)

        # open gripper
        self.gripper_open = 0
        self.gripperMsg.goal.command.position = self.gripper_open
        self.GripperPub.publish(self.gripperMsg)

        # get out
        leave = False
        approx[2] = approx[2] + 0.2
        while not leave:
            self.set_pose(approx)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        print('wait to finish')
        rospy.sleep(2)

    def robot_careful(self, ):
        # go to cup
        leave = False
        found_object = False
        while not leave:
            if active_cup and active_robot:
                cup = self.cup.pose.position
                kuka = self.kuka.pose.position

                # get the distance between object and hand
                diff = np.zeros(3)
                diff[0] = np.abs(np.round(kuka.x - cup.x, 3))
                diff[1] = -1*np.round(kuka.y - cup.y, 3)
                diff[2] = np.abs(np.round(cup.z - kuka.z, 3))
                distance = math.sqrt(diff[0]**2 + diff[1]**2 + diff[2]**2)
                print('distance', diff)

                # apply limits of handover
                if diff[0] > 0.75 or diff[2] < 0.0:
                    # stop robot
                    vel_cmd = [0, 0, 0, 0, 0, 0]
                    self.publish_robot_desired(vel_cmd)
                    rospy.sleep(1)
                else:
                    # reach my hand
                    if not found_object:
                        hand = diff
                        # raise the gripper a bit higher and take into account the gripper
                        hand[0] = hand[0] - 0.2
                        hand[1] = hand[1] + 0.02
                        hand[2] = hand[2] + 0.02
                        found_object = True
                    else:
                        self.set_pose(hand)
                        self.get_robot_pos()
                        if self.ee_real_logged:
                            vel_cmd = self.calculate_robot_desired_attractor()
                            self.publish_robot_desired(vel_cmd)
                            print("2- Difference between desired position and actual\n" + str(
                                np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                            if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.02:
                                leave = True

            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        rospy.sleep(1)

        # approx cup
        found_object = False
        close_grip = False
        leave = False
        while not leave:
            if not found_object:
                # get the near the cup
                hand[0] = hand[0] + 0.1
                found_object = True
            else:
                self.set_pose(hand)
                self.get_robot_pos()
                if self.ee_real_logged:
                    vel_cmd = self.calculate_robot_desired_attractor()
                    self.publish_robot_desired(vel_cmd)
                    print("2- Difference between desired position and actual\n" + str(
                        np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                    if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.02:
                        close_grip = True

                if close_grip:
                    # grasp cup
                    self.gripper_open = 0.3
                    self.gripperMsg.goal.command.position = self.gripper_open
                    self.GripperPub.publish(self.gripperMsg)
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)

        # move cup
        leave = False
        while not leave:
            approx = np.array([0.6, -0.35, 0.42])
            self.set_pose(approx)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        rospy.sleep(1)

        # approx cup
        leave = False
        approx[0] = approx[0] + 0.2
        while not leave:
            self.set_pose(approx)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)

        # open gripper
        self.gripper_open = 0
        self.gripperMsg.goal.command.position = self.gripper_open
        self.GripperPub.publish(self.gripperMsg)

        # get out
        leave = False
        approx[0] = approx[0] - 0.2
        while not leave:
            self.set_pose(approx)
            self.get_robot_pos()
            if self.ee_real_logged:
                vel_cmd = self.calculate_robot_desired_attractor()
                self.publish_robot_desired(vel_cmd)
                print("2- Difference between desired position and actual\n" + str(
                    np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)))

                if (np.round(np.linalg.norm(self.target_position - self.end_effector_position), 2)) < 0.05:
                    leave = True
            signal.signal(signal.SIGINT, self.signal_handler)

        print('wait to finish')
        rospy.sleep(2)

    def classifier(self, vel, distance):

        for j in range(0, len(vel)-2):
            e = np.zeros(2)
            for i in (0, 1):
                out = np.absolute((vel[j + 1] - vel[j]) / (distance[j + 1] - distance[j]))
                xd = np.absolute(eig[i][1] / eig[i][0])

                e[i] = -1 * (np.absolute(out - xd))
                self.b_d[i] = self.epsilon * (e[i] + (self.b[i] - 0.5) * xd)

            E.append([[e[0], e[1]]])

            B_d = winner_take_all(self.b, self.b_d)
            for i in (0, 1):
                self.b[i] = self.b[i] + B_d[i] * 0.1
                self.b[i] = max(0, min(1, self.b[i]))
            self.b[1] = 1 - self.b[0]
            B.append([[self.b[0], self.b[1]]])
        return True

    def calculate_robot_desired_attractor(self, ):
        vel_cmd = np.zeros(6)
        vel_cmd[:3] = (self.target_position - self.end_effector_position) * self.gain
        vel_cmd[3:6] = self.desired_orientation
        return vel_cmd

    def calculate_robot_desired_orientation(self, ):
        vel_cmd = np.zeros(6)

        (roll, pitch, yaw) = tf.transformations.euler_from_quaternion(self.end_efector_orientation)
        vel_cmd[3:6] = (self.desired_orientation - [roll, yaw, pitch]) * self.gain
        return vel_cmd

    def quat_to_direction(self, quat):
        R0 = tf.transformations.quaternion_matrix(quat)
        angle, vec, _ = tf.transformations.rotation_from_matrix(R0)
        return angle * vec

    def quat_to_euler(self, quat):
        (roll, pitch, yaw) = tf.transformations.euler_from_quaternion(quat)
        euler = np.zeros(3)
        euler[0] = roll
        euler[1] = yaw
        euler[2] = pitch
        return euler

    def publish_robot_desired(self, vel_cmd):
        msg = Twist()
        msg.linear_x = vel_cmd[0]
        msg.linear_y = vel_cmd[1]
        msg.linear_z = vel_cmd[2]
        msg.angular_x = vel_cmd[3]
        msg.angular_y = vel_cmd[4]
        msg.angular_z = vel_cmd[5]
        self.robot_desired.twist = msg
        self.robot_desired.reference_frame = 0
        self.robot_desired.duration = 0
        # print(self.robot_desired)
        self.robot_pub.publish(self.robot_desired)

    def set_pose(self, position):
        self.target_position = position
        self.desired_orientation = np.array([0, 0, 0])  # Robot end effector facing down
        self.cmd_received = False
        self.ee_real_logged = False
        self.gain = 1

    def set_pose_down(self, position):
        self.target_position = position
        self.desired_orientation = np.array([math.pi -0.1, math.pi/2, 0])  # Robot end effector facing down
        self.cmd_received = False
        self.ee_real_logged = False
        self.gain = 1

    def get_robot_pos(self):
        try:
            self.trans_ee_real = self.listener.lookupTransform('/base_link', '/end_effector_link', rospy.Time(0))
            if not self.ee_real_logged:
                self.ee_real_logged = True
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            return
        self.end_effector_position = np.array(self.trans_ee_real[0])
        self.end_efector_orientation = np.array(self.trans_ee_real[1])  # A quaternion

    def init_params(self):
        # initialize params for kinova
        self.num_joints = 6
        self.ee_real_logged = False
        self.robot_desired_joints = Base_JointSpeeds()
        self.robot_desired = TwistCommand()

    def init_ros(self):
        rospy.init_node('MoveStop', anonymous=True)
        self.robot_pub = rospy.Publisher("/my_gen3/in/cartesian_velocity", TwistCommand, queue_size=3)
        self.listener = tf.TransformListener()
        self.GripperPub = rospy.Publisher("/my_gen3/robotiq_2f_85_gripper_controller/gripper_cmd/goal",
                                          GripperCommandActionGoal, queue_size=3)

    def tf_base(self, data):
        global last_robot
        global active_robot
        global once_1

        if once_1:
            last_robot = data
            once_1 = False
        if data.pose != last_robot.pose:
            last_robot = data
            active_robot = True
            self.kuka = data
        elif data.pose == last_robot.pose:
            active_robot = False

    def tf_redcup(self, data):
        global last_cup
        global active_cup
        global once_2

        if once_2:
            last_cup = data
            # set initial position of cup
            self.cup_initial = data.pose.position
            if len(str(data.header.stamp.nsecs)) == 7:
                self.time_initial = decimal.Decimal(str(data.header.stamp.secs) + ".00" + str(data.header.stamp.nsecs))
            elif len(str(data.header.stamp.nsecs)) == 8:
                self.time_initial = decimal.Decimal(str(data.header.stamp.secs) + ".0" + str(data.header.stamp.nsecs))
            else:
                self.time_initial = decimal.Decimal(str(data.header.stamp.secs) + "." + str(data.header.stamp.nsecs))
            once_2 = False
        if data.pose != last_cup.pose:
            last_cup = data
            active_cup = True
            self.cup = data
        elif data.pose == last_cup.pose:
            active_cup = False

    def signal_handler(self, signal, frame):
        print("\n Program exiting gracefully")
        # stop robot
        vel_cmd = [0, 0, 0, 0, 0, 0]
        self.publish_robot_desired(vel_cmd)
        sys.exit(0)


if __name__ == "__main__":
    CarePickandPlaceMocap()
