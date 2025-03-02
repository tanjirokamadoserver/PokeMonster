local AREA_SLAP = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 2, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 149)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Multi-Slap")
combat:setArea(createCombatArea(AREA_SLAP))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Multi-Slap")
spell:words("### Multi-Slap ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
