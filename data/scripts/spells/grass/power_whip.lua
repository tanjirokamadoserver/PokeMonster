local AREA_WHIP = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat1:setArea(createCombatArea(AREA_WHIP))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Power Whip")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
local position = creature:getPosition()

    doSendMagicEffect(position, 214)

    combat1:execute(creature, variant)

    return true
end

spell:name("Power Whip")
spell:words("### Power Whip ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
