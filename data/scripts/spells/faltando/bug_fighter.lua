local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    return true
end

spell:name("Bug Figther")
spell:words("#Bug Figther#")
spell:register()
