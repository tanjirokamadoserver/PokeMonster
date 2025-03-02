local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 325)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psywave")

local area = createCombatArea{
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
}

combat:setArea(area)

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Psywave")
spell:words("#Psywave#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
