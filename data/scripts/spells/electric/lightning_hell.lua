local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Lightning Hell")
combat:setParameter(COMBAT_PARAM_EFFECT, 2143)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 8000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 358)
combat:addCondition(condition)


local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    
    return 
end

targetSpell:name("Lightning Hell")
targetSpell:words("#Lightning Hell")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(5)
targetSpell:register()
