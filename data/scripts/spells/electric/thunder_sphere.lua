local AREA_SPHERE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setArea(createCombatArea(AREA_SPHERE))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunder Sphere")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    
    local position = creature:getPosition()

    doSendMagicEffect(position, 2495)

    combat1:execute(creature, variant)

    return true
end

spell:name("Thunder Sphere")
spell:words("### Thunder Sphere ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
