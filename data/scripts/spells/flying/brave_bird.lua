local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1296)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Brave Bird")

local speedCondition = createConditionObject(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 10000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 800)
speedCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
speedCondition:setParameter(CONDITION_PARAM_EFFECT, 842)

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    local healthLoss = math.floor(creature:getHealth() * 0.05)
    creature:addHealth(-healthLoss)
    local result = combat:execute(creature, variant)
    creature:addCondition(speedCondition)
    return result
end

targetSpell:name("Brave Bird")
targetSpell:words("Brave Bird")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(5)
targetSpell:register()
