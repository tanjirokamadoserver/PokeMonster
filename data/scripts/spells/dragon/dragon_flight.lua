local AREA_DRAGON = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Flight")
combat:setArea(createCombatArea(AREA_DRAGON))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    creature:sendJump(250, 500)

    addEvent(function(cid)
        local creature = Creature(cid)
        if creature then
            local position = creature:getPosition()
            local effectPosition = Position(position.x + 3, position.y + 3, position.z)
            effectPosition:sendMagicEffect(2326)

            addEvent(function(cid)
                local creature = Creature(cid)
                if creature then
                    combat:execute(creature, variant)
                end
            end, 600, cid)
        end
    end, 700, creatureId)

    return true
end

spell:name("Dragon Flight")
spell:words("### Dragon Flight ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()