local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    return true
end

spell:name("fire damage2")
spell:words("#fire damage2#")
spell:register()
