local ffi  = require( "ffi" )

local sokol_filename = _G.SOKOL_DLL or "sokol_dll"
local libs = ffi_sokol_libs or {
   OSX     = { x64 = sokol_filename..".so" },
   Windows = { x64 = sokol_filename..".dll" },
   Linux   = { x64 = sokol_filename..".so", arm = sokol_filename..".so" },
   BSD     = { x64 = sokol_filename..".so" },
   POSIX   = { x64 = sokol_filename..".so" },
   Other   = { x64 = sokol_filename..".so" },
}

local lib  = ffi_sokol_libs or libs[ ffi.os ][ ffi.arch ]
local sokol_libs   = ffi.load( lib )

-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
   #include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_args.h"
   #include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_fetch.h"
   #include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_glue.h"
   #include "]]..HEADER_PATH..[[ffi/sokol-headers/sokol_time.h"
]])

return sokol_libs