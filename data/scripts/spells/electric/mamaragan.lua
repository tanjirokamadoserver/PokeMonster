local AREA_STORM = {
{0, 0, 0},
{1, 1, 1},
{1, 2, 1},
{1, 1, 1},
{0, 0, 0}
}

local AREA_STORM1 = {
{0, 0, 0, 0, 0, 0, 0},
{0, 0, 1, 1, 1, 0, 0},
{0, 1, 0, 0, 0, 1, 0},
{0, 1, 0, 2, 0, 1, 0},
{0, 1, 0, 0, 0, 1, 0},
{0, 0, 1, 1, 1, 0, 0},
{0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM2 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 2, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM3 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM4 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}


-- Criando um objeto de combate para cada área
local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 336)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mamaragan")
combat1:setArea(createCombatArea(AREA_STORM))

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 336)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mamaragan")
combat2:setArea(createCombatArea(AREA_STORM1))

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 336)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mamaragan")
combat3:setArea(createCombatArea(AREA_STORM2))

local combat4 = createCombatObject()
combat4:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat4:setParameter(COMBAT_PARAM_EFFECT, 336)
combat4:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mamaragan")
combat4:setArea(createCombatArea(AREA_STORM3))

local combat5 = createCombatObject()
combat5:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat5:setParameter(COMBAT_PARAM_EFFECT, 336)
combat5:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mamaragan")
combat5:setArea(createCombatArea(AREA_STORM4))

-- Tabela contendo todos os combates
local combats = {combat1, combat2, combat1, combat2, combat1, combat2, combat1, combat2, combat3, combat2, combat3, combat2, combat3, combat2, combat3, combat4, combat3, combat4, combat3, combat4, combat3, combat4}

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
		if creatureId then
			addEvent(executeCombat, delay, creatureId, combat)
			delay = delay + 250
			end
		end
    return true
end

spell:name("Mamaragan")
spell:words("### Mamaragan ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()