-- This illustrates how to publish and subscribe to an image using the ROS Interface.
-- An alternate version using image transport can be created with following functions:
--
-- simExtRosInterface_imageTransportAdvertise
-- simExtRosInterface_imageTransportPublish
-- simExtRosInterface_imageTransportShutdownPublisher
-- simExtRosInterface_imageTransportShutdownSubscriber
-- simExtRosInterface_imageTransportSubscribe

function imageMessage_callback(msg)
    -- Apply the received image to the passive vision sensor that acts as an image container
    simSetVisionSensorCharImage(passiveVisionSensor,msg.data)
end

if (sim_call_type==sim_childscriptcall_initialization) then
    -- Get some handles:
    activeVisionSensor=simGetObjectHandle('Vision_sensor')
    passiveVisionSensor=simGetObjectHandle('PassiveVision_sensor')

    -- Enable an image publisher and subscriber:
    pub=simExtRosInterface_advertise('/image', 'sensor_msgs/Image')
    simExtRosInterface_publisherTreatUInt8ArrayAsString(pub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
    sub=simExtRosInterface_subscribe('/image', 'sensor_msgs/Image', 'imageMessage_callback')
    simExtRosInterface_subscriberTreatUInt8ArrayAsString(sub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end

if (sim_call_type==sim_childscriptcall_sensing) then
    -- Publish the image of the active vision sensor:
    local data,w,h=simGetVisionSensorCharImage(activeVisionSensor)
    d={}
    d['header']={seq=0,stamp=simExtRosInterface_getTime(), frame_id="a"}
    d['height']=h
    d['width']=w
    d['encoding']='rgb8'
    d['is_bigendian']=1
    d['step']=w*3
    d['data']=data
    simExtRosInterface_publish(pub,d)
end

if (sim_call_type==sim_childscriptcall_cleanup) then
    -- Shut down publisher and subscriber. Not really needed from a simulation script (automatic shutdown)
    simExtRosInterface_shutdownPublisher(pub)
    simExtRosInterface_shutdownSubscriber(sub)
end




