local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 12)
combat:setParameter(COMBAT_PARAM_EFFECT, 12)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rock Throw")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 355)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    combat2:execute(creature, variant)

    return true
end

spell:name("Rock Throw")
spell:words("#Rock Throw#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
