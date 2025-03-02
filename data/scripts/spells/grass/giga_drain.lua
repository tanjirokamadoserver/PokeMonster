local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 46)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Giga Drain")

local effectOffsetX = 0
local effectOffsetY = 1

local function applyEffect(creature, target)
    if target then
        local damage = combat:execute(creature, target)
        if damage > 0 then
            local healAmount = math.floor(damage * 0.90)
            creature:addHealth(healAmount)
        end

        -- Aplica o efeito visual
        local targetPosition = target:getPosition()
        targetPosition.x = targetPosition.x + effectOffsetX
        targetPosition.y = targetPosition.y + effectOffsetY
        targetPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
    end
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(creature, target)
    end

    return true
end

-- Configuração da spell
targetSpell:name("Giga Drain")
targetSpell:words("#Giga Drain")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:register()