local AREA_TOMBS = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 3, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE) 
combat:setParameter(COMBAT_PARAM_EFFECT, 1177) 
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Swagger")
combat:setArea(createCombatArea(AREA_TOMBS))

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 5000) 
condition:setParameter(CONDITION_PARAM_SPEED, -500) 
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 500) 
condition:setParameter(CONDITION_PARAM_EFFECT, 866) 
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Swagger")
spell:words("### Swagger ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
