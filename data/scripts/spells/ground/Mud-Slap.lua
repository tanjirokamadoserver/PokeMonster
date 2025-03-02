local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 700)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mud-Slap")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_SPEED, -200)
combat:addCondition(condition)

local condition2 = createConditionObject(CONDITION_BLIND)
condition2:setParameter(CONDITION_PARAM_TICKS, 10000)
condition2:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition2:setParameter(CONDITION_PARAM_EFFECT, 1216)
combat:addCondition(condition2)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    
    combat:execute(creature, variant)

    return true
end

spell:name("Mud-Slap")
spell:words("##Mud-Slap##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
