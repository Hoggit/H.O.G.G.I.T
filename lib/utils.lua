HOGGIT.randomInList = function(list)
  local idx = math.random(1, #list)
  return list[idx]
end

HOGGIT.filterTable = function(t, filter)
  local out = {}
  for k,v in pairs(t) do
    if filter(v) then out[k] = v end
  end
  return out
end

HOGGIT.listContains = function(list, elem)
  for _, value in ipairs(list) do
    if value == elem then
      return true
    end
  end

  return false
end

HOGGIT.getLatLongString = function(pos, decimal)
    local lat, long = coord.LOtoLL(pos)
    if decimal == nil then decimal = false end
    return mist.tostringLL(lat, long, 3, decimal)
end

-- Returns a textual smoke name based on the provided enum
-- @param a trigger.smokeColor enum
-- @return the English word as a string representing the color of the smoke. i.e. trigger.smokeColor.Red returns "Red"
HOGGIT.getSmokeName = function(smokeColor)
  if smokeColor == trigger.smokeColor.Green then return "Green" end
  if smokeColor == trigger.smokeColor.Red then return "Red" end
  if smokeColor == trigger.smokeColor.White then return "White" end
  if smokeColor == trigger.smokeColor.Orange then return "Orange" end
  if smokeColor == trigger.smokeColor.Blue then return "Blue" end
end
