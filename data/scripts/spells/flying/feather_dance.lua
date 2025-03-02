local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Feather Dance")
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 18)


local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    --@ pode adicionar mais coisas aqui
    return combat:execute(creature, variant)
end

targetSpell:name("Feather Dance")
targetSpell:words("#Feather Dance")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(2)
targetSpell:register()
