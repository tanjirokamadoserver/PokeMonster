local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1393)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Feint Attack")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    
    combat:execute(creature, variant)

    return true
end

spell:name("Feint Attack")
spell:words("#Feint Attack#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()