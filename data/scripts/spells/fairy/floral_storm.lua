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

local EFFECTS = {1038}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Floral Storm")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(creature_id, centerPos)
    local creature = Creature(creature_id)
    if not creature then
        return -- Se a criatura não existir, não faz nada
    end

    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(5, 15)
    local randomOffsetY = math.random(5, 15)
    local startPos = centerPos - Position(randomOffsetX, randomOffsetY, 0)
    local targetPos = centerPos + Position(math.random(-3, 3), math.random(-3, 3), 0)
    doSendDistanceShoot(startPos, targetPos, 22)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creature_id) then -- Verifica se a criatura ainda existe
                doRandomEffect(creature_id, centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, variant)

    -- Inicia o lançamento dos efeitos
    castEffects(creature_id, centerPos)
    return true
end

spell:name("Floral Storm")
spell:words("#Floral Storm#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

