local AREA_BOUNCE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat1:setArea(createCombatArea(AREA_BOUNCE))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bounce")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    creature:sendJump(50, 3000)

    -- Agendamento do evento para 3 segundos após o pulo
    addEvent(function(cid)
        local creature = Creature(cid)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        local position = creature:getPosition()
        doSendMagicEffect(position, 2424)
        combat1:execute(creature, variant)
    end, 3000, creature_id)

    return true
end

spell:name("Bounce")
spell:words("### Bounce ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
