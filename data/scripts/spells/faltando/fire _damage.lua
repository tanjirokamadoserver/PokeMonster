local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    return true
end

spell:name("fire damage")
spell:words("#fire damage#")
spell:register()
