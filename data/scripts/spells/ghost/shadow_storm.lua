local SHOT_COUNT = 30
local SHOT_DELAY = 50
local MISSILE_EFFECT = 19

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GHOSTDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Shadow Storm")

local spell = Spell(SPELL_INSTANT)

local function doShotDownDamage(creature_id, toPos)
    local creature = Creature(creature_id)
    if not creature then
        return
    end

    combat:execute(creature, Variant(toPos))
    toPos:sendMagicEffect(785)
end

local function doShotUp(fromPos, toPos, effect, nextToPosition, creature_id)
    doSendDistanceShoot(fromPos, toPos, effect)
    addEvent(doSendDistanceShoot, 75, toPos, nextToPosition, effect)
    addEvent(doShotDownDamage, 400, creature_id, nextToPosition)
end

local function doShot(count, creature_id)
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

                local randomOffsetX = math.random(-3, 3)
                local randomOffsetY = math.random(-3, 3)
                local targetPos = creaturePos + Position(randomOffsetX, randomOffsetY, 0)

                local upwardPos = targetPos - Position(9 + math.random(-2, 2), 9 + math.random(-2, 2), 0)
                
                doShotUp(creaturePos, upwardPos, MISSILE_EFFECT, targetPos, creature_id)
            end, i * SHOT_DELAY, creature_id)
        end
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    doShot(SHOT_COUNT, creature_id)
    return true
end

spell:name("Shadow Storm")
spell:words("#Shadow Storm#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
