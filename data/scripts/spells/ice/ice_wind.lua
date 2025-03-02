local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 703)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ice Wind")
combat:setArea(createCombatArea({
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
}))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    
    return true
end

spell:name("Ice Wind")
spell:words("#Ice Wind#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
