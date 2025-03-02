local AREA_STORM = {
{0, 0, 0},
{0, 1, 0},
{1, 2, 1},
{0, 1, 0},
{0, 0, 0}
}

local AREA_STORM1 = {
{0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 1, 0, 0, 0},
{0, 0, 1, 0, 1, 0, 0},
{0, 1, 0, 2, 0, 1, 0},
{0, 0, 1, 0, 1, 0, 0},
{0, 0, 0, 1, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM2 = {
{0, 0, 0, 1, 0, 0, 0},
{0, 1, 1, 0, 1, 1, 0},
{0, 1, 0, 0, 0, 1, 0},
{1, 0, 0, 2, 0, 0, 1},
{0, 1, 0, 0, 0, 1, 0},
{0, 1, 1, 0, 1, 1, 0},
{0, 0, 0, 1, 0, 0, 0}
}

local AREA_STORM3 = {
{0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 0, 1, 0, 0, 0},
{0, 0, 1, 0, 0, 0, 1, 0, 0},
{0, 1, 0, 0, 2, 0, 0, 1, 0},
{0, 0, 1, 0, 0, 0, 1, 0, 0},
{0, 0, 0, 1, 0, 1, 0, 0, 0},
{0, 0, 0, 0, 1, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 563)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magma Storm")
combat1:setArea(createCombatArea(AREA_STORM))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 372)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magma Storm")
combat2:setArea(createCombatArea(AREA_STORM1))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 525)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magma Storm")
combat3:setArea(createCombatArea(AREA_STORM2))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 373)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magma Storm")
combat4:setArea(createCombatArea(AREA_STORM3))

local combats = {combat1, combat2, combat3, combat4}

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
        -- Adicionando um evento com verificação para garantir que a criatura ainda exista
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                executeCombat(creatureId, combat)
            end
        end, delay)

        delay = delay + 600  -- Incrementa o delay entre os eventos
    end

    return true
end

spell:name("Magma Storm")
spell:words("### Magma Storm ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
