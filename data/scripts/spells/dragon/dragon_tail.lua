local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dragon Tail")
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 40)

local directionEffects = {
    [0] = 2176, -- Norte
    [1] = 2178, -- Leste
    [2] = 2177, -- Sul
    [3] = 2179  -- Oeste
}

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
		local dir = creature:getDirection()
		local effect = directionEffects[dir]

		if effect then
			creature:getPosition():sendMagicEffect(effect)
		end
	end
	return true
end

targetSpell:name("Dragon Tail")
targetSpell:words("#Dragon Tail#")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(1)
targetSpell:register()
