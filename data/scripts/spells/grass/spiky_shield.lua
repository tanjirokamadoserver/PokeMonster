local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spiky Shield")

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
        if target and target:getCondition(CONDITION_DEFENSEBONUS, CONDITIONID_COMBAT, 0) then
            local creaturePos = target:getPosition()
            local effectPos = Position(creaturePos.x + offsetX, creaturePos.y + offsetY, creaturePos.z)
            effectPos:sendMagicEffect(473)

            -- Reagendar o próximo efeito somente se a criatura ainda existir
            addEvent(function()
                if Creature(cid) then
                    applyEffect(cid)
                end
            end, effectInterval)
        end
    end

    -- Inicia o ciclo do efeito
    addEvent(function()
        if Creature(creatureId) then
            applyEffect(creatureId)
        end
    end, effectInterval)

    return true
end

spell:name("Spiky Shield")
spell:words("### Spiky Shield ###")
spell:needLearn(false)
spell:register()