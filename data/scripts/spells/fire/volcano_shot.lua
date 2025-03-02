local SHOT_COUNT = 1
local SHOT_DELAY = 150
local MISSILE_EFFECT = 6

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Volcano Shot")

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
    target:getPosition():sendMagicEffect(984)
end

local function doShotUp(fromPos, toPos, effect, nextToPosition, creature_id, target_id)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(doSendDistanceShoot, 75, toPos, nextToPosition, effect)
    addEvent(doShotDownDamage, 400, creature_id, nextToPosition, target_id)
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
                    local upwardPos = creaturePos + Position(math.random(-2, 2), math.random(-2, 2), 0) -- Corrigido
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
    if not target then return false end
    local target_id = target:getId()
    doShot(SHOT_COUNT, creature_id, target_id)
    return true
end

spell:name("Volcano Shot")
spell:words("#Volcano Shot#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
