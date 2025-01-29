local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_dll"
local libs = ffi_sokol_gfx or {
   OSX     = { x64 = sokol_filename..".so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = sokol_filename..".so", arm = sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_gfx or libs[ ffi.os ][ ffi.arch ]
local sokol_gfx   = ffi.load( lib )

-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
#include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_gfx.h" 

enum sg_params_extended {
   SG_SHADERSTAGE_VS,
   SG_SHADERSTAGE_FS
} sg_params_extended;

]])

return sokol_gfx