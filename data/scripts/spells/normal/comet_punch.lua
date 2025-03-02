local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 100)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Comet Punch")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Comet Punch")
spell:words("#Comet Punch#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
