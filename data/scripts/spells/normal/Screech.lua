local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 34)
combat:setParameter(COMBAT_PARAM_EFFECT, 904)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Screech")

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    combat:execute(creature, Variant(targetPos))
    return true
end

spell:name("Screech")
spell:words("#Screech#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
