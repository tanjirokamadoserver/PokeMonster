local AREA_LEAFAGE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat1:setArea(createCombatArea(AREA_LEAFAGE))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2425)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leafage")

-- Função para aplicar o efeito
local function applyEffect(target)
    target:sendJump(20, 1000) -- Aplica o efeito "jump" no alvo
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Executa o combate na área
    combat1:execute(creature, variant)

    -- Aplica o efeito nos alvos atingidos
    for _, target in ipairs(combat1:getTargets(creature, variant)) do
        addEvent(applyEffect, 0, target)
    end

    return true
end

spell:name("Leafage")
spell:words("### Leafage ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
