logFile = io.open(HOGGIT.log_base..[[\HOGGIT.log]], "w")

function log(str)
  if str == nil then str = 'nil' end
  if logFile then
    logFile:write("HOGGIT --- " .. str .."\r\n")
    logFile:flush()
  end
end
