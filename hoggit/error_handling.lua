HandleError = function(err)
    log("Error in pcall: "  .. err)
    log(debug.traceback())
    return err
end
  
try = function(func, catch)
    return function()
      local r, e = xpcall(func, HandleError)
      if not r then
        return catch(e)
      end
      return r
    end
end

