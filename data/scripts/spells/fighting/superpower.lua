local AREA_POWER = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat1:setArea(createCombatArea(AREA_POWER))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Superpower")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local initialPosition = creature:getPosition()
    doSendMagicEffect(initialPosition, 1009)

    addEvent(function(cid)
        local creature = Creature(cid)
        if creature then
            local currentPosition = creature:getPosition()
            doSendMagicEffect(currentPosition, 2436)
        end
    end, 1700, creatureId)

    for i = 1, 8 do
        addEvent(function(cid)
            local creature = Creature(cid)
            if creature then
                local currentPosition = creature:getPosition()
                local combatVariant = Variant(currentPosition)
                combat1:execute(creature, variant)
            end
        end, 1700 + (i * 100), creatureId)
    end

    return true
end

spell:name("Superpower")
spell:words("### Superpower ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
