local ffi       = require("ffi")

local dirtools  = {}

local tinsert   = table.insert
local tconcat   = table.concat

---------------------------------------------------------------------------------------
-- Dirtools is about to become a little more complex and become a Virtual File System.
--
--  Scope: The VFS will handle all file management, thus io calls should be replaced 
--         with the equivalent vfs calls (same name, different lib). 
--         There are unique examples where this might not be needed, this is why the io
--         lib is not being overridden.
--  
--  File Support: VFS will handle unique file types and resource conversion, which may 
--         end up a separate module. Initially file types supported by the builder will be:
--            - image files (png, jpg)
--            - lua scripts (.lua and .lcc bytecode)
--            - shaders (only .glsl - these will be converted to bytecode at build)
--            - data files (extension must be registered with vfs, and custom handler can be added)
--
--  Resrouces: VFS is most important for building and packaging resource for release 
--         creation. The build tool (rbuilder) shall have options for how resources are
--         packaged. For example: Various custom data file types may need to exist 
--         standalone, and not be packaged into the resource files.
--
--  Require: VFS will manage loading lua and modules via search_packages system in lua.
--         If an example or project runs from a sokol-luajit repo then the build system
--         shall replicate the same loading within the bytecode generation. 
--         Build script combine, build and this file dirtools will include functions to handle
--         the specific pathing and file types as part of the require system.
---------------------------------------------------------------------------------------


local allfolders_cmd = [[dir /ON /AD /B "%s"]]
if(ffi.os ~= "Windows") then allfolders_cmd = [[ls -p "%s" | grep /]] end
local allfiles_cmd = [[dir /ON /A-D /B "%s"]]
if(ffi.os ~= "Windows") then allfiles_cmd = [[ls -p "%s" | grep -v /]] end

-- --------------------------------------------------------------------------------------

local list_folders_cache = {}
local list_cache = {}

local sep = "\\"
if(ffi.os ~= "Windows") then sep = "/" end
dirtools.sep = sep

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
    package.path    = package.path..";"..path.."lua/?/init.lua"
    package.path    = package.path..";"..path.."/?.lua"
end

---------------------------------------------------------------------------------------

local function log_info( str )
    print(string.format("[Info] %s", str))
end

local function log_error( str )
    print(string.format("[Error] %s", str))
end

---------------------------------------------------------------------------------------

dirtools.add_cpath = function( new_path )
    package.cpath    = package.cpath..";"..new_path
end

---------------------------------------------------------------------------------------

dirtools.add_package_path = function( new_path )
    package.path    = package.path..";"..new_path.."/?.lua"
end

---------------------------------------------------------------------------------------

dirtools.compare_paths = function(p1, p2)
    -- Remove  minus, they seem to cause the most problems 
    p1 = string.gsub(p1, "%-", "_")
    p2 = string.gsub(p2, "%-", "_")
    return string.match(p1, p2)
end

---------------------------------------------------------------------------------------

dirtools.combine_path = function( base, addition )
    -- remove any returns and tabs from both 
    base = string.gsub(base, "[\n\t\r]+","")
    addition = string.gsub(addition, "[\n\t\r]+","")
    return string.format("%s%s%s",base,sep,addition)
end

---------------------------------------------------------------------------------------

dirtools.get_drives = function()

    local drives = {}
    if(ffi.os == "Windows") then 

        local cmd = "fsutil fsinfo drives"
        local fh = io.popen(cmd, "r")
        if(fh) then 
            local data = fh:read("*a")
            fh:close() 
            if(string.match(data, "Drives: ")) then 
                data = string.sub(data, 10, -1)
                for f in string.gmatch(data, "([^%s]+)") do 
                    f = string.sub(f, 1, -2)
                    tinsert(drives, f)
                end
            end
        end
    else 
        -- Note: Add more -t <filetype> to support different file system mounts
        local cmd = "df -h -t ext4 --output=target" 

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

        if(path == nil) then return nil end 

        local fh = io.popen([[attrib "]]..path..[["]], "r")
        if(fh) then 
            local res = fh:read("*a")
            local fileattr = string.sub(res, 1, 20)
            fileattr = string.gsub(fileattr, " ", "")
            fh:close()
            if(string.match(res, "^File not found")) then return nil end
            return (#fileattr == 0)
        end
        return nil
    end
else
    dirtools.is_folder = function(path)

        if(path == nil) then return nil end 

        local fh = io.popen("file "..path, "r")
        if(fh) then 
            local res = fh:read("*a")
            local folder = string.match(res, ".-: directory$")
            fh:close()
            return (folder ~= nil)
        end
        return nil 
    end
end

---------------------------------------------------------------------------------------

dirtools.make_folder = function(folderpath)

    local found = dirtools.is_folder(folderpath)
    if(found == nil) then 
        local cmd = [[mkdir -f "]]..folderpath..[["]]
        if(ffi.os == "Windows") then cmd = [[mkdir "]]..folderpath..[["]] end
        local fh = io.popen(cmd, "r")
        if(fh) then 
            local data = fh:read("*a")
            fh:close() 
            log_info(data)
            return true
        else 
            log_error("Cannot make folder: "..folderpath)
            return nil
        end
    else
        log_info("Folder already exists: "..folderpath)
    end
end

---------------------------------------------------------------------------------------

dirtools.get_relative_path = function( fullpath, parent_path )

    local rpath = nil 
    local str_st, str_end = string.find( fullpath, parent_path, 1, true )
    if(str_st and str_end) then 
        rpath = string.sub(fullpath, str_end+2, -1)        
    end
    return rpath
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

    if(expected_root_folder) then
        local folder_name = expected_root_folder
        local last_folder, remain = string.match(base_dir, "(.-"..folder_name..")(.-)")
        last_folder = last_folder or ""
        remain = remain or ""

        remain = remain:gsub("%s+", "")
        if(string.len(last_folder) > 0) then             
            base_dir = last_folder..sep
        else 
            base_dir = "" 
        end
    end
    -- log_info("Base Directory: "..base_dir)
    return base_dir
end

-- --------------------------------------------------------------------------------------

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
        log_error("dirtools.get_folderslist bad path: "..tostring(path))
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

dirtools.get_dirlist = function(path, cache_update, extfilter)

    -- Check path first. If its a drive on windows then no caching
    if(ffi.os == "Windows") then 
        local colon = string.match(path, "(.)$")
        if(colon == ":") then path = path..sep end
    end

    if(list_cache[path] and cache_update == nil) then 
        return list_cache[path] 
    end

    -- Get all the folders first
    local files = dirtools.get_folderslist(path, cache_update)

    -- Add the files to the list.
    local res = ""
    -- Fill with temp file list of dir /b 
    local fh = io.popen(string.format(allfiles_cmd, path), "r")
    if(fh) then 
        res = fh:read("*a")
        fh:close()
        if(#res == 0) then 
            list_cache[path] = files
            return files        
        end
    else 
        log_error("dirtools.get_dirlist bad path: "..tostring(path))
        return {}        
    end

    for f in string.gmatch(res, "(.-)\n") do 
        -- Only match with filter on end of filename
        local add_file = true
        if(extfilter) then 
            add_file = string.match(f, extfilter.."$")
        end
        if(add_file) then 
            local newfile = { name = ffi.string(f), folder = nil }
            newfile.select = ffi.new("int[1]")
            newfile.select[0] = 0
            table.insert(files, newfile) 
        end
    end    

    list_cache[path] = files
    return files
end

---------------------------------------------------------------------------------------
dirtools.path_match = function(list, path)

    for i,v in ipairs(list) do 
        if(dirtools.compare_paths(v.name, path)) then 
            return true
        end
    end
    return false
end

---------------------------------------------------------------------------------------
dirtools.get_parent = function( path )
    if(path == nil or path == "") then path = "." end
    local parentpath = dirtools.get_folder(path)
    return parentpath
end

------------------------------------------------------------------------------------------------------------

local function windows_dir( folder )
	local result = nil
	local f = io.popen("dir /AD /b \""..tostring(folder).."\"")
	if f then
		result = f:read("*a")
	else
		log_error("failed to read - "..tostring(folder))
	end
	return result
end

------------------------------------------------------------------------------------------------------------

local function unix_dir( folder )
	local result = nil
	local f = io.popen("ls -d -A -G -N -1 * \""..tostring(folder).."\"")
	if f then
		result = f:read("*a")
	else
		log_error("failed to read - "..tostring(folder))
	end
	return result
end

------------------------------------------------------------------------------------------------------------

dirtools.getdirs = function ( folder )
	local dirstr = ""
	if ffi.os == "HTML5" then

	elseif ffi.os == "Windows" then
		dirstr = windows_dir(folder)
	else
		dirstr = unix_dir(folder)
	end

	-- split string by line endings into a nice table
	local restbl = nil
	if(dirstr) then 
		restbl = csplit(dirstr, "\n")
	end

	return restbl
end

---------------------------------------------------------------------------------------

dirtools.find_folder = function( start_path, parent_up, folder_name )

    -- If starting in current application folder, convert it to a full path
    if(start_path == ".") then 
        start_path = dirtools.get_app_path()
    end
    local list = dirtools.get_folderslist(start_path)
    if(dirtools.path_match(list, "sokol-luajit") == true) then 
        return start_path
    end

    local current = start_path
    for i=1, parent_up do 
        current = dirtools.get_parent(current)
        list = dirtools.get_folderslist(current)
        if(dirtools.path_match(list, "sokol-luajit") == true) then 
            return current
        end
    end
    return nil
end

---------------------------------------------------------------------------------------

dirtools.fileparts = function( path )

    return string.match(path, "(.-)([^\\/]-([^%.]+))$")
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