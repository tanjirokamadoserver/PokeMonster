local AREA_BOX = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat1:setArea(createCombatArea(AREA_BOX))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Black Box")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    doSendMagicEffect(position, 2515)

    combat1:execute(creature, variant)

    return true
end

spell:name("Black Box")
spell:words("### Black Box ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
