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

local EFFECTS = {400}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Night Daze")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(creatureId, centerPos)
    local creature = Creature(creatureId)
    if not creature then
        return -- Interrompe se a criatura não existir
    end

    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY)

    doSendDistanceShoot(centerPos, targetPos, 40)
    
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creatureId, centerPos)
    for i = 0, EFFECT_COUNT - 1 do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                doRandomEffect(creatureId, centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, variant)

    castEffects(creatureId, centerPos)
    return true
end

spell:name("Night Daze")
spell:words("#Night Daze#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

