local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 238)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Close Combat")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Close Combat")
spell:words("##Close Combat##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(2)
spell:needTarget(true)
spell:register()
