local config = {
    ["shiny rampardos"] = {
        effectId = 1690,
        missileId = 188,
        missileId2 = 187,
    },

    ["default"] = {
        effectId = 1447,
        missileId = 29,
        missileId2 = 29,
    },
}

local condition = Condition(CONDITION_STUN)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 1447)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)

local acombat = Combat()
local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Frenzy Plant")
combat:addCondition(condition) -- Adicionando a condição de stun ao combate

local area = createCombatArea({
    {0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0},
    {0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0},
    {1, 1, 0, 0, 0, 3, 0, 1, 0, 0, 1},
    {0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0},
    {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0}
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

    Position({x = p.pos.x - 7, y = p.pos.y - 5, z = p.pos.z}):sendDistanceEffect(p.pos)
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
    pos:sendDistanceEffect({x = pos.x - math.random(1, 2), y = pos.y - 5, z = pos.z})
    
    -- Adicionando checagem antes de agendar o evento
    if Creature(p.cid) then
        addEvent(Down, 100, p)
    end
end

function onTargetTile(creature, pos)
    if (math.random(0, 2) >= 1) then
        -- Aguardar um pouco mais para evitar sobrecarga
        addEvent(Up, math.random(500, 1500), {cid = creature:getId(), combat = combat, pos = pos})
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
    -- Atrasar um pouco o evento para balancear o tempo entre as execuções
    addEvent(damagear, math.random(800, 1500), {cid = creature:getId(), var = variant, combat = combat})
    return acombat:execute(creature, variant)
end

firedamage:name("Frenzy Plant")
firedamage:words("#Frenzy Plant#")
firedamage:isAggressive(true)
firedamage:needLearn(false)
firedamage:register()