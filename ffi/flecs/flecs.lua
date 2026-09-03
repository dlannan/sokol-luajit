-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")
local ffi  = require( "ffi" )

local flecs_filename = _G.FLECS_DLL or "flecs"
local libs = ffi_flecs_app or {
   OSX     = { x64 = flecs_filename.."_macos.so", arm64  = flecs_filename.."_macos_arm64.so" },
   Windows = { x64 = flecs_filename..".dll" },
   Linux   = { x64 = "./bin/linux/lib"..flecs_filename..".so", arm = "./bin/linux/lib"..flecs_filename..".so" },
   BSD     = { x64 = flecs_filename..".so" },
   POSIX   = { x64 = flecs_filename..".so" },
   Other   = { x64 = flecs_filename..".so" },
}

local lib  = ffi_flecs_app or libs[ ffi.os ][ ffi.arch ]
local flecs_app   = ffi.load( lib )

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
#include "]]..HEADER_PATH..[[ffi/flecs/flecs_ffi.h" 
]])

return flecs_app