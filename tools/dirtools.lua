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

local sep = "\\"
if(ffi.os ~= "Windows") then sep = "/" end

---------------------------------------------------------------------------------------

dirtools.get_drives = function()
    local cmd = "wmic logicaldisk get name"
    -- Note: Add more -t <filetype> to support different file system mounts
    if(ffi.os ~= "Windows") then cmd = "df -h -t ext4 --output=target" end

    local drives = {}
    local fh = io.popen(cmd, "r")
    if(fh) then 
        local data = fh:read("*a")
        local count = 0
        for f in string.gmatch(data, "(.-)\n") do 
            f = string.gsub(f, "%s+", "")
            if(count > 0) then 
                if(#f > 0) then
                    tinsert(drives, f)
                end
            end 
            count = count + 1
        end
        fh:close()
    end
    return drives
end

---------------------------------------------------------------------------------------
-- Much safer way to build folder than pattern match (very unstable)
dirtools.get_folder = function(path)
    local parts = {}
    local patt = "(.-)[\\]"
    if(ffi.os ~= "Windows") then patt = "(.-)[/]" end
    for pseg in string.gmatch(path, patt) do
        tinsert(parts, pseg)
    end
    if(#parts < 1) then return path end
    return tconcat(parts, sep)
end

---------------------------------------------------------------------------------------
-- Check if the path is folder or file
if(ffi.os == "Windows") then 
    dirtools.is_folder = function(path)

        local fh = io.popen("attrib "..path, "r")
        if(fh) then 
            local res = fh:read("*a")
            local fileattr = string.sub(res, 1, 20)
            fileattr = string.gsub(fileattr, " ", "")
            fh:close()
            return (#fileattr == 0)
        end
        return false
    end
else
    dirtools.is_folder = function(path)

        local fh = io.popen("file "..path, "r")
        if(fh) then 
            local res = fh:read("*a")
            local folder = string.match(res, ".-: directory$")
            fh:close()
            return (folder ~= nil)
        end
        return false
    end
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

local allfolders_cmd = "dir /ON /AD /B %s"
if(ffi.os ~= "Windows") then allfolders_cmd = "ls -p %s | grep /" end
local allfiles_cmd = "dir /ON /A-D /B %s"
if(ffi.os ~= "Windows") then allfiles_cmd = "ls -p %s | grep -v /" end

-- --------------------------------------------------------------------------------------

local list_folders_cache = {}
local list_cache = {}

dirtools.get_folderslist = function(path, cache_update)

    -- Check path first. If its a drive on windows then no caching
    if(ffi.os == "Windows") then 
        local colon = string.sub(path, 2,-1)
        if(colon == ":") then cache_update = true; path = path..sep end
    end

    if(list_folders_cache[path] and cache_update == nil) then 
        return list_folders_cache[path] 
    end

    local files             = {}
    table.insert(files, 1, { name = ".." })
    
    local res = ""
    -- Fill with temp file list of dir /b 
    local fh = io.popen(string.format(allfolders_cmd, path), "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
    else 
        print("[Error] dirtools.get_folderslist bad path: "..tostring(path))
        return files
    end

    for f in string.gmatch(res, "(.-)\n") do 
        local newfile = { name = ffi.string(f), folder = true }
        newfile.select = ffi.new("int[1]")
        newfile.select[0] = 0
        table.insert(files, newfile) 
    end    

    list_folders_cache[path] = files
    return files
end

---------------------------------------------------------------------------------------

dirtools.get_dirlist = function(path, cache_update)

    -- Check path first. If its a drive on windows then no caching
    if(ffi.os == "Windows") then 
        local colon = string.match(path, "(.)$")
        if(colon == ":") then path = path..sep end
    end

    if(list_cache[path] and cache_update == nil) then 
        return list_cache[path] 
    end

    -- Get all the folders first
    local files = dirtools.get_folderslist(path)

    -- Add the files to the list.
    local res = ""
    -- Fill with temp file list of dir /b 
    local fh = io.popen(string.format(allfiles_cmd, path), "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
        if(#res == 0) then 
            print(path)
            list_cache[path] = files
            return files        
        end
    else 
        print("[Error] dirtools.get_dirlist bad path: "..tostring(path))
        return {}        
    end

    for f in string.gmatch(res, "(.-)\n") do 
        local newfile = { name = ffi.string(f), folder = nil }
        newfile.select = ffi.new("int[1]")
        newfile.select[0] = 0
        table.insert(files, newfile) 
    end    

    list_cache[path] = files
    return files
end

---------------------------------------------------------------------------------------
dirtools.get_parent = function( path )
    if(path == nil or path == "") then path = "." end
    local parentpath = dirtools.get_folder(path)
    return parentpath
end

---------------------------------------------------------------------------------------
dirtools.change_folder = function( path, child )
    
    local newpath = path..sep..child
    return newpath
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