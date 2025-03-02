local AREA_Psychic = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_Psychic))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Gyro Ball")

local spell = Spell(SPELL_INSTANT)

local directions = {NORTH, EAST, SOUTH, WEST}

-- Função para girar a direção do Pokémon
local function spinPokemon(creatureId, times, totalDuration)
    local creature = Creature(creatureId)
    if creature and times > 0 then
        local newDirection = directions[((creature:getDirection() + 1) % 4) + 1]
        creature:setDirection(newDirection)
        addEvent(spinPokemon, 100, creatureId, times - 1, totalDuration - 100)
    end
end

-- Função para lançar o projétil
local function launchMissile(creatureId, monsterPos)
    local creature = Creature(creatureId)
    if creature then
        doSendDistanceShoot(creature:getPosition(), monsterPos, 24)
    end
end

-- Função que executa a magia
local function castSpell(creatureId, variant, times)
    local creature = Creature(creatureId)
    if creature and times > 0 then
        local position = creature:getPosition()
        doSendMagicEffect(Position(position.x + 1, position.y + 1, position.z), 2005) -- Efeito ajustado
        combat1:execute(creature, variant)

        local area = {}
        for x = -4, 3 do
            for y = -4, 3 do
                if not (x == 0 and y == 0) then
                    table.insert(area, {x = x, y = y})
                end
            end
        end

        local missileDelay = 0
        local totalMissiles = 0

        -- Lançando os projéteis
        for i = 1, #area do
            local missilePos = Position(position.x + area[i].x, position.y + area[i].y, position.z)
            local tile = Tile(missilePos)
            if tile then
                local monsters = tile:getCreatures()
                if monsters then
                    for _, monster in ipairs(monsters) do
                        if monster:isMonster() then
                            missileDelay = missileDelay + 100
                            totalMissiles = totalMissiles + 1
                            addEvent(function()
                                if Creature(creatureId) then -- Verifica se a criatura ainda existe antes de lançar o projétil
                                    launchMissile(creatureId, monster:getPosition())
                                end
                            end, missileDelay)
                        end
                    end
                end
            end
        end

        -- Recursão para lançar a magia novamente
        addEvent(castSpell, missileDelay + 300, creatureId, variant, times - 1)
        spinPokemon(creatureId, (missileDelay + 300) / 100, missileDelay + 300)
    end
end

-- Função principal da spell
function spell.onCastSpell(creature, variant)
    castSpell(creature:getId(), variant, 5)
    return true
end

spell:name("Gyro Ball")
spell:words("### Gyro Ball ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
