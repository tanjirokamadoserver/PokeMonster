local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 22)
combat:setParameter(COMBAT_PARAM_EFFECT, 246)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Magical Leaf")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    local function executeCombat(creatureId, variant)
        local caster = Creature(creatureId)
        if not caster then
            return -- Interrompe se a criatura não existir
        end
        combat:execute(caster, variant)
    end

    -- Agendamento dos eventos para o ataque múltiplo
    for i = 0, 2 do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                executeCombat(creatureId, variant)
            end
        end, i * 200)
    end

    return true
end

spell:name("Magical Leaf")
spell:words("#Magical Leaf#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
