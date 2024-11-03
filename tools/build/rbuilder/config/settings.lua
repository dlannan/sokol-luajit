-- rbuild config settings

local ffi       = require("ffi")

-- ------------------------------------------------------------------------------------------------------

local settings = {

    appname         = "rbuild",
    version         = "00.01.snow",

    srlua_path      = "../srlua/",      -- initially rbuild will run for the tools/build/rbuilder folder
    arch            = ffi.arch,
    os              = ffi.os,

    project_name    = "default",
    project_path    = "",               -- Always starts empty. Will support a project file.
    
    sokol_path      = "../../../../bin/",
    sokol_bin       = "bin/",
    sokol_ffi       = "ffi/",
    sokol_lua       = "lua/",
    sokol_examples  = "examples/",

    -- These are futures -- 
    remote_build    = "https://mybuildserver.com/sokol_build",
    remote_data     = "https://myremotedata.com/data",
}

settings.title     = settings.appname.." ("..settings.version..")"

-- ------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------

return settings

-- ------------------------------------------------------------------------------------------------------