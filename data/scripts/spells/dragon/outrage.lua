local AREA_OUTRAGE = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}
local AREA_OUTRAGE2 = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1402)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Outrage")
combat:setArea(createCombatArea(AREA_OUTRAGE))

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 973)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Outrage")
combat1:setArea(createCombatArea(AREA_OUTRAGE2))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    combat1:execute(creature, variant)
    return true
end

spell:name("Outrage")
spell:words("### Outrage ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
