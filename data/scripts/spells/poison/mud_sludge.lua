local EFFECT_COUNT = 50
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

local EFFECTS = {294}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mud Sludge")
combat:setArea(createCombatArea(AREA_WIND))

local spell = Spell(SPELL_INSTANT)

local function doRandomEffect(centerPos)
    local randomEffect = EFFECTS[math.random(#EFFECTS)]
    local targetPos = centerPos + Position(math.random(-3, 3), math.random(-3, 3), 0)
    doSendDistanceShoot(centerPos, targetPos, 15)
    targetPos:sendMagicEffect(randomEffect)
end

local function castEffects(centerPos, creatureId)
    for i = 1, EFFECT_COUNT do
        addEvent(function()
            local creature = Creature(creatureId)  -- Verifica se a criatura ainda existe
            if creature then  -- Verifica se a criatura é válida
                local pos = centerPos
                local randomEffect = EFFECTS[math.random(#EFFECTS)]
                local targetPos = pos + Position(math.random(-3, 3), math.random(-3, 3), 0)
                doSendDistanceShoot(pos, targetPos, 15)
                targetPos:sendMagicEffect(randomEffect)
            end
        end, i * EFFECT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()  -- Pega o ID da criatura para verificar no evento
    combat:execute(creature, Variant(creature:getPosition()))
    castEffects(creature:getPosition(), creatureId)
    return true
end

spell:name("Mud Sludge")
spell:words("#Mud Sludge#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
