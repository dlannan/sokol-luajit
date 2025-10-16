local utils 		    = require("utils")
local json 		        = require("json")

-- TODO: This needs to go to config or similar
local scripts_lua       = "data/lua/"

local route = {
    http_server = nil,
    ecs_server = nil,
}

local scripts_lua_load_json = {
    pattern = "/(.*%.lua)%??.*$", 
    func = function(matches, stream, headers, body)
        local lua_data = utils.loaddata(base_www_path..scripts_lua..matches[1])	
        -- Convert to json
        local out_tbl = { content = tostring(lua_data) }
        local json_data = json.encode(out_tbl)
        return route.http_server.json(json_data)
    end,
}

local scripts_json = {
    pattern = "/(.*%.json)%??.*$", 
    func = function(matches, stream, headers, body)
        local json_data = utils.loaddata(base_www_path..matches[1])	
        return route.http_server.json(json_data)
    end,
}

local scripts_js = {
    pattern = "/(.*%.js)%??.*$", 
    func = function(matches, stream, headers, body)
        local js = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.script(js)
    end,
}

local scripts_mjs = {
    pattern = "/(.*%.mjs)%??.*$", 
    func = function(matches, stream, headers, body)
        local js = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.script(js)
    end,
}

local scripts_ts = {
    pattern = "/(.*%.ts)%??.*$", 
    func = function(matches, stream, headers, body)
        local ts = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.tscript(ts)
    end,
}

local scripts_css = {
    pattern = "/(.*%.css)%??.*$", 
    func = function(matches, stream, headers, body)
        local css = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.css(css)
    end,
}

local scripts_css_map = {
    pattern = "/(.*%.css.map)$", 
    func = function(matches, stream, headers, body)
        local css = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.file(css, base_www_path..matches[1])
    end,
}

-- Order is important!!
route.routes = {
    scripts_lua_load_json,
    scripts_json,
    scripts_js,
    scripts_ts,
    scripts_mjs,
    scripts_css,
    scripts_css_map,
}

return route