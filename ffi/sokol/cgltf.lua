local ffi  = require( "ffi" )

local cgltf_filename = _G.CGLTF_DLL or "cgltf_dll"
local libs = ffi_cgltf or {
   OSX     = { x64 = cgltf_filename.."_macos.so", arm64  = cgltf_filename.."_macos_arm64.so" },
   Windows = { x64 = cgltf_filename..".dll" },
   Linux   = { x64 = "./bin/linux/lib"..cgltf_filename..".so", arm = "./bin/linux/lib"..cgltf_filename..".so" },
   BSD     = { x64 = cgltf_filename..".so" },
   POSIX   = { x64 = cgltf_filename..".so" },
   Other   = { x64 = cgltf_filename..".so" },
}

local lib  = cgltf or libs[ ffi.os ][ ffi.arch ]
local cgltf   = ffi.load( lib )

-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
#include "]]..HEADER_PATH..[[ffi/sokol-headers/cgltf.h" 
]])

return cgltf