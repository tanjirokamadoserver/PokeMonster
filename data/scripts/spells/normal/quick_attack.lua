local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Quick Attack")
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local function applyEffect(creature, target)
    -- Aplica o efeito no alvo
    target:sendJump(10, 150)
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    -- Processa todos os alvos afetados pelo combate
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(creature, target)
    end

    -- Executa o combate
    return combat:execute(creature, variant)
end

targetSpell:name("Quick Attack")
targetSpell:words("#Quick Attack")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(2)
targetSpell:register()
