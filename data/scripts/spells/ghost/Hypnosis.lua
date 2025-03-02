local acombat = createCombatObject()
acombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
acombat:setParameter(COMBAT_PARAM_EFFECT, 1487)
acombat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hypnosis")

local area = createCombatArea(
{
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
}
)

acombat:setArea(area)

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 5000) 
condition:setParameter(CONDITION_PARAM_SPEED, -500)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 500)
condition:setParameter(CONDITION_PARAM_EFFECT, 33)
acombat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    acombat:execute(creature, variant)
    return true
end

spell:name("Hypnosis")
spell:words("#Hypnosis#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
