local ffi       = require("ffi")

local dirtools  = {}

local tinsert   = table.insert
local tconcat   = table.concat

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
    package.path    = package.path..";"..path.."lua/?.lua"
    package.path    = package.path..";"..path.."/?.lua"
end

---------------------------------------------------------------------------------------
-- Much safer way to build folder than pattern match (very unstable)
dirtools.get_folder = function(path)
    local parts = {}
    local sep = "\\"
    local patt = "(.-)[\\]"
    if(ffi.os ~= "Windows") then patt = "(.-)[/]"; sep = "/" end
    for pseg in string.gmatch(path, patt) do
        tinsert(parts, pseg)
    end
    return tconcat(parts, sep)
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

-- --------------------------------------------------------------------------------------

local dir_cmd = "dir /b"
if(ffi.os ~= "Windows") then dir_cmd = "ls -1" end

local list_cache = {}

dirtools.get_dirlist = function(path, cache_update)

    if(list_cache[path] and cache_update == nil) then return list_cache[path] end

    local files             = {}
    local res = ""
    -- Fill with temp file list of dir /b 
    local fh = io.popen(dir_cmd.." "..path, "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
    else 
        print("[Error] dirtools.get_dirlist bad path: "..tostring(path))
        return files        
    end

    for f in string.gmatch(res, "(.-)\n") do 
        local newfile = { name = ffi.string(f)}
        newfile.select = ffi.new("int[1]")
        newfile.select[0] = 0
        table.insert(files, newfile) 
    end    

    list_cache[path] = files
    return files
end

-- --------------------------------------------------------------------------------------

local folders_cmd = "dir /Ad /b"
if(ffi.os ~= "Windows") then folders_cmd = "ls -1 -d */" end

local list_folders_cache = {}

dirtools.get_folderslist = function(path, cache_update)

    if(list_folders_cache[path] and cache_update == nil) then return list_folders_cache[path] end

    local files             = {}
    local res = ""
    -- Fill with temp file list of dir /b 
    local fh = io.popen(folders_cmd.." "..path, "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
    else 
        print("[Error] dirtools.get_folderslist bad path: "..tostring(path))
        return files
    end

    for f in string.gmatch(res, "(.-)\n") do 
        local newfile = { name = ffi.string(f)}
        newfile.select = ffi.new("int[1]")
        newfile.select[0] = 0
        table.insert(files, newfile) 
    end    

    list_folders_cache[path] = files
    return files
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