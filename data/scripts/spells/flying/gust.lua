local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Gust")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {0, 3, 0}
}))

local effects = {
    [DIRECTION_NORTH] = 646,
    [DIRECTION_EAST] = 646,
    [DIRECTION_SOUTH] = 646,
    [DIRECTION_WEST] = 646
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

    local function applyEffect(i)
        -- Verifique se a criatura existe antes de continuar
        if not creature or creature:isRemoved() then
            return false
        end

        -- Aplicar efeito apenas em tiles ímpares
        if i % 2 == 1 then
            local effectPos = Position(pos.x + offsetX * i, pos.y + offsetY * i, pos.z)
            effectPos:sendMagicEffect(effectId)
        end
    end

    -- Agendar eventos de efeito
    for i = 1, 6 do
        addEvent(function() 
            -- Verifica se a criatura ainda existe antes de aplicar o efeito
            if creature and not creature:isRemoved() then
                applyEffect(i)
            end
        end, (i - 1) * 300)
    end

    -- Executar o combate
    combat:execute(creature, variant)
    return true
end

spell:name("Gust")
spell:words("#Gust#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()

