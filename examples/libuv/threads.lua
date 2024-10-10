
package.path = package.path..";lua/?.lua;lua/?/init.lua"
package.path = package.path..";ffi/?.lua;ffi/?/init.lua"
package.path = package.path..";deps/?.lua;deps/?/init.lua"

-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'
local ffiext = require 'ffi-extensions'
local kern = ffiext.kern

local p = require 'pretty-print-ffi'.prettyPrint
local loop = require 'uv-ffi'

-----------------------------------------------------------------------------------------------

function hare(arg) 
    local tracklen = arg[0]
    while (tracklen) do
      tracklen = tracklen - 1
      kern.Sleep(100)
      p("Hare ran another step.")
    end
end
  
-----------------------------------------------------------------------------------------------
function tortoise(arg) 
    local tracklen = arg[0]
    while (tracklen) do
      tracklen = tracklen - 1
      kern.Sleep(500)
      p("Tortise ran another step.")
    end
end 
  
-----------------------------------------------------------------------------------------------

local tracklen1 = ffi.new("int[1]", 10)
local tracklen2 = ffi.new("int[1]", 10)

local hare_id = ffi.new("uv_thread_t[1]")
local tortoise_id = ffi.new("uv_thread_t[1]")

local id1 = loop.uv.uv_thread_create(hare_id, hare, tracklen1)
local id2 = loop.uv.uv_thread_create(tortoise_id, tortoise, tracklen2)
p("Res:", id1)
p("Res:", id2)

while tracklen2[0] > 0 do
    kern.Sleep(50)
end

loop.uv.uv_thread_join(hare_id)
loop.uv.uv_thread_join(tortoise_id)

-----------------------------------------------------------------------------------------------
