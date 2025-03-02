local AREA_THUNDER = {
    {1, 0, 0, 1, 0, 0, 1},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {1, 1, 1, 2, 1, 1, 1},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {1, 0, 0, 1, 0, 0, 1}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setArea(createCombatArea(AREA_THUNDER))
combat1:setParameter(COMBAT_PARAM_EFFECT, 1333)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunder")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 336)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    local position = creature:getPosition()

    doSendMagicEffect(position, 2422)

    combat1:execute(creature, variant)

    return true
end

spell:name("Thunder")
spell:words("### Thunder ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
