
-- This is a stub of how to make a virtual file system append a loader to the package loader system
-- Not sure why other loaders are throw away. I think an insert would be nicer (ie, higher prioerity or similar)

loadfile = function(name, mode, ...)
    local file = load_file(name) -- native function returning data blob
    if file then
        -- :as_chunk() method will do "lua_loadbuffer" and set environment if asked
        return file:as_chunk(name, ...)
    end
    return nil, "cannot open '"..name.."': No such file or directory"
end

dofile = function(name, ...)
    local chunk, err = loadfile(name)
    if not chunk then error(err, 2) end
    return chunk(...)
end

local function vfs_loader(modname, file)
    local chunk, err = file:as_chunk(modname)
    if not chunk then error(err,2) end
    return chunk()
end

local function vfs_searcher(fname)
    local file = load_file(gsub(fname,"%.","/")..".lua")
    if file then
        return vfs_loader, file
    end
end

-- not just insert our searcher, but drop all the rest to disable
-- loading of external files
package.searchers = { package.loaders[1], vfs_searcher }