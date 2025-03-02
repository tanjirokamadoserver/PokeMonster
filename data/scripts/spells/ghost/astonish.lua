local acombat = createCombatObject()
acombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
acombat:setParameter(COMBAT_PARAM_EFFECT, 804)
acombat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Astonish")

local area = createCombatArea(
{
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},  
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}
}
)

acombat:setArea(area)


local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    acombat:execute(creature, variant)
    return true
end

spell:name("Astonish")
spell:words("#Astonish#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
