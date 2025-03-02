local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FAIRYDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 17)
combat:setParameter(COMBAT_PARAM_EFFECT, 257)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Dazzling Gleam")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    local targetPos = target:getPosition()
    local creatureId = creature:getId()

    local function repeatAttack(count)
        if count <= 4 then
            -- Verifica se a criatura ainda existe antes de executar
            local currentCreature = Creature(creatureId)
            if currentCreature then
                combat:execute(currentCreature, Variant(targetPos))
                addEvent(repeatAttack, 150, count + 1)
            end
        end
    end

    repeatAttack(1)

    return true
end

spell:name("Dazzling Gleam")
spell:words("#Dazzling Gleam#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(8)
spell:needTarget(true)
spell:register()
