local EFFECT_COUNT = 25
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

local EFFECTS = {114} -- Lista de efeitos visuais que serão lançados aleatoriamente

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Low Sweep")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    
    -- Envia o míssil do centro para a posição alvo
    doSendDistanceShoot(centerPos, targetPos, 40)
    
    -- Aplica o efeito visual na posição alvo
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creature_id)
            if creature then
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end


function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, variant)

    castEffects(creature_id, centerPos)
    return true
end

spell:name("Low Sweep")
spell:words("#Low Sweep#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
