--[[
spawner.lua

Automatically create a table of all units in the game and create a spawner for them.
]]

HOGGIT = {}

HOGGIT.Spawner = function(grpName)
    local CallBack = {}
    return {
      Spawn = function(self)
        local added_grp = Group.getByName(mist.cloneGroup(grpName, true).name)
        if CallBack.func then
          if not CallBack.args then CallBack.args = {} end
          mist.scheduleFunction(CallBack.func, {added_grp, unpack(CallBack.args)}, timer.getTime() + 1)
        end
        return added_grp
      end,
      SpawnAtPoint = function(self, point)
        local vars = {
          groupName = grpName,
          point = point,
          action = "clone"
        }
  
        local new_group = mist.teleportToPoint(vars)
        if new_group then
          local name = new_group.name
          if CallBack.func then
            if not CallBack.args then CallBack.args = {} end
            mist.scheduleFunction(CallBack.func, {Group.getByName(name), unpack(CallBack.args)}, timer.getTime() + 1)
          end
          return Group.getByName(name)
        else
          trigger.action.outText("Error spawning " .. grpName, 15)
        end
  
      end,
      SpawnInZone = function(self, zoneName)
        local added_grp = Group.getByName(mist.cloneInZone(grpName, zoneName).name)
        if CallBack.func then
          if not CallBack.args then CallBack.args = {} end
          mist.scheduleFunction(CallBack.func, {added_grp, unpack(CallBack.args)}, timer.getTime() + 1)
        end
        return added_grp
      end,
      OnSpawnGroup = function(self, f, args)
        CallBack.func = f
        CallBack.args = args
      end
    }
end

HOGGIT.spawners = {['neutral'] = {}, ['red'] = {}, ['blue'] = {}}

for cidx, coalitionName in ipairs({'neutral', 'red', 'blue'}) do
    for gidx, group in pairs(coalition.getGroups(cidx - 1)) do
        HOGGIT.spawners[coalitionName][Group.getName(group)] = HOGGIT.Spawner(Group.getName(group))
    end
end
