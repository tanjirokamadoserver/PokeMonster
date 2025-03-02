local AREA_BOMB = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat1:setArea(createCombatArea(AREA_BOMB))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2223)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Touch")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 89)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat1:execute(creature, variant)
    return true
end

spell:name("Poison Touch")
spell:words("### Poison Touch ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
