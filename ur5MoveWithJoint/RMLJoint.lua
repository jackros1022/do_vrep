--[[
1. 通过graph记录关节1数据 【Object: absolute gamma-orientation】和【UR5_link2_visible】
   关节1，【 0 -> 90 -> -90 -> 0 】 
2. 为什么没有指定当前位置信息？
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
