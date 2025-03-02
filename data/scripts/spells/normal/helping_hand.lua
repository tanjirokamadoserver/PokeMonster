local AREA_HAND = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_HAND))

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 10000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 2000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 10000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 13)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()
	
    doSendMagicEffect(position, 1800)

    combat1:execute(creature, variant)
    creature:addCondition(speedCondition)

    return true
end

spell:name("Helping Hand")
spell:words("### Helping Hand ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
