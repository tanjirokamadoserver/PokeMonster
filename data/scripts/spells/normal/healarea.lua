local AREA_HEAL = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 3, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
}

local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_EFFECT, 13)
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_NORMALDAMAGE)
combat1:setArea(createCombatArea(AREA_HEAL))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local position = creature:getPosition()

    -- Aplica o dano da área
    combat1:execute(creature, variant)

    -- Cura as criaturas na área
    local creatures = Game.getSpectators(position, false, false, 3, 3, 3, 3) -- Captura as criaturas na área de 3x3 em volta do centro
    for _, target in ipairs(creatures) do
        if target:isCreature() then
            local maxHealth = target:getMaxHealth()
            local healAmount = math.floor(maxHealth * 0.20)
            target:addHealth(healAmount)
            target:getPosition():sendMagicEffect(13) -- Opcional: efeito visual de cura
        end
    end

    return true
end

spell:name("Healarea")
spell:words("### Healarea ###")
spell:needLearn(false)
spell:register()
