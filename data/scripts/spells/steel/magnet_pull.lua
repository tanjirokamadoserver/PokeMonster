local combat, combatDamage = Combat(), Combat()
local effect, distanceEffect = 2197, 24
local effectExecuted = false

local area = createCombatArea(
    {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    }
)

setCombatArea(combat, area)
setCombatArea(combatDamage, area)
setCombatParam(combatDamage, COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combatDamage:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magnet Pull")

local function recursiveSpell(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    if os.time() <= param.time then
        addEvent(recursiveSpell, 300, param)
    end
end

local function applyTargetEffect(creature, target)
    if creature:isTarget(target) then
        local pos = target:getClosestFreePosition(creature:getPosition(), 1, true)
        if pos then
            target:teleportTo(pos)
        end
    end
end

local function applyTileEffect(creature, pos)
    if math.random(1, 2) == 1 then
        Position(pos):sendMagicEffect(effect)
        if math.random(1, 2) == 1 then
            Position(creature:getPosition()):sendDistanceEffect(pos, distanceEffect)
        end
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creaturePos = creature:getPosition() + Position(1, 1, 0)
    creaturePos:sendMagicEffect(2005)
    effectExecuted = false

    -- Aplica efeitos nos alvos
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyTargetEffect(creature, target)
    end

    -- Aplica efeitos nas tiles
    for _, pos in ipairs(combat:getTargetPositions(creature, variant)) do
        applyTileEffect(creature, pos)
    end

    -- Agendamento do combate secundário
    addEvent(function(params)
        local creature = Creature(params.cid)
        if creature then
            combatDamage:execute(creature, params.var)
        end
    end, 100, {cid = creature:getId(), var = variant})

    -- Inicia evento recursivo
    addEvent(recursiveSpell, 300, {cid = creature:getId(), var = variant, time = os.time() + 4})
    return true
end

spell:name("Magnet Pull")
spell:words("#Magnet Pull#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
