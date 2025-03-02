local EFFECT_COUNT = 20
local EFFECT_DELAY = 50
local PRE_ATTACK_DELAY = 200

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {89,119,355}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rock Blast")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    
    doSendDistanceShoot(centerPos, targetPos, 12)
    
    targetPos:sendMagicEffect(randomEffect)
end

-- Função para lançar múltiplos efeitos
local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creatureId) then  -- Verifica se a criatura ainda existe
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

-- Função chamada quando a magia é lançada
function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local centerPos = creature:getPosition()

    -- Envia o efeito inicial antes do ataque
    addEvent(function()
        if Creature(creatureId) then  -- Verifica se a criatura ainda existe
            centerPos:sendMagicEffect(128)
        end
    end, PRE_ATTACK_DELAY)

    -- Executa o combate e os efeitos após o atraso
    addEvent(function()
        if Creature(creatureId) then  -- Verifica se a criatura ainda existe
            combat:execute(creature, variant)
            castEffects(creatureId, centerPos)
        end
    end, PRE_ATTACK_DELAY + EFFECT_DELAY)

    return true
end

spell:name("Rock Blast")
spell:words("#Rock Blast#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()