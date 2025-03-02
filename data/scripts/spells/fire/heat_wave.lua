local AREA_BURST = {
    {1, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 0, 1},
    {0, 1, 0, 0, 1, 0, 0, 1, 0},
    {0, 1, 0, 0, 1, 0, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 3, 1, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 372)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heat Wave")
combat:setArea(createCombatArea(AREA_BURST))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Heat Wave")
spell:words("### Heat Wave ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
