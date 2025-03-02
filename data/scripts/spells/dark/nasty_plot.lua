local AREA_HONE = {
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
    }

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Nasty plot")
combat:setArea(createCombatArea(AREA_HONE))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local position = creature:getPosition()

    position:sendMagicEffect(366)

    combat:execute(creature, variant)
    return true
end

spell:name("Nasty plot")
spell:words("#Nasty plot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
