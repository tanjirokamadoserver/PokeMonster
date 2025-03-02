local AREA_BOMB = {
{0, 0, 0},
{1, 1, 1},
{1, 3, 1},
{1, 1, 1},
{0, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GROUNDDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 7)
combat:setParameter(COMBAT_PARAM_EFFECT, 315)
combat:setArea(createCombatArea(AREA_BOMB))
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Mud Bomb")

local condition = Condition(CONDITION_BLIND)
condition:setTicks(6000)
condition:setParameter(CONDITION_PARAM_EFFECT, 654)
condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat:execute(creature, variant)

    return true
end

spell:name("Mud Bomb")
spell:words("#Mud Bomb#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(6)
spell:needTarget(true)
spell:register()
