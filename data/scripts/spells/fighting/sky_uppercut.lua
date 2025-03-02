local AREA_SKY = {
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setArea(createCombatArea(AREA_SKY))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sky Uppercut")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local position = creature:getPosition()

    if direction == DIRECTION_NORTH then
        doSendMagicEffect({x = position.x, y = position.y, z = position.z}, 571)
    elseif direction == DIRECTION_EAST then
        doSendMagicEffect({x = position.x, y = position.y, z = position.z}, 573)
    elseif direction == DIRECTION_SOUTH then
        doSendMagicEffect({x = position.x, y = position.y, z = position.z}, 572)
    elseif direction == DIRECTION_WEST then
        doSendMagicEffect({x = position.x, y = position.y, z = position.z}, 570)
    end

    combat1:execute(creature, variant)

    return true
end

spell:name("Sky Uppercut")
spell:words("### Sky Uppercut ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
