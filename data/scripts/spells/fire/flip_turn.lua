local BULLET_FIRE_EFFECT = 332
local BULLET_FIRE_DAMAGE = COMBAT_FIREDAMAGE
local MISSILE_TYPE = 20
local INVISIBILITY_EFFECT = 437

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, BULLET_FIRE_DAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, BULLET_FIRE_EFFECT)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Flip Turn")

local condition = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 2000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetId = target:getId() -- Obtém o ID do alvo
    local creatureId = creature:getId() -- Obtém o ID da criatura
    local targetPos = target:getPosition()
    local creaturePos = creature:getPosition()
    local originalOutfit = creature:getOutfit()

    -- Move a criatura para a posição do alvo
    creature:moveTo(targetPos)
    doSendDistanceShoot(creaturePos, targetPos, MISSILE_TYPE)
    creature:addCondition(condition)
    doSendMagicEffect(creaturePos, INVISIBILITY_EFFECT)
    combat:execute(creature, Variant(targetPos))

    -- Agenda a restauração do outfit e o segundo efeito
    addEvent(function(cid, tid, outfit)
        local creature = Creature(cid)
        local target = Creature(tid)
        if creature and creature:isCreature() then
            creature:setOutfit(outfit)
            if target then
                local newTargetPos = creature:getPosition()
                local targetCurrentPos = target:getPosition()
                doSendDistanceShoot(targetCurrentPos, newTargetPos, MISSILE_TYPE)
            end
        end
    end, 2000, creatureId, targetId, originalOutfit)

    return true
end

spell:name("Flip Turn")
spell:words("#Flip Turn#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
