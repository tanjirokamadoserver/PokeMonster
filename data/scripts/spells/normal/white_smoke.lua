local AREA_SMOCK = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_SMOCK))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2197)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "White Smoke")

local condition = createConditionObject(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 16)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    for i = 0, 9 do
        addEvent(function()
            local creature_id = creature:getId()
            local creature = Creature(creature_id)
            if creature then
                local position = creature:getPosition()
                combat1:execute(creature, Variant(position))
            end
        end, i * 1000)
    end

    return true
end

spell:name("White Smoke")
spell:words("### White Smoke ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
