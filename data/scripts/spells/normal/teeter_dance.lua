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
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 2, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM3 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}


local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 23)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Teeter Dance")
combat1:setArea(createCombatArea(AREA_STORM))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 23)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Teeter Dance")
combat2:setArea(createCombatArea(AREA_STORM1))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 23)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Teeter Dance")
combat3:setArea(createCombatArea(AREA_STORM2))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 23)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Teeter Dance")
combat4:setArea(createCombatArea(AREA_STORM3))

local condition = Condition(CONDITION_CONFUSION)
condition:setTicks(3000)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat1:addCondition(condition)
combat2:addCondition(condition)
combat3:addCondition(condition)
combat4:addCondition(condition)

local combats = {combat1, combat2, combat3, combat4, combat1, combat2, combat3, combat4, combat1, combat2, combat3, combat4, combat1, combat2, combat3, combat4, combat1, combat2, combat3, combat4}

local function executeCombat(creatureId, combat)
    local creature = Creature(creatureId)
    if not creature then
        return -- Interrompe se a criatura não existir
    end

    local position = creature:getPosition()
    combat:execute(creature, Variant(position))
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local delay = 0
    local creatureId = creature:getId()

    for _, combat in ipairs(combats) do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe antes de executar o combate
                executeCombat(creatureId, combat)
            end
        end, delay)
        delay = delay + 400
    end

    return true
end

spell:name("Teeter Dance")
spell:words("### Teeter Dance ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()