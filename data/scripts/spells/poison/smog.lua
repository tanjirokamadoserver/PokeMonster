local AREA_SCREEN = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 700)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Smog")
combat:setArea(createCombatArea(AREA_SCREEN))

local condition = createConditionObject(CONDITION_POISON)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 144)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local repetitions = 14 
    local delay = 500 

    local function repeatCombat(reps)
        if reps > 0 then
            local creature = Creature(creatureId)
            if creature then
                combat:execute(creature, Variant(creature:getPosition()))
                addEvent(repeatCombat, delay, reps - 1)
            end
        end
    end

    repeatCombat(repetitions)
    return true
end

spell:name("Smog")
spell:words("### Smog ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
