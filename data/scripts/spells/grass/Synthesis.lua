local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Synthesis")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local healthToRestore = creature:getMaxHealth() * 0.20
    creature:addHealth(healthToRestore)
    combat:execute(creature, variant) 
    return true
end

spell:name("Synthesis")
spell:words("### Synthesis ###")
spell:needLearn(false)
spell:register()
