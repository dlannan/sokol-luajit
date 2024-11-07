-- rbuild config settings

local ffi       = require("ffi")

-- ------------------------------------------------------------------------------------------------------

local settings = {

    rbuilder = {
        appname         = "rbuild",
        version         = "00.01.snow",
    },

    platform = {
        target          = "Win64",
        srlua_path      = "../srlua/",      -- initially rbuild will run for the tools/build/rbuilder folder
        arch            = ffi.arch,
        os              = ffi.os,
    },

    project = {
        project_name    = "default",
        project_path    = "./",               -- Always starts empty. Will support a project file.
        project_file    = "default.slp"     -- Sokol luajit project file
    },

    graphics = {
        display_res     = "1024x768",
        display_width   = 1024,
        display_height  = 768,
        display_fps     = 60,
        antialias       = "fxaa",
    },

    audio = {
        master_volume   = 1.0,
        effects_volume  = 1.0,
        music_volume    = 1.0,
    },
    
    sokol = {
        sokol_path      = "../../../../",
        sokol_bin       = "bin/",
        sokol_ffi       = "ffi/",
        sokol_lua       = "lua/",
        sokol_examples  = "examples/",
    },

    remote = {
        -- These are futures -- 
        remote_build    = "https://mybuildserver.com/sokol_build",
        remote_data     = "https://myremotedata.com/data",
    },

    -- Assets will be populated by project file
    assets = {

    },
}

settings.rbuilder.title     = settings.rbuilder.appname.." ("..settings.rbuilder.version..")"

-- ------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------

return settings

-- ------------------------------------------------------------------------------------------------------