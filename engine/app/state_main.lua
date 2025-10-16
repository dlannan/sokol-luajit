local sapp              = require("sokol_app")
local nk                = sg
local slib              = require("sokol_libs") -- Warn - always after gfx!!
local ffi               = require("ffi")

local smgr 			    = require("engine.utils.statemanager")

-- local bins 			    = require("engine.states.geometry.bins")

------------------------------------------------------------------------------------------------------------
-- Global because states need to use it themselves

mainState	            = smgr:NewState()
mainState.sm            = smgr

------------------------------------------------------------------------------------------------------------
-- Require all the states we will use for the game

-- local SmainMenu         = require("app.states.menus.sceneMenuMain")
-- local Sassets           = require("app.states.setupAssets")
-- local SsceneRunner      = require("app.states.sceneRunner")

------------------------------------------------------------------------------------------------------------
-- Register every state with the statemanager.

function mainState:Init(wwidth, wheight)

    -- mainState.sm:CreateState("MainMenu",		SmainMenu)
    -- mainState.sm:CreateState("SetupAssets", 	Sassets)
    -- mainState.sm:CreateState("SceneRunner", 	SsceneRunner)

	-- mainState.sm:AddSibling("SceneRunner", "SetupAssets")
    mainState.width     = wwidth 
    mainState.height    = wheight

    -- Sassets:Init(wwidth, wheight)
end 

------------------------------------------------------------------------------------------------------------

local function RenderNuklear(width, height)
    nk.snk_render(width, height)
end

------------------------------------------------------------------------------------------------------------

function mainState:Begin()
    Sassets:Begin()
    -- bins.bin_add_func(bins.BTYPE_OPAQUE, RenderNuklear)
end

------------------------------------------------------------------------------------------------------------
-- Assess input info
function mainState:Input(event, action)

    if(event.type == sapp.SAPP_EVENTTYPE_RESIZED) then 
        nk.snk_handle_event(event)
        mainState.sm:Message( nil, "window_resize", {event.window_width, event.window_height}, nil )
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_ENTER) then 
        sapp.sapp_show_mouse(false)
        mainState.sm:Message(mainState, "mouse_enter", {}, nil)
    elseif(event.type == sapp.SAPP_EVENTTYPE_MOUSE_LEAVE) then 
        sapp.sapp_show_mouse(true)
        mainState.sm:Message(mainState, "mouse_leave", {}, nil)
    else 
        nk.snk_handle_event(event)
    end
    
    -- Sassets:Input(event, action)
end

------------------------------------------------------------------------------------------------------------
-- Enter state manager loop
function mainState:Update(mxi, myi, buttons)

    -- Sassets:Update(mxi, myi, buttons)
end 

------------------------------------------------------------------------------------------------------------

function mainState:Render(dt)

    -- Sassets:Render(dt)
end


------------------------------------------------------------------------------------------------------------
-- Assess message queue
function mainState:Message( owner, message_id, message, sender )

	if(message_id == "window_resize") then 
		mainState.width     = message[1]
		mainState.height    = message[2]
	end	    
    -- Sassets:Message(owner, message_id, message, sender)
end

------------------------------------------------------------------------------------------------------------

function mainState:Finish( )
    -- Sassets:Finish()
end

------------------------------------------------------------------------------------------------------------

return mainState