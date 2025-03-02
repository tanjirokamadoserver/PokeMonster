local AREA_STOMP = {
    {1, 0, 0, 1, 0, 0, 1},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {1, 1, 1, 3, 1, 1, 1},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {1, 0, 0, 1, 0, 0, 1}
}

local AREA_STOMP2 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 2, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_STOMP))
combat1:setParameter(COMBAT_PARAM_EFFECT, 119)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Crusher Stomp")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat2:setArea(createCombatArea(AREA_STOMP2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 128)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Crusher Stomp")

local condition = createConditionObject(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()

    creature:sendJump(20, 200)

    addEvent(function()
        local creature = Creature(creature_id)  -- Criar a referência da criatura dentro do evento
        if creature then  -- Verificar se a criatura ainda existe
            combat1:execute(creature, variant)
            combat2:execute(creature, variant)
        end
    end, 250)  -- O tempo do addEvent permanece o mesmo

    return true
end

spell:name("Crusher Stomp")
spell:words("### Crusher Stomp ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
