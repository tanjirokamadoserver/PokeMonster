local AREA_SCREEN = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 326)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stunning Confusion")
combat:setArea(createCombatArea(AREA_SCREEN))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local repetitions = 8 
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

spell:name("Stunning Confusion")
spell:words("### Stunning Confusion ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
