local AREA_PULSE = {
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Mist")
combat:setArea(createCombatArea(AREA_PULSE))

local spell = Spell(SPELL_INSTANT)

local effects = {
    [0] = 591,  -- North
    [1] = 588,  -- East
    [2] = 590,  -- South
    [3] = 589,  -- West
}

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local position = creature:getPosition()
    local effectID = effects[direction]

    if not effectID then return false end

    local hit = combat:execute(creature, variant)
    position:sendMagicEffect(effectID)

    if hit then
        addEvent(function(cid)
            local creature = Creature(cid)
            if creature then
                local newPosition = position

                if direction == 0 then
                    newPosition.y = newPosition.y - 4
                elseif direction == 1 then
                    newPosition.x = newPosition.x + 4
                elseif direction == 2 then
                    newPosition.y = newPosition.y + 4
                elseif direction == 3 then
                    newPosition.x = newPosition.x - 4
                end

                creature:teleportTo(newPosition)
            end
        end, 300, creature:getId())
    end

    return true
end

spell:name("Dragon Mist")
spell:words("#Dragon Mist#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()