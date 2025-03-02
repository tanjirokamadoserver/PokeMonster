local AREA_KINESIS = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_KINESIS))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Kinesis")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local position = creature:getPosition()

    local function executeAttack(isFirst)
        local creature = Creature(creatureId)
        if not creature then
            return -- Interrompe se a criatura não existir
        end

        if isFirst then
            doSendMagicEffect(position, 2459)
        end

        combat1:execute(creature, Variant(position))
    end

    -- Execução inicial do ataque
    executeAttack(true)

    -- Agendamento do segundo ataque com verificação de existência da criatura
    addEvent(function()
        if Creature(creatureId) then -- Verifica novamente se a criatura existe
            executeAttack(false)
        end
    end, 200)

    return true
end

spell:name("Kinesis")
spell:words("### Kinesis ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

