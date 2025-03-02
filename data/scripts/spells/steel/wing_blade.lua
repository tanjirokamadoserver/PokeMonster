local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wing Blade")
combat:setArea(createCombatArea({
    {1, 3, 1}
}))

local condition = Condition(CONDITION_STUN)
condition:setTicks(1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 1432)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local effects = {
    [DIRECTION_NORTH] = 252,
    [DIRECTION_EAST] = 254,
    [DIRECTION_SOUTH] = 253,
    [DIRECTION_WEST] = 255
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    pos:sendMagicEffect(effectId)

    combat:execute(creature, variant)
    return true
end

spell:name("Wing Blade")
spell:words("#Wing Blade#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
