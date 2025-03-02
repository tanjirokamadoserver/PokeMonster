local config = {
    ["shiny rampardos"] = {
        effectId = 1690,
        missileId = 188,
        missileId2 = 187,
    },

    ["default"] = {
        effectId = 2114,
        missileId = 29,
        missileId2 = 29,
    },
}

local acombat = Combat()
local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Blizzard")

local area = createCombatArea(
{
    {1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1},
    {0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0},
    {1, 1, 0, 0, 0, 3, 0, 1, 0, 0, 1},
    {0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0},
    {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1}
}
)
local area2 = createCombatArea(
{
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}
)
combat:setArea(area2)
acombat:setArea(area)

local function Down(p)
    local creature = Creature(p.cid)
    if not creature then
        return
    end

    local params = config[creature:getName():lower()]
    if not params then
        params = config["default"]
    end

    Position({x = p.pos.x - 7, y = p.pos.y - 5, z = p.pos.z}):sendDistanceEffect(p.pos, params.missileId)
    Position(p.pos):sendMagicEffect(params.effectId)
end

local function Up(p)
    local creature = Creature(p.cid)
    if not creature then
        return
    end

    local params = config[creature:getName():lower()]
    if not params then
        params = config["default"]
    end
    
    local pos = creature:getPosition()
    pos:sendDistanceEffect({x = pos.x - math.random(6,8), y = pos.y - 5, z = pos.z}, params.missileId2)
    addEvent(Down, 500, p)
end

function onTargetTile(creature, pos)
    if (math.random(0,2) >= 1) then
        addEvent(function()
            if Creature(creature:getId()) then -- Verifica se a criatura ainda existe
                addEvent(Up, math.random(0, 1500), {cid = creature:getId(), combat = combat, pos = pos})
            end
        end, 1500)
    end
end

local function damagear(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    local combat, var = param.combat, param.var
    combat:execute(creature, var)
end

acombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local iceStorm = Spell(SPELL_INSTANT)

function iceStorm.onCastSpell(creature, variant)
    addEvent(function() -- Verifica se a criatura ainda existe antes de executar
        local creatureCheck = Creature(creature:getId())
        if creatureCheck then
            addEvent(damagear, math.random(1400, 2000), {cid = creature:getId(), var = variant, combat = combat})
        end
    end, 1500)
    return acombat:execute(creature, variant)
end

iceStorm:name("Blizzard")
iceStorm:words("#Blizzard#")
iceStorm:isAggressive(true)
iceStorm:needLearn(false)
iceStorm:register()
