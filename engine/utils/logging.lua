
local tinsert   = table.insert

local logging   = {
    logfilename = "data/config/rbuilder.log",
    logfh       = nil,      -- log file handle 
    loglines    = {},       -- As each line is written, its captured for display if needed.
}

-- --------------------------------------------------------------------------------------

logging.write   = function( str )

    logging.fh = logging.fh or io.open(logging.logfilename, "w")
    assert(logging.fh, "[Fatal Error] Cannot open logfile")

    tinsert(logging.loglines, str)

    logging.fh:write(str)
    io.write(str)  -- writes to std out as well
end

-- --------------------------------------------------------------------------------------

logging.info    = function( infostr )
    logging.write(string.format("[Info] %s\n", infostr))
end

-- --------------------------------------------------------------------------------------

logging.warn    = function( warnstr )
    logging.write(string.format("[Warning] %s\n", warnstr))
end

-- --------------------------------------------------------------------------------------

logging.error   = function( errstr )
    logging.write(string.format("[Error] %s\n", errstr))
end

-- --------------------------------------------------------------------------------------

logging.cleanup   = function( )
    if(logging.logfh) then 
        logging.logfh:close()
    end
end

-- --------------------------------------------------------------------------------------

return logging

-- --------------------------------------------------------------------------------------
