local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 383)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 4)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Blue Flames")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()

    local targetPos = target:getPosition()

    for i = 1, 5 do
        addEvent(function()
            local currentCreature = Creature(creature:getId())
            if currentCreature then
                combat:execute(currentCreature, variant)
            end
        end, (i - 1) * 150)
    end

    creature:teleportTo(targetPos)

    return true
end

spell:name("Blue Flames")
spell:words("##Blue Flames##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
