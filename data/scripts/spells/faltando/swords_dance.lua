local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    return true
end

spell:name("Swords Dance")
spell:words("#Swords Dance#")
spell:register()
