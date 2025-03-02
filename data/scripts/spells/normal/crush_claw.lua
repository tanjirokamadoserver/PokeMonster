local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 7)
combat:setParameter(COMBAT_PARAM_EFFECT, 1680)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Crush Claw")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

        combat:execute(creature, variant)
        
    return true
end

spell:name("Crush Claw")
spell:words("#Crush Claw#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
