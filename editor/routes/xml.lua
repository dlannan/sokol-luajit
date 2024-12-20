local utils 		    = require("utils")

local route = {
    http_server = nil,
    ecs_server = nil,
    twig = nil,
}

local xml_html = {
    pattern = "/(.-%.html)(.-)$",
    func = function(matches, stream, headers, body)
        -- local html = utils.loaddata(base_www_path..matches[1])
        route.ecs_server.html.current_page = matches[1]
        route.ecs_server.html.params = utils.parseurl(matches[2])
        html, html_len = route.twig.parse( matches[1], route.ecs_server )
        return route.http_server.html(html)
    end,
}

local xml_svg = {
    pattern = "/(.*%.svg)$", 
    func = function(matches, stream, headers, body)
        local svg = utils.loaddata(base_www_path..matches[1])		
        return route.http_server.file(svg, base_www_path..matches[1])
    end,
}

route.routes = {
    xml_html,
    xml_svg,
}

return route