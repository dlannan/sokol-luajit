
local logging   = {}

-- --------------------------------------------------------------------------------------

logging.info    = function( infostr )
    io.write(string.format("[Info] %s\n", infostr))
end

-- --------------------------------------------------------------------------------------

logging.warn    = function( warnstr )
    io.write(string.format("[Warning] %s\n", warnstr))
end

-- --------------------------------------------------------------------------------------

logging.error   = function( errstr )
    io.write(string.format("[Error] %s\n", errstr))
end

-- --------------------------------------------------------------------------------------

return logging

-- --------------------------------------------------------------------------------------