----------------------------------------------1-singleIkGroupWithSingleIkElement-undamped--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.

When you run the simulation and click 'Compute IK', 
the robot's green tip dummy will be brought onto the red target dummy by computing appropriate joint angles. 
A single IK group containing a single IK element is used. Resolution is undamped (using the Jacobian pseudo-inverse), 
and you will notice that if you place the target dummy out of reach or close to a singular configuration, stability will suffer.
]]
if (sim_call_type==sim_childscriptcall_initialization) then
    ui=simGetUIHandle('UI')
    ik=simGetIkGroupHandle('ik')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui)
    if a==1 then
        simHandleIkGroup(ik)
    end
end

----------------------------------------------2-singleIkGroupWithSingleIkElement-damped--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.

When you run the simulation and click 'Compute IK (damped least squares)', 
the robot's green tip dummy will be brought close to the red target dummy by computing appropriate joint angles. 
A single IK group containing a single IK element is used. Resolution is damped (using the damped least square method (DLS)). 
This resolution method is more stable than the Jacobian pseudo-inverse, but requires more iterations to converge depending on the damping factor.
]]
if (sim_call_type==sim_childscriptcall_initialization) then
    ui=simGetUIHandle('UI')
    ik=simGetIkGroupHandle('ik')
    uiDamped=simGetUIHandle('UI_damped')
    ikDamped=simGetIkGroupHandle('ik_damped')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui)
    if a==1 then
        simHandleIkGroup(ik)
    end
    a=simGetUIEventButton(uiDamped)
    if a==1 then
        simHandleIkGroup(ikDamped)
    end
end

----------------------------------------------3-twoIkGroupsWithEachOneIkElement-resolutionOrderIsNotRelevant--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.

When you run the simulation and click 'Compute IK1' and 'Compute IK2', 
the robot's green tip dummy will be brought onto its respective red target dummy by computing appropriate joint angles. 
Since the two mechanisms do not share common joints, resolution can be done sequentially (via two IK groups), and the resolution order is not important. 
Two IK groups containing each a single IK element are used. Resolution is undamped (using the Jacobian pseudo-inverse). 
]]
-- base1
if (sim_call_type==sim_childscriptcall_initialization) then
    ui=simGetUIHandle('UI_1')
    ik=simGetIkGroupHandle('ik_1')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui)
    if a==1 then
        simHandleIkGroup(ik)
    end
end


-- base2
if (sim_call_type==sim_childscriptcall_initialization) then
    ui=simGetUIHandle('UI_2')
    ik=simGetIkGroupHandle('ik_2')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui)
    if a==1 then
        simHandleIkGroup(ik)
    end
end



----------------------------------------------4-twoIkGroupsWithEachOneIkElement-resolutionOrderIsRelevant--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.

When you run the simulation and click 'Compute IK1' and 'Compute IK2', 
the robot's green tip dummy will be brought onto its respective red target dummy by computing appropriate joint angles. 
Since the two mechanisms do not share common joints, resolution can be done sequentially (via two IK groups), 
but the resolution order is important. Two IK groups containing each a single IK element are used. 
Resolution is undamped (using the Jacobian pseudo-inverse).
]]

if (sim_call_type==sim_childscriptcall_initialization) then
    ui1=simGetUIHandle('UI_1')
    ik1=simGetIkGroupHandle('ik_1')
    ui2=simGetUIHandle('UI_2')
    ik2=simGetIkGroupHandle('ik_2')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui1)
    if a==1 then
        simHandleIkGroup(ik1)
    end
    a=simGetUIEventButton(ui2)
    if a==1 then
        simHandleIkGroup(ik2)
    end
end



----------------------------------------------5-singleIkGroupWithTwoIkElements--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.
When you run the simulation, you have 3 possibilities:

a) When you click 'Compute IK1', a single IK group containing a single IK element will be used to bring the green tip dummy 
onto its corresponding red target dummy in the right mechanism. The other elements of the mechanism are ignored.

b) When you click 'Compute IK2', a similar approach as in a) is taken for the left branch of the mechanism. 
If you solve often enough the left and right branch, the two targets will eventually be reached simultaneously

c) When you click 'Compute simultaneous", a single IK group containing two IK elements will be used to simultaneously bring 
the two green tip dummies onto their red target dummies. Using a single IK group containing two IK elements is required, 
since the two IK branches share a common joint.
]]

if (sim_call_type==sim_childscriptcall_initialization) then
    ui1=simGetUIHandle('UI_1')
    ik1=simGetIkGroupHandle('ik_1')
    ui2=simGetUIHandle('UI_2')
    ik2=simGetIkGroupHandle('ik_2')
    uiCommon=simGetUIHandle('UI_common')
    ikCommon=simGetIkGroupHandle('ik_common')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui1)
    if a==1 then
        simHandleIkGroup(ik1)
    end
    a=simGetUIEventButton(ui2)
    if a==1 then
        simHandleIkGroup(ik2)
    end
    a=simGetUIEventButton(uiCommon)
    if a==1 then
        simHandleIkGroup(ikCommon)
    end
end




----------------------------------------------6-singleIkGroupWithTwoIkElements-weightedAndDampedResolution--------------------------------------------------------------

--[[This scene illustrates a very simple inverse kinematics example.

It contains a branched kinematic chain that needs to be solved via a single IK group containing two IK elements. 
IK resolution of the mechanism happens simultaneously for the two branches, and it is possible to adjust 
the resolution weight for the left or the right branch.
]]
if (sim_call_type==sim_childscriptcall_initialization) then
    ui1=simGetUIHandle('UI_1')
    ik1=simGetIkGroupHandle('ik_1')
    ui2=simGetUIHandle('UI_2')
    ik2=simGetIkGroupHandle('ik_2')
    uiNone=simGetUIHandle('UI_none')
    ikNone=simGetIkGroupHandle('ik_none')
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui1)
    if a==1 then
        simHandleIkGroup(ik1)
    end
    a=simGetUIEventButton(ui2)
    if a==1 then
        simHandleIkGroup(ik2)
    end
    a=simGetUIEventButton(uiNone)
    if a==1 then
        simHandleIkGroup(ikNone)
    end
end



----------------------------------------------7-fkAndIkResolutionForParallelMechanisms--------------------------------------------------------------
--[[This scene illustrates a very simple inverse kinematics example.

It contains a 2 Ik elements: the first is responsible to keep the loop closed. The second is responsible to bring 
the green tip dummy onto its red target dummy.

The mechanism can now be driven in FK or IK mode:

a) in FK mode, we don't care about the green tip dummy overlapping its red target dummy, 
so we temporarily disable its associated IK element. We also change the joint mode for the two motors to passive mode, 
so that they won't be involved in IK calculations. We then can adjust the desired motor angles, 
and compute the loop closure Ik group

b) in FK mode, we require the two IK elements: one is in charge of closing the loop, 
the other one is in charge to bring the green tip dummy onto its red target dummy. 
Those two IK elements need to be solved simultaneously (i.e. in the same IK group). 
We also make sure that the motor joints are in IK mode, otherwise we very probably won't 
have enough DoFs to comply with all constraints.

The same approach can be used to control very complicated parallel mechanisms in FK or IK mode.
]]

if (sim_call_type==sim_childscriptcall_initialization) then
    ui=simGetUIHandle('UI')
    fkUi=simGetUIHandle('fkUi')
    ikGroup=simGetIkGroupHandle('ik')
    tipDummy=simGetObjectHandle('tip')
    motorJoint1=simGetObjectHandle('fk_motor1')
    motorJoint2=simGetObjectHandle('fk_motor2')

    -- First set the motor joint into ik mode:
    simSetJointMode(motorJoint1,sim_jointmode_ik,0)
    simSetJointMode(motorJoint2,sim_jointmode_ik,0)
    -- Make sure the IK element that brings the tip onto the target is disabled:
    simSetIkElementProperties(ikGroup,tipDummy,0)
    -- Now close the mechanism (if it was open):
    simHandleIkGroup(ikGroup)
    -- Read the current position of the motor joint:
    local angle=simGetJointPosition(motorJoint1)
    simSetUISlider(fkUi,1,1000*(angle*180/math.pi+160)/320)
    angle=simGetJointPosition(motorJoint2)
    simSetUISlider(fkUi,2,1000*(angle*180/math.pi+160)/320)
end


if (sim_call_type==sim_childscriptcall_actuation) then
    local a=simGetUIEventButton(ui)
    if a==1 then
        -- First set the motor joint into ik mode:
        simSetJointMode(motorJoint1,sim_jointmode_ik,0)
        simSetJointMode(motorJoint2,sim_jointmode_ik,0)
        -- Make sure the IK element that brings the tip onto the target is enabled:
        simSetIkElementProperties(ikGroup,tipDummy,sim_ik_x_constraint+sim_ik_y_constraint)
        -- Compute:
        simHandleIkGroup(ikGroup)
        -- Update the slider position:
        local angle=simGetJointPosition(motorJoint1)
        simSetUISlider(fkUi,1,1000*(angle*180/math.pi+160)/320)
        angle=simGetJointPosition(motorJoint2)
        simSetUISlider(fkUi,2,1000*(angle*180/math.pi+160)/320)
    end

    a=simGetUIEventButton(fkUi)
    if a>=1 then
        -- First set the motor joint into passive mode:
        simSetJointMode(motorJoint1,sim_jointmode_passive,0)
        simSetJointMode(motorJoint2,sim_jointmode_passive,0)
        -- Set the desired joint angle:
        local angle=math.pi*(-160+320*simGetUISlider(fkUi,1)/1000)/180
        simSetJointPosition(motorJoint1,angle)
        angle=math.pi*(-160+320*simGetUISlider(fkUi,2)/1000)/180
        simSetJointPosition(motorJoint2,angle)
        -- Make sure the IK element that brings the tip onto the target is disabled:
        simSetIkElementProperties(ikGroup,tipDummy,0)
        -- Compute:
        simHandleIkGroup(ikGroup)
    end
end



----------------------------------------------8-computingJointAnglesForRandomPoses--------------------------------------------------------------


