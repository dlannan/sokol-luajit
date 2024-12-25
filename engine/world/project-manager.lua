
------------------------------------------------------------------------------------------------------------

local tinsert 	    = table.insert

local utils 	    = require('lua.utils')
local ffi 		    = require("ffi")

local dirtools      = require("tools.vfs.dirtools")

------------------------------------------------------------------------------------------------------------

local projectmanager = {
    recents     = {},
    sys         = {
        drives  = dirtools.get_drives(),
        folders = dirtools.get_folderslist("."),
        current_folder = dirtools.get_app_path(),
    },
}

------------------------------------------------------------------------------------------------------------

projectmanager.init = function(self)


end

------------------------------------------------------------------------------------------------------------


return projectmanager

------------------------------------------------------------------------------------------------------------
