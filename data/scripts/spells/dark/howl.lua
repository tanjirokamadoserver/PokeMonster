local AREA_HONE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},  
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
    }

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 734)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Howl")
combat:setArea(createCombatArea(AREA_HONE))

local conditionSleep = createConditionObject(CONDITION_PARALYZE)
conditionSleep:setParameter(CONDITION_PARAM_TICKS, 6000)
conditionSleep:setParameter(CONDITION_PARAM_SPEED, -4000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT, 15)
combat:addCondition(conditionSleep)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Howl")
spell:words("#Howl#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
