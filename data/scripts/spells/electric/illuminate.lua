local combat1 = createCombatObject()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ELECTRICDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, 275)

-- ADICIONAR CEGUEIRA NOS POKEMONS EM VOLTA @ICARO

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)

    combat1:execute(creature, variant)

    return true
end

spell:name("Illuminate")
spell:words("### Illuminate ###")
spell:needLearn(false)
spell:register()
