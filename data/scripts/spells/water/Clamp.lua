local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 3)
combat:setParameter(COMBAT_PARAM_EFFECT, 668)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Clamp")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    
    local function executeCombat(creatureId, times)
        if times > 0 then
            local creature = Creature(creatureId)
            if creature then
                combat:execute(creature, variant)
                addEvent(executeCombat, 150, creatureId, times - 1)
            end
        end
    end

    executeCombat(creature:getId(), 3)

    return true
end

spell:name("Clamp")
spell:words("#Clamp#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
