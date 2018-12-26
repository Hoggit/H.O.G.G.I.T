-- Development mode.  This module is defined and configured with a base config
-- in the game install Scripts folder in development mode.
if HOGGIT and HOGGIT.script_base then
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\error_handling.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\logging.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\utils.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\spawner.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\communication.lua]])
    dofile(HOGGIT.script_base..[[\HOGGIT\lib\group.lua]])
else
    -- The dist version of this framework starts with this file in the minification, so we need to define the top
    -- level module right here.
    HOGGIT = {}
end