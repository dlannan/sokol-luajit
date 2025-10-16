local utils 		    = require("utils")

local route = {
    http_server = nil,
    ecs_server = nil,
    twig = nil,
}

local index_root = {
    pattern = "/index%.html[.+]?$", 
    func = function(matches, stream, headers, body)
        -- local index = utils.loaddata(base_www_path.."index.html")
        index, index_len = route.twig.parse( base_www_path.."index.html" )
        return route.http_server.html(index)
    end,
}

route.routes = {
    index_root,
}

return route 