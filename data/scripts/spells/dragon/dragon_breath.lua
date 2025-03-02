local AREA_DRAGON = {
    {0, 0, 0, 0, 0, 0, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 3, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1436)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Breath")
combat:setArea(createCombatArea(AREA_DRAGON))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Dragon Breath")
spell:words("### Dragon Breath ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
