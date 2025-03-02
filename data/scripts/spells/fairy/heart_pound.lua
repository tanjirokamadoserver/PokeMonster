local AREA_POUND = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat1:setArea(createCombatArea(AREA_POUND))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2008)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heart Pound")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    doSendMagicEffect(position, 2099)

    -- Agendamento do evento para executar o combate
    addEvent(function(cid)
        local creature = Creature(cid)
        if creature then
            -- A criatura existe, executa o combate
            combat1:execute(creature, variant)
        end
    end, 2000, creature_id)

    return true
end

spell:name("Heart Pound")
spell:words("### Heart Pound ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

