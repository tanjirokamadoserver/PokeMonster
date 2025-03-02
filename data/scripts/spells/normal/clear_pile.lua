local combat = Combat()

-- Configuração dos parâmetros do combate
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE) -- Correção do nome do tipo de dano
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Clear Pile")

local effectOffsetX = 0
local effectOffsetY = 1

-- Função para aplicar o efeito no alvo
local function applyEffect(target)
    local targetPosition = target:getPosition()
    targetPosition.x = targetPosition.x + effectOffsetX
    targetPosition.y = targetPosition.y + effectOffsetY
    targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
end

-- Spell configurada para uso
local targetSpellTeste = Spell(SPELL_INSTANT)

function targetSpellTeste.onCastSpell(creature, variant)
    -- Obtendo os alvos do combate e aplicando os efeitos
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(target)
    end

    return true
end

-- Configurando os atributos da spell
targetSpellTeste:name("Clear Pile")
targetSpellTeste:words("###Clear Pile###")
targetSpellTeste:isAggressive(true)
targetSpellTeste:needLearn(false)
targetSpellTeste:needTarget(true)
targetSpellTeste:register()
