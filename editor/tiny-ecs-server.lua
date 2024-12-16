------------------------------------------------------------------------------------------------------------
-- State - Tiny ECS server
--
-- Decription: A simple http server for interrogating ecs scene
-- 				Can debug ecs objects
--				Can update objects remotely from http (localip)
------------------------------------------------------------------------------------------------------------

local tinsert 		= table.insert

local utils 		= require("lua.utils")
local json          = require("lua.json")
local tf 			= require("lua.transforms")
local tiny          = require("editor.tiny-ecs")
local http_server   = require("lua.https-server")

local fps 		    = require("lua.metrics.fps")
local mem 		    = require("lua.metrics.mem")

local twig          = require("editor.twig.twig")
local dirtools      = require("tools.vfs.dirtools")

base_www_path       = "editor/www/"

------------------------------------------------------------------------------------------------------------

local tinyserver	= {

    entities            = {},
    entities_lookup     = {},
    cameras_lookup      = {},
    
    change_camera       = nil,
    current_camera      = "camera",

    update              = true,
    fps                 = 0,
    mem                 = 0, 
    deltas              = {},

    vars                = {},
}

------------------------------------------------------------------------------------------------------------

tinyserver.port            = 9190
tinyserver.host            = "127.0.0.1"

BACKLOG                        = 5

tinyserver.updateRate     = 1.0  -- per second
tinyserver.lastUpdate     = 0.0 

------------------------------------------------------------------------------------------------------------

local routes = {
    index       = require("editor.routes.index"),
    scripts     = require("editor.routes.scripts"),
    fonts       = require("editor.routes.fonts"),
    images      = require("editor.routes.images"),
    custom      = require("editor.routes.custom"),
    xml         = require("editor.routes.xml"),
    posts       = require("editor.routes.posts"),
}

tinyserver.routes = routes

------------------------------------------------------------------------------------------------------------

local function register_get( route )

    routes[route].ecs_server = tinyserver 
    routes[route].http_server = http_server
    routes[route].twig = twig

    for k,v in ipairs(routes[route].routes) do 
        http_server.router.get( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function register_post( route )

    routes[route].ecs_server = tinyserver 
    routes[route].http_server = http_server
    routes[route].twig = twig

    for k,v in ipairs(routes[route].routes) do 
        http_server.router.post( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function startServer( host, port )
    
    tinyserver.http_server = http_server.create(port)

    -- Add routes here if you need to load in specific asset/mime types
    register_get( "custom")

    register_get( "scripts")
    register_get( "fonts")
    register_get( "images")
    register_get( "xml")
    
    register_post( "posts")

    register_get( "index")

    http_server.router.unhandled(function(method, uri, stream, headers, body)
        return tinyserver.http_server.html("404 - cannot find endpoint.", http_server.NOT_FOUND)
    end)
    http_server.start()
end 

------------------------------------------------------------------------------------------------------------
-- This occurs on every entity 
tinyserver.entitySystemProc = function(self, e, dt)

    if(tinyserver.update == false) then return end 
    
    if( e.id and tinyserver.entities_lookup[e.id] ) then 
        
        -- Continually updates the entities
        local idx = tinyserver.entities_lookup[e.id]
        if(idx) then 
            tinyserver.entities[idx] = e
            -- Check for pos/rot updates - check for gamne object 
            if(e.go) then 
                local go = {} --gameobject.get_go(e.go)
                e.pos = go.pos
                e.rot = go.rot
                e.scale = go.scale
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

tinyserver.setSystems = function( systems )
    tinyserver.systems = systems
end

------------------------------------------------------------------------------------------------------------

tinyserver.setWorlds = function( worlds )
    tinyserver.worlds = worlds
end

------------------------------------------------------------------------------------------------------------

tinyserver.setEntities = function(  entities, entities_lookup, cameras_lookup )
    tinyserver.entities = entities
    tinyserver.entities_lookup = entities_lookup
    tinyserver.cameras_lookup = cameras_lookup
end

------------------------------------------------------------------------------------------------------------

tinyserver.findGo = function( go )
    for k,v in pairs(tinyserver.entities) do 
        if (v.go == go) then return v end 
    end 
    return nil
end

------------------------------------------------------------------------------------------------------------

tinyserver.init = function()

    local base_path = dirtools.get_app_path()
    local editor_path = dirtools.combine_path(base_path, "editor")
    editor_path = dirtools.combine_path(editor_path, "www")

    tinyserver.vars = {}
    twig.init( editor_path, tinyserver )

    -- Start the server
    startServer( tinyserver.host, tinyserver.port)
end

------------------------------------------------------------------------------------------------------------

tinyserver.update = function ()
    if(tinyserver.change_camera) then 
        print('Changing camera to: '..tinyserver.change_camera)
        -- msg.post(tinyserver.current_camera, "release_camera_focus")
        -- msg.post(tinyserver.change_camera, "acquire_camera_focus")
        tinyserver.current_camera = tinyserver.change_camera
        tinyserver.change_camera = nil
    end

    -- metrics updated 
    tinyserver.fps = fps.fps()
    tinyserver.mem = mem.mem()
    tinyserver.deltas = fps.deltas()
    
    http_server.update()
end

------------------------------------------------------------------------------------------------------------

tinyserver.final = function(self)
    http_server.stop()
end

------------------------------------------------------------------------------------------------------------

return tinyserver

------------------------------------------------------------------------------------------------------------