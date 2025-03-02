local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 8)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Headbutt")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Headbutt")
spell:words("##Headbutt##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(3)
spell:needTarget(true)
spell:register()

