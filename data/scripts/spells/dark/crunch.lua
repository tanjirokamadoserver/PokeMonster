local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DARKDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 147)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Crunch")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false -- Interrompe se não houver alvo
    end

    local targetPos = target:getPosition()
    local creatureId = creature:getId()
    local targetId = target:getId()

    local function repeatAttack(count)
        if count <= 2 then
            local attacker = Creature(creatureId)
            local defender = Creature(targetId)

            if attacker and defender then -- Garante que ambos ainda existam
                combat:execute(attacker, Variant(defender:getPosition()))
                addEvent(repeatAttack, 500, count + 1)
            end
        end
    end

    repeatAttack(1)

    return true
end

spell:name("Crunch")
spell:words("#Crunch#")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(1)
spell:needTarget(true)
spell:register()
