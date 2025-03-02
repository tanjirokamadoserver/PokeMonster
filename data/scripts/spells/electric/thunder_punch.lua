local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 1405)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunder Punch")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 2204)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    combat2:execute(creature, variant)

    return true
end

spell:name("Thunder Punch")
spell:words("##Thunder Punch##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(2)
spell:needTarget(true)
spell:register()
