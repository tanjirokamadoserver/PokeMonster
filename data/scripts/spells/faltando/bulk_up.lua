local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    return true
end

spell:name("Bulk Up")
spell:words("#Bulk Up#")
spell:register()
