local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bulldoze")
combat:setArea(createCombatArea({
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 3, 0}
}))

local effects = {
    [DIRECTION_NORTH] = 127,
    [DIRECTION_EAST] = 125,
    [DIRECTION_SOUTH] = 126,
    [DIRECTION_WEST] = 124
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local startPos = creature:getPosition()
    local creatureId = creature:getId()

    -- Função responsável por enviar os efeitos de forma sequencial
    local function sendEffect(index, cid)
        local creature = Creature(cid) -- Recria a referência à criatura
        if not creature then
            return -- Encerra se a criatura não existir mais
        end

        if index > 5 then
            combat:execute(creature, variant)
            return -- Termina após enviar todos os efeitos
        end

        local pos = Position(startPos.x, startPos.y, startPos.z)
        pos:sendMagicEffect(effectId)

        -- Agendamento do próximo efeito
        addEvent(sendEffect, 350, index + 1, cid)
    end

    sendEffect(1, creatureId)
    return true
end

spell:name("Bulldoze")
spell:words("#Bulldoze#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
