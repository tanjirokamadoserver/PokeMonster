local AREA_COUNT = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local AREA_COUNT2 = {
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 3, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat1:setArea(createCombatArea(AREA_COUNT))
combat1:setParameter(COMBAT_PARAM_EFFECT, 1118)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sand Eruption")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat2:setArea(createCombatArea(AREA_COUNT2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 1117)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sand Eruption Additional Effect")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    position.x = position.x + 2
    position.y = position.y + 0

    doSendMagicEffect(position, 2276)

    -- Agendamento de evento
    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            combat1:execute(creature, variant)
            combat2:execute(creature, variant)
        end
    end, 1000) 

    return true
end

spell:name("Sand Eruption")
spell:words("### Sand Eruption ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
