local acombat = createCombatObject()
local combat = createCombatObject()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dream Eater")

local area = createCombatArea(NO_AREA)
local area2 = createCombatArea({
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}
})

combat:setArea(area2)
acombat:setArea(area)

local conditionSleep = createConditionObject(CONDITION_SLEEP)
conditionSleep:setParameter(CONDITION_PARAM_TICKS, 6 * 1000)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT_TICKS, 2 * 200)
conditionSleep:setParameter(CONDITION_PARAM_EFFECT, 15) 
acombat:addCondition(conditionSleep)

local function AttackDown(params)
    local creature = Creature(params.cid)
    if not creature then
        return
    end

    local position = Position(params.pos)
    position:sendMagicEffect(params.effectId)
end

function onTargetTile(creature, pos)
    local effectPosition = {x = pos.x + 5, y = pos.y + 1, z = pos.z}
    addEvent(AttackDown, 0, {cid = creature:getId(), pos = effectPosition, effectId = 2493})
end

local function damagear(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    param.combat:execute(creature, param.var)
end

acombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    -- Agendando o dano com verificação de existência da criatura
    addEvent(function()
        if Creature(creature:getId()) then -- Verifica se a criatura ainda existe
            damagear({cid = creature:getId(), var = variant, combat = combat})
        end
    end, math.random(0, 300)) -- Atraso aleatório para o ataque

    -- Executando o combate com o efeito de sono
    return acombat:execute(creature, variant)
end

spell:name("Dream Eater")
spell:words("#Dream Eater#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
