------------------------------------------------------------------------------------------------------------
-- State - Run the scene
--
-- Decription: 
--    Runs most of the scene.

local smgr 			= require("utils.statemanager")
local nk        	= sg
local hmm      		= require("hmm")

------------------------------------------------------------------------------------------------------------

-- These are child states that allow easier management of a simple controller
local SmenuMain   	= require("app.states.menus.sceneMenuMain")
local SenvHandler  	= require("app.states.world.envHandler")
local SAssetMenu 	= require("app.states.menus.sceneMenuAssets")

local tinsert 		= table.insert

local nkgui			= require("nuklear.gui")
local pngloader 	= require("nuklear.png-loader")
local themes 		= require("nuklear.themes")
local colors 		= themes.colors
local utils			= require("utils.utils")

local tf 			= require("utils.transforms")

local player 		= require("libs.camera.player")
local orbit 		= require("libs.camera.orbitGO")
local follow 		= require("libs.camera.follow")

local socket    	= require("socket.core")
local copas 		= require("copas")

------------------------------------------------------------------------------------------------------------

local SsceneRunner	= smgr:NewState()

local enums = {
	VIEW_ORBIT 		= 1,
	VIEW_FLY 		= 2,
}

------------------------------------------------------------------------------------------------------------

function SsceneRunner:Init(wwidth, wheight)

	SmenuMain:Init(wwidth, wheight)
	SenvHandler:Init(wwidth, wheight)
end

------------------------------------------------------------------------------------------------------------

function SsceneRunner:Begin()
	
	self.Sassets = smgr:GetState("SetupAssets")

	SmenuMain:Begin(self.Sassets)
	SenvHandler:Begin(self.Sassets)

	-- gltf:load("/assets/models/demo_grass01/demo_grass01.gltf", "/temp/temp006", "temp")
	-- go.set_rotation(vmath.quat_rotation_y(3.141 * 0.5), "/temp/temp006")
	-- 
	-- updatelights(Gmain)
end

------------------------------------------------------------------------------------------------------------

function SsceneRunner:Screenshot()
	self.do_screenshot = true
end 

------------------------------------------------------------------------------------------------------------

function SsceneRunner:TakeScreenshot()

	nkgui:update()
	nkgui:render()

	screenshot.png(function(png, image, w, h)
		local ss_id = os.date('%d_%m_%y %H_%M.png')
		local fh = io.open("data/screenshots/"..ss_id, "wb")
		if(fh) then 
			fh:write(image)
			fh:close()
		end
		self.do_screenshot = nil
	end)
	return 
end

------------------------------------------------------------------------------------------------------------

function SsceneRunner:Update(mxi, myi, buttons)

	--nkgui:update()
	
	if(self.do_screenshot) then 
		self:TakeScreenshot()
	end
	
	SmenuMain:Update(mxi, myi, buttons)
	SenvHandler:Update(mxi, myi, buttons)

	--nkgui:render()
	
	self.prevmxi = mxi
	self.prevmyi = myi
end

------------------------------------------------------------------------------------------------------------

function SsceneRunner:Input(action_id, action)

	-- if(action_id == hash("screenshot") and action.released) then 
	-- 	self:Screenshot()
	-- 	return true
	-- end
	
	SmenuMain:Input(action_id, action)
	SenvHandler:Input(action_id, action)
end

------------------------------------------------------------------------------------------------------------
-- On message send to the current state
function SsceneRunner:Message( owner, message_id, message, sender )

	local ctx = mainState.ctx
	if(message_id == "mouse_enter") then
		nk.nk_style_show_cursor(ctx)
	elseif(message_id == "mouse_leave") then
		nk.nk_style_hide_cursor(ctx)
	end

	SmenuMain:Message( owner, message_id, message, sender )
	SenvHandler:Message( owner, message_id, message, sender )
end
	
------------------------------------------------------------------------------------------------------------

function SsceneRunner:Finish()

	SmenuMain:Finish()
	SenvHandler:Finish()
end
	
------------------------------------------------------------------------------------------------------------

return SsceneRunner

------------------------------------------------------------------------------------------------------------
