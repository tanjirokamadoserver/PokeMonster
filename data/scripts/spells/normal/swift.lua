local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 33)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Swift")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    local function repeatAttack(times)
        if times > 0 then
            local creature = Creature(creatureId)
            if creature then
                combat:execute(creature, variant)
                addEvent(repeatAttack, 100, times - 1)
            end
        end
    end

    local repetitions = math.random(3)
    repeatAttack(repetitions)

    return true
end

spell:name("Swift")
spell:words("##Swift##")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
