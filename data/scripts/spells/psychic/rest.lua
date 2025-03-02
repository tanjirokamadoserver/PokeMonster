local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 133)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    
    -- Recupera 30% do HP máximo da criatura
    local maxHealth = creature:getMaxHealth()
    local healAmount = math.floor(maxHealth * 0.3)
    creature:addHealth(healAmount)

    return true
end

spell:name("Rest")
spell:words("### Rest ###")
spell:needLearn(false)
spell:register()
