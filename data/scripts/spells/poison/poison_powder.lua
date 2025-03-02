local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_GRASSDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 85)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Poison Powder")

local area = createCombatArea(
{
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},  
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 2, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}
)

combat:setArea(area)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:clearConditions()
    local condition = createConditionObject(CONDITION_POISON)
    condition:setParameter(CONDITION_PARAM_OWNER, creature:getId())

    local mType = MonsterType(creature:getName())
    local attack = mType:moveMagicAttackBase()

    local damage = 1

    condition:addDamage(-damage)

    combat:addCondition(condition)
    return combat:execute(creature, variant)
end

spell:name("Poison Powder")
spell:words("#Poison Powder#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()