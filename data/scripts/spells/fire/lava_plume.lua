local AREA_Psychic = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat1:setArea(createCombatArea(AREA_Psychic))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Lava Plume")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    addEvent(function(creature_id)
        local creature = Creature(creature_id)
        if creature then
            creature:sendJump(20, 300)
        end
    end, 200, creature_id)

    addEvent(function(creature_id)
        local creature = Creature(creature_id)
        if creature then
            doSendMagicEffect(position, 2540)
            combat1:execute(creature, variant)
        end
    end, 600, creature_id)

    return true
end

spell:name("Lava Plume")
spell:words("### Lava Plume ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
