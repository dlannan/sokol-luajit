------------------------------------------------------------------------------------------------------------
-- State - Run the scene
--
-- Decription: 
--    Runs most of the scene.

local smgr 			= require("engine.utils.statemanager")
local sapp      	= require("sokol_app")
local nk        	= sg
local hmm      		= require("hmm")

-- --------------------------------------------------------------------------------------
-- Tiny ECS will be our core object manager. 
--    Rendering, physics collision and more will be components to this system
--    Rendering specifically will be built with a ldb that will run all the culling, sorting
--      and binning needed. This will be decoupled from the editor itself. 
local tiny          = require('engine.world.world-manager')

------------------------------------------------------------------------------------------------------------
-- These are child states that allow easier management of a simple controller
-- local Splayer   	= require("engine.states.characterControl")
-- local SgeomModels 	= require("engine.states.geometry.models")

local utils			= require("lua.utils")
local tf 			= require("engine.utils.transforms")

-- local player 		= require("libs.camera.player")
-- local orbit 		= require("libs.camera.orbitGO")
-- local follow 		= require("libs.camera.follow")

local tinsert 		= table.insert

------------------------------------------------------------------------------------------------------------

local SengineRunner	= smgr:NewState()

local enums = {
	VIEW_ORBIT 		= 1,
	VIEW_FLY 		= 2,
}

------------------------------------------------------------------------------------------------------------

function SengineRunner:Init(wwidth, wheight)

	self.wwidth = wwidth 
	self.wheight = wheight
	tiny:init({noserver = true})

	-- SgeomModels:Init(wwidth, wheight)
end

-- --------------------------------------------------------------------------------------

local ctr = 0
local accum = 0

local function checkperf(dt)
    ctr = ctr + 1
    if(ctr % 60 == 1) then 
        tiny.fps = (accum / 60)
        accum = 0
    end
    accum = accum + dt
end

------------------------------------------------------------------------------------------------------------

local characterCameraHandler = function( self, delta )

	local pitch		= -self.xangle
	local yaw		= self.yangle

	xzLen = math.cos(yaw)
	self.lookvec.Z = -xzLen * math.cos(pitch)
	self.lookvec.Y = math.sin(yaw)
	self.lookvec.X = xzLen * math.sin(-pitch)

	if(math.abs(self.speed) > 0.0) then 
		self.pos = hmm.HMM_Lerp( smgr.dt, self.pos, self.pos + self.lookvec * self.speed )
	end

	local xrot = hmm.HMM_QuaternionFromAxisAngle(hmm.HMM_Vec3(1, 0, 0), pitch)
	local yrot = hmm.HMM_QuaternionFromAxisAngle(hmm.HMM_Vec3(0, 1, 0),yaw)
	self.rot = hmm.HMM_MultiplyQuaternion(xrot, yrot)

	-- go.set_rotation( self.rot, self.cameraobj )		
	-- go.set_position( self.pos, self.cameraobj )
end

------------------------------------------------------------------------------------------------------------

local function cameraSet( self )

	local cam_name = self.cam_names[self.cam_select]
	self.cam = self.cams[cam_name]
end

------------------------------------------------------------------------------------------------------------

function SengineRunner:Begin()

	self.maincamera_url = "/maincamera"
	self.camera_url = "/camera#camera"

	-- Splayer:Begin()

	self.target  = "/camtarget"
	-- self.pos = go.get_position(self.maincamera_url)

	self.cams = { 
		player 	= {}, --player.init(self.maincamera_url, self.target, 20.0, characterCameraHandler ),
		orbit 	= {}, --orbit.init(self.maincamera_url, self.target, 30.0 ),
		follow	= {}, --follow.init(self.maincamera_url, self.target, 30.0 ),
	}
	self.cam_names =  { "player", "orbit", "follow" }
	self.cam_select = 1
	cameraSet(self)

	self.cam.speed = 0.0
	
	-- gltf:load("/assets/models/demo_grass01/demo_grass01.gltf", "/temp/temp006", "temp")
	-- go.set_rotation(vmath.quat_rotation_y(3.141 * 0.5), "/temp/temp006")
	-- 
	-- updatelights(Gmain)
	self.prevmxi 		= 0
	self.prevmyi 		= 0
	self.move 			= 0
	self.move_speed 	= 5.0
	self.mode 			= enums.VIEW_FLY

	-- SgeomModels:Begin()
end

------------------------------------------------------------------------------------------------------------

function SengineRunner:Screenshot()
	self.do_screenshot = true
end 

------------------------------------------------------------------------------------------------------------

function SengineRunner:TakeScreenshot()

	-- screenshot.png(function(png, image, w, h)
	-- 	local ss_id = os.date('%d_%m_%y %H_%M.png')
	-- 	local fh = io.open("data/screenshots/"..ss_id, "wb")
	-- 	if(fh) then 
	-- 		fh:write(image)
	-- 		fh:close()
	-- 	end
	-- 	self.do_screenshot = nil
	-- end)
end

------------------------------------------------------------------------------------------------------------

function SengineRunner:Update(mxi, myi, buttons)

	local dt = engineState.sm.dt
	--nkgui:update()
	
	if(self.do_screenshot) then 
		self:TakeScreenshot()
	end
	
	local sec = os.clock()
	local hr = tonumber(os.date("%H")) / 24
	local min = tonumber(os.date("%M")) / 60
	local datetime = os.date("%X %p")
	

    checkperf(sapp.sapp_frame_duration())
    tiny:update(sapp.sapp_frame_duration())

	--self.cam.speed = 0.0
	if(buttons[3].down == true) then 

		if( self.mode == enums.VIEW_FLY) then
			if(self.prevmxi ~= mxi) then 
				self.cam.xangle = hmm.HMM_Lerp(smgr.dt * 0.2, self.cam.xangle, self.cam.xangle + (mxi - self.prevmxi))
			end
			
			if(self.prevmyi ~= myi) then 
				self.cam.yangle = hmm.HMM_Lerp(smgr.dt * 0.2, self.cam.yangle, self.cam.yangle + (myi - self.prevmyi))
			end
					
			if(self.move == 1) then 
				self.cam.speed = self.move_speed
			end 
			if(self.move == -1) then 
				self.cam.speed = -self.move_speed
			end 

			-- Need to add some extra code for handling strafing in fly mode.
			-- if(self.move == -2) then 
			-- end 
			-- if(self.move == 2) then 
			-- end 	
			
		elseif (self.mode == enums.VIEW_ORBIT) then 

			local obj = SAssetMenu.current_go
			if(self.cam.target ~= obj and obj) then 
				self.cam.target = obj
			end
			
			if(self.prevmxi ~= mxi) then 
				self.cam.yangle = hmm.HMM_Lerp( smgr.dt * 0.2, self.cam.yangle, self.cam.yangle + (mxi - self.prevmxi))
			end

			if(self.prevmyi ~= myi) then 
				self.cam.xangle = hmm.HMM_Lerp( smgr.dt * 0.2, self.cam.xangle, self.cam.xangle + (myi - self.prevmyi))
			end
			
		end
	end

	self.move = 0
	
	-- Splayer:Update(mxi, myi, buttons)
	-- SgeomModels:Update(mxi, myi, buttons)

	-- self.cam.update(self, dt )
	self.prevmxi = mxi
	self.prevmyi = myi
end

------------------------------------------------------------------------------------------------------------

function SengineRunner:Render(dt)

	-- Splayer:Render(dt)
	-- SgeomModels:Render(dt)
end

------------------------------------------------------------------------------------------------------------

function SengineRunner:Input(action_id, action)

	-- if(action_id == hash("screenshot") and action.released) then 
	-- 	self:Screenshot()
	-- 	return true
	-- end

	-- if(action_id == hash("orbit") and action.released) then 
	-- 	if(self.mode == enums.VIEW_FLY) then 
	-- 		local obj = SAssetMenu.current_go
	-- 		if(obj) then 
	-- 			self.mode = enums.VIEW_ORBIT 
	-- 			self.cam_select = 2
	-- 			cameraSet(self)
	-- 			-- set starting distance to match current distance
	-- 			self.cam.distance = hmm.HMM_LengthVec3( go.get_position(obj) - go.get_position(self.maincamera_url) )
	-- 			self.cam.target = obj
	-- 		end
	-- 	else 
	-- 		self.mode = enums.VIEW_FLY
	-- 		self.cam_select = 1
	-- 		cameraSet(self)
	-- 	end
	-- end

	-- if(action_id == hash("forward")) then 
	-- 	self.move = 1
	-- end
	-- if(action_id == hash("back")) then 
	-- 	self.move = -1
	-- end
	-- if(action_id == hash("left")) then 
	-- 	self.move = -2
	-- end
	-- if(action_id == hash("right")) then 
	-- 	self.move = 2
	-- end	

	-- if(action_id == hash("shift_down") and action.pressed) then 
	-- 	self.move_speed	= 20.0 
	-- end 
	-- if(action_id == hash("shift_down") and action.released) then 
	-- 	self.move_speed	= 5.0 
	-- end
	
	-- Splayer:Input(action_id, action)
	-- SgeomModels:Input(action_id, action)
end

------------------------------------------------------------------------------------------------------------
-- On message send to the current state
function SengineRunner:Message( owner, message_id, message, sender )

	local ctx = mainState.ctx
	if(message_id == "window_resize") then 
		self.wwidth     = message[1]
		self.wheight    = message[2]
	elseif(message_id == "mouse_enter") then
		nk.nk_style_show_cursor(ctx)
	elseif(message_id == "mouse_leave") then
		nk.nk_style_hide_cursor(ctx)
	end

	-- Splayer:Message( owner, message_id, message, sender )
	-- SgeomModels:Message( owner, message_id, message, sender )
end
	
------------------------------------------------------------------------------------------------------------

function SengineRunner:Finish()

	-- Splayer:Finish()
	-- SgeomModels:Finish()

	tiny:final()
end
	
------------------------------------------------------------------------------------------------------------

return SengineRunner

------------------------------------------------------------------------------------------------------------
