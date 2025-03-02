local AREA_POOL = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local AREA_POOL2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = Combat()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat1:setArea(createCombatArea(AREA_POOL))
combat1:setParameter(COMBAT_PARAM_EFFECT, 1163)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Frost Tornado")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat2:setArea(createCombatArea(AREA_POOL2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Frost Tornado")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()
    doSendMagicEffect(position, 950)

    addEvent(function()
        local creature = Creature(creature:getId())
        if creature then
            combat1:execute(creature, Variant(creature:getPosition()))
            combat2:execute(creature, Variant(creature:getPosition()))
        end
    end, 1500)

    return true
end

spell:name("Frost Tornado")
spell:words("### Frost Tornado ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
