local ffi = require("ffi")

local dirtools = {}

---------------------------------------------------------------------------------------

dirtools.add_default_paths = function(path) 
    local folders = {
        ["Linux"]       = "linux",
        ["Windows"]     = "win64",
        ["MacOSX"]      = "macos",
    }
    local extensions = {
        ["Linux"]       = "so",
        ["Windows"]     = "dll",
        ["MacOSX"]      = "so",
    }

    package.cpath   = package.cpath..";"..path.."bin/"..folders[ffi.os].."/?."..extensions[ffi.os]
    package.path    = package.path..";"..path.."/ffi/sokol/?.lua"
    package.path    = package.path..";"..path.."/?.lua"
end

---------------------------------------------------------------------------------------

dirtools.get_app_path = function( expected_root_folder )

    local base_dir = "."
    if(ffi.os == "Windows") then 
        local cmdh = io.popen("cd", "r")
        if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
    else 
        local cmdh = io.popen("pwd", "r")
        if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
    end

    local folder_name = expected_root_folder
    local last_folder, remain = string.match(base_dir, "(.-"..folder_name..")(.-)")
    last_folder = last_folder or ""
    remain = remain or ""

    remain = remain:gsub("%s+", "")
    if(ffi.os == "Windows") then 
        base_dir = last_folder.."\\"
    else 
        base_dir = last_folder.."/"
    end
    -- print("Base Directory: "..base_dir)
    return base_dir
end

---------------------------------------------------------------------------------------
-- By default the paths are added

dirtools.init = function( base_path )
    local path = dirtools.get_app_path(base_path)
    dirtools.add_default_paths(path)
end

---------------------------------------------------------------------------------------

return dirtools

---------------------------------------------------------------------------------------