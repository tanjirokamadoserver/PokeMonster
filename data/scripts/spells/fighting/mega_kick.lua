local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 114)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mega Kick")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Mega Kick")
spell:words("##Mega Kick##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(2)
spell:needTarget(true)
spell:register()
