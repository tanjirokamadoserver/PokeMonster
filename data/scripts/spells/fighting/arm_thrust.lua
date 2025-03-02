local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Arm Thrust")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 218,
    [DIRECTION_EAST] = 216,
    [DIRECTION_SOUTH] = 219,
    [DIRECTION_WEST] = 217
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local direction = creature:getDirection()
    local effectId = effects[direction]

    -- Aplica o efeito mágico no alvo
    creature:getPosition():sendMagicEffect(effectId)

    -- Agendamento dos ataques, com verificações de existência da criatura
    for i = 0, 2 do
        addEvent(function(cid)
            local creature = Creature(cid)
            if creature then
                combat:execute(creature, variant)
            end
        end, i * 150, creatureId)
    end
    
    return true
end

spell:name("Arm Thrust")
spell:words("#Arm Thrust#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
