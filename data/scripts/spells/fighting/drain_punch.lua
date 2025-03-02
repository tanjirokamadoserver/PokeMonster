local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 1401)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Drain Punch")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 20)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    combat2:execute(creature, variant)

    local healAmount = math.floor(creature:getMaxHealth() * 0.05)
    creature:addHealth(healAmount)
    
    doSendMagicEffect(creature:getPosition(), 552)

    return true
end

spell:name("Drain Punch")
spell:words("##Drain Punch##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
