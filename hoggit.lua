-- Development mode.  This module is defined and configured with a base config
-- in the game install Scripts folder in development mode.
if HOGGIT and HOGGIT.script_base then
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\error_handling.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\logging.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\utils.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\spawner.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\communication.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\hoggit\group.lua]])
else
    -- The dist version of this framework starts with this file in the minification, so we need to define the top
    -- level module right here.
    HOGGIT = {}
end

if trigger.misc.getUserFlag(9999) then 
    trigger.action.outText("DEBUG MODE ON", 10)
    HOGGIT.debug = true
    HOGGIT.debug_text = function(text, time)
        trigger.action.outText(text, time)
    end
else
    HOGGIT.debug = false
    HOGGIT.debug_text = function()end
end