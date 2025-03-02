local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leaf Guard")

local condition = createConditionObject(CONDITION_DEFENSEBONUS)
condition:setParameter(CONDITION_PARAM_TICKS, 15000)

local effectInterval = 1000
local offsetX = 1
local offsetY = 1

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant) 
    creature:addCondition(condition)
    
    local creatureId = creature:getId()

    local function applyEffect(cid)
        local target = Creature(cid)
        if not target then
            return -- Encerra se a criatura não existir
        end

        -- Verifica se a criatura ainda possui a condição ativa
        if target:getCondition(CONDITION_DEFENSEBONUS, CONDITIONID_COMBAT, 0) then
            local creaturePos = target:getPosition()
            local effectPos = Position(creaturePos.x + offsetX, creaturePos.y + offsetY, creaturePos.z)
            effectPos:sendMagicEffect(737)

            -- Reagenda o evento somente se a condição ainda está ativa
            addEvent(applyEffect, effectInterval, cid)
        end
    end

    -- Inicializa o efeito
    addEvent(function()
        if Creature(creatureId) then -- Garante que a criatura ainda existe antes de iniciar
            applyEffect(creatureId)
        end
    end, effectInterval)
    
    return true
end

spell:name("Leaf Guard")
spell:words("### Leaf Guard ###")
spell:needLearn(false)
spell:register()
