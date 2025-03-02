local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ancient Absorb")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local effectPos = creature:getPosition()
    effectPos.x = effectPos.x + 1
    effectPos.y = effectPos.y + 1

    doSendMagicEffect(effectPos, 794)
    combat:execute(creature, Variant(effectPos))

    local healAmount = creature:getMaxHealth() * 0.05
    creature:addHealth(healAmount)

    return true
end

spell:name("Ancient Absorb")
spell:words("#Ancient Absorb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
