local AREA_Psyusion = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PSYCHICDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psyusion")

local spell = Spell(SPELL_INSTANT)

local function onTargetTile(creature_id, pos)
    local creature = Creature(creature_id)
    if not creature then
        return -- Para caso a criatura não exista mais
    end

    pos:sendMagicEffect(137)
    combat:execute(creature, Variant(pos))
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local targetPos = creature:getPosition()

    for x = -3, 3 do
        for y = -3, 3 do
            local tilePos = Position(targetPos.x + x, targetPos.y + y, targetPos.z)
            if AREA_Psyusion[y + 4] and AREA_Psyusion[y + 4][x + 4] == 1 then
                addEvent(function()
                    if Creature(creature_id) then -- Verifica novamente se a criatura ainda existe
                        onTargetTile(creature_id, tilePos)
                    end
                end, 0)
            end
        end
    end

    return true
end

spell:name("Psyusion")
spell:words("### Psyusion ###")
spell:isAggressive(true)
spell:needLearn(false)
spell:range(7)
spell:needTarget(false)
spell:register()
