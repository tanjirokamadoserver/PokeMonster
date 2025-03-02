local AREA_METEOR = {
    {0, 0, 0, 1, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 1, 0, 1, 3, 1, 0, 1, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 1, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat1:setArea(createCombatArea(AREA_METEOR))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2517)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Meteor Mash")


local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 1490)

    combat1:execute(creature, variant)

    return true
end

spell:name("Meteor Mash")
spell:words("### Meteor Mash ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
