local AREA_FLATTER = {
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},  
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1300)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Flatter")
combat:setArea(createCombatArea(AREA_FLATTER))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Flatter")
spell:words("#Flatter#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
