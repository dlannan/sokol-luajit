
------------------------------------------------------------------------------------------------------------

local tinsert 	    = table.insert

local utils 	    = require('lua.utils')
local json          = require('lua.json')
local ffi 		    = require("ffi")

local dirtools      = require("tools.vfs.dirtools")
local cfgmgr        = require('editor.config-manager')
local datahlp       = require('editor.config.data-helper')
local tiny          = require('engine.world.world-manager')

------------------------------------------------------------------------------------------------------------

local projectmanager = {
    current_project     = {},
    recents             = {},

    sys                 = {
        has_create      = 1,

        drives          = dirtools.get_drives(),
        folders         = dirtools.get_folderslist("."),
        current_folder  = dirtools.get_app_path(),
    },
}

------------------------------------------------------------------------------------------------------------

projectmanager.init = function(self)

    cfgmgr.load()
    self.recents = cfgmgr.recents
end

------------------------------------------------------------------------------------------------------------

projectmanager.create = function(self, project)

    -- Check the path is valid first 
    if(project) then 
        if(project.path and dirtools.is_folder(project.path)) then 

            tiny.default = tiny.default or tiny.addWorld(tiny, "MasterWorld")

            local clean_name = utils.cleanstring(project.name)
            local project_path = dirtools.combine_path(project.path, clean_name)
            if(dirtools.make_folder(project_path)) then 

                local assets_path = dirtools.combine_path(project_path, "assets")
                dirtools.make_folder(assets_path)
                local config_path = dirtools.combine_path(project_path, "config")
                dirtools.make_folder(config_path)
                local build_path = dirtools.combine_path(project_path, "build")
                dirtools.make_folder(build_path)
                local cache_path = dirtools.combine_path(project_path, "cache")
                dirtools.make_folder(cache_path)
                local data_path = dirtools.combine_path(project_path, "data")
                dirtools.make_folder(data_path)

                -- Iterate default worlds and create datasets (assets, scripts etc) for them
                local world_entries = datahlp.make_worlds(data_path, tiny.worlds)

                local project_filename = dirtools.combine_path(project_path, "project.slp")
                self.current_project = {
                    filename    = project_filename,
                    name        = clean_name,
                    paths       = {
                        project     = project_path,
                        assets      = assets_path,
                        config      = config_path,
                        build       = build_path,
                        cache       = cache_path,
                        data        = data_path,
                        worlds      = world_entries,
                    },
                }

                local fh = io.open(project_filename, "w")
                if(fh) then 
                    fh:write( json.encode(self.current_project) )
                    fh:close()
                end
            else 

            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

projectmanager.load = function(self, project)

    -- Check the path is valid first 
    if(project) then 
        if(project.path and dirtools.is_folder(project.path)) then 

            project_filename = dirtools.combine_path(project.path, project.projectfile)
            local fh = io.open(project_filename, "r")
            if(fh) then 
                local data = fh:read( "*a" )
                self.current_project = json.decode(data)
                fh:close()
            end

            -- Load worlds 
            -- Clear worlds first!! 
            tiny.worlds = {}
            for i,world_obj in ipairs(self.current_project.paths.worlds) do
                local fh = io.open( world_obj.filename, "r")
                if(fh) then 
                    local data = fh:read("*a")
                    fh:close()
                    tiny.addWorld(tiny, world_obj.name)
                    tiny.current_world.data = json.decode(data)
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------
-- Consider making this a timed autosaver. Will see.
projectmanager.save = function(self, project)

end

------------------------------------------------------------------------------------------------------------


return projectmanager

------------------------------------------------------------------------------------------------------------
