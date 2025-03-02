local AREA_UP = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 326)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spit Up")
combat:setArea(createCombatArea(AREA_UP))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
 
    combat:execute(creature, variant)

    return true
end

spell:name("Spit Up")
spell:words("#Spit Up#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
