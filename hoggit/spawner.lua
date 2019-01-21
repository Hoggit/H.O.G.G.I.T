--- spawner.lua
-- Spawning utilities for H.O.G.G.I.T. Framework

--Groups that should be auto-respawned along with their delay, and respawn percentage
HOGGIT.zombies = {}

-- Scheduled functions to check for respawns.  This allows us to queue up functions to check for
-- dead zombies, and by keeping a reference to the scheduled functions ID we can cancel it if 
-- another unit in the same group dies a short while after, and queue up another one, basically
-- batching the dead checks if you kill many units in the same group in quick succession.
HOGGIT.zombie_checks = {}

--[[
Auto generated spawner objects created from the .miz
Example usage:  if you have a red coalition group in the .miz named "Bad Guys":
HOGGIT.spawners.red['Bad Guys']:Spawn()
]]
HOGGIT.spawners = {['neutral'] = {}, ['red'] = {}, ['blue'] = {}}

--[[--
Spawner object that takes a group name from the ME.
Has flexible options for spawning a group once defined. One of these are created for each group that exists 
in the .miz later on (stored in HOGGIT.spawners), but you can also define your own if you'd like to have groups 
that have the same template in the .miz, but have different behaviors 
(like spawning in a different location, or adding respawn options)

Example usage: With a group in your .miz with the name "Good Guys 1":
local good_guys_spawn = HOGGIT.Spawner("Good Guys 1")
local spawned_good_guys_group = good_guys_spawn:Spawn()

@param grpName Name of a group defined in the mission editor
@return HOGGIT.Spawner
]]
HOGGIT.Spawner = function(grpName)
    local GroupName = grpName

    --- holds the function and args that are called when this spawner spawns a group
    local CallBack = {}

    --- Table/Dictionary keyed by a group object with true value if group is alive.
    -- Dead groups will be set to nil and garbage collected
    local SpawnedGroups = {}

    --- Respawn options
    local zombie = false
    local respawn_delay = 60
    local partial_death_threshold_percent = nil
    local partial_death_respawn_delay = respawn_delay

    return {
        --- Spawns a copy of the "template" group in the mission editor 
        -- Spawns the group at the same location and with the same parameters as the 'template' in the mission editor.
        -- @param self HOGGIT.Spawner object
        -- @return Group
        Spawn = function(self)
            local added_grp = Group.getByName(mist.cloneGroup(grpName, true).name)
            if CallBack.func then
            if not CallBack.args then CallBack.args = {} end
            mist.scheduleFunction(CallBack.func, {added_grp, unpack(CallBack.args)}, timer.getTime() + 1)
            end
            SpawnedGroups[added_grp] = true
            if zombie then 
                HOGGIT.setZombie(added_grp, self, true) 
                HOGGIT.debug_text("Spawned new zombie " .. added_grp:getName(), 3) 
            end
            return added_grp
        end,

        --- Same as 'Spawn', but takes an SSE Vec2 (table with an X and Y keys)
        -- @param self HOGGIT.Spawner object
        -- @param point Vec2
        -- @return Group
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
            local added_grp = Group.getByName(name)
            SpawnedGroups[added_grp] = true
            if zombie then HOGGIT.setZombie(added_grp, self, true) end
            return added_grp
            else
                HOGGIT.debug_text("Error spawning " .. grpName, 15)
            end
    
        end,

        --- Same as 'Spawn' but takes a zone name defined in the mission editor
        -- @param self HOGGIT.Spawner object
        -- @param zoneName Name of a zone that's defined in the mission editor
        -- @return Group
        SpawnInZone = function(self, zoneName)
            local added_grp = Group.getByName(mist.cloneInZone(grpName, zoneName).name)
            if CallBack.func then
            if not CallBack.args then CallBack.args = {} end
            mist.scheduleFunction(CallBack.func, {added_grp, unpack(CallBack.args)}, timer.getTime() + 1)
            end
            SpawnedGroups[added_grp] = true
            if zombie then HOGGIT.setZombie(added_grp, self, true) end
            return added_grp
        end,

        --- Add a function with arguments to be called when this Spawner actually spawns a unit
        -- @param self HOGGIT.Spawner
        -- @param f the function to be called, always called with spawned group as first param
        -- @param args table of additional arguments that the callback function will be called with
        OnSpawnGroup = function(self, f, args)
            CallBack.func = f
            CallBack.args = args
        end,

        --[[
        Setup Zombies that respawn upon death!

        Adds groups to the HOGGIT.zombies table for evaulation for respawning.
        @param spawner HOGGIT.Spawner object
        @param respawn_delay Amount of seconds group will respawn after emitting S_EVENT_DEAD event
        @param partial_death_threshold_percent Percentage of dead units in group to consider whole group dead
        @param partial_death_respawn_delay Amount of time that a partially dead unit that meets the threshold percent 
        to be considered completely dead takes to respawn in seconds, default: respawn_delay
        ]]
        SetGroupRespawnOptions = function(
            self, 
            respawn_delay, 
            partial_death_threshold_percent, 
            partial_death_respawn_delay) do
            if partial_death_respawn_delay == nil and partial_death_threshold_percent ~= nil then
                partial_death_respawn_delay = respawn_delay
            end
        
            self:SetZombieOptions({
                ['zombie'] = true,
                ['respawn_delay'] = respawn_delay,
                ['partial_death_threshold_percent'] = partial_death_threshold_percent,
                ['partial_death_respawn_delay'] = partial_death_respawn_delay
                })
            end
        end,

        SetZombieOptions = function(self, options)
            zombie = options['zombie']
            if zombie then
                respawn_delay = options['respawn_delay']
                partial_death_threshold_percent = options['partial_death_threshold_percent']
                if options['partial_death_respawn_delay'] then
                    partial_death_respawn_delay = options['partial_death_respawn_delay']
                else
                    partial_death_respawn_delay = respawn_delay
                end

                HOGGIT.debug_text(GroupName .. " is now a zombie!  Arggghhh!", 10)
            end
        end,

        GetRespawnDelay = function(self, partial)
            if partial then
                return partial_death_respawn_delay
            else
                return respawn_delay
            end
        end,

        GetPartialDeathThresholdPercent = function(self)
            return partial_death_threshold_percent
        end
    }
end

--- Setup the default table of spawners, one for every group in the .miz
HOGGIT.SetupDefaultSpawners = function()
    for cidx, coalitionName in ipairs({'neutral', 'red', 'blue'}) do
        for gidx, group in pairs(coalition.getGroups(cidx - 1)) do
            HOGGIT.spawners[coalitionName][Group.getName(group)] = HOGGIT.Spawner(Group.getName(group))
        end
    end
end

HOGGIT.setZombie = function(group, spawner, state)
    if state then
        HOGGIT.zombies[group:getName()] = spawner
    else
        HOGGIT.zombies[group:getName()] = nil
    end
end

HOGGIT._deathHandler = function(event)
    if event.id == world.event.S_EVENT_CRASH or event.id == world.event.S_EVENT_DEAD then
        HOGGIT.debug_text("SOMETHING DEAD YO", 10)
        if not event.initiator then return end
        if not event.initiator.getGroup then return end

        local grp = event.initiator:getGroup():getName()
        if grp then
            HOGGIT.debug_text("FOUND GROUP", 10)
            if HOGGIT.zombies[grp] then
                HOGGIT.debug_text("CONFIRMED ZOMBIE", 10)
                local spawner = HOGGIT.zombies[grp]
                HOGGIT.debug_text("FOUND SPAWNER", 10)
                if HOGGIT.zombie_checks[spawner] then
                    HOGGIT.debug_text("FOUND SPAWNER CHECK", 10)
                    local s_func_id = HOGGIT.zombie_checks[spawner]
                    mist.removeFunction(s_func_id)
                    HOGGIT.debug_text("Removing dead check id ".. s_func_id .." for group: " .. grp, 10)
                end
                local new_func_id = mist.scheduleFunction(function()
                    HOGGIT.debug_text("STARTING DEAD CHECK", 10)
                    local needs_respawn = false
                    local partial_respawn = false
                    if not HOGGIT.GroupIsAlive(grp) then
                        needs_respawn = true
                        HOGGIT.debug_text("THEY DEAD, RESPAWNIN", 10)
                    elseif spawner:GetPartialDeathThresholdPercent() then
                        HOGGIT.debug_text("CHECKING PERCENT", 10)
                        local group_obj = Group.getByName(grp)
                        local group_size = group_obj:getSize()
                        local initial_size = group_obj:getInitialSize()
                        local percent_alive = group_size / initial_size * 100
                        HOGGIT.debug_text(percent_alive .. " percent alive.  Threshold is " .. spawner:GetPartialDeathThresholdPercent(), 10)
                        if (100 - percent_alive) >= spawner:GetPartialDeathThresholdPercent() then
                            HOGGIT.debug_text("TRIGGERING PARTIAL RESPAWNING", 10)
                            needs_respawn = true
                            partial_respawn = true
                        end
                    end

                    if needs_respawn then
                        HOGGIT.debug_text("GROUP NEEDS RESPAWNING", 10)
                        local delay = spawner:GetRespawnDelay(partial_respawn)
                        HOGGIT.debug_text("DELAY OF " .. delay, 10)
                        HOGGIT.zombies[grp] = nil

                        mist.scheduleFunction(function()
                            HOGGIT.setZombie(spawner.Spawn(), spawner, true)
                        end, {}, timer.getTime() + delay)
                    end
                    HOGGIT.zombie_checks[spawner] = nil

                end, {}, timer.getTime() + 10)
                HOGGIT.debug_text("Scheduled NEW dead check id ".. new_func_id .." for group: " .. grp, 10)
                HOGGIT.zombie_checks[spawner] = new_func_id
            end
        end
    end
end
mist.addEventHandler(HOGGIT._deathHandler)
