local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 23)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hyper Voice")

local area = createCombatArea{
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
}

combat:setArea(area)

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_SPEED, -4000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Hyper Voice")
spell:words("#Hyper Voice#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
