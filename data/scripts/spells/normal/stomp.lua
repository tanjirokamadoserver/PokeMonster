local AREA_STOMP = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 3, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1202)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stomp")
combat:setArea(createCombatArea(AREA_STOMP))

local condition = Condition(CONDITION_STUN)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 1168)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Stomp")
spell:words("### Stomp ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
