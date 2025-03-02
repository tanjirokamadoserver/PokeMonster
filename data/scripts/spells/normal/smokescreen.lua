local AREA_SCREEN = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 315)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Smokescreen")
combat:setArea(createCombatArea(AREA_SCREEN))

local condition = createConditionObject(CONDITION_BLIND)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 1216)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local repetitions = 4 
    local delay = 500 

    local function repeatCombat(reps)
        if reps > 0 then
            local creature = Creature(creatureId)
            if creature then
                combat:execute(creature, Variant(creature:getPosition()))
                addEvent(function()
                    repeatCombat(reps - 1)
                end, delay)
            end
        end
    end

    repeatCombat(repetitions)
    return true
end

spell:name("Smokescreen")
spell:words("### Smokescreen ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
