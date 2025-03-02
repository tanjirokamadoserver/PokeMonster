local AREA_TANTRUM = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat1:setArea(createCombatArea(AREA_TANTRUM))
combat1:setParameter(COMBAT_PARAM_EFFECT, 101)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stomping Tantrum")

local AREA_TANTRUM2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat2:setArea(createCombatArea(AREA_TANTRUM2))
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stomping Tantrum")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local position = creature:getPosition()
    
    creature:sendJump(20, 250)
    
    -- Agendar o efeito do salto
    addEvent(function()
        local creature = Creature(creatureId) -- Verificar se a criatura ainda existe
        if creature then
            local jumpPosition = creature:getPosition()
            jumpPosition.x = jumpPosition.x + 1
            jumpPosition.y = jumpPosition.y + 1
            doSendMagicEffect(jumpPosition, 128)
        end
    end, 500)
    
    -- Agendar o lançamento do primeiro combate (combat2)
    addEvent(function()
        local creature = Creature(creatureId) -- Verificar se a criatura ainda existe
        if creature then
            combat2:execute(creature, variant)
        end
    end, 500)

    -- Agendar o lançamento do segundo combate (combat1)
    addEvent(function()
        local creature = Creature(creatureId) -- Verificar se a criatura ainda existe
        if creature then
            combat1:execute(creature, variant)
        end
    end, 1500)

    return true
end

spell:name("Stomping Tantrum")
spell:words("### Stomping Tantrum ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
