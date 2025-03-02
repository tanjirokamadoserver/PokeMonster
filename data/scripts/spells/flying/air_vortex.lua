local combat, combatDamage = Combat(), Combat()
local combatA = Combat()
local effect, distanceEffect = 2073, 24

local area = createCombatArea({
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
})

local area2 = createCombatArea({
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 2, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1}
})

local conditionpara = Condition(CONDITION_NOMOVE)
conditionpara:setParameter(CONDITION_PARAM_TICKS, 4 * 1000)

local outfitCondition = Condition(CONDITION_OUTFIT)
outfitCondition:setParameter(CONDITION_PARAM_TICKS, 4 * 1000)

combat:setArea(area)
combatDamage:setArea(area)
combatA:setArea(area2)

combatDamage:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combatDamage:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Air Vortex")

combatA:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combatA:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_NONE)
combatA:setParameter(COMBAT_PARAM_EFFECT, 3)
combatA:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Air Vortex")

local conditionsle = Condition(CONDITION_SILENCE)
conditionsle:setParameter(CONDITION_PARAM_TICKS, 6 * 1000)
combatDamage:addCondition(conditionsle)

local function recursiveSpell(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    combatA:execute(creature, Variant(creature:getPosition()))

    if os.time() <= param.time then
        addEvent(recursiveSpell, 300, param)
    end
end

local function applyEffect(creature, target)
    if creature:isTarget(target) then
        local pos = target:getClosestFreePosition(creature:getPosition(), 1, true)
        if pos then
            target:teleportTo(pos)
        end
    end
end

local function showEffect(params)
    Position(params.toPos):sendMagicEffect(effect)
    if math.random(1, 2) == 1 then
        Position(params.fromPos):sendDistanceEffect(params.toPos, distanceEffect)
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(creature, target)
    end

    combat:execute(creature, variant)
    creature:addCondition(conditionpara)

    addEvent(function(params)
        local creature = Creature(params.cid)
        if creature then
            combatDamage:execute(creature, params.var)
        end
    end, 100, {cid = creature:getId(), var = variant})

    addEvent(recursiveSpell, 300, {cid = creature:getId(), var = variant, time = os.time() + 4})
    return combatA:execute(creature, variant)
end

spell:name("Air Vortex")
spell:words("#Air Vortex#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()