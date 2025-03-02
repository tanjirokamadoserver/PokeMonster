local psy1 = {        
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 1, 2, 1, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local psy2 = {        
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 1, 0, 2, 0, 1, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local psy3 = {        
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 2, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local psy4 = {        
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local function createCombatForArea(area, effect, spellName)
    local combat = createCombatObject()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, effect)
    combat:setArea(createCombatArea(area))
    combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, spellName)
    return combat
end

local combat1 = createCombatForArea(psy1, 326, "Psychokinesis")
local combat2 = createCombatForArea(psy2, 326, "Psychokinesis")
local combat3 = createCombatForArea(psy3, 326, "Psychokinesis")
local combat4 = createCombatForArea(psy4, 326, "Psychokinesis")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    doSendMagicEffect(position, 1992)

    local combats = {combat1, combat2, combat3, combat2, combat4, combat3, combat1, combat2}
    local delay = 2000

    for i, combat in ipairs(combats) do
        addEvent(function()
            local creature = Creature(creature_id)
            if creature then
                combat:execute(creature, Variant(position))
            end
        end, delay)
        delay = delay + 200
    end

    return true
end

spell:name("Psychokinesis")
spell:words("### Psychokinesis ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
