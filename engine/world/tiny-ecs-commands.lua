
local utils         = require("lua.utils")

------------------------------------------------------------------------------------------------------------

local tinsert       = table.insert
local tconcat       = table.concat

------------------------------------------------------------------------------------------------------------

local CMDS  = {
    TEST              = 0, 

    -- System commands
    INIT_CONFIG     = function( msg ) end,
    INIT_WORLD      = function( msg ) end,

    -- Assets commands
    ASSET_LOAD      = function( msg ) end,
    ASSET_DEL       = function( msg ) end,

    -- Scene commands
    SCENE_LOAD      = function( msg ) end,
    SCENE_DEL       = function( msg ) end,
    SCENE_COPY      = function( msg ) end,

    -- Entity commands
    ENTITY_NEW      = function( msg ) end,
    ENTITY_DEL      = function( msg ) end,
    ENTITY_COPY     = function( msg ) end,

    -- Scripts commands
    SCRIPT_LOAD     = function( msg ) end,
    SCRIPT_NEW      = function( msg ) end,
    SCRIPT_DEL      = function( msg ) end,
    SCRIPT_ASSIGN   = function( msg ) end,
    
    -- Performance commands
    PERF_REALTIME   = function( msg ) end,
    PERF_STATS      = function( msg ) end,
}

------------------------------------------------------------------------------------------------------------

local commands = {
    -- Incoming commands from the editor to respond to
    queue           = {},
}

------------------------------------------------------------------------------------------------------------

commands.process_command = function(ws, msg)

    if(type(msg) == "table" and msg.cmd and CMDS[msg.cmd]) then 
        print("Processing message...")
        print(utils.tdump(msg))
        -- Put them in the cmd queue for processing during update pass
        tinsert(commands.queue, msg)
    end
end

------------------------------------------------------------------------------------------------------------

commands.process_queue = function()

    for k, msg in ipairs(commands.queue) do
        CMDS[msg.cmd]( msg )
    end
end

------------------------------------------------------------------------------------------------------------

return commands

------------------------------------------------------------------------------------------------------------