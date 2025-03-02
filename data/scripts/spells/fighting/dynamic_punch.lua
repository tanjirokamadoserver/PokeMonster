local AREA_STORM = {
{0, 0, 0},
{1, 1, 1},
{1, 2, 1},
{1, 1, 1},
{0, 0, 0}
}

local AREA_STORM1 = {
{0, 0, 0, 0, 0, 0, 0},
{0, 0, 1, 1, 1, 0, 0},
{0, 1, 0, 0, 0, 1, 0},
{0, 1, 0, 2, 0, 1, 0},
{0, 1, 0, 0, 0, 1, 0},
{0, 0, 1, 1, 1, 0, 0},
{0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM2 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 2, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM3 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM4 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

-- Criando um objeto de combate para cada área
local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 1338)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dynamic Punch")
combat1:setArea(createCombatArea(AREA_STORM))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 1338)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dynamic Punch")
combat2:setArea(createCombatArea(AREA_STORM1))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 1338)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dynamic Punch")
combat3:setArea(createCombatArea(AREA_STORM2))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 1338)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dynamic Punch")
combat4:setArea(createCombatArea(AREA_STORM3))

local combat5 = createCombatObject()
combat5:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat5:setParameter(COMBAT_PARAM_EFFECT, 1338)
combat5:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dynamic Punch")
combat5:setArea(createCombatArea(AREA_STORM3))

local condition = Condition(CONDITION_CONFUSION)
condition:setTicks(5000)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat1:addCondition(condition)
combat2:addCondition(condition)
combat3:addCondition(condition)
combat4:addCondition(condition)
combat5:addCondition(condition)

-- Tabela contendo todos os combates
local combats = {combat1, combat2, combat3, combat4, combat5}

local function executeCombat(creatureId, combat)
    local creature = Creature(creatureId)
    if creature then
        combat:execute(creature, Variant(creature:getPosition()))
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local delay = 0
    local creatureId = creature:getId()
    for _, combat in ipairs(combats) do
        -- Usando addEvent com verificação da existência da criatura
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                executeCombat(creatureId, combat)
            end
        end, delay)
        delay = delay + 500
    end
    return true
end

spell:name("Dynamic Punch")
spell:words("### Dynamic Punch ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
