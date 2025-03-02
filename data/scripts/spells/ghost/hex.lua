local AREA_HEX = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_HEX))
combat1:setParameter(COMBAT_PARAM_EFFECT, 709)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hex")

local condition = createConditionObject(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
condition:setParameter(CONDITION_PARAM_SPEED, 450)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()

    creature:addCondition(condition)

    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            combat1:execute(creature, Variant(creature:getPosition()))
        end
    end, 3000)

    return true
end

spell:name("Hex")
spell:words("### Hex ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
