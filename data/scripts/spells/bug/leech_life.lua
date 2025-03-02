local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 144)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 15)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Leech Life")

local effectOffsetX = 0
local effectOffsetY = 0

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

spell:name("Leech Life")
spell:words("###Leech Life###")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
