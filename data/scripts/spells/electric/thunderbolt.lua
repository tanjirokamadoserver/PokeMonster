local SHOT_COUNT = 3
local SHOT_DELAY = 150
local MISSILE_EFFECT = 42

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Thunderbolt")

local spell = Spell(SPELL_INSTANT)

local function doShotDownDamage(creature_id, target_id, offsetX, offsetY)
    local creature = Creature(creature_id)
    if not creature then return end
    
    local target = Creature(target_id)
    if not target then return end

    combat:execute(creature, Variant(target_id))
    
    local effectPos = target:getPosition()
    effectPos.x = effectPos.x + offsetX
    effectPos.y = effectPos.y + offsetY
    effectPos:sendMagicEffect(379)
end

local function doShotUp(fromPos, toPos, effect, nextToPosition, creature_id, target_id, offsetX, offsetY)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(doSendDistanceShoot, 75, toPos, nextToPosition, effect)
    addEvent(doShotDownDamage, 400, creature_id, target_id, offsetX, offsetY)
end

local function doShot(creature_id, target_id)
    for i = 1, SHOT_COUNT do
        addEvent(function()
            local creature = Creature(creature_id)
            if not creature then return end
            
            local target = creature:getTarget()
            if not target or target:getId() ~= target_id then return end
            
            local creaturePos = creature:getPosition()
            local upwardPos = creaturePos - Position(9 + math.random(-2, 2), 9 + math.random(-2, 2), 0)
            local targetPos = target:getPosition()

            doShotUp(creaturePos, upwardPos, MISSILE_EFFECT, targetPos, creature_id, target_id, 1, 1)
        end, i * SHOT_DELAY)
    end
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then return false end

    doShot(creature:getId(), target:getId())
    return true
end

spell:name("Thunderbolt")
spell:words("#Thunderbolt#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(5)
spell:needTarget(true)
spell:register()
