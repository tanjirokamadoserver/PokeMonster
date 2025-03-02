local AREA_WRATH = {
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setArea(createCombatArea(AREA_WRATH))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunder Wrath")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    doSendMagicEffect(creature:getPosition(), 803)
    
    addEvent(function(creatureId)
        local creature = Creature(creatureId)
        if creature then
            doSendMagicEffect(creature:getPosition(), 2444)
            combat1:execute(creature, variant)
        end
    end, 300, creature:getId())
    
    return true
end

spell:name("Thunder Wrath")
spell:words("### Thunder Wrath ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
