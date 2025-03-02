local AREA_PULSE = {
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Nuzzle")
combat:setArea(createCombatArea(AREA_PULSE))

local condition = createConditionObject(CONDITION_CONFUSION)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 358)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local effects = {
    [0] = 609,  -- North
    [1] = 610,  -- East
    [2] = 608,  -- South
    [3] = 611,  -- West
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
                    newPosition.y = newPosition.y - 5
                elseif direction == 1 then
                    newPosition.x = newPosition.x + 5
                elseif direction == 2 then
                    newPosition.y = newPosition.y + 5
                elseif direction == 3 then
                    newPosition.x = newPosition.x - 5
                end

                creature:teleportTo(newPosition)
            end
        end, 300, creature:getId())
    end

    return true
end

spell:name("Nuzzle")
spell:words("#Nuzzle#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
