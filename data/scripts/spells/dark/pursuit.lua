local BULLET_SEED_EFFECT = 332
local BULLET_SEED_DAMAGE = COMBAT_BUGDAMAGE
local MISSILE_TYPE = 54
local INVISIBILITY_EFFECT = 437

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, BULLET_SEED_DAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, BULLET_SEED_EFFECT)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Pursuit")

local condition = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 2000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPos = target:getPosition()
    local creaturePos = creature:getPosition()

    local originalOutfit = creature:getOutfit()
    
    -- Move the creature to the target position
    creature:moveTo(targetPos)

    doSendDistanceShoot(creaturePos, targetPos, MISSILE_TYPE)
    creature:addCondition(condition)

    doSendMagicEffect(creaturePos, INVISIBILITY_EFFECT)
    combat:execute(creature, Variant(targetPos))

    -- Agendamento para restaurar o outfit e lançar o projétil
    addEvent(function()
        local currentCreature = Creature(creature:getId()) -- Verifica se a criatura ainda existe
        if currentCreature and currentCreature:isCreature() then
            currentCreature:setOutfit(originalOutfit)
            local newTargetPos = currentCreature:getPosition()
            local targetCurrentPos = target:getPosition()

            -- Lança o projétil na nova posição do alvo
            doSendDistanceShoot(targetCurrentPos, newTargetPos, MISSILE_TYPE)
        end
    end, 2000)

    return true
end

spell:name("Pursuit")
spell:words("#Pursuit#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()