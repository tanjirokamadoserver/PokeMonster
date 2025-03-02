local AREA_TOMBS = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 3, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 365)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Water Pulse")
combat:setArea(createCombatArea(AREA_TOMBS))

-- Função para aplicar o efeito em cada target.
local function applyEffect(target)
    target:sendJump(20, 300)
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    -- Itera sobre os alvos e aplica o efeito.
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(target)
    end

    -- Executa o combate.
    combat:execute(creature, variant)
    return true
end

spell:name("Water Pulse")
spell:words("### Water Pulse ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

