local AREA_FORCE = {
    {1, 1, 1},
    {1, 2, 1},
    {1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setArea(createCombatArea(AREA_FORCE))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Counter Spin")

local spell = Spell(SPELL_INSTANT)

local effects = {
    north = 252,
    east = 254,
    south = 253,
    west = 255
}

local function repeatAttack(creatureId, pos, count)
    addEvent(function() 
        local creature = Creature(creatureId)  -- Recria a referência da criatura
        if creature and count > 0 then
            pos:sendMagicEffect(effects.north)
            pos:sendMagicEffect(effects.east)
            pos:sendMagicEffect(effects.south)
            pos:sendMagicEffect(effects.west)

            combat:execute(creature, variant)

            addEvent(repeatAttack, 500, creatureId, pos, count - 1)  -- Agendamento recursivo
        end
    end, 500)  -- Tempo de delay antes de executar a função
end

function spell.onCastSpell(creature, variant)
    local pos = creature:getPosition()
    repeatAttack(creature:getId(), pos, 9)
    return true
end

spell:name("Counter Spin")
spell:words("#Counter Spin#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

