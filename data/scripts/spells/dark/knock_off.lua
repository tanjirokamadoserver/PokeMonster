local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 264)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Knock Off")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Knock Off")
spell:words("#Knock Off#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()