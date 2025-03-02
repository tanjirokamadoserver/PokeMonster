local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Peck")
combat:setParameter(COMBAT_PARAM_EFFECT, 104)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local function applyEffect(target)
    target:sendJump(10, 150)
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(target)
    end

    return true
end

targetSpell:name("Peck")
targetSpell:words("#Peck")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(1)
targetSpell:register()