local AREA_Psychic = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_Psychic2 = {
    {0, 0, 0, 1, 0, 0, 0},
    {0, 1, 1, 0, 1, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 3, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 1, 1, 0, 1, 1, 0},
    {0, 0, 0, 1, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 337)
combat1:setArea(createCombatArea(AREA_Psychic))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stored Power")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 344)
combat2:setArea(createCombatArea(AREA_Psychic2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stored Power")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    doSendMagicEffect(position, 1992)

    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            combat1:execute(creature, variant)
            combat2:execute(creature, variant)
        end
    end, 3000)

    return true
end

spell:name("Stored Power")
spell:words("### Stored Power ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
