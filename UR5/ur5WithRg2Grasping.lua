-- This is a threaded script, and is just an example!
--[[
    包含三个部分：
    1. UR5
    2. RG2
    3. conveyorbelt
]]
-----------------------------------------------------UR5---------------------------------------------------------------------------------------------
enableIk=function(enable)
    if enable then
        simSetObjectMatrix(ikTarget,-1,simGetObjectMatrix(ikTip,-1))
        for i=1,#jointHandles,1 do
            simSetJointMode(jointHandles[i],sim_jointmode_ik,1)
        end

        simSetExplicitHandling(ikGroupHandle,0)
    else
        simSetExplicitHandling(ikGroupHandle,1)
        for i=1,#jointHandles,1 do
            simSetJointMode(jointHandles[i],sim_jointmode_force,0)
        end
    end
end

setGripperData=function(open,velocity,force)
    if not velocity then
        velocity=0.11
    end
    if not force then
        force=20
    end
    if not open then
        velocity=-velocity
    end
    local data=simPackFloatTable({velocity,force})
    simSetStringSignal(modelName..'_rg2GripperData',data)
end

-- Initialize some values:
jointHandles={-1,-1,-1,-1,-1,-1}
for i=1,6,1 do
    jointHandles[i]=simGetObjectHandle('UR5_joint'..i)
end
ikGroupHandle=simGetIkGroupHandle('UR5')
ikTip=simGetObjectHandle('UR5_ikTip')
ikTarget=simGetObjectHandle('UR5_ikTarget')
modelBase=simGetObjectAssociatedWithScript(sim_handle_self)
modelName=simGetObjectName(modelBase)

-- Set-up some of the RML vectors: （Reflexxes Motion Library）
vel=180
accel=40
jerk=80
currentVel={0,0,0,0,0,0,0}
currentAccel={0,0,0,0,0,0,0}
maxVel={vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180}
maxAccel={accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180}
maxJerk={jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180}
targetVel={0,0,0,0,0,0}

ikMaxVel={0.4,0.4,0.4,1.8}
ikMaxAccel={0.8,0.8,0.8,0.9}
ikMaxJerk={0.6,0.6,0.6,0.8}

initialConfig={0,0,0,0,0,0}
pickConfig={-70.1*math.pi/180,18.85*math.pi/180,93.18*math.pi/180,68.02*math.pi/180,109.9*math.pi/180,90*math.pi/180}
dropConfig1={-183.34*math.pi/180,14.76*math.pi/180,78.26*math.pi/180,-2.98*math.pi/180,-90.02*math.pi/180,86.63*math.pi/180}
dropConfig2={-197.6*math.pi/180,14.76*math.pi/180,78.26*math.pi/180,-2.98*math.pi/180,-90.02*math.pi/180,72.38*math.pi/180}
dropConfig3={-192.1*math.pi/180,3.76*math.pi/180,91.16*math.pi/180,-4.9*math.pi/180,-90.02*math.pi/180,-12.13*math.pi/180}
dropConfig4={-189.38*math.pi/180,24.94*math.pi/180,64.36*math.pi/180,0.75*math.pi/180,-90.02*math.pi/180,-9.41*math.pi/180}

dropConfigs={dropConfig1,dropConfig2,dropConfig3,dropConfig4}
dropConfigIndex=1
droppedPartsCnt=0

enableIk(false)
setGripperData(true)
simSetInt32Parameter(sim_intparam_current_page,0)

while droppedPartsCnt<6 do

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,pickConfig,targetVel)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        enableIk(true)
        simSetInt32Parameter(sim_intparam_current_page,1)
    

        pos=simGetObjectPosition(ikTip,-1)
        quat=simGetObjectQuaternion(ikTip,-1)
        simRMLMoveToPosition(ikTarget,-1,-1,nil,nil,ikMaxVel,ikMaxAccel,ikMaxJerk,{pos[1]+0.105,pos[2],pos[3]},quat,nil)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        setGripperData(false)
        simWait(0.5)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        simRMLMoveToPosition(ikTarget,-1,-1,nil,nil,ikMaxVel,ikMaxAccel,ikMaxJerk,{pos[1],pos[2]-0.2,pos[3]+0.2},quat,nil)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        enableIk(false)
        simSetInt32Parameter(sim_intparam_current_page,0)

        simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,dropConfigs[dropConfigIndex],targetVel)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        simSetInt32Parameter(sim_intparam_current_page,2)
        enableIk(true)
        pos=simGetObjectPosition(ikTip,-1)
        quat=simGetObjectQuaternion(ikTip,-1)
        simRMLMoveToPosition(ikTarget,-1,-1,nil,nil,ikMaxVel,ikMaxAccel,ikMaxJerk,{pos[1],pos[2],0.025+0.05*math.floor(0.1+droppedPartsCnt/2)},quat,nil)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        setGripperData(true)
        simWait(0.5)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        simRMLMoveToPosition(ikTarget,-1,-1,nil,nil,ikMaxVel,ikMaxAccel,ikMaxJerk,pos,quat,nil)
    end

    if simGetSimulationState()~=sim_simulation_advancing_abouttostop then
        enableIk(false)

        simSetInt32Parameter(sim_intparam_current_page,0)

        dropConfigIndex=dropConfigIndex+1
        if dropConfigIndex>4 then
            dropConfigIndex=1
        end

        droppedPartsCnt=droppedPartsCnt+1
    end
end

simRMLMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,initialConfig,targetVel)
simStopSimulation()

-----------------------------------------------------conveyorbelt---------------------------------------------------------------------------------------------
if (sim_call_type==sim_childscriptcall_initialization) then 
    pathHandle=simGetObjectHandle("ConveyorBeltPath")
    forwarder=simGetObjectHandle('ConveyorBelt_forwarder')  -- 代表整体传送带
    sensor=simGetObjectHandle('conveyorBelt_sensor')
    simSetPathTargetNominalVelocity(pathHandle,0) -- for backward compatibility
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
 
end 

if (sim_call_type==sim_childscriptcall_actuation) then 
    beltVelocity=0.08

    if simReadProximitySensor(sensor)>0 then
        beltVelocity=0
    end

    local dt=simGetSimulationTimeStep()     -- 仿真速度
    local p=simGetPathPosition(pathHandle)
    -- 	number result=simSetPathPosition(number objectHandle,number position)
    simSetPathPosition(pathHandle,p+beltVelocity*dt)
    
    -- Here we "fake" the transportation pads with a single static rectangle that we dynamically reset
    -- at each simulation pass (while not forgetting to set its initial velocity vector) :
    
    relativeLinearVelocity={beltVelocity,0,0}
    -- Reset the dynamic rectangle from the simulation (it will be removed and added again)
    simResetDynamicObject(forwarder)
    -- Compute the absolute velocity vector:
    m=simGetObjectMatrix(forwarder,-1)      -- -1代表绝对方位
    m[4]=0 -- Make sure the translation component is discarded
    m[8]=0 -- Make sure the translation component is discarded
    m[12]=0 -- Make sure the translation component is discarded
    absoluteLinearVelocity=simMultiplyVector(m,relativeLinearVelocity)
    -- Now set the initial velocity of the dynamic rectangle:
    simSetObjectFloatParameter(forwarder,sim_shapefloatparam_init_velocity_x,absoluteLinearVelocity[1])
    simSetObjectFloatParameter(forwarder,sim_shapefloatparam_init_velocity_y,absoluteLinearVelocity[2])
    simSetObjectFloatParameter(forwarder,sim_shapefloatparam_init_velocity_z,absoluteLinearVelocity[3])
end 


-----------------------------------------------------RG2---------------------------------------------------------------------------------------------

if (sim_call_type==sim_childscriptcall_initialization) then
    modelBase=simGetObjectAssociatedWithScript(sim_handle_self)
    robotBase=modelBase
    while true do
        robotBase=simGetObjectParent(robotBase)
        if robotBase==-1 then
            robotName='UR5'
            break
        end
        robotName=simGetObjectName(robotBase)
        local suffix,suffixlessName=simGetNameSuffix(robotName)
        if suffixlessName=='UR5' then
            break
        end
    end
    robotName=simGetObjectName(robotBase)
    motorHandle=simGetObjectHandle('RG2_openCloseJoint')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local data=simGetStringSignal(robotName..'_rg2GripperData')
    if data then
        velocityAndForce=simUnpackFloatTable(data)
        simSetJointTargetVelocity(motorHandle,velocityAndForce[1])
        simSetJointForce(motorHandle,velocityAndForce[2])
    end
end

