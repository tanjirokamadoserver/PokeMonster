local AREA_HEATZONE = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 3, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local AREA_HEATZONE2 = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 3, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat1:setArea(createCombatArea(AREA_HEATZONE))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2196)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heatzone")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat2:setArea(createCombatArea(AREA_HEATZONE2))
combat2:setParameter(COMBAT_PARAM_EFFECT, 2197)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Heatzone")

local spell = Spell(SPELL_INSTANT)

local function sendMissiles(creature, area)
    local origin = creature:getPosition()
    for y = 1, #area do
        for x = 1, #area[y] do
            if area[y][x] == 1 then
                local targetPos = {x = origin.x + x - math.ceil(#area[y] / 2), y = origin.y + y - math.ceil(#area / 2), z = origin.z}
                doSendDistanceShoot(origin, targetPos, 24)
            end
        end
    end
end

function executeCombat2(creature, variant, repeatCount)
    if repeatCount > 0 then
        combat2:execute(creature, variant)
        addEvent(executeCombat2, 1000, creature, variant, repeatCount - 1)
    end
end

function spell.onCastSpell(creature, variant)
    sendMissiles(creature, AREA_HEATZONE)
    combat1:execute(creature, variant)
    addEvent(function()
        -- Verificação dentro do addEvent
        local creature = Creature(creature:getId())  -- Recria a referência da criatura
        if creature then
            combat2:execute(creature, variant)
        end
    end, 1200)

    addEvent(function()
        -- Verificação dentro do addEvent
        local creature = Creature(creature:getId())  -- Recria a referência da criatura
        if creature then
            executeCombat2(creature, variant, 25)
        end
    end, 2200)

    return true
end

spell:name("Heatzone")
spell:words("### Heatzone ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
