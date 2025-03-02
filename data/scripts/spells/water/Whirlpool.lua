local AREA_POOL = {
    {1, 0, 0, 1, 0, 0, 1},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {1, 1, 1, 2, 1, 1, 1},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {1, 0, 0, 1, 0, 0, 1}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat1:setArea(createCombatArea(AREA_POOL))
combat1:setParameter(COMBAT_PARAM_EFFECT, 1360)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Whirlpool")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 799)

    addEvent(function()
        local creature = Creature(creature:getId())
        if creature then
            combat1:execute(creature, Variant(creature:getPosition()))
        end
    end, 2000)

    return true
end

spell:name("Whirlpool")
spell:words("### Whirlpool ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
