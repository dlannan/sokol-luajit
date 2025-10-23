------------------------------------------------------------------------------------------------------------
-- Version format: <najor>.<minor>.<tag>  -- TODO: Possibly use git ?

local major         = "0"
local minor         = "001"
local tag           = "001"
------------------------------------------------------------------------------------------------------------

PROJECT_VERSION		= major.."."..minor.."."..tag
print("PROJECT_VERSION: "..PROJECT_VERSION)

------------------------------------------------------------------------------------------------------------

local sapp      	= require("sokol_app")
local tinsert       = table.insert

------------------------------------------------------------------------------------------------------------
-- Global because states need to use it themselves

local defaults = {
    move = { x=0, y=0 }, 
    buttons = { 
        [1] = { pressed = false, released = false },    -- left mouse button
        [2] = { pressed = false, released = false },    -- middle mouse button
        [3] = { pressed = false, released = false },    -- right mouse button
    } 
}

-- This is global - dont freak out. All variables are technically global :) (Live under _G)
engineState               = {}
engineState.queued        = {}
engineState.events        = defaults
engineState.sm            = require("engine.utils.statemanager")

------------------------------------------------------------------------------------------------------------
-- Require all the states we will use for the game

local mainState           = require("engine.app.state_main")
local SengineRunner       = require("engine.app.states.engineRunner")

------------------------------------------------------------------------------------------------------------
-- Queue a state for execution from beginning

engineState.queue = function( name, state, startup )

    if(name == nil or state == nil) then return end 
    tinsert(engineState.queued, { name = name, state = state, startup = startup } )
end

------------------------------------------------------------------------------------------------------------
-- Register every state with the statemanager.

engineState.init = function( w, h )

    engineState.sm:Init()
    engineState.sm:CreateState("EngineRunner", 	    SengineRunner)
    engineState.sm:CreateState("MainState", 	    mainState)

    engineState.sm:AddSibling("MainState", "EngineRunner")

    -- Add any queued states
    local startup = nil 
    for i, v in ipairs(engineState.queued) do 
        engineState.sm:CreateState(v.name, v.state)
        if(v.startup) then startup = v.name end 

        v.state:Init(w, h)
    end 

    -- Init some modules ready for kick off.
    mainState:Init(w, h)
    SengineRunner:Init(w, h)

    -- This kicks things off!
    engineState.sm:ChangeState("EngineRunner")

    if(startup) then
        engineState.sm:AddSibling(startup, "EngineRunner")
    end
end 

------------------------------------------------------------------------------------------------------------
-- Assess input info
engineState.input = function(action_id, action)

    local events = engineState.events
    events.move.x = action.x
    events.move.y = action.y

    -- if action_id == hash("button_left") then
    --     events.buttons[1].pressed = action.pressed 
    --     if(action.pressed == true) then events.buttons[1].down = true end
    --     events.buttons[1].released = action.released 
    --     if(action.released == true) then events.buttons[1].down = false end        
    -- end
    -- if action_id == hash("button_right") then
    --     events.buttons[3].pressed = action.pressed 
    --     if(action.pressed == true) then events.buttons[3].down = true end
    --     events.buttons[3].released = action.released 
    --     if(action.released == true) then events.buttons[3].down = false end
    -- end
    -- if action_id == hash("button_middle") then
    --     events.buttons[2].pressed = action.pressed 
    --     if(action.pressed == true) then events.buttons[2].down = true end
    --     events.buttons[2].released = action.released    
    --     if(action.released == true) then events.buttons[2].down = false end     
    -- end 
    engineState.sm:Input(action_id, action)
end

------------------------------------------------------------------------------------------------------------
-- Enter state manager loop
engineState.update = function(delta)

    local events = engineState.events
    
    if( engineState.sm:Run() ) then 
        engineState.sm.dt = delta
        engineState.sm:Update(events.move.x, events.move.y, events.buttons)
        engineState.sm:Render()
    else 
        -- exit here.
    end 
end

------------------------------------------------------------------------------------------------------------
-- Assess message queue
engineState.message = function( owner, message_id, message, sender )

    engineState.sm:Message( owner, message_id, message, sender )
end

------------------------------------------------------------------------------------------------------------

engineState.finish = function( )
    engineState.sm:ExitState()  -- Main Menu
end

------------------------------------------------------------------------------------------------------------

return engineState