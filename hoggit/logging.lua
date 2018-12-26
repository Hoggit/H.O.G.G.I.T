--- Logging.lua
-- Logging utility for HOGGIT framework

-- Open a log file for use
logFile = io.open(HOGGIT.log_base..[[\HOGGIT.log]], "w")

--- Write a string to the logfile
-- @param str The string to write to the log
function log(str)
    if str == nil then str = 'nil' end
    if logFile then
        logFile:write("HOGGIT --- " .. str .."\r\n")
        logFile:flush()
    end
end
