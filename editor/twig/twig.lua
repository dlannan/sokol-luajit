
local ffi       = require 'ffi'
local utils     = require("utils")

----------------------------------------------------------------------------------------------
--- main options
local aspect = require("aspect.template").new({
    debug       = true,
    -- cache       = false,
})

----------------------------------------------------------------------------------------------

local filters = require("aspect.filters")

filters.add("startsWith", {
    input = "string", -- input value type
    output = "boolean", -- output value type
    -- define foo's arguments
    args = {
        [1] = {name = "text", type = "string"}, 
        [2] = {name = "test", type = "string"}
    }
}, function (v, text, test) 
    if(test == nil or text == nil) then return false end
    return text:find(test, 1, true) == 1
end)

----------------------------------------------------------------------------------------------

local function init( www_path )

    aspect.loader = require("aspect.loader.filesystem").new( www_path )
end 

----------------------------------------------------------------------------------------------

local function parse( fullpath, vars )

    local output, err = aspect:render(fullpath, vars)
    if(err) then
        local errfile = io.open("aspect-error.log", "w")
        errfile:write( tostring(err) )
        errfile:close()
        print("Error in twig parse: ", fname)
    end
    local outputstr = tostring(output)
    return outputstr, #outputstr
end

-----------------------------------------------------------------------------------------------

return {

    init = init,
    parse = parse,
}

----------------------------------------------------------------------------------------------
