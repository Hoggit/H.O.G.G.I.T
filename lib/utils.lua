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
