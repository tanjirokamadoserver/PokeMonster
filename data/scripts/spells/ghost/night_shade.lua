local AREA_SCREEN1 = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat1:setArea(createCombatArea(AREA_SCREEN1))
combat1:setParameter(COMBAT_PARAM_EFFECT, 134)
combat1:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Night Shade")

local condition = createConditionObject(CONDITION_SILENCE)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 600)
condition:setParameter(CONDITION_PARAM_EFFECT, 32)
combat1:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()
	
    position.x = position.x + 1 
    position.y = position.y + 1

    doSendMagicEffect(position, 2020)

    combat1:execute(creature, variant)

    return true
end

spell:name("Night Shade")
spell:words("### Night Shade ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
