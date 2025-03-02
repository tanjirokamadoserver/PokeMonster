local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 10000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 400)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 13)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()
    position:sendMagicEffect(927)
    combat:execute(creature, variant)
	creature:addCondition(speedCondition)
    return true
end

spell:name("Quiver Dance")
spell:words("### Quiver Dance ###")
spell:needLearn(false)
spell:register()
