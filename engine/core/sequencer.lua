-- The sequencer is a way to sequence functions or states without needing to 
--   manage the threading, and operation of the sequence. 
-- For example: 
--   Need: You need an init to happen, then a load and then a lobby or menu to start in order.
--         You want the graphics frame update to be continuous (no locking) and the ability to inject
--         the rendering for the state currently active.
--   Sequencer:
--         Append your states in-order into a table and call the sqeuncer with that table.

local tinsert   = table.insert 
local tremove   = table.remove

local statemgr  = require("lua.engine.statemanager")

-- Sequencer itself is a state
local Sequencer = statemgr:NewState()

-- --------------------------------------------------------------------------------------

Sequencer.Begin   = function( self, seqtbl )

    statemgr:Init() 
    local base_name = "Sequencer_"
    Sequencer.list = {}

    for idx, state in ipairs(seqtbl) do 

        local newState = statemgr:NewState()
        -- Collect just the methods in each state's table. If there is an update or a render then assign it to the methods
        for name, value in pairs(state) do 
        
            if(name:lower() == "begin") then newState.Begin = value 
            elseif(name:lower() == "init") then newState.Init = value 
            elseif(name:lower() == "input") then newState.Input = value 
            elseif(name:lower() == "update") then newState.Update = value 
            elseif(name:lower() == "render") then newState.Render = value 
            elseif(name:lower() == "finish") then newState.Finish = value 
            else 
                -- States may have their own methods and props - keep them!
                newState[name] = value
            end
        end
        if(newState.Init) then newState:Init() end 
        
        local statename = string.format("%s%d", base_name, idx)
        tinsert(Sequencer.list, statename)
        statemgr:CreateState(statename, newState)
    end 

    -- Kick off Sequencer with a ChangeState!
    if(#Sequencer.list > 0) then 
        statemgr:ChangeState( tremove(Sequencer.list, 1) )
    end
end

-- --------------------------------------------------------------------------------------

Sequencer.Input         = function( self, owner, action_id, action )
    statemgr:Input(owner, action_id, action)
end

-- --------------------------------------------------------------------------------------

Sequencer.Update        = function(self, px, py, buttons)

    statemgr:Update(px, py, buttons)
end 

-- --------------------------------------------------------------------------------------

Sequencer.Render        = function(self, w, h)
    statemgr:Render(w, h)
end

-- --------------------------------------------------------------------------------------

Sequencer.Finish        = function(self)
    statemgr:ExitState()
end

-- --------------------------------------------------------------------------------------

Sequencer.NextState        = function(self)
    -- When a state has completed then jump to the next!
    if(#Sequencer.list > 0) then 
        statemgr:ChangeState( tremove(Sequencer.list, 1) )
    end
end


-- --------------------------------------------------------------------------------------

return Sequencer

-- --------------------------------------------------------------------------------------
