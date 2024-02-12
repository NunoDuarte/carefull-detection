#!/usr/bin/env python
# this version works on python3 ubuntu 20

from geometry_msgs.msg import PoseStamped
from scipy.signal import savgol_filter
import rospy
import numpy as np
import sys
import math
import signal
import operator
import decimal

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


def signal_handler(signal, frame):
    print("\n Program exiting gracefully")
    sys.exit(0)


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


class CareController:

    def __init__(self):
        # Subscribers
        self.robot_base = rospy.Subscriber("/Cup_1/pose", PoseStamped, self.tf_base) # Robot_1
        self.red_cup = rospy.Subscriber("/Cup_2/pose", PoseStamped, self.tf_redcup, queue_size=1) #Red_cup

        # init params
        self.kuka = PoseStamped()
        self.cup = PoseStamped()

        self.init_ros()

        # init params for classifier carefulness
        self.b = np.array([0.5, 0.5])
        self.b_d = np.array([0.0, 0.0])
        self.epsilon = 0.28  # adaptation rate

        self.model()

    def model(self, ):
        print('Starting node..')

        i = 0
        close = False
        while not close:
            if active_cup and active_robot:
                cup = self.cup.pose.position

                cup_pose = np.zeros(3)
                cup_pose[0] = np.abs(np.round(cup.x - self.cup_initial.x, 3))
                cup_pose[1] = np.abs(np.round(cup.y - self.cup_initial.y, 3))
                cup_pose[2] = np.abs(np.round(cup.z - self.cup_initial.z, 3))

                vec_dis = float(math.sqrt(cup_pose[0]**2 + cup_pose[1]**2 + cup_pose[2]**2))
                # rospy.loginfo("cup \n%s", vec_dis)

                if len(str(self.cup.header.stamp.nsecs)) == 7:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + ".00" + str(self.cup.header.stamp.nsecs))
                elif len(str(self.cup.header.stamp.nsecs)) == 8:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + ".0" + str(self.cup.header.stamp.nsecs))
                else:
                    time = decimal.Decimal(str(self.cup.header.stamp.secs) + "." + str(self.cup.header.stamp.nsecs))
                diff_time = time - self.time_initial
                print('time', diff_time)

                # get at least one past point
                if i > 1:
                    vel = np.abs((vec_dis - vec_past)/float(diff_time - cup_past_time))
                    print('velocity', vel)

                    # ignore, object is static
                    if i < 10 and vel == 0.0:
                        Data = []
                        Data_vel = []
                        i = 0
                    else:
                        Data.append(vec_dis)
                        Data_vel.append(vel)

                    if len(Data) == 40:
                        pose_smooth = savgol_filter(Data, 11, 5)
                        vel_smooth = savgol_filter(Data_vel, 11, 5)

                        is_okay = self.classifier(vel_smooth, pose_smooth)

                        if is_okay:
                            print(B[-1])
                        input()

                vec_past = vec_dis
                cup_past_time = diff_time

                kuka_eef = np.array([0.55, -0.38, 1.38])
                if (np.absolute(cup.x - kuka_eef[0]) < 0.01 and np.absolute(cup.y - kuka_eef[1]) < 0.1
                        and np.absolute(cup.z - kuka_eef[2]) < 0.1):
                    close = True

                i = i + 1

            rospy.sleep(0.02)
            rospy.spin
            signal.signal(signal.SIGINT, signal_handler)
            self.rate.sleep()

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

    def init_ros(self, ):
        rospy.init_node('Carefulness', anonymous=True)
        self.rate = rospy.Rate(FREQ)

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


if __name__ == "__main__":
    CareController()
