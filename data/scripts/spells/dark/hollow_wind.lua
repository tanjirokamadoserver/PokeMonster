local AREA_WIND = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat1:setArea(createCombatArea(AREA_WIND))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2447)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hollow Wind")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat1:execute(creature, variant)

    return true
end

spell:name("Hollow Wind")
spell:words("#Hollow Wind#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
