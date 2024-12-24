
-- Assets are loaded globally, but they can be unloaded (to conserve memory) while maintain
--   handles for instant/fast reloads. 
-- Worlds hold asset id's and 'in-memory' asset references (handles)
-- Groups tag assets that need to be loaded/unloaded together within a world 
--   depending on the developers own criteria ie: location loading, cutscene loading etc.

local dirtools      = require("tools.vfs.dirtools")
local utils         = require("utils")

------------------------------------------------------------------------------------------------------------

local assetmanager = {

    assets          = {},
    asset_count     = 0,

    -- Used for scenes to pool assets for a group
    cache           = {},
}

------------------------------------------------------------------------------------------------------------
-- This limits asset loading. Only registered supported types here.
-- Each type will have its own loader that is used in assetmanager.load()
-- This will grow. And is likely to change. Beware.

local ASSETTYPES = {
    ["png"]       = function(filename)  end,
    ["jpg"]       = function(filename)  end,
    ["gltf"]      = function(filename)  end,
    ["glb"]       = function(filename)  end,
    ["lua"]       = function(filename)  end,
    ["lcc"]       = function(filename)  end,
    ["ogg"]       = function(filename)  end,
    ["glsl"]      = function(filename)  end,
    ["shc"]       = function(filename)  end,
}

------------------------------------------------------------------------------------------------------------
-- Reset asset manager or make a new one.

assetmanager.init   = function()

    -- May add unloading all assets before this. However lua should free the handles and release the mem
    assetmanager.assets          = {}
    assetmanager.asset_count     = 0
    assetmanager.cache           = {}   
end

------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------
-- Load an asset into the pool. 
--   Returns: asset uid, asset name, asset type

assetmanager.load   = function( filename )

    local assetinfo = nil
    local path, filestr, ext = dirtools.getparts(filename)
    ext = string.lower(ext)
    print(path, filestr, ext)

    if(ext and ASSETTYPES[ext]) then 
        print("Valid asset: "..filename)
    end
    return assetinfo
end

------------------------------------------------------------------------------------------------------------

return assetmanager

------------------------------------------------------------------------------------------------------------