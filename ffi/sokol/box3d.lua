local ffi  = require( "ffi" )

local box3d_filename = _G.BOX3D_DLL or "box3d"
local libs = ffi_box3d or {
   OSX     = { x64 = box3d_filename.."_macos.so", arm64 = box3d_filename.."_macos_arm64.so" },
   Windows = { x64 = box3d_filename..".dll" },
   Linux   = { x64 = "./bin/linux/lib"..box3d_filename..".so", arm = "./bin/linux/lib"..box3d_filename..".so" },
   BSD     = { x64 = box3d_filename..".so" },
   POSIX   = { x64 = box3d_filename..".so" },
   Other   = { x64 = box3d_filename..".so" },
}

local lib  = ffi_box3d or libs[ ffi.os ][ ffi.arch ]
local lib_box3d   = ffi.load( lib )

-- load lcpp (ffi.cdef wrapper turned on per default)
local lcpp = require("tools.lcpp")

-- just use LuaJIT ffi and lcpp together
HEADER_PATH = HEADER_PATH or ""
ffi.cdef([[
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/base.h"
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/math_functions.h"
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/constants.h"
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/id.h"
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/types.h"
   #include "]]..HEADER_PATH..[[ffi/box3d-headers/collision.h"

   #include "]]..HEADER_PATH..[[ffi/box3d-headers/box3d.h"
]])

return lib_box3d