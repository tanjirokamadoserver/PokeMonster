local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 14)
combat:setParameter(COMBAT_PARAM_EFFECT, 9)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Gunk Shot")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    -- Função para executar o combate com verificação se a criatura ainda existe
    local function executeCombat(creatureId, times)
        local creature = Creature(creatureId)
        if creature then
            combat:execute(creature, variant)
        end

        times = times - 1
        if times > 0 then
            addEvent(function()
                if Creature(creatureId) then
                    executeCombat(creatureId, times)
                end
            end, 150)
        end
    end

    local repeatTimes = math.random(2, 3)
    executeCombat(creatureId, repeatTimes)

    return true
end

spell:name("Gunk Shot")
spell:words("#Gunk Shot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()

