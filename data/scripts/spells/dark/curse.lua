local AREA_CURSE = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat1:setArea(createCombatArea(AREA_CURSE))
combat1:setParameter(COMBAT_PARAM_EFFECT, 263)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Curse")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    local function executeCombat(creatureId)
        local creature = Creature(creatureId)
        if not creature then
            return -- Interrompe se a criatura não existir
        end
        
        local newPos = creature:getPosition()
        combat1:execute(creature, Variant(newPos))
    end

    -- Agendamento de eventos para execução do combate
    for i = 0, 3 do
        addEvent(function()
            if Creature(creatureId) then -- Verifica se a criatura ainda existe
                executeCombat(creatureId)
            end
        end, 500 * (i + 1))
    end

    return true
end

spell:name("Curse")
spell:words("#Curse#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()

