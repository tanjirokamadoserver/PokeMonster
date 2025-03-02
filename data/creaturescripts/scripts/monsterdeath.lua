function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local player = creature:getMaster()
    if player then
	local item = player:getUsingBall()
		if item then
			item:setSpecialAttribute("pokeHealth", 0)
			player:sendCancelMessage("Your pokemon has died.")
			creature:unregisterEvent("MonsterDeath")
			player:say("Thanks, " .. creature:getName() .. "!", TALKTYPE_MONSTER_SAY)
			item:setSpecialAttribute("isBeingUsed", 0)
			doSendGobackInformations(player, summon, "remove")
			doSendPokeTeamByClient(player)
			player:setUsingPokeball(false)
		end
    end
    return true
end
