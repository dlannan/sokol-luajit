
local utils         = require("lua.utils")

------------------------------------------------------------------------------------------------------------

local tinsert       = table.insert
local tconcat       = table.concat

------------------------------------------------------------------------------------------------------------

local CMDS  = {
    CMD_NONE          = 0, 

    -- System commands
    CMD_INIT_CONFIG   = 0x0101,
    CMD_INIT_WORLD    = 0x0102,

    -- Assets commands
    CMD_INIT_CONFIG   = 0x0201,
    CMD_INIT_WORLD    = 0x0202,

    -- Scene commands
    CMD_INIT_CONFIG   = 0x0401,
    CMD_INIT_WORLD    = 0x0402,

    -- Entity commands
    CMD_INIT_CONFIG   = 0x0801,
    CMD_INIT_WORLD    = 0x0802,

    -- Scripts commands
    CMD_INIT_CONFIG   = 0x1001,
    CMD_INIT_WORLD    = 0x1002,
    
    -- Performance commands
    CMD_INIT_CONFIG   = 0x1101,
    CMD_INIT_WORLD    = 0x1102,

}


------------------------------------------------------------------------------------------------------------

local commands = {
    -- Incoming commands from the editor to respond to
    queue           = {},
}

------------------------------------------------------------------------------------------------------------

commands.process_command = function(ws, msg)

    print("Processing message: ", msg)
    print(utils.tdump(msg))
    tinsert(commands.queue, msg)
end

------------------------------------------------------------------------------------------------------------

return commands

------------------------------------------------------------------------------------------------------------