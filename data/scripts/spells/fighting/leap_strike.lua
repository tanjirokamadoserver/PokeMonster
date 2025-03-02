local AREA_LEAP = {
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1}
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIGHTINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leap Strike")
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 80)
combat:setParameter(COMBAT_PARAM_EFFECT, 1123)
combat:setArea(createCombatArea(AREA_LEAP))

function onTargetCreature(creature, target)
    local targetPosition = target:getPosition()
    creature:teleportTo(targetPosition)
    targetPosition:sendMagicEffect(1290)
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        local targetPosition = target:getPosition()
        creature:teleportTo(targetPosition)
        targetPosition:sendMagicEffect(1290)
    end
    return true
end

targetSpell:name("Leap Strike")
targetSpell:words("#Leap Strike")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(2)
targetSpell:register()
