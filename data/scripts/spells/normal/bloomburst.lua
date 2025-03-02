local EFFECT_COUNT = 20
local EFFECT_DELAY = 50

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {997}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bloomburst")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

-- Função para gerar o efeito aleatório em torno de uma posição
local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-2, 4)
    local randomOffsetY = math.random(-2, 4)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

-- Função para disparar todos os efeitos
local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId) -- Verifica se a criatura ainda existe
            if creature then
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local centerPos = creature:getPosition()

    combat:execute(creature, variant)

    -- Dispara os efeitos aleatórios
    castEffects(creature:getId(), centerPos)
    return true
end

spell:name("Bloomburst")
spell:words("#Bloomburst#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
