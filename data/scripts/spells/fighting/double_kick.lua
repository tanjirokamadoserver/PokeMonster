local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 1123)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Double Kick")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 111)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Double Kick")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local targetPos = variant:getPosition()

    combat:execute(creature, variant)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            combat2:execute(creature, variant)
        end
    end, 200)

    return true
end

spell:name("Double Kick")
spell:words("##Double Kick##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
