local SHOT_COUNT = 25
local SHOT_DELAY = 50
local MISSILE_EFFECT = 40

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sandstorm")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_STUN)
condition:setTicks(6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 700)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function applyDamageInArea(creature_id)
    local creature = Creature(creature_id)
    if creature then
        local creaturePos = creature:getPosition()
        combat:execute(creature, Variant(creaturePos))
    end
end

local function doShotDownEffect(toPos)
    toPos:sendMagicEffect(159)
end

local function doShotUp(fromPos, toPos, effect, nextToPosition)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(doSendDistanceShoot, 75, toPos, nextToPosition, effect)
    addEvent(doShotDownEffect, 400, nextToPosition)
end

local function doShot(count, creature_id)
    if count <= 0 then return end

    -- Verifica se a criatura ainda existe antes de continuar
    local creature = Creature(creature_id)
    if not creature then return end

    for i = 1, SHOT_COUNT do
        addEvent(function()
            local creature = Creature(creature_id)
            if not creature then return end -- Verifica novamente dentro do evento

            local creaturePos = creature:getPosition()
            local randomOffsetX = math.random(-3, 3)
            local randomOffsetY = math.random(-3, 3)
            local targetPos = creaturePos + Position(randomOffsetX, randomOffsetY, 0)
            local upwardPos = targetPos - Position(9 + math.random(-2, 2), 9 + math.random(-2, 2), 0)
            
            doShotUp(creaturePos, upwardPos, MISSILE_EFFECT, targetPos)
        end, i * SHOT_DELAY)
    end

    -- Aplica o dano na área depois do último tiro
    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            applyDamageInArea(creature_id)
        end
    end, SHOT_COUNT * SHOT_DELAY)
end

function spell.onCastSpell(creature, variant)
    -- Garantia de que a criatura ainda existe antes de lançar a magia
    local creatureId = creature:getId()
    doShot(SHOT_COUNT, creatureId)
    return true
end

spell:name("Sandstorm")
spell:words("#Sandstorm#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
