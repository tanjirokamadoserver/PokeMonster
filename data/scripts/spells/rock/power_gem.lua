local AREA_PULSE = {
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 3, 1, 0, 0}
}

local AREA_PULSE2 = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 3, 1, 0, 0}
}

local AREA_PULSE3 = {
    {0, 0, 1, 3, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2249)
combat:setArea(createCombatArea(AREA_PULSE))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Power Gem")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 351)
combat2:setArea(createCombatArea(AREA_PULSE2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Power Gem")

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 351)
combat3:setArea(createCombatArea(AREA_PULSE3))
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Power Gem")

local spell = Spell(SPELL_INSTANT)
local INTERVAL = 600

local function executePattern(creatureId, variant, startPos, direction, step)
    local function safeExecutePattern()
        local creature = Creature(creatureId)
        if not creature then return end

        local offsets = {
            [DIRECTION_NORTH] = {x = 0, y = -step},
            [DIRECTION_EAST] = {x = step, y = 0},
            [DIRECTION_SOUTH] = {x = 0, y = step},
            [DIRECTION_WEST] = {x = -step, y = 0}
        }

        local offsetX, offsetY = offsets[direction].x, offsets[direction].y
        local newPosition = Position(startPos.x + offsetX, startPos.y + offsetY, startPos.z)
        local newVariant = Variant(newPosition)

        -- Executa o combate de acordo com o passo
        if step == 1 then
            combat3:execute(creature, newVariant)
        else
            combat:execute(creature, newVariant)
            combat2:execute(creature, newVariant)
        end

        -- Agendamento recursivo
        if step < 5 then
            addEvent(function() safeExecutePattern() end, INTERVAL)
        end
    end

    -- Chama a função de execução de forma segura
    safeExecutePattern()
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local startPos = creature:getPosition()
    local direction = creature:getDirection()
    executePattern(creatureId, variant, startPos, direction, 1)
    return true
end

spell:name("Power Gem")
spell:words("#Power Gem#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()

