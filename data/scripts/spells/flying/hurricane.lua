local SHOT_COUNT = 20
local SHOT_DELAY = 500  
local RANGE = 1
local NEW_OUTFIT_ID = 0
local EFFECT_AROUND = 2216
local EFFECT_CENTER = 2237

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Hurricane")

local spell = Spell(SPELL_INSTANT)

local function doShotDownDamage(creature_id, toPos)
    local creature = Creature(creature_id)
    if not creature then
        return
    end
    combat:execute(creature, Variant(toPos))
    toPos:sendMagicEffect(EFFECT_AROUND)
end

local function doShotAround(creature_id)
    local creature = Creature(creature_id)
    if not creature then
        return
    end

    local creaturePos = creature:getPosition()
    creaturePos:sendMagicEffect(EFFECT_CENTER)

    for x = -RANGE, RANGE do
        for y = -RANGE, RANGE do
            if x ~= 0 or y ~= 0 then
                local targetPos = creaturePos + Position(x, y, 0)
                local upwardPos = targetPos - Position(0, 9, 0) 
                addEvent(doShotDownDamage, 400, creature_id, targetPos)
            end
        end
    end
end

local function startShots(creature_id)
    for i = 1, SHOT_COUNT do
        addEvent(doShotAround, i * SHOT_DELAY, creature_id)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local creature = Creature(creature_id)
    
    if not creature then
        return false
    end

    local originalOutfit = creature:getOutfit()
    creature:setOutfit({lookType = NEW_OUTFIT_ID})

    local creaturePos = creature:getPosition()
    creaturePos:sendMagicEffect(EFFECT_CENTER)

    for x = -RANGE, RANGE do
        for y = -RANGE, RANGE do
            if x ~= 0 or y ~= 0 then
                local targetPos = creaturePos + Position(x, y, 0)
                targetPos:sendMagicEffect(EFFECT_AROUND)
            end
        end
    end

    startShots(creature_id)

    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            creature:setOutfit(originalOutfit)
        end
    end, SHOT_COUNT * SHOT_DELAY + 400)

    return true
end

spell:name("Hurricane")
spell:words("#Hurricane#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
