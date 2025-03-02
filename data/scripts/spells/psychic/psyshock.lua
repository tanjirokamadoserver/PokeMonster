local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psyshock")

local spell = Spell(SPELL_INSTANT)

local function calculatePositionWithOffset(startPosition, direction, distance)
    local offset = {
        [0] = {x = 0, y = -1}, -- NORTH
        [1] = {x = 1, y = 0},  -- EAST
        [2] = {x = 0, y = 1},  -- SOUTH
        [3] = {x = -1, y = 0}  -- WEST
    }
    return Position(
        startPosition.x + (offset[direction].x * distance),
        startPosition.y + (offset[direction].y * distance),
        startPosition.z
    )
end

local function calculateVisualPosition(startPosition, direction, offsetX, offsetY, distance)
    local basePosition = calculatePositionWithOffset(startPosition, direction, distance)
    return Position(
        basePosition.x + offsetX,
        basePosition.y + offsetY,
        startPosition.z
    )
end

function spell.onCastSpell(creature, variant)
    local startPosition = creature:getPosition()
    local direction = creature:getDirection()
    local creatureId = creature:getId()
    local offsetX, offsetY = 1, 1

    for i = 1, 6 do
        addEvent(function()
            local currentCreature = Creature(creatureId) -- Verifica se a criatura ainda existe
            if not currentCreature then
                return -- Interrompe se a criatura não existir
            end

            local damagePosition = calculatePositionWithOffset(startPosition, direction, i)
            local visualPosition = calculateVisualPosition(startPosition, direction, offsetX, offsetY, i)

            combat:execute(currentCreature, Variant(damagePosition))
            doSendMagicEffect(visualPosition, 2109)
        end, i * 300)
    end

    return true
end

spell:name("Psyshock")
spell:words("### Psyshock ###")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
