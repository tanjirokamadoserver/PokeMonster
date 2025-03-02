local efect = 1217

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Iron Spiner")

if not SOUTHWEST then
    NORTH = 0
    EAST = 1
    SOUTH = 2
    WEST = 3
    SOUTHWEST = 4
    SOUTHEAST = 5
    NORTHWEST = 6
    NORTHEAST = 7
end

function getPosByDir(basePos, dir)
    local pos = Position(basePos)
    if dir == NORTH then
        pos.y = pos.y - 1
    elseif dir == SOUTH then
        pos.y = pos.y + 1
    elseif dir == WEST then
        pos.x = pos.x - 1
    elseif dir == EAST then
        pos.x = pos.x + 1
    elseif dir == NORTHWEST then
        pos.y = pos.y - 1
        pos.x = pos.x - 1
    elseif dir == NORTHEAST then
        pos.y = pos.y - 1
        pos.x = pos.x + 1
    elseif dir == SOUTHWEST then
        pos.y = pos.y + 1
        pos.x = pos.x - 1
    elseif dir == SOUTHEAST then
        pos.y = pos.y + 1
        pos.x = pos.x + 1
    end
    return pos
end

local function rotation_ring(parameters)
    local caster = Creature(parameters.cid)
    if not caster then return end
    if parameters.n > #parameters.directions then return end

    local creaturePos = caster:getPosition()
    local targetPos = getPosByDir(creaturePos, parameters.directions[parameters.n])

    Position(targetPos):sendMagicEffect(efect)
    
    local tile = Tile(targetPos)
    if tile and tile:isWalkable() then
        local creatures = tile:getCreatures()
        if creatures then
            for _, creature in ipairs(creatures) do
                combat:execute(caster, Variant(creature:getId()))
            end
        end
    end

    parameters.n = parameters.n + 1
    addEvent(function()
        -- Verificação de criatura dentro do evento
        rotation_ring(parameters)
    end, parameters.delay)
end

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local directions = {NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST}

    rotation_ring({
        directions = directions,
        delay = 200,
        n = 1,
        cid = creatureId
    })
    
    return true
end

spell:name("Iron Spiner")
spell:words("#Iron Spiner#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
