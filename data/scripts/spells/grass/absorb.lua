local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 9)
combat:setParameter(COMBAT_PARAM_EFFECT, 272)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Absorb")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)
    
    local maxHealth = creature:getMaxHealth() 
    local healAmount = math.floor(maxHealth * 0.02) 
    creature:addHealth(healAmount)
    
    return true
end

spell:name("Absorb")
spell:words("#Absorb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
