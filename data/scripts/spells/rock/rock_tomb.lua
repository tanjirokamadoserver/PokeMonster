local SHOT_COUNT = 1
local SHOT_DELAY = 150
local MISSILE_EFFECT = 40
local CONDITION_SPEED_REDUCTION = 200
local CONDITION_DURATION = 6000
local EFFECT_ID = 158

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rock Tomb")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, CONDITION_DURATION)
condition:setParameter(CONDITION_PARAM_SPEED, -CONDITION_SPEED_REDUCTION)

local spell = Spell(SPELL_INSTANT)

local function doShotDownDamage(creature_id, toPos, target_id)
    local creature = Creature(creature_id)
    if not creature then
        return
    end
    local target = Creature(target_id)
    if not target then
        return
    end

    combat:execute(creature, Variant(target_id))
    target:getPosition():sendMagicEffect(EFFECT_ID)
    target:addCondition(condition)
end

local function doShotUp(fromPos, toPos, effect, nextToPosition, creature_id, target_id)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(function()
        if Creature(creature_id) then -- Verifica se a criatura ainda existe antes de enviar o segundo projétil
            doSendDistanceShoot(toPos, nextToPosition, effect)
        end
    end, 75)
    addEvent(function()
        if Creature(creature_id) then -- Verifica se a criatura ainda existe antes de realizar o dano
            doShotDownDamage(creature_id, nextToPosition, target_id)
        end
    end, 400)
end

local function doShot(count, creature_id, target_id)
    if count > 0 then
        local creature = Creature(creature_id)
        if not creature then
            return
        end

        for i = 1, SHOT_COUNT do
            addEvent(function(creature_id)
                local creature = Creature(creature_id)
                if not creature then
                    return
                end
                local creaturePos = creature:getPosition()
                local upwardPos = creaturePos - Position(9 + math.random(-2, 2), 9 + math.random(-2, 2), 0)
                local target = creature:getTarget()

                if not target or target:getId() ~= target_id then
                    return
                end

                local targetPos = target:getPosition()
                doShotUp(creaturePos, upwardPos, MISSILE_EFFECT, targetPos, creature_id, target_id)
            end, i * SHOT_DELAY, creature_id)
        end
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local target = creature:getTarget()
    
    if not target then
        return false
    end

    local target_id = target:getId()
    doShot(SHOT_COUNT, creature_id, target_id)
    return true
end

spell:name("Rock Tomb")
spell:words("#Rock Tomb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()


