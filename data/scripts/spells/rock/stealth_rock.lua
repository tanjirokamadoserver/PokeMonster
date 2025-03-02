local AREA_ROCK = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat1:setArea(createCombatArea(AREA_ROCK))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2211)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stealth Rock")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 2286)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    local function executeCombat(times)
        if times > 0 then
            combat1:execute(creature, variant)
            addEvent(executeCombat, 1000, times - 1)
        end
    end

    -- Garantir que a criatura ainda existe antes de adicionar o evento
    if Creature(creature_id) then
        executeCombat(10)
    end

    return true
end

spell:name("Stealth Rock")
spell:words("### Stealth Rock ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
