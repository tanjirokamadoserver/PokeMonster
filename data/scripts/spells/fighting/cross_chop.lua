local AREA_CHOP = {
    {1, 3, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setArea(createCombatArea(AREA_CHOP))
combat:setParameter(COMBAT_PARAM_EFFECT, 702)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Cross Chop")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Cross Chop")
spell:words("##Cross Chop##")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
