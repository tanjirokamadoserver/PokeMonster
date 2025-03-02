local AREA_BOMB = {
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 13)
combat:setParameter(COMBAT_PARAM_EFFECT, 383)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Egg Bomb")
combat:setArea(createCombatArea(AREA_BOMB))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Egg Bomb")
spell:words("#Egg Bomb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
