local acombat = createCombatObject()
acombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
acombat:setParameter(COMBAT_PARAM_EFFECT, 1108)
acombat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Infestation")

local area = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},  
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
})

acombat:setArea(area)

local conditionSleep = createConditionObject(CONDITION_SLEEP)
conditionSleep:setParameter(CONDITION_PARAM_TICKS, 6 * 1000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT_TICKS, 2 * 200)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT, 23) 
acombat:addCondition(conditionSleep)

local function damagear(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    param.combat:execute(creature, param.var)
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId() -- Armazena o ID da criatura

    addEvent(function()
        -- Verifica se a criatura ainda existe
        local creature = Creature(creatureId)
        if not creature then
            return -- Sai do evento se a criatura não existir
        end

        -- Executa o dano ou efeito se a criatura existir
        local params = {cid = creatureId, var = variant, combat = acombat}
        damagear(params)
    end, math.random(1000, 1500)) -- Define o atraso

    return acombat:execute(creature, variant)
end

spell:name("Infestation")
spell:words("#Infestation#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
