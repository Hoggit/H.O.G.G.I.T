-- Returns the location of the first unit in a given group.
-- If the group is nil, this function returns nil.
-- @param grp The group you want coordinates for.
-- @return Vec3 The group's first unit's coordinates, or nil if the group is nil
HOGGIT.groupCoords = function(grp)
  if grp ~= nil then
    return grp:getUnits()[1]:getPosition().p
  end
  return nil
end

-- Starts a smoke beacon at the specified group's location
-- @param grp The group to smoke. Will be placed on or near the first unit.
-- @param smokeColor The trigger.smokeColor enum value to use. Defaults to White smoke
HOGGIT.smokeAtGroup = function(grp, smokeColor)
  local pos = HOGGIT.groupCoords(grp)
  if smokeColor == nil then smokeColor = trigger.smokeColor.White end
  trigger.action.smoke(pos, smokeColor)
end
