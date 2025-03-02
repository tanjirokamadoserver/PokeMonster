local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_SOLARDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Solar Power")

local effectOffsetX = 0
local effectOffsetY = 1


local function applyEffect(target)
    local targetPosition = target:getPosition()
    targetPosition.x = targetPosition.x + effectOffsetX
    targetPosition.y = targetPosition.y + effectOffsetY
    targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
end

local targetSpellTeste = Spell(SPELL_INSTANT)

function targetSpellTeste.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(target)
    end

    return true
end

targetSpellTeste:name("Solar Power")
targetSpellTeste:words("###Solar Power###")
targetSpellTeste:isAggressive(true)
targetSpellTeste:needLearn(false)
targetSpellTeste:needTarget(true)
targetSpellTeste:register()
