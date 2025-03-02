local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 166)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heal Pulse")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    doSendMagicEffect(position, 2020)

    combat:execute(creature, variant)

    return true
end

spell:name("Heal Pulse")
spell:words("#Heal Pulse#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
