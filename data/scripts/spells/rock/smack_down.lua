local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)
combat:setParameter(COMBAT_PARAM_EFFECT, 817)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Smack Down")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    for i = 0, 2 do
        addEvent(function()
            local creature = Creature(creatureId)  -- Obtém a criatura novamente
            if creature then  -- Verifica se a criatura ainda existe
                combat:execute(creature, variant)
            end
        end, i * 200)  -- Tempo entre os lançamentos
    end

    return true
end


spell:name("Smack Down")
spell:words("#Smack Down#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
