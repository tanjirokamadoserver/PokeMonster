local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Gun")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = {effectId = 70, offset = {x = 1, y = -1}}, -- Efeito 70
    [DIRECTION_EAST] = {effectId = 71, offset = {x = 4, y = 1}},  -- Efeito 71
    [DIRECTION_SOUTH] = {effectId = 72, offset = {x = 1, y = 4}},  -- Efeito 72
    [DIRECTION_WEST] = {effectId = 73, offset = {x = -1, y = 1}}   -- Efeito 73
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

spell:name("Water Gun")
spell:words("#Water Gun#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
