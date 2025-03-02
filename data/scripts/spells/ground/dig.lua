local AREA_DIG = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat1:setArea(createCombatArea(AREA_DIG))
combat1:setParameter(COMBAT_PARAM_EFFECT, 2195)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dig")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()
    local originalOutfit = creature:getOutfit()
    local creaturePosition = creature:getPosition()
    
    creature:setOutfit({lookType = 0})
    doSendMagicEffect(creaturePosition, 2189)

    for i = 0, 4 do
        addEvent(function()
            local currentCreature = Creature(creatureId)
            if not currentCreature then
                return -- Interrompe se a criatura não existir
            end
            local currentPosition = currentCreature:getPosition()
            doSendMagicEffect(currentPosition, 1441)
        end, i * 1000 + 500)
    end

    addEvent(function()
        local currentCreature = Creature(creatureId)
        if not currentCreature then
            return -- Interrompe se a criatura não existir
        end
        
        currentCreature:setOutfit(originalOutfit)
        local currentPosition = currentCreature:getPosition()
        doSendMagicEffect(currentPosition, 2189)

        addEvent(function()
            local combatCreature = Creature(creatureId)
            if not combatCreature then
                return -- Verifica se a criatura ainda existe antes de executar o combate
            end
            local combatVariant = Variant(combatCreature:getPosition())
            combat1:execute(combatCreature, combatVariant)
        end, 300)
    end, 5000)

    return true
end

spell:name("Dig")
spell:words("### Dig ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
