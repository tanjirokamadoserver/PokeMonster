local EFFECT_COUNT = 30
local EFFECT_DELAY = 25

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {662} -- Lista de efeitos visuais que serão lançados aleatoriamente
local CREATURE_EFFECT = 458 -- Efeito que sairá da criatura

-- Defina o deslocamento em x e y
local EFFECT_OFFSET_X = 1
local EFFECT_OFFSET_Y = 1

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Great Love")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_CONFUSION)
condition:setTicks(10000)
condition:setParameter(CONDITION_PARAM_EFFECT, 662)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    -- Verifica se a posição de efeito ainda é válida
    if not centerPos then return end
    
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            -- Verifica se a criatura ainda existe no momento do evento
            local creature = Creature(creature_id)
            if creature then
                doRandomEffect(centerPos)  -- Executa a lógica do efeito se a criatura existir
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    local effectPosition = centerPos + Position(EFFECT_OFFSET_X, EFFECT_OFFSET_Y, 0)
    effectPosition:sendMagicEffect(CREATURE_EFFECT)

    combat:execute(creature, variant)

    castEffects(creature_id, centerPos)
    return true
end

spell:name("Great Love")
spell:words("#Great Love#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
