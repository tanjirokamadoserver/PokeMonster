local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Brick Break")
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
    [DIRECTION_NORTH] = 1290,
    [DIRECTION_EAST] = 1290,
    [DIRECTION_SOUTH] = 1290,
    [DIRECTION_WEST] = 1290
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]

    creature:getPosition():sendMagicEffect(effectId)
    
    combat:execute(creature, variant)
    return true
end

spell:name("Brick Break")
spell:words("#Brick Break#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
