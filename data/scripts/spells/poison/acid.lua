local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 15)
combat:setParameter(COMBAT_PARAM_EFFECT, 21)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Acid")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Acid")
spell:words("#Acid#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
