local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Snarl")

local effectOffsetX = 0
local effectOffsetY = 1

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
    local targetPosition = target:getPosition()
    targetPosition.x = targetPosition.x + effectOffsetX
    targetPosition.y = targetPosition.y + effectOffsetY
    targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
	end
	return true
end

spell:name("Snarl")
spell:words("###Snarl###")
spell:isAggressive(true)
spell:needLearn(false)
spell:needTarget(true)
spell:register()
