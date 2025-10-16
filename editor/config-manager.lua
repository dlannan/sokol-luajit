
-- Config manager handles editor config only.

local utils 		    = require("utils")
local json              = require("json")
local dirtools          = require("tools.vfs.dirtools")

---------------------------------------------------------------------------------------    

configmanager   = {
    recents_path    = "data/config/recents.json",
    recents         = {},
}

---------------------------------------------------------------------------------------    

configmanager.load  = function() 

    -- This returns true for folder, false for file and nil for invalid
    local recents_file = dirtools.is_folder(configmanager.recents_path)
    if(recents_file == nil) then 

    elseif(recents_file == false) then 
        local data = utils.loaddata( configmanager.recents_path )
        configmanager.recents = json.decode(data)
    end
end 

---------------------------------------------------------------------------------------    

configmanager.save = function() 

    local fh = io.open(configmanager.recents_path, "w")
    if(fh) then 
        fh:write( json.encode(configmanager.recents) )
        fh:close()
    end
    -- silent fail. 
end 

---------------------------------------------------------------------------------------    

configmanager.add_recent = function(name, path) 
    table.insert(configmanager.recents, { name=name, path=path } )
end

---------------------------------------------------------------------------------------    

return configmanager

---------------------------------------------------------------------------------------    
