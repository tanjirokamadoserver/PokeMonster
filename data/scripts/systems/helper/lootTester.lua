function Player.generateLootTest(self, monsterName, quantity)
    local mType = MonsterType(monsterName)
    if not mType then
        return error("MonsterType não existe: " .. monsterName)
    end
    local zoneId = self:getZoneId()
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    for i = 1, quantity do
        local monsterLoot = mType:getLoot()
        for j = 1, #monsterLoot do
            backpack:createLootItem(monsterLoot[j], zoneId, self)
            print(i)
        end
    end
end