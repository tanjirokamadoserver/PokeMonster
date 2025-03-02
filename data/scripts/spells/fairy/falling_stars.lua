local config = {
    ["shiny rampardos"] = {
        effectId = 1690,
        missileId = 188,
        missileId2 = 187,
    },

    ["default"] = {
        effectId = 2514,
        missileId = 90,
        missileId2 = 90,
    },
}

local acombat = createCombatObject()
local combat = createCombatObject()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Falling Stars")

local area = createCombatArea(
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

local function AttackDown(p)
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

local function AttackUP(p)
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
    -- Verificação adicional dentro do addEvent
    addEvent(function()
        if Creature(p.cid) then -- Verifica se a criatura ainda existe
            AttackDown(p)
        end
    end, 500)
end

function onTargetTile(creature, pos)
    if (math.random(0,2) >= 1) then
        addEvent(function()
            if Creature(creature:getId()) then -- Verifica se a criatura ainda existe
                AttackUP({cid = creature:getId(), combat = combat, pos = pos})
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

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    addEvent(function()
        if Creature(creature:getId()) then -- Verifica se a criatura ainda existe
            damagear({cid = creature:getId(), var = variant, combat = combat})
        end
    end, math.random(1400, 2000))
    return acombat:execute(creature, variant)
end

spell:name("Falling Stars")
spell:words("#Falling Stars#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
