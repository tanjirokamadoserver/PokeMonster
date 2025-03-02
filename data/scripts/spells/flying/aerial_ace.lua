local config = {
    ["shiny rampardos"] = {
        effectIds = {1690, 1691}, -- Adicione mais IDs conforme necessário
        missileId = 188,
        missileId2 = 187,
    },

    ["default"] = {
        effectIds = {17, 222, 244}, -- Adicione mais IDs conforme necessário
        missileId = 90,
        missileId2 = 90,
    },
}

local acombat = Combat()
local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Aerial Ace")

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

    local effectId = params.effectIds[math.random(#params.effectIds)]
    Position({x = p.pos.x - 7, y = p.pos.y - 5, z = p.pos.z})
    Position(p.pos):sendMagicEffect(effectId)
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
    pos:sendDistanceEffect({x = pos.x - math.random(6,8), y = pos.y - 5, z = pos.z})
    addEvent(Down, 500, p)
end

function onTargetTile(creature, pos)
    if (math.random(0,2) >= 1) then
        addEvent(function() 
            if Creature(creature:getId()) then  -- Verifica se a criatura ainda existe
                addEvent(Up, math.random(0, 1500), {cid = creature:getId(), combat = combat, pos = pos})
            end
        end, 0)
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
    addEvent(damagear, math.random(1400, 2000), {cid = creature:getId(), var = variant, combat = combat})
    return acombat:execute(creature, variant)
end

firedamage:name("Aerial Ace")
firedamage:words("#Aerial Ace#")
firedamage:isAggressive(true)
firedamage:needLearn(false)
firedamage:register()