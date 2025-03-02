local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1202)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Earthquake")

local area = createCombatArea(
{
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0}
})

combat:setArea(area)

-- Função para aplicar os efeitos no target
local function applyEffect(target)
    if target:isCreature() then
        target:sendJump(20, 280) -- Aplica o efeito de "pulo" no target
    end
end

local function recursiveSpell(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    local position = creature:getPosition()
    position:shakeScreen(6, 300) -- Efeito de "shake" na tela

    -- Executa o combate na posição da criatura
    combat:execute(creature, Variant(position))

    -- Verifica se o tempo ainda está dentro do limite
    if os.time() <= param.time then
        addEvent(recursiveSpell, 320, param) -- Agendamento da próxima execução
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(target) -- Aplica o efeito para cada target
    end

    local position = creature:getPosition()
    position:shakeScreen(6, 300) -- Efeito inicial de shake na tela

    -- Agendamento do evento recursivo
    addEvent(function()
        if Creature(creature:getId()) then -- Verifica se a criatura ainda existe
            recursiveSpell({cid = creature:getId(), var = variant, time = os.time() + 3})
        end
    end, 320)

    return true
end

spell:name("Earthquake")
spell:words("#Earthquake#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
