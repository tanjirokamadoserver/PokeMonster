local SHOT_COUNT = 15
local SHOT_DELAY = 100
local MISSILE_EFFECT = 12
local AREA_EFFECT = 355

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
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Falling Rocks")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doShotUp(fromPos, toPos, effect, nextToPosition)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(function()
        doSendDistanceShoot(toPos, nextToPosition, effect)
        doSendMagicEffect(nextToPosition, AREA_EFFECT)
    end, 75)
end

local function doShot(creatureId, centerPos)
    for i = 1, SHOT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)
            if not creature then return end -- Verifica se a criatura ainda existe

            local creaturePos = creature:getPosition()
            local randomOffset = Position(math.random(-3, 3), math.random(-3, 3), 0)
            local targetPos = creaturePos + randomOffset
            local upwardPos = targetPos - Position(9 + math.random(-2, 2), 9 + math.random(-2, 2), 0)

            doShotUp(creaturePos, upwardPos, MISSILE_EFFECT, targetPos)
        end, i * SHOT_DELAY)
    end

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            combat:execute(creature, Variant(centerPos))
        end
    end, SHOT_COUNT * SHOT_DELAY + 100)
end

function spell.onCastSpell(creature, variant)
    doShot(creature:getId(), creature:getPosition())
    return true
end

spell:name("Falling Rocks")
spell:words("#Falling Rocks#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
