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
