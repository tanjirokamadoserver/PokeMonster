local AREA_WIND = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setArea(createCombatArea(AREA_WIND))
combat:setParameter(COMBAT_PARAM_EFFECT, 332)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Silver Wind")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    local target = Creature(variant:getNumber())
    if target then
        local targetPosition = target:getPosition()
        position:sendDistanceEffect(targetPosition, 24)
    end

    combat:execute(creature, variant)

    return true
end

spell:name("Silver Wind")
spell:words("### Silver Wind ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()