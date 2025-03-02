local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Vacuum Wave")
combat:setArea(createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 3, 1}
}))

local effects = {
    [DIRECTION_NORTH] = 100,
    [DIRECTION_EAST] = 100,
    [DIRECTION_SOUTH] = 100,
    [DIRECTION_WEST] = 100
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local direction = creature:getDirection()
    local effectId = effects[direction]
    local pos = creature:getPosition()

    local function applyEffect(i)
        -- Verifica se a criatura ainda existe
        local currentCreature = Creature(creature:getId())
        if not currentCreature then
            return false
        end

        local effectPos = Position(pos.x, pos.y, pos.z)
        effectPos:sendMagicEffect(effectId)
    end

    for i = 1, 3 do
        addEvent(function() applyEffect(i) end, (i - 1) * 300)
    end

    combat:execute(creature, variant)
    return true
end

spell:name("Vacuum Wave")
spell:words("#Vacuum Wave#")
spell:isAggressive(true)
spell:needDirection(true)
spell:needLearn(false)
spell:register()