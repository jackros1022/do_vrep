-- This is a threaded script!
--[[
    1. 场景拖出机器人，添加4个点（注意考虑 位置 和 姿态）
    2. 
]]

--[[ 函数 simRMLMoveToPosition（）
number result,table_3 newPos,table_4 newQuaternion,table_4 newVel,
table_4 newAccel,number timeLeft=simRMLMoveToPosition(number objectHandle,number relativeToObjectHandle,
                                                      number flags,table_4 currentVel,table_4 currentAccel,table_4 maxVel,
                                                      table_4 maxAccel,table_4 maxJerk,table_3 targetPosition,
                                                      table_4 targetQuaternion,table_4 targetVel)
参数解释：
@ objectHandle: handle of the object to be moved
@ relativeToObjectHandle: indicates relative to which reference frame the movement data is specified. 
    Specify -1 for a movement relative to the absolute reference frame, sim_handle_parent for a movement relative to the object's parent frame, 
    or an object handle relative to whose reference frame the movement should be performed.
@ flags: RML flags. -1 for default flags.
@ currentVel: the current velocity of the object (velX, velY, velZ, velAngle). Can be nil in which case a velocity vector of 0 is used.
@ currentAccel: the current acceleration of the object (accelX, accelY, accelZ, accelAngle). Can be nil in which case an acceleration vector of 0 is used.
@ maxVel: the maximum allowed velocity of the object (maxVelX, maxVelY, maxVelZ, maxVelAngle)
@ maxAccel: the maximum allowed acceleration of the object (maxAccelX, maxAccelY, maxAccelZ, maxAccelAngle)
@ maxJerk: the maximum allowed jerk of the object (maxJerkX, maxJerkY, maxJerkZ, maxJerkAngle). 
    With the RML type II plugin, the max. jerk will however always be infinite.
@ targetPosition: the desired target position of the object (expressed relative to relativeToObjectHandle). 
    Can be nil, in which case the position of the object will stay constant
@ targetQuaternion: the desired target orientation of the object (expressed relative to relativeToObjectHandle). 
    Can be nil, in which case the orientation of the object will stay constant
@ targetVel: the desired velocity of the object at the target (targetVelX, targetVelY, targetVelZ, targetVelAngle). 
    Can be nil in which case a velocity vector of 0 is used.
]]

getTargetPosVectorFromObjectPose=function(objectHandle)
    local p=simGetObjectPosition(objectHandle,targetBase)
    local o=simGetObjectQuaternion(objectHandle,targetBase)
    return p,o
end


threadFunction=function()
    while simGetSimulationState()~=sim_simulation_advancing_abouttostop do

        -- target is the object that the robot's tooltip will try to follow via IK, which means that
        -- if you change the position/orientation of target, then the robot's tooltip will try to follow
        -- target is used so that all position and orientation values are always relative to the robot base
        -- (e.g. so that if you move the robot to another position, you will not have to rewrite this code!)

        -- Go to pos1:
        targetP,targetO=getTargetPosVectorFromObjectPose(pos1_handle)
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to pos2:
        targetP,targetO=getTargetPosVectorFromObjectPose(pos2_handle)
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to pos3:
        targetP,targetO=getTargetPosVectorFromObjectPose(pos3_handle)
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to pos4:
        targetP,targetO=getTargetPosVectorFromObjectPose(pos4_handle)
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
    end
end

-- Initialization:
simSetThreadSwitchTiming(2) 

target=simGetObjectHandle('IRB4600_IkTarget')
targetBase=simGetObjectHandle('IRB4600')

pos1_handle=simGetObjectHandle('pos1')
pos2_handle=simGetObjectHandle('pos2')
pos3_handle=simGetObjectHandle('pos3')
pos4_handle=simGetObjectHandle('pos4')


-- Set-up some of the RML vectors:
maxVel={0.4,0.4,0.4,1.8}
maxAccel={0.3,0.3,0.3,0.9}
maxJerk={0.2,0.2,0.2,0.8}


-- Here we execute the regular thread code:
res,err=xpcall(threadFunction,function(err) return debug.traceback(err) end)
if not res then
    simAddStatusbarMessage('Lua runtime error: '..err)
end