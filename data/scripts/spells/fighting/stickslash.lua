local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 213)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stickslash")

local spell = Spell(SPELL_INSTANT)

local directions = {
    {x = 1, y = 0},
    {x = 1, y = 1},
    {x = 0, y = 1},
    {x = -1, y = 1},
    {x = -1, y = 0},
    {x = -1, y = -1},
    {x = 0, y = -1},
    {x = 1, y = -1}
}

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    local function executeCombat(index)
        if index > #directions then
            return
        end

        -- Verificar se a criatura ainda existe antes de continuar
        local creature = Creature(creature_id)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        local offset = directions[index]
        local targetPosition = Position(position.x + offset.x, position.y + offset.y, position.z)
        local targetTile = Tile(targetPosition)

        if targetTile then
            combat1:execute(creature, variant)
        end

        -- Agendar o próximo evento apenas se a criatura ainda existir
        addEvent(function()
            if Creature(creature_id) then -- Verifica se a criatura ainda existe
                executeCombat(index + 1)
            end
        end, 150)
    end

    -- Inicia o combate com o primeiro índice
    executeCombat(1)
    return true
end

spell:name("Stickslash")
spell:words("### Stickslash ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
