local EFFECT_COUNT = 10
local EFFECT_DELAY = 50

local AREA_WIND = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local EFFECTS = {128}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Earth Power")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-2, 2)
    local randomOffsetY = math.random(-2, 2)
    local targetPos = centerPos + Position(randomOffsetX, randomOffsetY, 0)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creatureId, centerPos)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                doRandomEffect(centerPos)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local centerPos = creature:getPosition()

    combat:execute(creature, Variant(centerPos))
    castEffects(creatureId, centerPos)

    return true
end

spell:name("Earth Power")
spell:words("#Earth Power#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
