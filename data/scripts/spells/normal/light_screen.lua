local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Light Screen")

local condition = createConditionObject(CONDITION_DEFENSEBONUS)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    creature:addCondition(condition)
    
    local creatureId = creature:getId()

    local function applyEffect(creatureId)
        local creature = Creature(creatureId)
        if not creature or creature:isRemoved() then
            return -- Se a criatura foi removida, interrompe a execução
        end
        local position = creature:getPosition()

        position:sendMagicEffect(2004)
    end

    -- Agendamento de eventos para aplicar o efeito em intervalos de 1 segundo
    for i = 0, 9 do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                applyEffect(creatureId)
            end
        end, i * 1000) -- Cada efeito será aplicado com um intervalo de 1 segundo
    end
    
    return true
end

spell:name("Light Screen")
spell:words("### Light Screen ###")
spell:needLearn(false)
spell:register()
