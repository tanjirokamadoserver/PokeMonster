local SPOUT = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 2, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local SPOUT2 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 2, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local SPOUT3 = {
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {1, 1, 1, 1, 0, 2, 0, 1, 1, 1, 1},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}

local SPOUT4 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 1, 1, 1, 2, 1, 1, 1, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local SPOUT5 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 1, 1, 0, 0, 0, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 2, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 0, 0, 0, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

-- Criando um objeto de combate para cada área
local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 406)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Spout")
combat1:setArea(createCombatArea(SPOUT))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 365)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Spout")
combat2:setArea(createCombatArea(SPOUT2))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 406)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Spout")
combat3:setArea(createCombatArea(SPOUT3))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 365)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Spout")
combat4:setArea(createCombatArea(SPOUT4))

local combat5 = createCombatObject()
combat5:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat5:setParameter(COMBAT_PARAM_EFFECT, 406)
combat5:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Spout")
combat5:setArea(createCombatArea(SPOUT5))

-- Tabela contendo todos os combates
local combats = {combat1, combat2, combat3, combat4, combat5, combat4}

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
        -- Verifica se a criatura ainda existe antes de agendar o evento
        addEvent(function()
            local creature = Creature(creatureId)
            if creature then
                executeCombat(creatureId, combat)
            end
        end, delay)

        delay = delay + 400 -- 0.5 segundos entre cada combate
    end
    return true
end

spell:name("Water Spout")
spell:words("### Water Spout ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
