local EFFECT_COUNT = 20
local EFFECT_DELAY = 50

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 3, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {250}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Extrasensory")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_STUN)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 332)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-4, 4)
    local randomOffsetY = math.random(-4, 4)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then -- Verifica se a criatura ainda existe
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, Variant(centerPos))

    castEffects(creatureId, centerPos)
    return true
end

spell:name("Extrasensory")
spell:words("#Extrasensory#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

