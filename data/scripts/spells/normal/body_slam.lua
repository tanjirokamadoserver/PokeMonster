local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Body Slam")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()

    target:sendJump(15, 300)

    combat:execute(creature, variant)

    return true
end

spell:name("Body Slam")
spell:words("#Body Slam#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
