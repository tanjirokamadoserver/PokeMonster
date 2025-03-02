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

local EFFECTS = {103}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fissure")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

-- Função para criar os efeitos aleatórios
local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

-- Função que gerencia os efeitos
local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            -- Verifica a criatura dentro do evento
            local creature = Creature(creatureId)
            if creature then
                doRandomEffect(centerPos)  -- Executa o efeito se a criatura existir
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, variant)  -- Executa o combate

    castEffects(creatureId, centerPos)  -- Chama os efeitos com a ID da criatura

    return true
end

spell:name("Fissure")
spell:words("#Fissure#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
