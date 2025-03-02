local EFFECT_COUNT = 20
local EFFECT_DELAY = 50

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {128}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Epicenter")
combat:setArea(createCombatArea(AREA_WIND))

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(doRandomEffect, i * EFFECT_DELAY, centerPos)
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local centerPos = creature:getPosition()
		if Creature(creature) then
		combat:execute(creature, variant)
		castEffects(centerPos)
		end
    return true
end

spell:name("Epicenter")
spell:words("#Epicenter#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
