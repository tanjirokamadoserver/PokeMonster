local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_STEELDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Metal Claw")

local function applyEffect(creature, target)
    local originalPos = creature:getPosition()
    local targetPos = target:getPosition()
    local dx = targetPos.x - originalPos.x
    local dy = targetPos.y - originalPos.y
    local newPos = Position(targetPos.x, targetPos.y, targetPos.z)

    -- Ajusta a posição baseada na distância
    if dx > 0 then
        newPos.x = targetPos.x - 1
    elseif dx < 0 then
        newPos.x = targetPos.x + 1
    end

    if dy > 0 then
        newPos.y = targetPos.y - 1
    elseif dy < 0 then
        newPos.y = targetPos.y + 1
    end

    -- Tenta teletransportar a criatura
    if creature:teleportTo(newPos, true) then
        originalPos:sendMagicEffect(212) -- Efeito na posição original
        newPos:sendMagicEffect(212) -- Efeito na nova posição
    end
end

local targetSpell = Spell(SPELL_INSTANT)

function targetSpell.onCastSpell(creature, variant)
    -- Aplica o efeito em todos os alvos do combate
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        applyEffect(creature, target)
    end

    -- Executa o combate
    return combat:execute(creature, variant)
end

targetSpell:name("Metal Claw")
targetSpell:words("#Metal Claw")
targetSpell:isAggressive(true)
targetSpell:needLearn(false)
targetSpell:needTarget(true)
targetSpell:range(5)
targetSpell:register()