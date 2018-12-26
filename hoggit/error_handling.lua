--- error_handling.lua
-- Adds intelligence to the way scripting errors in DCS are handled.
-- Must be included after hoggit.logging module

local HandleError = function(err)
    log("Error in pcall: "  .. err)
    log(debug.traceback())
    return err
end

--- Adds basic try/catch functionality
-- @param func unsafe function to call
-- @param catch the function to call if func fails
try = function(func, catch)
    return function()
      local r, e = xpcall(func, HandleError)
      if not r then
        return catch(e)
      end
      return r
    end
end

