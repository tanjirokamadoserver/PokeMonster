local AREA_TOMB = {
    {0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 3, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE) 
combat:setParameter(COMBAT_PARAM_EFFECT, 2202) 
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sand Tomb")
combat:setArea(createCombatArea(AREA_TOMB))

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000) 
condition:setParameter(CONDITION_PARAM_SPEED, -500) 
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600) 
condition:setParameter(CONDITION_PARAM_EFFECT, 866) 
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Sand Tomb")
spell:words("### Sand Tomb ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
