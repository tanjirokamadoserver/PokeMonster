local AREA_BALL = {
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)
combat:setParameter(COMBAT_PARAM_EFFECT, 406)
combat:setArea(createCombatArea(AREA_BALL))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()
	
    doSendMagicEffect(position, 2)

    combat:execute(creature, variant)

    return true
end

spell:name("Water Ball")
spell:words("#Water Ball#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()
