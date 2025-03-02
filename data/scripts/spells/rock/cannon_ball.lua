local AREA_COUNT = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat1:setArea(createCombatArea(AREA_COUNT))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Cannon Ball")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    if not creature or not variant then return false end

    local creatureid = creature:getId()
    local position = creature:getPosition()
    
    doSendMagicEffect(position, 1056)

    addEvent(function()
        if isCreature(creatureid) then
            combat1:execute(creature, variant)
            doSendMagicEffect(position, 2086)
        end
    end, 2000)

    return true
end

spell:name("Cannon Ball")
spell:words("### Cannon Ball ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
