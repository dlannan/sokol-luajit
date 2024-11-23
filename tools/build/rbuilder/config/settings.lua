-- rbuild config settings

local ffi       = require("ffi")
local json      = require("lua.json")
local logging   = require("utils.logging")

-- ------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------
-- The main module table
local settings = {

    recents = {},
}

-- Default settings if none are loaded or found
local platforms = { "Win64", "MacOS", "Linux", "IOS64" }
local resolutions = { "1920x1080", "1680x1050", "1600x900", "1440x900", "1376x768" }
local arch = { "x86", "x64", "arm", "arm64", "arm64be", "ppc", "mips", "mipsel", "mips64", "mips64el", "mips64r6", "mips64r6el" }
local oss = { "Windows", "Linux", "OSX", "BSD", "POSIX", "Other" }

local default_settings = {

    rbuilder = {
        appname         = { index = 1, value = "rbuild", slen = 7 },
        version         = { index = 2, value = "00.01.snow", slen = 32 },
    },

    platform = {
        target          = { index = 1, value = 1, ptype = "combo", plist = platforms },
        srlua_path      = { index = 2, value = "../srlua/", ptype = "path", slen = 256 },     -- initially rbuild will run for the tools/build/rbuilder folder
        arch            = { index = 3, value = 2, ptype = "combo", plist = arch },
        os              = { index = 4, value = 1, ptype = "combo", plist = oss },
    },

    project = {
        project_name    = { index = 1, value = "default", ptype = "string", slen = 64 },
        build_path      = { index = 2, value = "<change me>", ptype = "path", slen = 256 },               -- Always starts empty. Will support a project file.
        project_start   = { index = 3, value = "example1.lua", ptype = "file", pfilter = "*.lua", slen = 128 },
    },

    graphics = {
        display_res     = { index = 1, value = 1, ptype = "combo", plist = resolutions },
        display_width   = { index = 2, value = 1024, vmin = 640, vmax = 8192, vstep = 32, vinc = 0.1, ptype = "int" },
        display_height  = { index = 3, value = 768, vmin = 480, vmax = 8192, vstep = 32, vinc = 0.1, ptype = "int" },
        display_fps     = { index = 4, value = 60, vmin = 25, vmax = 200, vstep = 5, vinc = 0.1, ptype = "int" },
        antialias       = { index = 5, value = "fxaa", slen = 16 },
    },

    audio = {
        master_volume   = { index = 1, value = 1.0, vmin = 0.0, vmax = 1.0, vstep = 0.02, vinc = 0.1, ptype = "float" },
        effects_volume  = { index = 2, value = 1.0, vmin = 0.0, vmax = 1.0, vstep = 0.02, vinc = 0.1, ptype = "float" },
        music_volume    = { index = 3, value = 1.0, vmin = 0.0, vmax = 1.0, vstep = 0.02, vinc = 0.1, ptype = "float" },
    },
    
    sokol = {
        sokol_path      = { index = 1, value = "../../../../", ptype = "path", slen = 256 },
        sokol_bin       = { index = 2, value = "bin/", ptype = "path", slen = 256 },
        sokol_ffi       = { index = 3, value = "ffi/", ptype = "path", slen = 256 },
        sokol_lua       = { index = 4, value = "lua/", ptype = "path", slen = 256 },
        sokol_examples  = { index = 5, value = "examples/", ptype = "path", slen = 256 },
    },

    remote = {
        -- These are futures -- 
        remote_build    = { index = 1, value = "https://mybuildserver.com/sokol_build", slen = 256 },
        remote_data     = { index = 2, value = "https://myremotedata.com/data", slen = 256 },
    },

    -- Assets will be populated by project file
    assets = {
        lua     = {},
        images  = {},
        data    = {},
    },
}

-- ------------------------------------------------------------------------------------------------------

local function loadconfig(projectpath)

    local res = nil
    local fh = io.open(projectpath, "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
        if(res == nil or #res == 0) then 
            print("[Error] loadconfig - cannot read settings file: "..projectpath)
            res = nil 
        else
            res = json.decode(res)
        end
        print(res)
    else
        print("[Error] settings.load - unable to load config: "..projectpath)
    end
    return res
end 

-- ------------------------------------------------------------------------------------------------------

settings.add_recents = function( filename )

    if(settings.recents)  then 

        -- Check it isnt already in the list, add to first and remove the other.
        local cleaned_recents = {}

        for i, v in ipairs(settings.recents) do
            local testf = string.gsub(filename, "%-", "_")
            local testv = string.gsub(v, "%-", "_")
            if string.match(testf, testv) then 
            else
                table.insert(cleaned_recents, v) 
            end
        end
        settings.recents = cleaned_recents
        table.insert(settings.recents, 1, filename)
    end
end


-- ------------------------------------------------------------------------------------------------------

settings.load_recents = function( )

    -- Grab the recents file list too.
    local fh = io.open("config/recent_projects.json", "r")
    if(fh) then 
        settings.recents = json.decode( fh:read("*a") )
        fh:close()
    else 
        logging.error(" settings.load_recents: Cannot load recents.")
    end    
end

-- ------------------------------------------------------------------------------------------------------

settings.save_recents = function( )

    -- Grab the recents file list too.
    if(settings.recents) then 
        local fh = io.open("config/recent_projects.json", "w")
        if(fh) then 
            fh:write(json.encode( settings.recents ))
            fh:close()
            logging.error(" settings.save_recents.")
        else 
            logging.error(" settings.save_recents: Cannot load recents.")
        end
    end
end

-- ------------------------------------------------------------------------------------------------------

settings.load = function( projectpath )

    if( projectpath == nil ) then 
        print("[Error] settings.load invalid projectpath nil, using default settings.")
        settings.config = default_settings
    else
        -- Load the project settings into the local config
        settings.config = loadconfig(projectpath)
    end

    local title = settings.config.rbuilder.appname.value.." ("..settings.config.rbuilder.version.value..")"
    settings.config.rbuilder.title = { value = title, slen = 32 }

    return settings.config
end

-- ------------------------------------------------------------------------------------------------------

settings.save = function( projectpath )

    -- Grab the recents file list too.
    settings.recent = nil
    local fh = io.open(projectpath, "w")
    if(fh) then 
        fh:write( json.encode(settings.config) )
        fh:close()
    end
end

-- ------------------------------------------------------------------------------------------------------

return settings

-- ------------------------------------------------------------------------------------------------------