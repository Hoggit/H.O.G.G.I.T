-- Returns the location of the first unit in a given group.
-- If the group is nil, this function returns nil.
HOGGIT.groupCoords = function(grp)
  if grp ~= nil then
    return grp:getUnits()[1]:getPosition().p
  end
  return nil
end
