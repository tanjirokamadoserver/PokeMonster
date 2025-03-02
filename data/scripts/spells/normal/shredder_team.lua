local AREA_TOMBS = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 3, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE) 
combat:setParameter(COMBAT_PARAM_EFFECT, 383) 
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shredder Team")
combat:setArea(createCombatArea(AREA_TOMBS))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    creature:addHealth(-creature:getHealth())
    return true
end

spell:name("Shredder Team")
spell:words("### Shredder Team ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
