local AREA_CONFUSION = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 13)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Healing Wish")
combat:setArea(createCombatArea(AREA_CONFUSION))
local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    return true
end

spell:name("Healing Wish")
spell:words("### Healing Wish ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

