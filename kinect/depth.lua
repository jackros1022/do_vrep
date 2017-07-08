if (sim_call_type==sim_childscriptcall_initialization) then
    activeVisionSensor=simGetObjectHandle('Vision_sensor')

    -- Enable an image publisher and subscriber:
    pub_depth=simExtRosInterface_advertise('/depth', 'sensor_msgs/Image')
    simExtRosInterface_publisherTreatUInt8ArrayAsString(pub_depth) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end

if (sim_call_type==sim_childscriptcall_sensing) then
    -- Publish the image of the active vision sensor:
    local data=simGetVisionSensorDepthBuffer(activeVisionSensor+sim_handleflag_codedstring)
    local res,nearClippingPlane=simGetObjectFloatParameter(activeVisionSensor,sim_visionfloatparam_near_clipping)
    local res,farClippingPlane=simGetObjectFloatParameter(activeVisionSensor,sim_visionfloatparam_far_clipping)
    nearClippingPlane=nearClippingPlane*1000 -- we want mm
    farClippingPlane=farClippingPlane*1000 -- we want mm
    data=simTransformBuffer(data,sim_buffer_float,farClippingPlane-nearClippingPlane,nearClippingPlane,sim_buffer_uint16)
    local res=simGetVisionSensorResolution(activeVisionSensor)
    d={}
    d['header']={seq=0,stamp=0, frame_id="a"}
    d['height']=res[2]
    d['width']=res[1]
    d['encoding']='16UC1' 
    d['is_bigendian']=1
    d['step']=res[1]*res[2]
    d['data']=data
    simExtRosInterface_publish(pub_depth,d)
end