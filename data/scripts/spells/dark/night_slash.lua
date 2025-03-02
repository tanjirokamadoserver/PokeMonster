local AREA_FORCE = {
    {1, 1, 1},
    {1, 2, 1},
    {1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setArea(createCombatArea(AREA_FORCE))
combat:setParameter(COMBAT_PARAM_EFFECT, 166)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Night Slash")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local pos = creature:getPosition()

    doSendMagicEffect(pos, 252)
    doSendMagicEffect(pos, 254)
    doSendMagicEffect(pos, 253)
    doSendMagicEffect(pos, 255)

    combat:execute(creature, variant)
    return true
end

spell:name("Night Slash")
spell:words("#Night Slash#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
