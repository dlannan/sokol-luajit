
package.path = package.path..";lua/?.lua;lua/?/init.lua"
package.path = package.path..";ffi/?.lua;ffi/?/init.lua"
package.path = package.path..";deps/?.lua;deps/?/init.lua"

-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'
local ffiext = require 'ffi-extensions'

local p = require 'pretty-print-ffi'.prettyPrint
local loop = require 'uv-ffi'

local function makeHeader(datalen)

   local dt = os.date("%a, %d %b %Y %X GMT")

   local data = "HTTP/1.1 200 OK\r\n"..
               "Date: "..dt.."\r\n"..
               "Server: Apache/2.4.29 (Ubuntu)\r\n"..
               "Cache-Control: max-age=604800\r\n"..
               "Pragma: no-cache\r\n"..
               "Content-Encoding: none\r\n"..
               "Content-Length: "..datalen.."\r\n"..
               "Connection: Close\r\n"..
               "Content-Type: text/html;charset=UTF-8\r\n\r\n"
   return data
end

-- require 'safe-coro'(function ()
--   local timer = loop:newTimer()
--   p("About to sleep", timer)
--   timer:sleep(1000)
--   p("Done sleeping!", timer)
--   timer:close()    
-- end)

local function alloc_buffer(handle, suggested_size) 
   return loop.uv.uv_buf_init( ffi.new("char[?]", suggested_size), suggested_size)
end
 
local function echo_write(req, status)
   if status == -1 then 
      p("Write error!")
   end
   p("Request:", req)
end
 
local function echo_read(client, nread, buf) 
   if nread == -1 then 
     p("Read error!");
     loop.uv.uv_close(ffi.cast("uv_handle_t*",client), nil)
     return
   end
 
   local write_req = ffi.new("uv_write_t[1]")
   local data = ffi.new ("uv_buf_t[1]")
   
   local resp = "<h1>HELLOOOOO</h1>\r\n"
   local hdr = makeHeader(#resp)
   hdr = hdr..resp

   data[0].base = ffi.cast("char *", hdr)
   data[0].len = #hdr

   loop.uv.uv_write(write_req, client, data, 1, echo_write)
end

function on_new_connect( server, status )

   client = ffi.new("uv_tcp_t[1]")
   loop.uv.uv_tcp_init(loop, client)
   -- Start accepting the request
   if loop.uv.uv_accept(server, ffi.cast("uv_stream_t*", client)) == 0 then 
      -- Valid accept then start reading stream
      loop.uv.uv_read_start(ffi.cast("uv_stream_t*", client), alloc_buffer, echo_read)
   else 
      -- Bad request or connection closed
      loop.uv.uv_close(ffi.cast("uv_handle_t*",client), nil)
   end
end 

local server = loop:newTcp()
local res = loop:bind(server, "0.0.0.0", 7000)
runcb = server:listen( 128, on_new_connect )
if runcb == nil then p("Couldnt create server."); return end
loop:run('default')
