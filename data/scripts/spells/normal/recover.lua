local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 307)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local maxHealth = creature:getMaxHealth()
    local recoverAmount = math.floor(maxHealth * 0.20)
    creature:addHealth(recoverAmount)
    
    combat:execute(creature, variant)
    return true
end

spell:name("Recover")
spell:words("### Recover ###")
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
