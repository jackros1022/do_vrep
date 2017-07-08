setIkMode=function()
    simSetExplicitHandling(ikGroup,0) -- that enables implicit IK handling
    simSwitchThread()
end

setFkMode=function()
    simSetExplicitHandling(ikGroup,1) -- that disables implicit IK handling
    simSwitchThread()
    simSetObjectParent(ikTarget,ikTip,true)
    simSetObjectPosition(ikTarget,ikTip,{0,0,0})
    simSetObjectPosition(ikTarget,ikTip,{0,0,0})
end

moveToJointPositions=function(newPos,velF)  -- 传入参数 newPos，velF
    if not velF then velF=1 end
    local accel=40*math.pi/180
    local jerk=20*math.pi/180
    local currentVel={0,0,0,0,0,0}
    local currentAccel={0,0,0,0,0,0}
    local maxVel={velF*175*math.pi/180,velF*175*math.pi/180,velF*175*math.pi/180,velF*250*math.pi/180,velF*250*math.pi/180,velF*360*math.pi/180}
    local maxAccel={accel,accel,accel,accel,accel,accel}
    local maxJerk={jerk,jerk,jerk,jerk,jerk,jerk}
    local targetVel={0,0,0,0,0,0,0}
    simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,newPos,targetVel)
end

moveToAuxJointPosition=function(newPos,velF)
    if not velF then velF=1 end
    local vel=40*math.pi/180
    local accel=10*math.pi/180
    local jerk=30*math.pi/180
    local currentVel={0}
    local currentAccel={0}
    local maxVel={vel*velF}
    local maxAccel={accel}
    local maxJerk={jerk}
    local targetVel={0}
    simRMLMoveToJointPositions({auxJoint},-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,{newPos},targetVel)
end

threadFunction=function()
    -- Main loop:
    while simGetSimulationState()~=sim_simulation_advancing_abouttostop do

        setFkMode()
        moveToJointPositions({90*math.pi/180,-30*math.pi/180,60*math.pi/180,0*math.pi/180,60*math.pi/180,0*math.pi/180})

        setIkMode()
        simSetObjectPosition(auxJoint,model,{0,1.5,0})
        simSetJointPosition(auxJoint,0)
        simSetObjectParent(ikTarget,auxJoint,true)
        moveToAuxJointPosition(360*math.pi/180)


        setFkMode()
        moveToJointPositions({0*math.pi/180,-30*math.pi/180,60*math.pi/180,0*math.pi/180,60*math.pi/180,0*math.pi/180})

        setIkMode()
        simSetObjectPosition(auxJoint,model,{1.5,0,0})
        simSetJointPosition(auxJoint,0)
        simSetObjectParent(ikTarget,auxJoint,true)
        moveToAuxJointPosition(360*math.pi/180)


        setFkMode()
        moveToJointPositions({-90*math.pi/180,-30*math.pi/180,60*math.pi/180,0*math.pi/180,60*math.pi/180,0*math.pi/180})

        setIkMode()
        simSetObjectPosition(auxJoint,model,{0,-1.5,0})
        simSetJointPosition(auxJoint,0)
        simSetObjectParent(ikTarget,auxJoint,true)
        moveToAuxJointPosition(360*math.pi/180)


        setFkMode()
        moveToJointPositions({0*math.pi/180,0*math.pi/180,0*math.pi/180,0*math.pi/180,0*math.pi/180,0*math.pi/180})

    end
end

-- Initialization:
jointHandles={}
for i=1,6,1 do
    jointHandles[i]=simGetObjectHandle('IRB4600_joint'..i)
end
model=simGetObjectAssociatedWithScript(sim_handle_self)
ikGroup=simGetIkGroupHandle('IRB4600')
ikTip=simGetObjectHandle('IRB4600_IkTip')
ikTarget=simGetObjectHandle('IRB4600_IkTarget')
auxJoint=simGetObjectHandle('IRB4600_auxJoint')

-- Main function:
res,err=xpcall(threadFunction,function(err) return debug.traceback(err) end)
if not res then
    simAddStatusbarMessage('Lua runtime error: '..err)
end
