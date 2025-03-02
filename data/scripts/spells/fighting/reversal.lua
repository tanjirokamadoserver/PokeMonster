local EFFECT_COUNT = 30
local EFFECT_DELAY = 25

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {1290}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Reversal")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(creature_id, centerPos)
    local creature = Creature(creature_id)
    if not creature then return end
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 4)
    local randomOffsetY = math.random(-3, 4)
    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    doSendDistanceShoot(centerPos, targetPos, 80)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creature_id) then -- Verifica se a criatura ainda existe
                doRandomEffect(creature_id, centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

local function applyPreAttackEffect(creature_id)
    local creature = Creature(creature_id)
    if not creature then return end
    local pos = creature:getPosition()
    pos:sendMagicEffect(2404)
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()
    addEvent(applyPreAttackEffect, 0, creature_id)
    addEvent(function()
        local creature = Creature(creature_id)
        if not creature then return end
        combat:execute(creature, variant)
        castEffects(creature_id, centerPos)
    end, 3000)
    return true
end

spell:name("Reversal")
spell:words("#Reversal#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

