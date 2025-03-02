local EFFECT_COUNT = 30
local EFFECT_DELAY = 50

local AREA_WIND = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1}
}

local EFFECTS = {54}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hydro Pump")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)
    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    
    doSendDistanceShoot(centerPos, targetPos, 3)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creature_id)
            if creature then -- Verifica se a criatura ainda existe antes de lançar o efeito
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, Variant(centerPos))
    castEffects(creature_id, centerPos)

    creature:sendJump(20, 300)
    
    return true
end

spell:name("Hydro Pump")
spell:words("#Hydro Pump#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
