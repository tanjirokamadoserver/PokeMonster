local AREA_BURNING = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat1:setArea(createCombatArea(AREA_BURNING))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Burn Up")

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 5000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, -100)
combat1:addCondition(speedCondition)

local Condition = createConditionObject(CONDITION_RAGE)
Condition:setParameter(CONDITION_PARAM_TICKS, 10000)
Condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    local position = creature:getPosition()

    doSendMagicEffect(position, 2436)

    combat1:execute(creature, variant)
    creature:addCondition(Condition)

    return true
end

spell:name("Burn Up")
spell:words("### Burn Up ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
