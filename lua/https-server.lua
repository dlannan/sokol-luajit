
local socket        = require("socket.core")
local copas         = require("copas")
local utils         = require("lua.utils")

------------------------------------------------------------------------------------------------------------

local tinsert       = table.insert
local tconcat       = table.concat

------------------------------------------------------------------------------------------------------------
-- Currently just http (will become websocket/https capable)

local http_server = {
    --{{Options
    ---The port number for the HTTP server. Default is 80
    port=80,
    ---The parameter backlog specifies the number of client connections
    -- that can be queued waiting for service. If the queue is full and
    -- another client attempts connection, the connection is refused.
    backlog=5,
    --}}Options

    NOT_FOUND = "endpoint not found.",

    -- Handles gets and posts mapping for endpoints
    router = {
        unhandled_func = function() print("Endpoint invalid. 404.") end,
        get_funcs = {},
        post_funcs = {},
    },
}

------------------------------------------------------------------------------------------------------------

http_server.router.unhandled = function(func)

    http_server.router.unhandled_func = func
end

------------------------------------------------------------------------------------------------------------

http_server.router.get = function(pattern, func)

    tinsert(http_server.router.get_funcs, { pattern = pattern, func = func })
end

------------------------------------------------------------------------------------------------------------

http_server.router.post = function(pattern, func)

    tinsert(http_server.router.post_funcs, { pattern = pattern, func = func })
end

------------------------------------------------------------------------------------------------------------

http_server.create = function(port)
    -- create a TCP socket and bind it to the local host, at any port
    http_server.server = assert(socket.tcp())
    http_server.server:setoption('reuseaddr', true)
    assert(http_server.server:bind("*", port))
    http_server.server:listen(http_server.backlog)

    copas.addserver(http_server.server, http_server.handler)
    copas.running = true

    -- Print IP and port
    local ip, newport = http_server.server:getsockname()
    print("[http_server.create] IP:"..ip.."  Port:"..newport.."...")
    return http_server.server
end 

------------------------------------------------------------------------------------------------------------

http_server.start = function()
end

------------------------------------------------------------------------------------------------------------

http_server.update = function()
    -- roughly 60Hz update rate (step depends alot on traffic)
    copas.step(0.01666666)
end

------------------------------------------------------------------------------------------------------------

http_server.html = function( html )

    local resp = "HTTP/1.0 200 OK\nContent-Type: text/html\n\n"
    resp = string.format("%s%s", resp, tostring(html))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.json = function(json)
    local resp = "HTTP/1.0 200 OK\nContent-Type: application/json\n\n"
    resp = string.format("%s%s", resp, tostring(json))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.file = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: application/octet-stream\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.ttf = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: font/truetype\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.woff = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: font/woff2\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end


------------------------------------------------------------------------------------------------------------

http_server.script = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: text/javascript\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.tscript = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: text/x.typescript\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.css = function(data)
    local resp = "HTTP/1.0 200 OK\nContent-Type: text/css\n\n"
    resp = string.format("%s%s", resp, tostring(data))
    return resp
end

------------------------------------------------------------------------------------------------------------

http_server.html_error = function( errno )
    local resp = string.format("HTTP/1.0 %s ERROR\n\n", errno) 
    return resp
end

------------------------------------------------------------------------------------------------------------
-- Because the whole req has already been put into lines, search for the main section header and body
local function get_header_body( lines )

    -- Look for the first line ending with CRLF, then a CRLF on the following line. Then body follows.
    local header = ""
    local body = ""
    local possible_header = false
    local header_done = false
    for i, line in ipairs(lines) do
        -- Dont process the first line (thats the GET part)
        if(i > 1) then 
            if(header_done == false) then 
                header = header..tostring(line).."\n"
            else 
                body = body..tostring(line).."\n"
            end

            if string.match(line, "^\r\n$") and possible_header == true and header_done == false then 
                header_done = true
            end
            if string.match(line, ".-\r\n$") and possible_header == false and header_done == false then 
                possible_header = true
            end
        end
    end
    -- print("------------------- HEADER >>")
    -- print(header)
    -- print("------------------- BODY >>")
    -- print(body)
    return header, body
end

------------------------------------------------------------------------------------------------------------

http_server.process_get = function( req, lines )
    local pfunc = http_server.router.get_funcs
    local header, body = get_header_body(lines)
    for k,v in ipairs(pfunc) do
        local matches = {}
        for capture in string.gmatch(req[2], v.pattern) do
            tinsert(matches, capture)
        end
        if(utils.tcount(matches) > 0) then 
            return  v.func(matches, req, header, body)
        end
    end
    return nil
end 

------------------------------------------------------------------------------------------------------------

http_server.process_post = function( req, lines )
    local pfunc = http_server.router.post_funcs
    print(table.concat(lines, "\n"))
    local header, body = get_header_body(lines)
    for k,v in ipairs(pfunc) do
        local matches = {}
        for capture in string.gmatch(req[2], v.pattern) do
            tinsert(matches, capture)
        end
        if(utils.tcount(matches) > 0) then 
            return v.func(matches, req, header, body)
        end
    end
    return nil
end 

------------------------------------------------------------------------------------------------------------

local function process_requests( req )
    
    -- Break into lines first
    local header = nil
    local lines = utils.csplit( req, "\n")
    if(utils.tcount(lines) == 0) then 
        lines = req 
        header = req 
    else 
        header = lines[1]
    end 

    -- Get first line to determine what sort of req it is. Only process get and post.
    local main_req = utils.csplit( header, " ")
    if(main_req[1] == "GET") then 
        return http_server.process_get(main_req, lines)
    elseif(main_req[1] == "POST") then 
        return http_server.process_post(main_req, lines)
    else 
        return http_server.html_error(404)
    end
end

------------------------------------------------------------------------------------------------------------
-- loop forever waiting for clients
http_server.handler = function(skt)
	
    -- Collate recieve if there is data to read
    local finished = false 
    local data = {}

    while true do 
        local indata, err  = copas.receive(skt)
        print(indata, err)
        if(indata == nil or string.len(indata) == 0 or err ~= nil) then 
            break
        end   
        tinsert(data, indata)
    end

    if(utils.tcount(data) > 0) then 
        local reqdata = tconcat(data, "\n")
        -- print(reqdata)
        -- Process request from client
        local html = process_requests(reqdata)
        if(html) then 
            copas.send(skt, html, 1, string.len(html))
        end
        -- copas.send(skt, "HTTP/1.0 200 OK\n\n\ncopas are you there?")
    end
end 

------------------------------------------------------------------------------------------------------------

http_server.stop = function()

	-- done with client, close the object
    if(http_server.client) then 
	    http_server.client:close()
    end
    http_server.server:close()
	print("http server Terminated")
end

------------------------------------------------------------------------------------------------------------

return http_server

------------------------------------------------------------------------------------------------------------
