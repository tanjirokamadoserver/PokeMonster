local AREA_BACK = {
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},  
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Payback")
combat:setArea(createCombatArea(AREA_BACK))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    position:sendMagicEffect(1803)

    combat:execute(creature, variant)
    return true
end

spell:name("Payback")
spell:words("#Payback#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
