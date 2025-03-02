local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local healthToRestore = creature:getMaxHealth() * 0.20 / 8

    -- Função para realizar a cura
    local function healEvent(creatureId)
        local creature = Creature(creatureId)
        if creature then
            creature:addHealth(healthToRestore)
            local position = creature:getPosition()
            local effectPosition = Position(position.x + 1, position.y + 1, position.z)
            effectPosition:sendMagicEffect(2325)
        end
    end
    
    -- Agendando eventos para cura com intervalos de 1 segundo
    for i = 1, 8 do
        addEvent(function()
            local creature = Creature(creature:getId()) -- Reconecta a criatura pelo ID
            if creature then
                healEvent(creature:getId()) -- Realiza o evento de cura
            end
        end, i * 1000, creature:getId())
    end
    
    -- Executa o combate
    combat:execute(creature, variant)
    
    return true
end

spell:name("Aqua Ring")
spell:words("# Aqua Ring #")
spell:needLearn(false)
spell:register()
