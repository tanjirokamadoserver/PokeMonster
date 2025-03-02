local EFFECT_COUNT = 10
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

local EFFECT_ID = 2100 

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Moonlight")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doEffectAtRandomPosition(centerPos)
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(EFFECT_ID)
end

local function castEffects(creature_id, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creature_id) then  -- Verifica se a criatura ainda existe
                doEffectAtRandomPosition(centerPos)
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

spell:name("Moonlight")
spell:words("#Moonlight#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
