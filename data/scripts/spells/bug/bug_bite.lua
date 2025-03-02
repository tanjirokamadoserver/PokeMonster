local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_BUGDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 8)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Bug Bite")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
		local targetPosition = target:getPosition()
		targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
	end
	return true
end

spell:name("Bug Bite")
spell:words("###Bug Bite###")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(2)
spell:needTarget(true)
spell:register()
