HOGGIT.GroupCommandAdded = {}
HOGGIT.GroupCommand = function(group, text, parent, handler)
  if HOGGIT.GroupCommandAdded[tostring(group)] == nil then
    log("No commands from group " .. group .. " yet. Initializing menu state")
    HOGGIT.GroupCommandAdded[tostring(group)] = {}
  end
  if not HOGGIT.GroupCommandAdded[tostring(group)][text] then
    log("Adding " .. text .. " to group: " .. tostring(group))
    callback = try(handler, function(err) log("Error in group command" .. err) end)
    missionCommands.addCommandForGroup( group, text, parent, callback)
    HOGGIT.GroupCommandAdded[tostring(group)][text] = true
  end
end
HOGGIT.GroupMenuAdded={}
HOGGIT.GroupMenu = function( groupId, text, parent )
  if HOGGIT.GroupMenuAdded[tostring(groupId)] == nil then
    log("No commands from groupId " .. groupId .. " yet. Initializing menu state")
    HOGGIT.GroupMenuAdded[tostring(groupId)] = {}
  end
  if not HOGGIT.GroupMenuAdded[tostring(groupId)][text] then
    log("Adding " .. text .. " to groupId: " .. tostring(groupId))
    HOGGIT.GroupMenuAdded[tostring(groupId)][text] = missionCommands.addSubMenuForGroup( groupId, text, parent )
  end
  return HOGGIT.GroupMenuAdded[tostring(groupId)][text]
end

HOGGIT.MessageToGroup = function(groupId, text, displayTime, clear)
  if not displayTime then displayTime = 10 end
  if clear == nil then clear = false end
  trigger.action.outTextForGroup( groupId, text, displayTime, clear)
end

HOGGIT.MessageToAll = function( text, displayTime )
  if not displayTime then displayTime = 10 end
  trigger.action.outText( text, displayTime )
end
