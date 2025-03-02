local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 16)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Horn Attack")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Verifica se a criatura ainda existe
    if not creature then
        return false -- Interrompe a execução se a criatura não existir ou estiver morta
    end

    -- Cria os eventos para executar o combate em intervalos
    for i = 0, 2 do
        addEvent(function()
            -- Verifica se a criatura ainda existe antes de executar o combate
            local targetCreature = Creature(creature:getId())
            if targetCreature then
                combat:execute(targetCreature, variant)
            end
        end, i * 100)
    end

    return true
end

spell:name("Horn Attack")
spell:words("#Horn Attack#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
