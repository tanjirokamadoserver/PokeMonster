local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hammer Arm")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local condition = Condition(CONDITION_STUN)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local effects = {
    [DIRECTION_NORTH] = 94,
    [DIRECTION_EAST] = 96,
    [DIRECTION_SOUTH] = 96,
    [DIRECTION_WEST] = 93
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local pos = creature:getPosition()
    local dir = creature:getDirection()

    pos:sendMagicEffect(effects[dir])
    
    combat:execute(creature, variant)
    return true
end

spell:name("Hammer Arm")
spell:words("#Hammer Arm#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
