local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 104)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local healthToRestore = creature:getMaxHealth() * 0.20  
    creature:addHealth(healthToRestore)
    combat:execute(creature, variant) 
    return true
end

spell:name("Roost")
spell:words("### Roost ###")
spell:needLearn(false)
spell:register()
