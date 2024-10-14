local ffi = require("ffi")

local dirtools = {}

dirtools.get_app_path = function( expected_root_folder )

    local base_dir = "."
    if(ffi.os == "Windows") then 
        local cmdh = io.popen("cd", "r")
        if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
    else 
        local cmdh = io.popen("cwd", "r")
        if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
    end

    local folder_name = expected_root_folder
    local last_folder, remain = string.match(base_dir, "(.-"..folder_name..")(.-)")
    remain = remain:gsub("%s+", "")
    if(ffi.os == "Windows") then 
        base_dir = last_folder.."\\"
    else 
        base_dir = last_folder.."/"
    end
    print("Base Directory: "..base_dir)
    return base_dir
end

return dirtools