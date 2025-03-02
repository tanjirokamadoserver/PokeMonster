local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sand Attack")
combat:setArea(createCombatArea({
    {0, 1, 0},
    {0, 3, 0}
}))


local effects = {
    [DIRECTION_NORTH] = {effectId = 121, offset = {x = 0, y = -1}}, -- Efeito 121
    [DIRECTION_EAST] = {effectId = 122, offset = {x = 2, y = 0}},  -- Efeito 122
    [DIRECTION_SOUTH] = {effectId = 123, offset = {x = 0, y = 2}},  -- Efeito 123
    [DIRECTION_WEST] = {effectId = 120, offset = {x = -1, y = 0}}   -- Efeito 120
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    
    if effects[direction] then
        local pos = creature:getPosition()
        local effectData = effects[direction]
        local newPos = Position(pos.x + effectData.offset.x, pos.y + effectData.offset.y, pos.z)
        
        -- Envia o efeito mágico correspondente
        newPos:sendMagicEffect(effectData.effectId)
        
        -- Executa o combate
        combat:execute(creature, variant)
    end
    
    return true
end

spell:name("Sand Attack")
spell:words("#Sand Attack#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
