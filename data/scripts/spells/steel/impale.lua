local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Impale")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local condition = createConditionObject(CONDITION_BLIND)
condition:setParameter(CONDITION_PARAM_TICKS, 4000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 2200)
combat:addCondition(condition)

local effects = {
    [DIRECTION_NORTH] = 1237,
    [DIRECTION_EAST] = 1237,
    [DIRECTION_SOUTH] = 1237,
    [DIRECTION_WEST] = 1237
}

local offsets = {
    [DIRECTION_NORTH] = {x = 0, y = -1},
    [DIRECTION_EAST] = {x = 1, y = 0},
    [DIRECTION_SOUTH] = {x = 0, y = 1},
    [DIRECTION_WEST] = {x = -1, y = 0}
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()
    local offsetX = offsets[direction].x
    local offsetY = offsets[direction].y

    -- Função para aplicar o efeito
    local function applyEffect(i)
        local targetCreature = Creature(creature:getId())
        if not targetCreature or targetCreature:isRemoved() then
            return false -- Interrompe se a criatura foi removida
        end

        local effectPos = Position(pos.x + offsetX * (2 * i - 1) + adjustX, pos.y + offsetY * (2 * i - 1) + adjustY, pos.z)
        effectPos:sendMagicEffect(effectId)
    end

    -- Agendamento dos eventos para aplicar os efeitos
    for i = 1, 4 do
        addEvent(function()
            local targetCreature = Creature(creature:getId())
            if targetCreature and not targetCreature:isRemoved() then
                applyEffect(i)
            end
        end, (i - 1) * 300)
    end

    combat:execute(creature, variant)
    return true
end

spell:name("Impale")
spell:words("#Impale#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
