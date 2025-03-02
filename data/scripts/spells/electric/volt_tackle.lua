local AREA_VOLT = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setArea(createCombatArea(AREA_VOLT))
combat1:setParameter(COMBAT_PARAM_EFFECT, 807)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Volt Tackle")

local spell = Spell(SPELL_INSTANT)

local function repeatMagicEffectAndExecuteCombat(creature_id, duration)
    local creature = Creature(creature_id)
    if not creature then return end
    
    local position = creature:getPosition()
    doSendMagicEffect(position, 993)
    
    if duration > 0 then
        addEvent(repeatMagicEffectAndExecuteCombat, 500, creature_id, duration - 500)
    else
        combat1:execute(creature, Variant(position))
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()  -- A referência à criatura é obtida aqui
    repeatMagicEffectAndExecuteCombat(creature_id, 3000)  -- Passamos o ID da criatura para garantir que sempre seja válida
    return true
end

spell:name("Volt Tackle")
spell:words("### Volt Tackle ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()