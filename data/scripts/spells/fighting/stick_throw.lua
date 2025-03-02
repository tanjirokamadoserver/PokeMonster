local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 35)
combat:setParameter(COMBAT_PARAM_EFFECT, 213)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stick Throw")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Stick Throw")
spell:words("#Stick Throw#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
