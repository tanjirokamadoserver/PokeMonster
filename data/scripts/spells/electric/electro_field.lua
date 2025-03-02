local efect = 1328
local tipu = 1576

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Electro Field")

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
    local pos = basePos
    if (dir == NORTH) then
        pos.y = pos.y - 1
    elseif (dir == SOUTH) then
        pos.y = pos.y + 1
    elseif (dir == WEST) then
        pos.x = pos.x - 1
    elseif (dir == EAST) then
        pos.x = pos.x + 1
    elseif (dir == NORTHWEST) then
        pos.y = pos.y - 1
        pos.x = pos.x - 1
    elseif (dir == NORTHEAST) then
        pos.y = pos.y - 1
        pos.x = pos.x + 1
    elseif (dir == SOUTHWEST) then
        pos.y = pos.y + 1
        pos.x = pos.x - 1
    elseif (dir == SOUTHEAST) then
        pos.y = pos.y + 1
        pos.x = pos.x + 1
    end
    return pos
end

local function rotation_ring(parameters)
    local caster = Creature(parameters.cid)
    if not caster then
        return
    end

    local downPos = parameters.downPos
    local topPos = parameters.topPos

    local gir_table_up = parameters.gir_table_up
    local gir_table_down = parameters.gir_table_down
    if gir_table_up[parameters.n] ~= nil and gir_table_down[parameters.n] then
        local creaturePos = caster:getPosition()

        local oldTopPos = { x = creaturePos.x + topPos.x, y = creaturePos.y + topPos.y, z = creaturePos.z }
        local oldDownPos = { x = creaturePos.x + downPos.x, y = creaturePos.y + downPos.y, z = creaturePos.z }

        topPos = getPosByDir(topPos, gir_table_up[parameters.n])
        downPos = getPosByDir(downPos, gir_table_down[parameters.n])

        local up_pos = { x = creaturePos.x + topPos.x, y = creaturePos.y + topPos.y, z = creaturePos.z }
        local down_pos = { x = creaturePos.x + downPos.x, y = creaturePos.y + downPos.y, z = creaturePos.z }

        parameters.n = parameters.n + 1
        Position(oldTopPos):sendDistanceEffect(up_pos, tipu)
        Position(oldDownPos):sendDistanceEffect(down_pos, tipu)
        Position(up_pos):sendMagicEffect(efect)
        Position(down_pos):sendMagicEffect(efect)

        up_pos.stackpos = 255
        local tileUp = Tile(up_pos)
        if tileUp and tileUp:isWalkable() then
            local creatures = Game.getMonstersFromPos(up_pos)
            if creatures then
                for _, creature in ipairs(creatures) do
                    if creature then
                        combat:execute(caster, Variant(creature:getId()))
                    end
                end
            end
        end

        down_pos.stackpos = 255
        local tileDown = Tile(down_pos)
        if tileDown and tileDown:isWalkable() then
            local creatures = Game.getMonstersFromPos(down_pos)
            if creatures then
                for _, creature in ipairs(creatures) do
                    if creature then
                        combat:execute(caster, Variant(creature:getId()))
                    end
                end
            end
        end

        addEvent(rotation_ring, parameters.delay, {
            up = parameters.up,
            down = parameters.down,
            topPos = topPos,
            downPos = downPos,
            n = parameters.n,
            cid = parameters.cid,
            delay = parameters.delay,
            gir_table_up = parameters.gir_table_up,
            gir_table_down = parameters.gir_table_down
        })
    end
end

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    local center = creature:getPosition()
    local creatureId = creature:getId()

    --Anel Externo
    rotation_ring({
        gir_table_up = { 0, 3, 4, 4, 2, 2, 5, 5, 1, 1, 7, 7, 0, 0, 6, 6, 3, 3, 4, 4, 2, 2, 5, 5, 1, 1, 7, 7, 0, 0, 6, 6, 3 },
        gir_table_down = { 2, 1, 7, 7, 0, 0, 6, 6, 3, 3, 4, 4, 2, 2, 5, 5, 1, 1, 7, 7, 0, 0, 6, 6, 3, 3, 4, 4, 2, 2, 5, 5, 1 },
        delay = 100,
        n = 1,
        cid = creatureId,
        topPos = { x = 0, y = -2, z = 0 },
        downPos = { x = 0, y = 2, z = 0 }
    })
    --Anel do meio
    rotation_ring({
        gir_table_up = { 0, 3, 4, 2, 2, 5, 1, 1, 7, 0, 0, 6, 3, 3, 4, 2, 2, 5, 1, 1, 7, 0, 0, 6, 3, },
        gir_table_down = { 2, 1, 7, 0, 0, 6, 3, 3, 4, 2, 2, 5, 1, 1, 7, 0, 0, 6, 3, 3, 4, 2, 2, 5, 1 },
        delay = 150,
        n = 1,
        cid = creatureId,
        topPos = { x = 0, y = -1, z = 0 },
        downPos = { x = 0, y = 1, z = 0 }
    })
    -- Primeiro anel
    rotation_ring({
        gir_table_up = { 0, 3, 2, 2, 1, 1, 0, 0, 3, 3, 2, 2, 1, 1, 0, 0, 3 },
        gir_table_down = { 2, 1, 0, 0, 3, 3, 2, 2, 1, 1, 0, 0, 3, 3, 2, 2, 1 },
        delay = 200,
        n = 1,
        cid = creatureId,
        topPos = { x = 0, y = 0, z = 0 },
        downPos = { x = 0, y = 0, z = 0 }
    })
    return true
end

spell:name("Electro Field")
spell:words("#Electro Field#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
