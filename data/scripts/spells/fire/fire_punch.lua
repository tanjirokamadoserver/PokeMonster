local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 4)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fire Punch")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPos = target:getPosition()
    
    local effectPos = {
        x = targetPos.x + 0,
        y = targetPos.y + 0,
        z = targetPos.z
    }

    doSendMagicEffect(effectPos, 1402)
    combat:execute(creature, Variant(targetPos))

    return true
end

spell:name("Fire Punch")
spell:words("#Fire Punch#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
