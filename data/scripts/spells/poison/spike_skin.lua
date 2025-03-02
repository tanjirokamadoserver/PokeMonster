local AREA_SKIN = {
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat1:setArea(createCombatArea(AREA_SKIN))
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Spike Skin")

local condition = createConditionObject(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
condition:setParameter(CONDITION_PARAM_SPEED, -500)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 500)
condition:setParameter(CONDITION_PARAM_EFFECT, 33)

local spell = Spell(SPELL_INSTANT)

local function executeCombatAndSendMissiles(creatureId)
    local creature = Creature(creatureId)
    if not creature then return end

    local position = creature:getPosition()
    combat1:execute(creature, Variant(creature:getId()))

    local startX, startY = position.x - math.floor(#AREA_SKIN[1] / 2), position.y - math.floor(#AREA_SKIN / 2)

    for y = 1, #AREA_SKIN do
        for x = 1, #AREA_SKIN[y] do
            if AREA_SKIN[y][x] == 1 then
                local targetPos = Position(startX + x - 1, startY + y - 1, position.z)
                doSendDistanceShoot(position, targetPos, MISSILE_ID)
                doSendMagicEffect(targetPos, EFFECT_ID)  -- Enviar o efeito
            end
        end
    end
end

function spell.onCastSpell(creature, variant)
    for i = 0, 6 do
        addEvent(function()
            if Creature(creature:getId()) then  -- Verifica se a criatura ainda existe antes de executar
                executeCombatAndSendMissiles(creature:getId())
            end
        end, i * 400)
    end
    return true
end

spell:name("Spike Skin")
spell:words("### Spike Skin ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
