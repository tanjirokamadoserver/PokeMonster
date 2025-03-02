local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 130)
combat:setParameter(COMBAT_PARAM_EFFECT, 654)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Iron Tail")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Iron Tail")
spell:words("#Iron Tail#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(3)
spell:needTarget(true)
spell:register()
