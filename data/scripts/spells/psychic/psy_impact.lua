local EFFECT_COUNT = 25
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

local EFFECTS = {463, 464, 465, 466, 467, 468}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psy Impact")
combat:setArea(createCombatArea(AREA_WIND))

local condition = Condition(CONDITION_BLIND)
condition:setTicks(6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 337)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos, creatureId)
    local creature = Creature(creatureId)
    if not creature then
        return -- Interrompe se a criatura não existir
    end

    local targetPos = centerPos + Position(math.random(-3, 3), math.random(-3, 3), 0)
    targetPos:sendMagicEffect(EFFECTS[math.random(#EFFECTS)])
end

local function castEffects(centerPos, creatureId)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                doRandomEffect(centerPos, creatureId)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local creaturePos = creature:getPosition()

    -- Executa o combate
    combat:execute(creature, Variant(creaturePos))

    -- Agendamento de efeitos
    castEffects(creaturePos, creatureId)

    return true
end

spell:name("Psy Impact")
spell:words("#Psy Impact#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

