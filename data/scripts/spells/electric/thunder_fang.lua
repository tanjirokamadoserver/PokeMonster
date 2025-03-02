local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 1482)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunder Fang")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Thunder Fang")
spell:words("##Thunder Fang##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
