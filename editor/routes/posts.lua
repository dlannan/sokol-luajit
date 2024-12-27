local utils 		    = require("utils")
local json              = require("json")
local dirtools          = require("tools.vfs.dirtools")

local route = {
    http_server = nil,
    ecs_server = nil,
}

local posts_form = {
    pattern = "/handleform$", 
    func = function(matches, stream, headers, body)
        if body then
            return route.http_server.html("Got form data: " .. tostring(body))
        else
            return route.http_server.html("Got no form data. Using http?")
        end
    end,
}

local posts_systems = {
    pattern = "/systems/enable$", 
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end
        local rdata = json.decode(body)
        local sys = route.ecs_server.current_world.systems[rdata.system.index]
        if( rdata.enabled == true) then
            sys.active = true 
        else
            sys.active = false 
        end
        return route.http_server.html("success")
    end,
}

local posts_cameraenable = {
    pattern = "/world/camera/enable$", 
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        route.ecs_server.change_camera = cdata.go        
        return route.http_server.html("success")
    end,
}

local posts_cameraeffect = {
    pattern = "/world/camera/effect$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        --if(cdata.effect) then msg.post("/ecs", cdata.effect) end
        return route.http_server.html("success")
    end,
}

local posts_assetloaddata = {
    pattern = "/world/assets/loaddata$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        print("Asset Loaddata: ", body)

        local cdata = json.decode(body)
        --if(cdata.effect) then msg.post("/ecs", cdata.effect) end
        if(cdata.filename) then 
            route.ecs_server.assetmgr.loaddata(cdata)
        end
        return route.http_server.json("success")
    end,
}

-- Technically this gets files and folders, but we only show folders and slp's
local posts_projectsysgetfolder = {
    pattern = "/project/sys/get_folder$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)

        if(cdata.folder) then 

            if(cdata.folder == "..") then 
                route.ecs_server.projectmgr.sys.current_folder = dirtools.get_parent(route.ecs_server.projectmgr.sys.current_folder)
            else 
                local path, name, ext = dirtools.fileparts(cdata.folder)
                if(ext ~= "slp") then 
                    route.ecs_server.projectmgr.sys.current_folder = dirtools.combine_path(route.ecs_server.projectmgr.sys.current_folder, cdata.folder)
                end
            end
            route.ecs_server.projectmgr.sys.folders = dirtools.get_dirlist(route.ecs_server.projectmgr.sys.current_folder, true, "slp")
        end
        return route.http_server.json("success")
    end,
}

local posts_projectsysgetdrive = {
    pattern = "/project/sys/get_drive$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        if(cdata.drive) then 
            route.ecs_server.projectmgr.sys.current_folder = cdata.drive
            route.ecs_server.projectmgr.sys.folders = dirtools.get_folderslist(cdata.drive)
        end
        return route.http_server.json("success")
    end,
}

local posts_projectcreate = {
    pattern = "/project/create$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        if(cdata.project) then 
            route.ecs_server.projectmgr:create(cdata.project)
        end
        return route.http_server.json("success")
    end,
} 

local posts_projectload = {
    pattern = "/project/load$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        if(cdata.project) then 
            route.ecs_server.projectmgr:load(cdata.project)
        end
        return route.http_server.json("success")
    end,
} 

route.routes = {
    posts_form,
    posts_systems,

    posts_cameraenable,
    posts_cameraeffect,

    posts_assetloaddata,

    posts_projectcreate,
    posts_projectload,
    posts_projectsysgetdrive,
    posts_projectsysgetfolder,
}

return route