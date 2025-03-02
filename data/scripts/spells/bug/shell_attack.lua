local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shell Attack")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    local creatureId = creature:getId()
    local target = creature:getTarget()

    local targetPos = target:getPosition()
    local creaturePos = creature:getPosition()

    local originalOutfit = creature:getOutfit()
    creature:setOutfit({lookType = 0})

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            creature:getPosition():sendDistanceEffect(targetPos, 46)
        end
    end, 100)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            local randomPos = Position(targetPos.x + math.random(-2, 2), targetPos.y + math.random(-2, 2), targetPos.z)
            randomPos:sendDistanceEffect(targetPos, 46)
        end
    end, 500)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            combat:execute(creature, Variant(targetPos))
        end
    end, 1000)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            targetPos:sendDistanceEffect(creaturePos, 46)
        end
    end, 1500)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            creature:setOutfit(originalOutfit)
        end
    end, 1700)

    return true
end

spell:name("Shell Attack")
spell:words("#Shell Attack#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
