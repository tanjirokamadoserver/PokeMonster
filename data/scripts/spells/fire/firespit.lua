local config = {
    ["shiny rampardos"] = {
        effectId = 16,
        missileId = 4,
        missileId2 = 4,
    },

    ["default"] = {
        effectId = 16,
        missileId = 4,
        missileId2 = 4,
    },
}

local acombat = Combat()
local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "fire spit")

local area = createCombatArea({
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
})

local area2 = createCombatArea({
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
})

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
    addEvent(function() Down(p) end, 500)
end

function onTargetTile(creature, pos)
    if (math.random(0,2) >= 1) then
        addEvent(function() 
            if Creature(creature:getId()) then
                Up({cid = creature:getId(), combat = combat, pos = pos})
            end
        end, math.random(0, 1500))
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

local firedamage = Spell(SPELL_INSTANT)

function firedamage.onCastSpell(creature, variant)
    addEvent(function() damagear({cid = creature:getId(), var = variant, combat = combat}) end, math.random(1400, 2000))
    return acombat:execute(creature, variant)
end

firedamage:name("fire spit")
firedamage:words("#firespit#")
firedamage:isAggressive(true)
firedamage:needLearn(false)
firedamage:register()
