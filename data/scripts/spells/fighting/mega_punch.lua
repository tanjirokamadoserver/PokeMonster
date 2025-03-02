local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mega Punch")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 238)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    combat2:execute(creature, variant)

    return true
end

spell:name("Mega Punch")
spell:words("##Mega Punch##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(2)
spell:needTarget(true)
spell:register()
