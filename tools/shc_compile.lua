-- A way to run the tool as part of a runtime or a build stage.
local ffi   = require("ffi")
local sg    = require("sokol_gfx")
local dirtools = require("tools.dirtools")

-- local base_dir = "."
-- if(ffi.os == "Windows") then 
--     local cmdh = io.popen("cd", "r")
--     if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
-- else 
--     local cmdh = io.popen("cwd", "r")
--     if(cmdh) then base_dir = cmdh:read("*a"); cmdh:close() end
-- end

-- local folder_name = "sokol%-luajit"
-- local last_folder, remain = string.match(base_dir, "(.-"..folder_name..")(.-)")
-- remain = remain:gsub("%s+", "")
-- if(ffi.os == "Windows") then 
--     base_dir = last_folder.."\\"
-- else 
--     base_dir = last_folder.."/"
-- end
-- print("Base Directory: "..base_dir)
local base_dir = dirtools.get_app_path("sokol%-luajit")

-- Setup some defaults
local sh_compiler = {

    target_tmp      = base_dir.."bin/shaderbin/shader_gen.h",
    target_lang     = "glsl410",
    target_output   = "sokol",

    typedefs        = {},
}

local exec_opts = {
    ["Linx"]        = base_dir.."tools/shader_compiler/linux/sokol-shdc.exe",
    ["Windows"]     = base_dir.."tools\\shader_compiler\\win32\\sokol-shdc.exe",
    ["MacOSX"]      = base_dir.."tools/shader_compiler/win32/sokol-shdc.exe",
}
local exec = exec_opts[ffi.os]


-- --------------------------------------------------------------------------------------
-- Process the shader header file for use in the lua scripts
--   returns a lua table that can then be used in the soko shader methods
sh_compiler.process_shader = function( filename, shader_src, program_name )

    if(program_name) then 
        program_name = program_name.."_"
    else 
        program_name = ""
    end

    local tbl = { ffi = ffi, sg = sg }
    local ffi_str = ""
    local buff = shader_src
    local header_section, body_section = string.match(buff, "#pragma pack%(push,1%)(.+)#pragma pack%(pop%)(.*)")
    -- This can happen with simple shaders.
    if(header_section == nil) then 
        header_section, body_section = string.match(buff, "#endif\n(#define.-#define.-\n)(.*)")
        header_section= string.gsub(header_section, "%((%d-)%)", " = %1")
        header_section = string.gsub(header_section, "#define ", "local ")
        local attribs = header_section
        ffi_str = ffi_str..attribs
        header_section = nil
    end

    if(header_section and sh_compiler.typedefs[filename] == nil) then 

        local typedefs = string.gsub(header_section, "#pragma pack%(pop%)", "")
        typedefs = string.gsub(typedefs, "#pragma pack%(push,1%)", "")
        typedefs = string.gsub(typedefs, "SOKOL_SHDC_ALIGN%(16%)", "__declspec%(align%(16%)%)")
        sh_compiler.typedefs[filename] = true
        ffi_str = ffi_str.."ffi.cdef[["
        ffi_str = ffi_str..typedefs
        ffi_str = ffi_str.."]]\n\n"
    end
print(ffi_str)
    -- Make a sg_shader_desc 

    -- get vs_source 
    ffi_str = ffi_str..[[local ]]..program_name..[[shader = ffi.new("sg_shader_desc[1]")]].."\n"
    ffi_str = ffi_str..[[local desc = ]]..program_name.."shader[0]\n\n"

    local vs_source_count, vs_source = string.match(body_section, "static const uint8_t vs_"..program_name.."source_.-(%[.-%]) = (%{.-%});")
    if(vs_source) then 
        ffi_str = ffi_str..[[local vs_]]..program_name..[[source_]]..sh_compiler.target_lang..[[ = ffi.new("uint8_t]]..vs_source_count..[[",]]..vs_source..")\n\n"
        --ffi_str = ffi_str..[[vs_]]..program_name..[[source_]]..sh_compiler.target_lang..[[ = ffi.string(vs_]]..program_name..[[source_]]..sh_compiler.target_lang..")\n\n"
    end

    -- get vs_source 
    local fs_source_count, fs_source = string.match(body_section, "static const uint8_t fs_"..program_name.."source_.-(%[.-%]) = (%{.-%});")
    if(fs_source) then 
        ffi_str = ffi_str..[[local fs_]]..program_name..[[source_]]..sh_compiler.target_lang..[[ = ffi.new("uint8_t]]..fs_source_count..[[",]]..fs_source..")\n\n"
        --ffi_str = ffi_str..[[fs_]]..program_name..[[source_]]..sh_compiler.target_lang..[[ = ffi.string(fs_]]..program_name..[[source_]]..sh_compiler.target_lang..")\n\n"
    end

    -- local desc = shader[0]

    local desc_str = ""
    local program_section = body_section
    if(program_name ~= "") then 
        program_section = string.match(body_section, "static inline const sg_shader_desc%* "..program_name..".-%{(.-)return 0;\n%}")
    end
    desc_str = string.match(program_section, "static sg_shader_desc desc;.-%{.-valid = true;(.-)%}")
    desc_str = string.gsub(desc_str, "            ", "")
    desc_str = string.gsub(desc_str, ";", "")
    desc_str = string.gsub(desc_str, "%(const char%*%)", "")
    desc_str = string.gsub(desc_str, "SG_UNIFORMLAYOUT_STD140", "sg.SG_UNIFORMLAYOUT_STD140")
    desc_str = string.gsub(desc_str, "SG_UNIFORMTYPE_FLOAT3", "sg.SG_UNIFORMTYPE_FLOAT3")
    desc_str = string.gsub(desc_str, "SG_UNIFORMTYPE_FLOAT4", "sg.SG_UNIFORMTYPE_FLOAT4")
    desc_str = string.gsub(desc_str, "SG_IMAGESAMPLETYPE_FLOAT", "sg.SG_IMAGESAMPLETYPE_FLOAT")
    desc_str = string.gsub(desc_str, "SG_SAMPLERTYPE_FILTERING", "sg.SG_SAMPLERTYPE_FILTERING")
    desc_str = string.gsub(desc_str, "SG_IMAGETYPE_2D", "sg.SG_IMAGETYPE_2D")

    ffi_str = ffi_str..desc_str.."\n"
    ffi_str = ffi_str..[[return ]]..program_name..[[shader]]
   
    if(sh_compiler.debug) then 
        print(">>------- Shader: "..filename.." ---------")
        print(ffi_str) 
        print("<<------- End Shader ---------")
    end
    return load(ffi_str, nil, nil, tbl)()
end

-- --------------------------------------------------------------------------------------
-- Compile shader to file, load file, parse it and build the appropriate lua script to use
--   in the sokol shader setups

sh_compiler.compile = function( glslfile, program_name )

    local command = exec..' -i '..glslfile.." -o "..sh_compiler.target_tmp
    command = command.." -l "..sh_compiler.target_lang.." -f "..sh_compiler.target_output
    print(command)

    local runner = io.popen(command, "r")
    -- Read in the results, then the files
    if(runner) then 
        local results = runner:read("*a")
        runner:close()
        print("[sh_compiler.lua] Shader: "..glslfile.." compiled correctly.")
    else 
        print("Invalid command: "..command)
        return nil
    end

    -- Load in the generated file
    local lua_shader = ""
    local tmpfile = io.open(sh_compiler.target_tmp, "r")
    if(tmpfile) then 
        local shader_src = tmpfile:read("*a")
        tmpfile:close()
        local lua_shader = sh_compiler.process_shader(glslfile, shader_src, program_name)
        return lua_shader
    else
        print("Cannot load tmpfile: "..sh_compiler.target_tmp)
        return nil
    end
end

return sh_compiler
