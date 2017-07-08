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

