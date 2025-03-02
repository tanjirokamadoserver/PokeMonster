local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 14)
combat:setParameter(COMBAT_PARAM_EFFECT, 314)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Toxic Spikes")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId() 

    local function executeCombat(creatureId, times)
        local creature = Creature(creatureId) 
        if creature then
            combat:execute(creature, variant)
        end

        times = times - 1
        if times > 0 then
            addEvent(function() 
                if Creature(creatureId) then -- Verifica se a criatura ainda existe antes de executar
                    executeCombat(creatureId, times) 
                end
            end, 150)
        end
    end

    local repeatTimes = math.random(2)
    executeCombat(creatureId, repeatTimes)

    return true
end

spell:name("Toxic Spikes")
spell:words("#Toxic Spikes#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
