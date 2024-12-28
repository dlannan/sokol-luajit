-- This is a script to help build the data files needed for a project

local dirtools      = require("tools.vfs.dirtools")
local utils         = require("utils")
local json 			= require("lua.json")

local tinsert 		= table.insert

---------------------------------------------------------------------------------------

local data_helper = {

}

------------------------------------------------------------------------------------------------------------
-- Each world thats created we make a default proc to process for http server
local loadDefaultAssets = function(world)

	-- Always start with an empty asset pool when creating a new world.
	local assetpool = {}

	-- Add a default env (simple plane) 

	-- Add the default skydome (so there is a decent bg)

	-- Add some gizmos needed for editing and such (like xyz axis gizmo, bound cube gizmo etc)

end

------------------------------------------------------------------------------------------------------------
-- Each world thats created we make a default proc to process for http server
local loadDefaultScenes = function(world)

	return { { name = "Default", id = 0 } }
end

------------------------------------------------------------------------------------------------------------
-- Each world thats created we make a default proc to process for http server
local loadDefaultScripts = function(world)

	return { 
		{ name = "global", id = 0, script = "engine.script.global", ref = "Global" },
		{ name = "scene", id = 1, script = "engine.script.scene", ref = "Default" } 
	}
end


---------------------------------------------------------------------------------------

data_helper.make_worlds = function( datapath, worlds ) 
    local worlddata_path = dirtools.combine_path(datapath, "worlds")
    dirtools.make_folder(worlddata_path)

	local world_entries = {}
	for i,world in ipairs(worlds) do
		
		local data = world.data or {}
		-- These are asset groups for the world
		data.groups = { { id = 0, name = "default", tags = "default,all" } } 
		-- World assets. Some default assets are added automatically (mainly for editor)
		data.assets = loadDefaultAssets(data)
		data.scenes = loadDefaultScenes(data)
		data.entities = {}
		data.scripts = loadDefaultScripts(data)

		world.data = data

		-- save to data folder.
		local world_filename = dirtools.combine_path(worlddata_path, world.name..".json")
		local fh = io.open( world_filename, "w" )
		if(fh) then 
			fh:write( json.encode( data ) )
			fh:close()
			tinsert(world_entries, { name = world.name, filename = world_filename })
		end
	end
	return world_entries
end

---------------------------------------------------------------------------------------

data_helper.make_assets = function( datapath ) 
    local worlddata_path = dirtools.combine_path(datapath, "assets")
    dirtools.make_folder(worlddata_path)
end

---------------------------------------------------------------------------------------

return data_helper

---------------------------------------------------------------------------------------