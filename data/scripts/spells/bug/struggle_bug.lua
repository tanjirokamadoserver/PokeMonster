local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setArea(createCombatArea(AREA_SQUARE1X1))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Struggle Bug")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local effectPos = target:getPosition()
    effectPos:doSendMagicEffect(927)
    combat:execute(creature, variant)
    return true
end

spell:name("Struggle Bug")
spell:words("#Struggle Bug#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
