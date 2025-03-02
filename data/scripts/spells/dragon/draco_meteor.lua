local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DRAGONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Draco Meteor")

local effectOffsetX = 0
local effectOffsetY = 1

local targetSpellTeste = Spell(SPELL_INSTANT)

function targetSpellTeste.onCastSpell(creature, variant)
	for _, target in ipairs(combat:getTargets(creature, variant)) do
    local targetPosition = target:getPosition()
    targetPosition.x = targetPosition.x + effectOffsetX
    targetPosition.y = targetPosition.y + effectOffsetY
    targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
	end
	return true
end

-- Configure the spell
targetSpellTeste:name("Draco Meteor")
targetSpellTeste:words("###Draco Meteor###")
targetSpellTeste:isAggressive(true)
targetSpellTeste:needLearn(false)
targetSpellTeste:needTarget(true)
targetSpellTeste:register()
