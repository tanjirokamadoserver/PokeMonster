local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 21)
combat:setParameter(COMBAT_PARAM_EFFECT, 389)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shadow Punch")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Shadow Punch")
spell:words("#Shadow Punch#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
