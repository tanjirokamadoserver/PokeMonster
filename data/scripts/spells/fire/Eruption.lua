local combat, combatDamage = Combat(), Combat()
local effect, distanceEffect = 16, 4
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
setCombatParam(combatDamage, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combatDamage:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Eruption")

-- Função para aplicar os efeitos no alvo
local function applyEffect(creature, target)
    if creature:isTarget(target) then
        local pos = target:getClosestFreePosition(creature:getPosition(), 1, true)
        if pos then
            target:teleportTo(pos)
        end
    end
end

-- Função para mostrar os efeitos visuais
local function showEffect(params)
    Position(params.toPos):sendMagicEffect(effect)
    if math.random(1, 2) == 1 then
        Position(params.fromPos):sendDistanceEffect(params.toPos, distanceEffect)
    end
end

-- Recursividade para efeitos contínuos
local function recursiveSpell(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    if os.time() <= param.time then
        addEvent(recursiveSpell, 300, param)
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    creature:getPosition():sendMagicEffect(370)
    effectExecuted = false

    -- Aplicar efeitos aos alvos
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(creature, target)
    end

    -- Executar dano em área
    combat:execute(creature, variant)
    
    -- Executar dano adicional com delay
    addEvent(function(params)
        local creature = Creature(params.cid)
        if creature then
            combatDamage:execute(creature, params.var)
        end
    end, 100, {cid = creature:getId(), var = variant})

    -- Efeito recursivo
    addEvent(recursiveSpell, 300, {cid = creature:getId(), var = variant, time = os.time() + 4})

    return true
end

spell:name("Eruption")
spell:words("#Eruption#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
