local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1432)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heal Block")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Heal Block")
spell:words("#Heal Block#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
