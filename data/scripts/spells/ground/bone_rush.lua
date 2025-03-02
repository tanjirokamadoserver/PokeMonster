local AREA_RUSH = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 2, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_RUSH2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 2, 0, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_RUSH3 = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local AREA_RUSH4 = {
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat1:setArea(createCombatArea(AREA_RUSH))
combat1:setParameter(COMBAT_PARAM_EFFECT, 1301)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bone Rush")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat2:setArea(createCombatArea(AREA_RUSH2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 1301)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bone Rush")

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat3:setArea(createCombatArea(AREA_RUSH3))
combat3:setParameter(COMBAT_PARAM_EFFECT, 1301)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bone Rush")

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat4:setArea(createCombatArea(AREA_RUSH4))
combat4:setParameter(COMBAT_PARAM_EFFECT, 1301)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bone Rush")

local spell = Spell(SPELL_INSTANT)

local function executeCombat(creatureId, variant, combat, delay)
    addEvent(function()
        local creature = Creature(creatureId)
        if creature then -- Verifica se a criatura ainda existe antes de executar o combate
            combat:execute(creature, variant)
        end
    end, delay)
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    executeCombat(creatureId, variant, combat1, 0)
    executeCombat(creatureId, variant, combat2, 600)
    executeCombat(creatureId, variant, combat3, 1000)
    executeCombat(creatureId, variant, combat4, 1400)
    executeCombat(creatureId, variant, combat4, 1800)
    executeCombat(creatureId, variant, combat3, 2200)
    executeCombat(creatureId, variant, combat2, 2600)
    executeCombat(creatureId, variant, combat1, 3000)

    return true
end

spell:name("Bone Rush")
spell:words("### Bone Rush ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()