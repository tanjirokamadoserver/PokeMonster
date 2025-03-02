local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE) --a que colocar o nome maiusculo da title antes do DAMAGE exemplo COMBAT_NOMETITLEDAMAGE
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Pixilate")

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
targetSpellTeste:name("Pixilate")
targetSpellTeste:words("###Pixilate###")
targetSpellTeste:isAggressive(true)
targetSpellTeste:needLearn(false)
targetSpellTeste:needTarget(true)
targetSpellTeste:register()
