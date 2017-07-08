--[[
1. 通过graph记录关节1数据 【Object: absolute gamma-orientation】和【UR5_link2_visible】
   关节1，【 0 -> 90 -> -90 -> 0 】 
2. 为什么没有指定当前位置信息？
]]

--[[函数 simRMLMoveToJointPositions（）
number result,table newPos,table newVel,table newAccel,
number timeLeft=simRMLMoveToJointPositions(table jointHandles,number flags,table currentVel,
                                           table currentAccel,table maxVel,table maxAccel,
                                           table maxJerk,table targetPos,table targetVel,table direction)
Lua parameters:	
@ jointHandles: handles of the joints to actuate
@ flags: RML flags. -1 for default flags.
@ currentVel: the current velocity of the joints. Can be nil in which case a velocity vector of 0 is used.
@ currentAccel: the current acceleration of the joints. Can be nil in which case an acceleration vector of 0 is used.
@ maxVel: the maximum allowed velocity of the joints
@ maxAccel: the maximum allowed acceleration of the joints
@ maxJerk: the maximum allowed jerk of the joints. With the RML type II plugin, the max. jerk will however always be infinite.
@ targetPos: the desired target positions of the joints
@ targetVel: the desired velocity of the joints at the target. Can be nil in which case a velocity vector of 0 is used.
@ direction: the desired rotation direction for cyclic revolute joints: 0 for the shortest distance, 
    -x for a movement towards negative values, +x for a movement towards positive values (n=(x-1) represents the number of additional turns). 
    Can be nil or omitted, in which case a value of 0 is used for all joints.
]]

-- This is a threaded script, and is just an example!

jointHandles={-1,-1,-1,-1,-1,-1}
for i=1,6,1 do
    jointHandles[i]=simGetObjectHandle('UR5_joint'..i)
end

-- Set-up some of the RML vectors:
vel=180
accel=40
jerk=80
currentVel={0,0,0,0,0,0,0}
currentAccel={0,0,0,0,0,0,0}
maxVel={vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180}                -- 速度
maxAccel={accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180}  -- 加速度
maxJerk={jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180}         -- 加加速度
targetVel={0,0,0,0,0,0}                                                                                                 -- 达到目标时的速度

targetPos1={90*math.pi/180,90*math.pi/180,-90*math.pi/180,90*math.pi/180,90*math.pi/180,90*math.pi/180}
simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,targetPos1,targetVel)

targetPos2={-90*math.pi/180,45*math.pi/180,90*math.pi/180,135*math.pi/180,90*math.pi/180,90*math.pi/180}
simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,targetPos2,targetVel)

targetPos3={0,0,0,0,0,0}
simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,targetPos3,targetVel)
