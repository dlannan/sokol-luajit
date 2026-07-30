
local msgpack           = require "lua.msgpack"
local uv                = require("luv")

local TAG_START         = "MSGPACK_START"
local TAG_END           = "MSGPACK_END"

local TAG_START_LEN     = #TAG_START + 1
local TAG_END_LEN       = #TAG_END + 1

--------------------------------------------------------------------------------------------------

local function try_reader(fn, ...)
    local err
    local ok, res = xpcall(fn, function(msg)
        local item = core.error("%s", msg)
        item.info = debug.traceback(nil, 2):gsub("\t", "")
        err = msg
    end, ...)
    if ok then
        return true, res
    end
    return false, err
end

--------------------------------------------------------------------------------------------------

local function endsWith(str, suffix)
    return str:sub(-#suffix) == suffix
end

--------------------------------------------------------------------------------------------------

local function startsWith(str, suffix)
    return str:sub(1, #suffix) == suffix
end

--------------------------------------------------------------------------------------------------
-- Setup a read stream to process a message pack chunk of data
local function read_chunk(reader, output_func)

    assert(reader, "msgpack reader should not be nil!!")

    local reading       = 0
    local reading_done  = nil
    local total         = ""

    reader:read_start(function(err, chunk)
        assert(not err, err)
        if chunk == nil then 
            return
        end 
        -- There may be multiple blocks to read within a single chunk!
        if startsWith(chunk, TAG_START) then
            chunk = string.sub(chunk, TAG_START_LEN)
            reading = 1
            for block in string.gmatch(chunk, string.format("%s(.-)%s", TAG_START, TAG_END)) do 
                if(output_func) then 
                    -- print(total)
                    local data = msgpack.unpack(block)
                    output_func(data) 
                end    
                chunk = ""
            end
        end
        if endsWith(chunk, TAG_END) then
            chunk = string.sub(chunk, 1, -TAG_END_LEN)
            reading_done = true
        end 
        reading = reading + 1
        if(reading > 0) then 
            total = total..chunk
        end 
        if(reading_done) then 
            if(output_func) then 
                -- print(total)
                local data = msgpack.unpack(total)
                output_func(data) 
            end
            reading_done = nil
            total = ""
            reading = 0
        end
    end)
end 

--------------------------------------------------------------------------------------------------

local function write_chunk( writer, data )
    assert(writer, "msgpack writer should not be nil!!")
    writer:write(TAG_START)
    writer:write(msgpack.pack(data))
    writer:write(TAG_END)
end

--------------------------------------------------------------------------------------------------

return {
    read_chunk          = read_chunk,
    write_chunk         = write_chunk,
}

--------------------------------------------------------------------------------------------------
