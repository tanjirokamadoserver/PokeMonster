local EFFECT_COUNT = 20
local EFFECT_DELAY = 50
local EXECUTION_COUNT = 6
local EXECUTION_INTERVAL = 500

local AREA_WIND = {
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}   
}

local EFFECTS = {971, 972}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shadow Claw")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function getRandomPositionInArea(centerPos)
    local validPositions = {}
    for y = 1, #AREA_WIND do
        for x = 1, #AREA_WIND[y] do
            if AREA_WIND[y][x] == 1 then
                table.insert(validPositions, Position(centerPos.x + x - math.ceil(#AREA_WIND[y] / 2), centerPos.y + y - math.ceil(#AREA_WIND / 2), centerPos.z))
            end
        end
    end
    if #validPositions > 0 then
        return validPositions[math.random(#validPositions)]
    end
    return centerPos
end

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local targetPos = getRandomPositionInArea(centerPos)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)  -- Verifica se a criatura existe
            if creature then  -- Somente executa o efeito se a criatura ainda existir
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

local function executeSpell(creature_id, centerPos, count)
    if count > 0 then
        local creature = Creature(creature_id)
        if not creature then
            return
        end

        combat:execute(creature, Variant(centerPos))
        castEffects(centerPos)

        addEvent(executeSpell, EXECUTION_INTERVAL, creature_id, centerPos, count - 1)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    executeSpell(creature_id, centerPos, EXECUTION_COUNT)
    return true
end

spell:name("Shadow Claw")
spell:words("#Shadow Claw#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
