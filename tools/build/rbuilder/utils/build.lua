-- A simple build script using lua to make a standalone exe using srlua

-- Use ffi for arch and os detection
local ffi = require("ffi")
local logging   = require("utils.logging")
local combine   = require("utils.combine")

local dirtools = require("tools.dirtools")
local base_path = dirtools.get_app_path("sokol%-luajit")

local tinsert   = table.insert

-- ----------------------------------------------------------------------------------

local luajit_builder = {

}

-- ----------------------------------------------------------------------------------
local function run_cmd(command) 
    print(command)
    local fh = io.popen( command, "r" )
    if(fh) then 
        local output = fh:read("*a")
        fh:close()
        io.write(output)
        logging.info("Success")
    else 
        logging.error("Cannot execute command: "..command)
    end
end

-- ----------------------------------------------------------------------------------

local function apply_config(startfile, config) 

    local fh = io.open(startfile, "r")
    if(fh) then 
        local script = fh:read("*a")
        fh:close() 

    else 
        logging.error("File not found: "..startfile)
    end
end

-- ----------------------------------------------------------------------------------
-- srlua and glue for each os

local plaform_cmds = {}

luajit_builder.configure = function(config)

    plaform_cmds["Windows"] = { 
        build_path = config["sokol"].sokol_path.value.."\\tools\\build\\",
        srlua = config["sokol"].sokol_path.value.."\\tools\\build\\srlua\\bin\\win64\\srlua.exe", 
        glue = config["sokol"].sokol_path.value.."\\tools\\build\\srlua\\bin\\win64\\glue.exe", 
        ext = ".exe", 
        sep = "\\",
        luajit = config["sokol"].sokol_bin.value.."\\win64\\luajit.exe",
        src_dll = config["sokol"].sokol_bin.value.."\\win64\\*.dll",
        src_cfg = ".\\config",
    }
    plaform_cmds["OSX"]     = { 
        build_path = config["sokol"].sokol_path.value.."/tools/build/",
        srlua = config["sokol"].sokol_path.value.."/tools/build/srlua/bin/macos/srlua", 
        glue = config["sokol"].sokol_path.value.."/tools/build/srlua/bin/macos/glue", 
        ext = "", 
        sep = "/",
        luajit = config["sokol"].sokol_bin.value.."/macos/luajit",
        src_dll = config["sokol"].sokol_bin.value.."/macos/*.dylib",
        src_cfg = "./config",
    }
    plaform_cmds["Linux"]   = { 
        build_path = config["sokol"].sokol_path.value.."/tools/build/",
        srlua = config["sokol"].sokol_path.value.."/tools/build/srlua/bin/linux/srlua", 
        glue = config["sokol"].sokol_path.value.."/tools/build/srlua/bin/linux/glue", 
        ext = "", 
        sep = "/",
        luajit = config["sokol"].sokol_bin.value.."/linux/luajit",
        src_dll = config["sokol"].sokol_bin.value.."/linux/*.so",
        src_cfg = "./config",
    }
end

-- --------------------------------------------------------------------------------------

luajit_builder.run = function( config )

    local cmds = plaform_cmds[ffi.os]
    local outputfolder = config["project"].build_path.value..cmds.sep..string.lower(ffi.os)..cmds.sep
    local outputexe = config["project"].project_name.value..cmds.ext

    -- make sure output folder exists - make it if not
    dirtools.make_folder(outputfolder)

    -- Add the startup file
    local startfiles = { config["project"].project_start.value }

    -- Check first start file (must be sokol setup file) to see if resolution and gfx settings
    --  can be applied from project side.
    if(startfiles[1]) then 
        apply_config(startfiles[1], config)
    end

    -- Iterate Lua source to add 
    local libfiles = {}
    for i,v in ipairs(config["assets"].lua) do 
        if(v.folder) then 

        else
            local rpath = dirtools.get_relative_path(v.name, config["sokol"].sokol_path.value)
            if(rpath == nil) then rpath = v.name end
            tinsert(libfiles, { name = rpath, fullpath = v.name })
        end
    end
    local combine_out = outputfolder.."combine.out"
    combine.run( combine_out, startfiles, libfiles)

    -- Build the exe
    local command = cmds.glue.." "..cmds.srlua.." "..combine_out.." "..outputfolder..outputexe
    run_cmd(command)

    local copycmd = "cp -rf "..cmds.src_dll.." "..outputfolder
    if(ffi.os == "Windows") then copycmd = "xcopy /C /I /Y "..cmds.src_dll.." "..outputfolder end
    -- Copy in the dlls/dylib/sos 
    run_cmd(copycmd)

    -- -- Copy in image files
    -- local copyimages = "cp -rf "..cmds.src_cfg.." "..outputfolder..cmds.sep.."config"
    -- if(ffi.os == "Windows") then copyimages = "xcopy /S /E /C /I /Y "..cmds.src_cfg.." "..outputfolder.."config" end

    -- -- Iterate Lua source to add 
    -- for i,v in ipairs(config["assets"].lua) do 
    --     if(v.folder) then 

    --     else
    --         buildchunk = buildchunk..v.name.." "
    --         run_cmd(copyimages)
    --     end
    -- end

    -- Copy in data files


    -- Remove temp files
    local cleanupcmd = "rm -f "..combine_out
    if(ffi.os == "Windows") then cleanupcmd = "del /f "..combine_out end
    --run_cmd(cleanupcmd)
end

-- --------------------------------------------------------------------------------------

return luajit_builder

-- --------------------------------------------------------------------------------------