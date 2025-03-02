local AREA_VOLT1 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 3, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_VOLT2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 3, 0, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_VOLT3 = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 3, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local AREA_VOLT4 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 3, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_VOLT5 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_VOLT6 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat1:setArea(createCombatArea(AREA_VOLT1))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat2:setArea(createCombatArea(AREA_VOLT2))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat3:setArea(createCombatArea(AREA_VOLT3))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat4:setArea(createCombatArea(AREA_VOLT4))

local combat5 = createCombatObject()
combat5:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat5:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat5:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat5:setArea(createCombatArea(AREA_VOLT5))

local combat6 = createCombatObject()
combat6:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat6:setParameter(COMBAT_PARAM_EFFECT, 1364)
combat6:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Wild Charge")
combat6:setArea(createCombatArea(AREA_VOLT6))

local combats = {combat6, combat5, combat4, combat3, combat2, combat1, combat6, combat5, combat4, combat3, combat2, combat1}

local function executeCombat(creatureId, combat)
    local creature = Creature(creatureId)
    if creature then
        combat:execute(creature, Variant(creature:getPosition()))
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local delay = 0
    local creatureId = creature:getId()

    for _, combat in ipairs(combats) do
        addEvent(function()
            -- Verifica se a criatura ainda existe antes de executar o combate
            if Creature(creatureId) then
                executeCombat(creatureId, combat)
            end
        end, delay)
        delay = delay + 300
    end

    return true
end

spell:name("Wild Charge")
spell:words("### Wild Charge ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
