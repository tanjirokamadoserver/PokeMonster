local MISSILE_TYPE = 15

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 21)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Bomb")

local condition = Condition(CONDITION_POISON)
condition:setTicks(10000)
condition:setParameter(CONDITION_PARAM_EFFECT, 21)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local area = createCombatArea({
    {0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0},
    {0, 1, 3, 1, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0}
})

combat:setArea(area)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local creaturePos = creature:getPosition()
    local missileFinalPos = Position(creaturePos.x - 7, creaturePos.y - 7, creaturePos.z)

    -- Envia o primeiro projétil
    doSendDistanceShoot(creaturePos, missileFinalPos, MISSILE_TYPE)

    -- Agendamento do lançamento de projétil para o alvo
    addEvent(function(cid)
        local target = Creature(cid)
        if target and target:isCreature() then
            doSendDistanceShoot(missileFinalPos, target:getPosition(), MISSILE_TYPE)
        end
    end, 500, creatureId)

    -- Agendamento da execução do combate
    addEvent(function(cid, combatVariant)
        local target = Creature(cid)
        if target and target:isCreature() then
            combat:execute(target, combatVariant)
        end
    end, 1000, creatureId, variant)

    return true
end

spell:name("Poison Bomb")
spell:words("#Poison Bomb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
