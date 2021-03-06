function speedChange_callback(ui,id,newVal)
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])*newVal/100
end

if (sim_call_type==sim_childscriptcall_initialization) then 
    bubbleRobBase=simGetObjectAssociatedWithScript(sim_handle_self)
    leftMotor=simGetObjectHandle("leftMotor")
    rightMotor=simGetObjectHandle("rightMotor")
    noseSensor=simGetObjectHandle("sensingNose")  -- 距离传感器
    minMaxSpeed={50*math.pi/180,300*math.pi/180}
    backUntilTime=-1 -- Tells whether bubbleRob is in forward or backward mode
    floorSensorHandles={-1,-1,-1}       -- 元组 视觉传感器 
    floorSensorHandles[1]=simGetObjectHandle("leftSensor")
    floorSensorHandles[2]=simGetObjectHandle("middleSensor")
    floorSensorHandles[3]=simGetObjectHandle("rightSensor")
    -- Create the custom UI:
    xml = '<ui title="'..simGetObjectName(bubbleRobBase)..' speed" closeable="false" resizeable="false" activate="false">'..[[
                <hslider minimum="0" maximum="100" onchange="speedChange_callback" id="1"/>
            <label text="" style="* {margin-left: 300px;}"/>
        </ui>
        ]]
    ui=simExtCustomUI_create(xml)
    speed=(minMaxSpeed[1]+minMaxSpeed[2])*0.5
    simExtCustomUI_setSliderValue(ui,1,100*(speed-minMaxSpeed[1])/(minMaxSpeed[2]-minMaxSpeed[1]))
end 


if (sim_call_type==sim_childscriptcall_actuation) then 
    result=simReadProximitySensor(noseSensor)
    if (result>0) then backUntilTime=simGetSimulationTime()+4 end       -- 仿真时间加4
    
    -- read the line detection sensors:
    sensorReading={false,false,false}
    for i=1,3,1 do
        result,data=simReadVisionSensor(floorSensorHandles[i])
        if (result>=0) then
            sensorReading[i]=(data[11]<0.3) -- data[11] is the average of intensity of the image
        end
    end
    
    -- compute left and right velocities to follow the detected line:
    rightV=speed
    leftV=speed
    if sensorReading[1] then
        leftV=0.03*speed
    end
    if sensorReading[3] then
        rightV=0.03*speed
    end
    if sensorReading[1] and sensorReading[3] then
        backUntilTime=simGetSimulationTime()+2      -- 仿真时间加2
    end
    
    if (backUntilTime<simGetSimulationTime()) then
        -- When in forward mode, we simply move forward at the desired speed
        simSetJointTargetVelocity(leftMotor,leftV)
        simSetJointTargetVelocity(rightMotor,rightV)
    else
        -- When in backward mode, we simply backup in a curve at reduced speed
        simSetJointTargetVelocity(leftMotor,-speed/2)
        simSetJointTargetVelocity(rightMotor,-speed/8)
    end
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
    simExtCustomUI_destroy(ui)
end 
