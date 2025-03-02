local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE) --a que colocar o nome maiusculo da title antes do DAMAGE exemplo COMBAT_NOMETITLEDAMAGE
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Ingrain")

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

-- Configure the spell
targetSpellTeste:name("Ingrain")
targetSpellTeste:words("###Ingrain###")
targetSpellTeste:isAggressive(true)
targetSpellTeste:needLearn(false)
targetSpellTeste:needTarget(true)
targetSpellTeste:register()
