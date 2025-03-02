local AREA_STORM = {
    {0, 0, 0},
    {1, 1, 1},
    {1, 2, 1},
    {1, 1, 1},
    {0, 0, 0}
}

local AREA_STORM1 = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 1, 0, 2, 0, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM2 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 2, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM3 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 2, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_STORM4 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combats = {}
for i, area in ipairs({AREA_STORM4, AREA_STORM3, AREA_STORM2, AREA_STORM1}) do
    local combat = createCombatObject()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, 1286)
    combat:setArea(createCombatArea(area))

    local silenceCondition = createConditionObject(CONDITION_SILENCE)
    silenceCondition:setParameter(CONDITION_PARAM_TICKS, 10000)
    combat:addCondition(silenceCondition)

    local paralyzeCondition = createConditionObject(CONDITION_PARALYZE)
    paralyzeCondition:setParameter(CONDITION_PARAM_TICKS, 4000)
    paralyzeCondition:setParameter(CONDITION_PARAM_SPEED, -200)
    paralyzeCondition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
    paralyzeCondition:setParameter(CONDITION_PARAM_EFFECT, 1300)
    combat:addCondition(paralyzeCondition)

    table.insert(combats, combat)
end

local function executeCombat(creatureId, combat)
    local creature = Creature(creatureId)
    if creature then
        combat:execute(creature, Variant(creature:getPosition()))
    end
end

local function applyEffect(creatureId)
    local creature = Creature(creatureId)
    if creature then
        local pos = creature:getPosition()
        pos.y = pos.y - 1 -- Move para baixo
        doSendMagicEffect(pos, 295)
    end
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local delay = 0
    local creatureId = creature:getId()

    for _, combat in ipairs(combats) do
        addEvent(executeCombat, delay, creatureId, combat)
        delay = delay + 500
    end

    for i = 500 * #combats -500 , delay -500 , -500 do
        addEvent(applyEffect,i , creatureId )
        addEvent(applyEffect,i , creatureId )
    end

    return true
end

spell:name("Taunt")
spell:words("### Taunt ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()