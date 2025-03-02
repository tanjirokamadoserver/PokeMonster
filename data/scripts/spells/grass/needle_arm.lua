local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 1688)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Needle Arm")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_SPEED, -4000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 1500)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, Variant(targetPos))

    return true
end

spell:name("Needle Arm")
spell:words("##Needle Arm##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
