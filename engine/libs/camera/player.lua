
-- A camera controller so I can pan and move around the scene. 
-- Enable/Disable using keys
--------------------------------------------------------------------------------

local tf 		= require("engine.utils.transforms")
local Vec3 		= {}

local hmm       = require("hmm")

-- Soft start and stop - all movements should be softened to make a nice movement
--   experience. Camera motion should also be dampened.

local move_dampen 	= 0.89
local look_dampen 	= 0.89

local cameraplayer = {}

--------------------------------------------------------------------------------

local function newcamera()
	
	local cameraplayer = {

		playerheight 	= 1.3, 
		cameraheight 	= 2.0,

		-- Where the look focus is in the distance
		lookdistance 	= 4.0,

		looklimityaw 	= math.pi * 0.5,
		looklimitpitch 	= math.pi * 0.5,

		lookvec 		= hmm.HMM_Vec3(0,0,0),
		pos				= hmm.HMM_Vec3(0,0,0),
		movevec 		= hmm.HMM_Vec3(0,0,0),

		xangle 			= 0.0,
		yangle			= 0.0,
	}
	return cameraplayer
end 

--------------------------------------------------------------------------------
-- A simple handler, can be easily replaced
local function defaulthandler( self, delta )

	-- local pitch		= -cameraplayer.xangle
	-- local yaw		= cameraplayer.yangle

	-- if (yaw > math.pi) then yaw = -math.pi; cameraplayer.yangle = -math.pi end 
	-- if (yaw < -math.pi) then yaw = math.pi; cameraplayer.yangle = math.pi end 
	-- if (pitch > math.pi * 0.5) then pitch = math.pi * 0.5; cameraplayer.xangle = math.pi * 0.5 end 
	-- if (pitch < -math.pi * 0.5) then pitch = -math.pi * 0.5; cameraplayer.xangle = -math.pi * 0.5 end 

	local ospos = go.get_position(self.target)
	local osrot = go.get_rotation(self.target)

	self.tpos 		 = hmm.HMM_Vec3(ospos.x, ospos.y, ospos.z)
	self.trot 		 = osrot
	self.teuler		 = tf.ToEulerAngles(self.trot)
	
	--local mdir = self.target.mover.globalizeDirection( Vec3Set(0.02, 1, self.distance) )
	local mdir 	 	 = vmath.rotate(self.trot,  hmm.HMM_Vec3(0.02, 1, self.distance))
	local campos 	 = hmm.HMM_Vec3(mdir.x, mdir.y, mdir.z)

	self.pos = self.tpos + campos
	self.rot = self.trot

	go.set_rotation( self.rot, self.cameraobj )	
	go.set_position( self.pos, self.cameraobj )
	self.prevpos = self.tpos
end

--------------------------------------------------------------------------------

cameraplayer.init = function( cameraobj, target, distance, handler )

	local newcam = newcamera()
	newcam.cameraobj = cameraobj 
	newcam.target = target

	newcam.tpos = hmm.HMM_Vec3(0,0,0)
	newcam.trot = hmm.HMM_Vec3(0,0,0)

	newcam.distance 	= distance
	newcam.smooth 		= 0.98
	newcam.speed 		= 1.0
	newcam.flat 		= true 		-- define if the camera rolls
	newcam.sloppiness 	= 1.4

	-- newcam.pos = go.get_position(cameraobj)
	-- newcam.rot = go.get_rotation(cameraobj)

	local tvec = hmm.HMM_Vec3(0,0,0) --go.get_position(newcam.target)
	newcam.prevpos = hmm.HMM_Vec3(tvec.X, tvec.Y, tvec.Z)

	newcam.enabled = true 		-- enabled by default
	newcam.handler = handler or defaulthandler

	newcam.update = function( self, delta )

		if(newcam.enabled ~= true) then return end
		if(newcam.handler) then newcam.handler( newcam, delta ) end
	end
	return newcam
end 


--------------------------------------------------------------------------------

return cameraplayer

--------------------------------------------------------------------------------