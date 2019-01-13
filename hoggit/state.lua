--- state.lua
-- State management functionality for saving things placed by players in ctld

if _G['lfs'] == nil or _G['io'] == nil or ctld == nil or mist == nil or json == nil then
    log("State functionality unavailable.  Make sure your install has DCS sanitization disabled and MIST+CTLD is loaded first.")
    HOGGIT.state.write_state = function()end
    HOGGIT.state.enumerateCTLD = function()end
else
    HOGGIT.state = {}
    HOGGIT.state.game_state = {

    }

    HOGGIT.state.write_state = function()
        log("Writing State...")
        local stateFile = lfs.writedir() .. HOGGIT.state.state_file
        local fp = io.open(stateFile, 'w')
        fp:write(json:encode(HOGGIT.state.game_state))
        fp:close()
        log("Done writing state.")
    end

    mist.scheduleFunction(HOGGIT.state.write_state, {}, timer.getTime() + HOGGIT.state.save_interval, HOGGIT.state.save_interval)

    -- update list of active CTLD AA sites in the global game state
    function enumerateCTLD()
        local CTLDstate = {}
        log("Enumerating CTLD")
        for _groupname, _groupdetails in pairs(ctld.completeAASystems) do
            local CTLDsite = {}
            for k,v in pairs(_groupdetails) do
                CTLDsite[v['unit']] = v['point']
            end
            CTLDstate[_groupname] = CTLDsite
        end
        HOGGIT.state.game_state.hawks = CTLDstate
        log("Done Enumerating CTLD")
    end

    ctld.addCallback(function(_args)
        if _args.action and _args.action == "unpack" then
            local name
            local groupname = _args.spawnedGroup:getName()
            if string.match(groupname, "Hawk") then
                name = "hawk"
            elseif string.match(groupname, "Avenger") then
                name = "avenger"
            elseif string.match(groupname, "M 818") then
                name = 'ammo'
            elseif string.match(groupname, "Gepard") then
                name = 'gepard'
            elseif string.match(groupname, "MLRS") then
                name = 'mlrs'
            elseif string.match(groupname, "Hummer") then
                name = 'jtac'
            end

            table.insert(HOGGIT.state.game_state.ctld_assets, {
                name=name,
                pos=GetCoordinate(Group.getByName(groupname))
            })

            enumerateCTLD()
            write_state()
        end
    end)

    HOGGIT.state.load_state = function()
        local statefile = io.open(lfs.writedir() .. HOGGIT.state.state_file, 'r')
        
    end
end