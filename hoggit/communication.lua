--- communication.lua
-- Menu system for groups via the F10 comms menu and messaging groups

HOGGIT.GroupCommandAdded = {}

--- Adds a menu item for the specified Group
-- @param group Group to get the command
-- @param text Text for the menu option
-- @param parent Parent menu item to attach this command to
HOGGIT.GroupCommand = function(group, text, parent, handler)
    if HOGGIT.GroupCommandAdded[tostring(group)] == nil then
        log("No commands from group " .. group .. " yet. Initializing menu state")
        HOGGIT.GroupCommandAdded[tostring(group)] = {}
    end
    if not HOGGIT.GroupCommandAdded[tostring(group)][text] then
        log("Adding " .. text .. " to group: " .. tostring(group))
        callback = try(handler, function(err) log("Error in group command" .. err) end)
        missionCommands.addCommandForGroup(group, text, parent, callback)
        HOGGIT.GroupCommandAdded[tostring(group)][text] = true
    end
end
HOGGIT.GroupMenuAdded = {}
HOGGIT.GroupMenu = function(groupId, text, parent)
    if HOGGIT.GroupMenuAdded[tostring(groupId)] == nil then
        log("No commands from groupId " .. groupId .. " yet. Initializing menu state")
        HOGGIT.GroupMenuAdded[tostring(groupId)] = {}
    end
    if not HOGGIT.GroupMenuAdded[tostring(groupId)][text] then
        log("Adding " .. text .. " to groupId: " .. tostring(groupId))
        HOGGIT.GroupMenuAdded[tostring(groupId)][text] = missionCommands.addSubMenuForGroup(groupId, text, parent)
    end
    return HOGGIT.GroupMenuAdded[tostring(groupId)][text]
end

--- Send a message to a specific group
-- @param groupId ID of the group that should get this message
-- @param text The text that is shown in the message
-- @param displayTime Amount of time in seconds to show the message
-- @param clear if True use the clearview message option which will get rid of the black background in the message area
HOGGIT.MessageToGroup = function(groupId, text, displayTime, clear)
    if not displayTime then displayTime = 10 end
    if clear == nil then clear = false end
    trigger.action.outTextForGroup(groupId, text, displayTime, clear)
end

--- Send a message to all players on the server
-- @param text The text that is shown in the message
-- @param displayTime Amount of time in seconds to show the message
HOGGIT.MessageToAll = function(text, displayTime)
    if not displayTime then displayTime = 10 end
    trigger.action.outText(text, displayTime)
end
