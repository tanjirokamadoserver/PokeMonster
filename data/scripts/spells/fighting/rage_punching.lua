local AREA_REVANGER = {
    {1, 1, 1},
    {1, 2, 1},
    {1, 1, 1}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rage Punching")
combat:setArea(createCombatArea(AREA_REVANGER))

local spell = Spell(SPELL_INSTANT)

local function executeAttack(creature, variant, effect)
    local position = creature:getPosition()
    local variantWithPosition = Variant(position)
    combat:execute(creature, variantWithPosition)
    position:sendMagicEffect(effect)
end

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local effects = {93, 94, 100, 96, 95}

    for i = 1, 5 do
        addEvent(function(cid)
            local creature = Creature(cid)
            if creature then
                executeAttack(creature, variant, effects[i])
            end
        end, (i - 1) * 500, creatureId)
    end

    return true
end

spell:name("Rage Punching")
spell:words("### Rage Punching ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
