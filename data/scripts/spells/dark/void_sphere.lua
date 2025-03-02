local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, 853)
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Void Sphere")

local condition = Condition(CONDITION_STUN)
condition:setTicks(3000)
condition:setParameter(CONDITION_PARAM_EFFECT, 297)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
    local originalPos = creature:getPosition()
    local targetPos = target:getPosition()

		if creature:teleportTo(targetPos) then
			originalPos:sendMagicEffect(212)
			targetPos:sendMagicEffect(212)
		else
			return false
		end
	end
	return true
end

targetSpell:name("Void Sphere")
targetSpell:words("#Void Sphere#")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(5)
targetSpell:register()
