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

local EFFECTS = {2422}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Discharge")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(creatureId)
    local creature = Creature(creatureId)
    if not creature then return end -- Verifica se a criatura ainda existe

    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local randomOffsetX = math.random(-3, 3)
    local randomOffsetY = math.random(-3, 3)

    local targetPos = creature:getPosition() + Position(randomOffsetX, randomOffsetY)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(creatureId)
    for i = 0, EFFECT_COUNT - 1 do
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                doRandomEffect(creatureId) -- Verifica a existência da criatura ao chamar a função
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    combat:execute(creature, variant)
    castEffects(creatureId) -- Chama a função para aplicar efeitos
    return true
end

spell:name("Discharge")
spell:words("#Discharge#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
