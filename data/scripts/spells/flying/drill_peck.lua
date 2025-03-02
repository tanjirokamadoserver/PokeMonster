local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 111)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Drill Peck")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Drill Peck")
spell:words("#Drill Peck#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
