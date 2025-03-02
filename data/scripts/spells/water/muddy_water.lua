local EFFECT_COUNT = 30
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

local EFFECTS = {56}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Muddy Water")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_BLIND)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 297)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local targetPos = centerPos + Position(math.random(-3, 3), math.random(-3, 3), 0)
    targetPos:sendMagicEffect(EFFECTS[math.random(#EFFECTS)])
end

-- Função para lançar os efeitos
local function castEffects(centerPos, creatureId)
    for i = 1, EFFECT_COUNT do
        -- Agendando os efeitos com base no atraso
        addEvent(function()
            local creature = Creature(creatureId)  -- Criando o objeto da criatura com base no ID
            if creature then  -- Verificando se a criatura ainda existe
                doRandomEffect(centerPos)  -- Lançando o efeito apenas se a criatura existir
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()  -- Pegando o ID da criatura

    -- Executando o combate
    combat:execute(creature, variant)

    -- Agendando a execução dos efeitos e passando o ID da criatura
    castEffects(creature:getPosition(), creatureId)

    return true
end

spell:name("Muddy Water")
spell:words("#Muddy Water#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()