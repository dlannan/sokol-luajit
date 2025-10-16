------------------------------------------------------------------------------------------------------------
-- State - Setup Game Assets
--
-- Decription: During initial loading setup the main assets needed

------------------------------------------------------------------------------------------------------------

local smgr 			= require("utils.statemanager")

local tinsert 		= table.insert

local tiny 			= require('libs.ecs.tiny-ecs')
local utils 		= require("utils.general")
local sapp      	= require("sokol_app")
local nk        	= sg

------------------------------------------------------------------------------------------------------------

local geom 			= require("libs.gltfloader.geometry-utils")
local imageutils 	= require("libs.gltfloader.image-utils")
local perlin 		= require("utils.perlin-noise")
local gltf 			= require("libs.gltfloader.gltfloader")

local wm 			= require("libs.ecs.world-manager")
	
------------------------------------------------------------------------------------------------------------

local Srunner   	= require("app.states.engineRunner")

local SEngineConfig	= smgr:NewState()

local ctx 			= nil

------------------------------------------------------------------------------------------------------------

SEngineConfig.cameras = {}
SEngineConfig.scenes = {}

--------------------------------------------------------------------------------
-- Must be global!!

-- Continually updates the cameras
function GprocessEntities(self, e, dt) 
	--print(e.name.. "   "..e.etype)
	if(e.etype == "camera") then 
		-- print("Camera: "..e.name.."   "..dt)
		SEngineConfig.cameras[e.name] = e 
	elseif(e.etype == "scene") then 
		-- print("Scene: "..e.name.."   "..dt)
		SEngineConfig.scenes[e.name] = e 
	end
end 


------------------------------------------------------------------------------------------------------------

function SEngineConfig:Init(wwidth, wheight)

	smgr:CreateState("SceneRunner", Srunner)
	smgr:AddSibling("SceneRunner", "SetupAssets")

	self.winx, self.winy = 100, 100
	self.win_width = sapp.sapp_widthf()
	self.win_height = sapp.sapp_heightf()
	self.winx = self.win_width - 300
	self.winy = 0
	self.winw = 300
	self.winh = self.win_height
		
	Srunner:Init(self.win_width, self.win_height)
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Resized(message)
	self.resized = message
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Begin()

	ctx			= mainState.ctx

	-- Second param regenerates meshes and go files
	mpool.init(100)

	-- Add an updater for cameras 
	wm:addSystem( "Entities", { "name", "etype" }, GprocessEntities )
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Update(mxi, myi, buttons)
	ctx = mainState.ctx
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Input(action_id, action)
	
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Message(sender, message_id, message)
	if(message_id == "window_resize") then 
		self.win_width = message[1]
		self.win_height = message[2]
		self.winx = self.win_width - 300
		self.winy = 0
		self.winw = 300
		self.winh = self.win_height
	end
end

------------------------------------------------------------------------------------------------------------

function SEngineConfig:Finish()
end
	
------------------------------------------------------------------------------------------------------------

return SEngineConfig

------------------------------------------------------------------------------------------------------------
