local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Pluck")
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    --@ pode adicionar mais coisas aqui
    return combat:execute(creature, variant)
end

targetSpell:name("Pluck")
targetSpell:words("#Pluck")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(1)
targetSpell:register()
