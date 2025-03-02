local acombat = createCombatObject()
acombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
acombat:setParameter(COMBAT_PARAM_EFFECT, 86)
acombat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stun Spore")

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Stun Spore")

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

local conditionSleep = createConditionObject(CONDITION_PARALYZE)
conditionSleep:setParameter(CONDITION_PARAM_TICKS, 10 * 1000)
conditionSleep:setParameter(CONDITION_PARAM_SPEED, -150)
acombat:addCondition(conditionSleep)

local function onTargetTile(creature, pos)
end
acombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

-- Função para aplicar dano de forma segura
local function damagear(param)
    local creature = Creature(param.cid)
    if not creature then
        return -- Encerra o evento caso a criatura não exista
    end
    param.combat:execute(creature, param.var)
end

local spell = Spell(SPELL_INSTANT)
function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    
    -- Garantia de execução segura do addEvent
    addEvent(function()
        if Creature(creatureId) then
            damagear({cid = creatureId, var = variant, combat = combat})
        end
    end, math.random(1000, 1500))
    
    return acombat:execute(creature, variant)
end

spell:name("Stun Spore")
spell:words("#Stun Spore#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
