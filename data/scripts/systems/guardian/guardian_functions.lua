function Player:summonGuardian(guardianName)
    local guardian = Game.createMonster(guardianName, self:getPosition(), true, true)
    if guardian then
        self:addGuardian(guardian)
        guardian:updateCreatureType()
        local pokemon = self:getSummons()[1]
        if pokemon then
            guardian:removeTarget(pokemon)
        end
        self:say("Vá " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)
        return guardian
    end
end

function Player:despawnGuardian(guardianName)
    local guardians = self:getGuardians()
    for _, guardian in ipairs(guardians) do
        if guardian:getName() == guardianName then
            self:removeGuardian(guardian)
            self:say("Volte " .. guardian:getName() .. "!", TALKTYPE_MONSTER_SAY)
            guardian:remove()
            return true
        end
    end
end

function Player:hasGuardian(guardianName)
    local guardians = self:getGuardians()
    for _, guardian in ipairs(guardians) do
        if guardian:getName() == guardianName then
            return true
        end
    end
    return false
end

local onLogout_Guardian_Player = CreatureEvent("onLogout_guardian")
function onLogout_Guardian_Player.onLogout(player)
    local guardians = player:getGuardians()
    if #guardians == 0 then return true end
    for _, guardian in ipairs(guardians) do
        player:removeGuardian(guardian)
        guardian:remove()
    end
	return true
end
onLogout_Guardian_Player:register()

local guardians_list = {
    [40608] = "Guardian Raikou",
    [40609] = "Guardian Suicune",
    [40610] = "Guardian Entei",
}

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition)
    local guardianName = guardians_list[item:getId()]
    if not player:hasGuardian(guardianName) then
        player:summonGuardian(guardianName)
    else
        player:despawnGuardian(guardianName)
    end
    return true
end

for id in pairs(guardians_list) do
    action:id(id)
end

action:register()