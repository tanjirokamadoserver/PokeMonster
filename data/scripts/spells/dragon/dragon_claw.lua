local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1994)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Claw")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Dragon Claw")
spell:words("##Dragon Claw##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
