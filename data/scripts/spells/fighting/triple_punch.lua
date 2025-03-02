local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 111)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Triple Punch")

local combat2 = createCombatObject()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 111)
combat2:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Triple Punch")

local combat3 = createCombatObject()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, 111)
combat3:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Triple Punch")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local targetPos = variant:getPosition()

    combat:execute(creature, variant)

    addEvent(function()
        local creature = Creature(creatureId)
        if creature then
            combat2:execute(creature, variant)
            
            addEvent(function()
                local creature = Creature(creatureId)
                if creature then
                    combat3:execute(creature, variant)
                end
            end, 100)
        end
    end, 100)

    return true
end

spell:name("Triple Punch")
spell:words("##Triple Punch##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
