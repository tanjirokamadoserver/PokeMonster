local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 34)
combat:setParameter(COMBAT_PARAM_EFFECT, 681)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sonicboom")

local condition = createConditionObject(CONDITION_CONFUSION)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    local function repeatAttack(times)
        local creature = Creature(creatureId)
        if not creature or times <= 0 then
            return -- Interrompe se a criatura não existir ou se acabarem as repetições
        end

        combat:execute(creature, variant) -- Executa o ataque
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe antes de chamar novamente
                repeatAttack(times - 1)
            end
        end, 150)
    end

    local repetitions = math.random(3, 5)
    repeatAttack(repetitions)

    return true
end

spell:name("Sonicboom")
spell:words("##Sonicboom##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
