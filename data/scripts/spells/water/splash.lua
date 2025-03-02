local AREA_SPLASH = {
    {1, 1, 1,},
    {1, 2, 1,},
    {1, 1, 1,}
}



local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_WATERDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 54)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Splash")
combat:setArea(createCombatArea(AREA_SPLASH))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creatureId = creature:getId()

    creature:sendJump(20, 200)
    
    addEvent(function()
        local c = Creature(creatureId)
        if c then
            combat:execute(c, variant)
        end
    end, 400)

    addEvent(function()
        local c = Creature(creatureId)
        if c then
            combat1:execute(c, variant)
        end
    end, 600)

    return true
end

spell:name("Splash")
spell:words("### Splash ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
