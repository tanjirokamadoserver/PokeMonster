local acombat = createCombatObject()
acombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
acombat:setParameter(COMBAT_PARAM_EFFECT, 61)
acombat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sleep Powder")

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Sleep Powder")

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
conditionSleep:setParameter(CONDITION_PARAM_TICKS, 5 * 1000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT, 33) 
acombat:addCondition(conditionSleep)

local function AttackDown(params)
    local creature = Creature(params.cid)
    if not creature then
        return
    end

    local position = Position(params.pos)
    position:sendDistanceEffect(position, 30)
    position:sendMagicEffect(params.effectId)
end

function onTargetTile(creature, pos)
end

local function damagear(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    param.combat:execute(creature, param.var)
end

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    -- Executa dano com verificação de existência da criatura
    addEvent(function()
        if Creature(creatureId) then
            damagear({cid = creatureId, var = variant, combat = combat})
        end
    end, math.random(1000, 1500))

    -- Executa o combate principal com área e condição
    return acombat:execute(creature, variant)
end

spell:name("Sleep Powder")
spell:words("#Sleep Powder#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
