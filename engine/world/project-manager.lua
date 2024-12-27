
------------------------------------------------------------------------------------------------------------

local tinsert 	    = table.insert

local utils 	    = require('lua.utils')
local ffi 		    = require("ffi")

local dirtools      = require("tools.vfs.dirtools")
local cfgmgr        = require('engine.world.config-manager')

------------------------------------------------------------------------------------------------------------

local projectmanager = {
    recents     = {},
    sys         = {
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


return projectmanager

------------------------------------------------------------------------------------------------------------
