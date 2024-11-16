-- A simple build script using lua to make a standalone exe using srlua

-- Use ffi for arch and os detection
local ffi = require("ffi")

-- ----------------------------------------------------------------------------------
local function run_cmd(command) 
    print(command)
    local fh = io.popen( command, "r" )
    if(fh) then 
        local output = fh:read("*a")
        fh:close()
        io.write(output)
        print("[Success]")
    else 
        print("[Error] Cannot execute command: "..command)
    end
end

-- ----------------------------------------------------------------------------------
-- srlua and glue for each os
local plaform_cmds = {
    ["Windows"] = { 
        srlua = ".\\tools\\srlua\\win64\\srlua.exe", 
        glue = ".\\tools\\srlua\\win64\\glue.exe", 
        ext = ".exe", 
        sep = "\\",
        luajit = ".\\bin\\win64\\luajit.exe",
        src_dll = ".\\bin\\win64\\*.dll",
        src_cfg = ".\\config",
    },
    ["OSX"]     = { 
        srlua = "./tools/srlua/macos/srlua", 
        glue = "./tools/srlua/macos/glue", 
        ext = "", 
        sep = "/",
        luajit = "./bin/macos/luajit",
        src_dll = "./bin/macos/*.dylib",
        src_cfg = "./config",
    },
    ["Linux"]   = { 
        srlua = "./tools/srlua/linux/srlua", 
        glue = "./tools/srlua/linux/glue", 
        ext = "", 
        sep = "/",
        luajit = "./bin/linux/luajit",
        src_dll = "./bin/linux/*.so",
        src_cfg = "./config",
    },
}

local cmds = plaform_cmds[ffi.os]
local outputfolder = "."..cmds.sep.."tools"..cmds.sep.."bin"..cmds.sep..string.lower(ffi.os)..cmds.sep
local outputexe = "minikeybd_"..ffi.os..cmds.ext

-- Have to build a bytecode "chunk" first.
local buildchunk = cmds.luajit.." ."..cmds.sep.."tools"..cmds.sep.."combine.lua "
buildchunk = buildchunk.."."..cmds.sep.."lua"..cmds.sep.."minikeybd.lua -L "
buildchunk = buildchunk.."."..cmds.sep.."ffi"..cmds.sep.."hidwin.lua "
buildchunk = buildchunk.."."..cmds.sep.."ffi"..cmds.sep.."lusb.lua "
buildchunk = buildchunk.."."..cmds.sep.."lua"..cmds.sep.."mapcodes.lua "
buildchunk = buildchunk.."."..cmds.sep.."lua"..cmds.sep.."wchar_win.lua "
run_cmd(buildchunk)

-- Build the exe
local command = cmds.glue.." "..cmds.srlua.." luac.out "..outputfolder..outputexe
run_cmd(command)

local copycmd = "cp -rf "..cmds.src_dll.." "..outputfolder
if(ffi.os == "Windows") then copycmd = "xcopy /C /I /Y "..cmds.src_dll.." "..outputfolder end
-- Copy in the dlls/dylib/sos 
run_cmd(copycmd)

-- Copy in config folder
local copyconfig = "cp -rf "..cmds.src_cfg.." "..outputfolder..cmds.sep.."config"
if(ffi.os == "Windows") then copyconfig = "xcopy /S /E /C /I /Y "..cmds.src_cfg.." "..outputfolder.."config" end
run_cmd(copyconfig)