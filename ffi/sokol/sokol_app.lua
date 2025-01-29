-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")
local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_dll"
local libs = ffi_sokol_app or {
   OSX     = { x64 = sokol_filename..".so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = "lib"..sokol_filename..".so", arm = "lib"..sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_app or libs[ ffi.os ][ ffi.arch ]
print(lib)
local sokol_app   = ffi.load( lib )

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
#include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_app.h" 
#include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_log.h"
]])

return sokol_app