--- Logging.lua
-- Logging utility for HOGGIT framework

if HOGGIT.debug then
    -- Open a log file for use
    logFile = io.open(HOGGIT.log_base..[[\HOGGIT.log]], "w")
end

--- Write a string to the logfile
-- @param str The string to write to the log
function log(str)
    if str == nil then str = 'nil' end
    if HOGGIT.debug and logFile then
        logFile:write("HOGGIT --- " .. str .."\r\n")
        logFile:flush()
    else
        env.info("HOGGIT --- " .. str .. "\r\n")
    end
end
