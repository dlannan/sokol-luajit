local tinsert 	= table.insert
local utils 	= require("lua.utils")
local hmm       = require("hmm")
local ffi 		= require("ffi")

local geom 		= require("lua.gltfloader.geometry-utils")

-- --------------------------------------------------------------------------------------------------------
-- Internal storage for a mesh gameobject
--
--  Note: components allowed are currently 16. I think if you are adding more than that, then you 
--        have a poor design. This needs to be simple and clean. I may reduce to 12 or less.
ffi.cdef[[

enum {
	COMPONENTS_MAX 		= 10
};

typedef struct gameobject {
	unsigned int 	id; 
	const char *	name;
	hmm_vec3 		pos;
	hmm_quaternion	rot;
	hmm_vec3		scale;

	unsigned int 	components[COMPONENTS_MAX];
	unsigned int 	sibling;
	unsigned int	parent;
} gameobject;
]]

-- --------------------------------------------------------------------------------------------------------

local GAMEOBJECTS_MAX	= 1000		-- Conservative alloc. This will be about 96K mem wise.
local GAMEOBJECTS_REALLOC_THRESHOLD 	= 0.9	-- 90% hit, then realloc

-- --------------------------------------------------------------------------------------------------------

local gameobject = {

	-- All gameobjects are stored in a memory block. 
	all_gameobjects = ffi.new("gameobject[?]", GAMEOBJECTS_MAX),
	-- This count is important - if it reached 90% it does a realloc and doubles and copies gameobjects
	alloc_count 	= GAMEOBJECTS_MAX,
	count 			= 0, 

	lookup_ids		= {},
	lookup_names	= {},	-- Note name lookup can be messy. Esp if duplicate names are used
}

-- --------------------------------------------------------------------------------------------------------
-- Clears the gameobject array
--   We dont reset the alloc_count, incase the user wants to refill. Faster to leave it. 
gameobject.reset = function( )

	gameobject.count = 0 
	gameobject.all_gameobjects = ffi.new("gameobject[?]", gameobject.alloc_count)
	gameobject.lookup_ids		= {}
	gameobject.lookup_names		= {}

end

-- --------------------------------------------------------------------------------------------------------

gameobject.check = function( )

	if(gameobject.count / gameobject.alloc_count > GAMEOBJECTS_REALLOC_THRESHOLD) then 

		gameobject.alloc_count = gameobject.alloc_count * 2
		local newobjects = ffi.new("gameobject[?]", gameobject.alloc_count)
		ffi.copy(newobjects, gameobject.all_gameobjects, gameobject.count * ffi.sizeof("gameobject"))
		gameobject.all_gameobjects = newobjects
	end
end

-- --------------------------------------------------------------------------------------------------------

gameobject.create = function( id, name, pos, rot, scale, parent )

	-- Sometimes the original gameobject name is used
	if(type(name)=="cdata") then name = ffi.string(name) end 

	pos = pos or hmm.HMM_Vec3(0, -999999, 0)
	rot = rot or hmm.HMM_Quaternion(0, 0, 0, 0)
	local scale = hmm.HMM_Vec3(0, 0, 0)

	gameobject.check()
	local gobj_index = gameobject.count 
	local gobj = ffi.cast("gameobject *", gameobject.all_gameobjects + gameobject.count)

	gobj.id 	= id or gobj_index
	gobj.name 	= ffi.string(name or "dummy")
	gobj.pos 	= pos 
	gobj.rot 	= rot 
	gobj.scale 	= scale 
	gobj.parent = parent or 0		-- Must be an index!!!

	-- Reverse lookups - will be useful if needed. May add spatial as well.
	gameobject.lookup_ids[gobj.id]		= gobj_index
	gameobject.lookup_names[gobj.name]	= gobj_index
	gameobject.count = gameobject.count + 1
	return gobj_index
end 

-- --------------------------------------------------------------------------------------------------------

gameobject.get_go = function( id )
	assert(id < gameobject.count and id >= 0)
	return gameobject.all_gameobjects[id]
end

-- --------------------------------------------------------------------------------------------------------

gameobject.goname = function( id )
	assert(id < gameobject.count and id >= 0)
	return ffi.string(gameobject.all_gameobjects[id].name)
end

-- --------------------------------------------------------------------------------------------------------

gameobject.set_position = function( id, pos )
	assert(id < gameobject.count and id >= 0)
	gameobject.all_gameobjects[id].pos = pos
end

-- --------------------------------------------------------------------------------------------------------

gameobject.set_rotation = function( id, rot )
	assert(id < gameobject.count and id >= 0)
	gameobject.all_gameobjects[id].rot = rot
end

-- --------------------------------------------------------------------------------------------------------

gameobject.set_scale = function( id, scale )
	assert(id < gameobject.count and id >= 0)
	gameobject.all_gameobjects[id].scale = scale
end

-- --------------------------------------------------------------------------------------------------------

gameobject.set_parent = function( id, parent )
	assert(id < gameobject.count and id >= 0)
	assert(parent < gameobject.count and parent >= 0)
	gameobject.all_gameobjects[id].parent = parent
end

-- --------------------------------------------------------------------------------------------------------

gameobject.get_mesh = function(id)
	assert(id < gameobject.count and id >= 0)
	local go = gameobject.all_gameobjects[id]
	return geom:GetMesh(ffi.string(go.name))
end 

-- --------------------------------------------------------------------------------------------------------

return gameobject 

-- --------------------------------------------------------------------------------------------------------
