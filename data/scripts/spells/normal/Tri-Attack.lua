local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Tri-Attack")
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local positions = {
    {x = 1, y = 0},
    {x = -1, y = 0},
    {x = 0, y = 1},
}

local function executeTriAttack(creatureId, variant, times)
    if times > 0 then
        local creature = Creature(creatureId)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        combat:execute(creature, variant)

        local target = Creature(variant:getNumber())
        if target then
            local posIndex = 9 - times
            local targetPos = target:getPosition()
            local effectPos = Position(targetPos.x + positions[posIndex].x, targetPos.y + positions[posIndex].y, targetPos.z)
            effectPos:sendMagicEffect(239)
        end

        addEvent(function()
            if Creature(creatureId) then
                executeTriAttack(creatureId, variant, times - 1)
            end
        end, 300)
    end
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    executeTriAttack(creatureId, variant, 8)
    return true
end

-- Registro da spell
targetSpell:name("Tri-Attack")
targetSpell:words("#Tri-Attack")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(6)
targetSpell:register()
