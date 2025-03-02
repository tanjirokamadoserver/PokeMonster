local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 16)
combat:setParameter(COMBAT_PARAM_EFFECT, 814)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Serpents Wrap")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Serpents Wrap")
spell:words("#Serpents Wrap#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
