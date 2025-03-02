local AREA_FORCE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_FORCE2 = {
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 0, 0, 0, 1, 1, 0},
    {1, 1, 0, 0, 0, 0, 0, 1, 1},
    {1, 1, 0, 0, 2, 0, 0, 1, 1},
    {1, 1, 0, 0, 0, 0, 0, 1, 1},
    {0, 1, 1, 0, 0, 0, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setArea(createCombatArea(AREA_FORCE))
combat:setParameter(COMBAT_PARAM_EFFECT, 326)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Expanding Force")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat2:setArea(createCombatArea(AREA_FORCE2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 194)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Expanding Force")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()
    doSendMagicEffect(position, 1270)

    addEvent(function(cid)
        local creature = Creature(cid)
        if creature then
            combat:execute(creature, variant)
            combat2:execute(creature, variant)
        end
    end, 400, creature_id)

    return true
end

spell:name("Expanding Force")
spell:words("### Expanding Force ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
