local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 24)
combat:setParameter(COMBAT_PARAM_EFFECT, 27)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "String Shot")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPos = target:getPosition()
    combat:execute(creature, Variant(targetPos))
    return true
end

spell:name("String Shot")
spell:words("#String Shot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
