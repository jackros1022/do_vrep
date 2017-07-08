-- This is a threaded script!
--[[
    包含2个部分：
    1. Robot1
    2. suctionPad
]]
-----------------------------------------------Robot1-------------------------------------------------------
activateSuctionPad=function(active)
    if (active) then
        simSetScriptSimulationParameter(suctionPadScript,'active','true')
    else
        simSetScriptSimulationParameter(suctionPadScript,'active','false')
    end
end

getTargetPosVectorFromObjectPose=function(objectHandle)
    local p=simGetObjectPosition(objectHandle,targetBase)
    local o=simGetObjectQuaternion(objectHandle,targetBase)
    return p,o
end

getNextContainerIndex=function(index)
    index=index+1
    if index>3 then
        index=1
    end
    return index
end

getNextBoxIndex=function(index)
    index=index+1
    if index>2 then
        index=1
    end
    return index
end

threadFunction=function()
    while simGetSimulationState()~=sim_simulation_advancing_abouttostop do
        -- 1. Pick-up a box:
        -- Go to approach pose near container X:
        targetP,targetO=getTargetPosVectorFromObjectPose(approaches[containerIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to grasp pose on box A:
        targetP,targetO=getTargetPosVectorFromObjectPose(boxes[boxIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Activate suction pad:
        activateSuctionPad(true)
        -- Go to approach pose near container X:
        targetP,targetO=getTargetPosVectorFromObjectPose(approaches[containerIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to initial pose:
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,initPos,initOr,nil)


        -- 2. Drop a box:
        -- Get the next container:
        containerIndex=getNextContainerIndex(containerIndex)
        -- Go to approach pose near container X+1:
        targetP,targetO=getTargetPosVectorFromObjectPose(approaches[containerIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to drop pose on container X+1:
        targetP,targetO=getTargetPosVectorFromObjectPose(drops[containerIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Deactivate suction pad:
        activateSuctionPad(false)
        -- Go to approach pose near container X+1:
        targetP,targetO=getTargetPosVectorFromObjectPose(approaches[containerIndex])
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,targetP,targetO,nil)
        -- Go to initial pose:
        simRMLMoveToPosition(target,targetBase,-1,nil,nil,maxVel,maxAccel,maxJerk,initPos,initOr,nil)


        -- 3. Now handle the other box:
        boxIndex=getNextBoxIndex(boxIndex)
        containerIndex=getNextContainerIndex(containerIndex)
    end
end

-- Initialization:
simSetThreadSwitchTiming(2) 

suctionPad=simGetObjectHandle('suctionPad')
suctionPadScript=simGetScriptAssociatedWithObject(suctionPad)

target=simGetObjectHandle('RobotTarget')
targetBase=simGetObjectHandle('Robot1')

box1=simGetObjectHandle('Cuboid1Grasp')
box2=simGetObjectHandle('Cuboid2Grasp')
boxes={box1,box2}

drop1=simGetObjectHandle('CuboidDrop1')
drop2=simGetObjectHandle('CuboidDrop2')
drop3=simGetObjectHandle('CuboidDrop3')
drops={drop1,drop2,drop3}

approach1=simGetObjectHandle('CuboidApproach1')
approach2=simGetObjectHandle('CuboidApproach2')
approach3=simGetObjectHandle('CuboidApproach3')
approaches={approach1,approach2,approach3}

-- targetSphere is the object that the robot's tooltip will try to follow via IK, which means that
-- if you change the position/orientation of targetSphere, then the robot's tooltip will try to follow
-- targetSphereBase is used so that all position and orientation values are always relative to the robot base
-- (e.g. so that if you move the robot to another position, you will not have to rewrite this code!)

-- Get the current position and orientation of the robot's tooltip:
initPos=simGetObjectPosition(target,targetBase)
initOr=simGetObjectQuaternion(target,targetBase)

-- Set-up some of the RML vectors:
maxVel={0.4,0.4,0.4,1.8}
maxAccel={0.3,0.3,0.3,0.9}
maxJerk={0.2,0.2,0.2,0.8}

activateSuctionPad(false)
boxIndex=2
containerIndex=2

-- Here we execute the regular thread code:
res,err=xpcall(threadFunction,function(err) return debug.traceback(err) end)
if not res then
    simAddStatusbarMessage('Lua runtime error: '..err)
end

-- Clean-up:


-----------------------------------------------suctionPad-------------------------------------------------------
if (sim_call_type==sim_childscriptcall_initialization) then 
    s=simGetObjectHandle('suctionPadSensor')
    l=simGetObjectHandle('suctionPadLoopClosureDummy1')
    l2=simGetObjectHandle('suctionPadLoopClosureDummy2')
    b=simGetObjectHandle('suctionPadBodyRespondable')
    suctionPadLink=simGetObjectHandle('suctionPadLink')
    
    infiniteStrength=simGetScriptSimulationParameter(sim_handle_self,'infiniteStrength')
    maxPullForce=simGetScriptSimulationParameter(sim_handle_self,'maxPullForce')
    maxShearForce=simGetScriptSimulationParameter(sim_handle_self,'maxShearForce')
    maxPeelTorque=simGetScriptSimulationParameter(sim_handle_self,'maxPeelTorque')
    
    simSetLinkDummy(l,-1)
    simSetObjectParent(l,b,true)
    m=simGetObjectMatrix(l2,-1)
    simSetObjectMatrix(l,-1,m)
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
 
end 

if (sim_call_type==sim_childscriptcall_sensing) then 
    parent=simGetObjectParent(l)
    if (simGetScriptSimulationParameter(sim_handle_self,'active')==false) then
        if (parent~=b) then
            simSetLinkDummy(l,-1)
            simSetObjectParent(l,b,true)
            m=simGetObjectMatrix(l2,-1)
            simSetObjectMatrix(l,-1,m)
        end
    else
        if (parent==b) then
            -- Here we want to detect a respondable shape, and then connect to it with a force sensor (via a loop closure dummy dummy link)
            -- However most respondable shapes are set to "non-detectable", so "simReadProximitySensor" or similar will not work.
            -- But "simCheckProximitySensor" or similar will work (they don't check the "detectable" flags), but we have to go through all shape objects!
            index=0
            while true do
                shape=simGetObjects(index,sim_object_shape_type)
                if (shape==-1) then
                    break
                end
                if (shape~=b) and (simGetObjectInt32Parameter(shape,sim_shapeintparam_respondable)~=0) and (simCheckProximitySensor(s,shape)==1) then
                    -- Ok, we found a respondable shape that was detected
                    -- We connect to that shape:
                    -- Make sure the two dummies are initially coincident:
                    simSetObjectParent(l,b,true)
                    m=simGetObjectMatrix(l2,-1)
                    simSetObjectMatrix(l,-1,m)
                    -- Do the connection:
                    simSetObjectParent(l,shape,true)
                    simSetLinkDummy(l,l2)
                    break
                end
                index=index+1
            end
        else
            -- Here we have an object attached
            if (infiniteStrength==false) then
                -- We might have to conditionally beak it apart!
                result,force,torque=simReadForceSensor(suctionPadLink) -- Here we read the median value out of 5 values (check the force sensor prop. dialog)
                if (result>0) then
                    breakIt=false
                    if (force[3]>maxPullForce) then breakIt=true end
                    sf=math.sqrt(force[1]*force[1]+force[2]*force[2])
                    if (sf>maxShearForce) then breakIt=true end
                    if (torque[1]>maxPeelTorque) then breakIt=true end
                    if (torque[2]>maxPeelTorque) then breakIt=true end
                    if (breakIt) then
                        -- We break the link:
                        simSetLinkDummy(l,-1)
                        simSetObjectParent(l,b,true)
                        m=simGetObjectMatrix(l2,-1)
                        simSetObjectMatrix(l,-1,m)
                    end
                end
            end
        end
    end
    
    if (simGetSimulationState()==sim_simulation_advancing_lastbeforestop) then
        simSetLinkDummy(l,-1)
        simSetObjectParent(l,b,true)
        m=simGetObjectMatrix(l2,-1)
        simSetObjectMatrix(l,-1,m)
    end
end 
