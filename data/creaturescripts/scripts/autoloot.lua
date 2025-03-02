function onKill(player, target)
    if not target:isMonster() then
        return true
    end

    -- local pokeName = string.lower(target:getName())
    -- local mission = kill_missions[pokeName]
    -- if mission then
    --     updatePassMission(player, mission.num, 1)
    -- end
    return true
end