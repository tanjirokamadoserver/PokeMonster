local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Clear Smog")

local spell = Spell(SPELL_INSTANT)

-- Nome ou identificador da spell Smog
local smogSpellName = "Smog"  -- Certifique-se de que esse seja o nome correto da spell Smog

function spell.onCastSpell(creature, variant)
    -- Procura por qualquer spell ativa chamada "Smog" na lista de efeitos ativos
    local activeSpells = creature:getActiveSpells()
    for _, activeSpell in ipairs(activeSpells) do
        if activeSpell:getName() == smogSpellName then
            activeSpell:remove() -- Cancela a spell Smog
        end
    end
    
    -- Executa a magia Clear Smog
    combat:execute(creature, variant) 
    creature:addCondition(condition)
    return true
end

spell:name("Clear Smog")
spell:words("### Clear Smog ###")
spell:needLearn(false)
spell:register()
