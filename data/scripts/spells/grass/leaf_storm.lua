local EFFECT_COUNT = 20
local EFFECT_DELAY = 100

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {246} -- Lista de efeitos mágicos
local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leaf Storm")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    -- Verifica se o centro ainda é válido antes de executar os efeitos
    if not centerPos then
        return
    end

    local targetPos = centerPos + Position(math.random(-3, 3), math.random(-3, 3), 0)
    doSendDistanceShoot(centerPos, targetPos, 9)
    targetPos:sendMagicEffect(EFFECTS[math.random(#EFFECTS)])
end

local function castEffects(centerPos, creatureId)
    -- Agendamento de eventos para efeitos aleatórios
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then -- Verifica se a criatura ainda existe
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId() 
    local position = creature:getPosition()
    
    combat:execute(creature, Variant(position)) 
    castEffects(position, creatureId) 
    return true
end

spell:name("Leaf Storm")
spell:words("#Leaf Storm#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
