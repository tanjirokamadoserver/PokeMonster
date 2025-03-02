local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 17)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "X-Scissor")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    
    return true
end

spell:name("X-Scissor")
spell:words("### X-Scissor ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
