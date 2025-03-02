local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Creepy Lick")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_SPEED, -500)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
condition:setParameter(CONDITION_PARAM_EFFECT, 33)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

local function getFrontPosition(creature, target)
    local creaturePosition = creature:getPosition()
    local targetPosition = target:getPosition()

    local offsetX = targetPosition.x - creaturePosition.x
    local offsetY = targetPosition.y - creaturePosition.y

    local frontPosition = {
        x = targetPosition.x + (offsetX == 0 and 0 or offsetX > 0 and -1 or 1),
        y = targetPosition.y + (offsetY == 0 and 0 or offsetY > 0 and -1 or 1),
        z = targetPosition.z
    }

    return frontPosition
end

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()

    local frontPosition = getFrontPosition(creature, target)

    creature:teleportTo(frontPosition, true)

    combat:execute(creature, Variant(target:getPosition()))

    doSendMagicEffect(target:getPosition(), 146)

    return true
end

spell:name("Creepy Lick")
spell:words("#Creepy Lick#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(true)
spell:register()
