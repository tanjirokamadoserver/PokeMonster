local AREA_IMPACT = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_IMPACT))
combat1:setParameter(COMBAT_PARAM_EFFECT, 104)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Giga Impact")

local spell = Spell(SPELL_INSTANT)

local function activateEffect(creature_id, position, duration)
    local elapsed = 0
    local interval = 3000

    local function repeatEffect()
        if elapsed < duration then
            local creature = Creature(creature_id)
            if creature then
                doSendMagicEffect(position, 2417)
                elapsed = elapsed + interval
                addEvent(repeatEffect, interval)
            end
        end
    end

    repeatEffect()
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    -- Inicia o efeito de repetição
    activateEffect(creature_id, position, 3000)

    -- Agendando a execução da animação de salto e do combate
    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            creature:sendJump(30, 300)

            addEvent(function()
                if Creature(creature_id) then -- Verifica se a criatura ainda existe antes de executar o combate
                    combat1:execute(creature, variant)
                end
            end, 400)
        end
    end, 3000)

    return true
end

spell:name("Giga Impact")
spell:words("### Giga Impact ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
