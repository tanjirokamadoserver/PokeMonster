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

local EFFECTS = {792}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Inferno")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_FIRE)
condition:setTicks(10000)
condition:setParameter(CONDITION_PARAM_EFFECT, 16)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    -- Criando a posição alvo para o efeito
    local targetPos = Position(centerPos.x + randomOffsetX, centerPos.y + randomOffsetY, centerPos.z)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creature_id) then -- Verifica se a criatura ainda existe
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    -- Executa o combate
    combat:execute(creature, Variant(centerPos))

    -- Lança os efeitos aleatórios
    castEffects(creature_id, centerPos)

    return true
end

spell:name("Inferno")
spell:words("#Inferno#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
