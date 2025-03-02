local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Flamethrower")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = {effectId = 384, offset = {x = 0, y = -1}}, -- Efeito 384
    [DIRECTION_EAST] = {effectId = 385, offset = {x = 4, y = 0}},  -- Efeito 385
    [DIRECTION_SOUTH] = {effectId = 387, offset = {x = 0, y = 4}},  -- Efeito 387
    [DIRECTION_WEST] = {effectId = 386, offset = {x = -1, y = 0}}   -- Efeito 386
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


spell:name("Flamethrower")
spell:words("#Flamethrower#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()
