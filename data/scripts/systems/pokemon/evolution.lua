
local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local pokemon = player:getSummon()

	if not pokemon or target ~= pokemon then
		player:sendCancelMessage("Você só pode evoluir o seu pokémon.")
		return true
	end

	local ball = player:getUsingBall()
	if not ball then return true end

	local summonName = target:getName()
	local monsterType = MonsterType(summonName)
	if not monsterType then
		error(("MonsterType not found: %s"):format(summonName))
		player:sendCancelMessage("Sorry, not possible. This problem was reported.")
		return true
	end

	local evolutionList = monsterType:getEvolutionList()
	if (#evolutionList < 1) then
		player:sendCancelMessage("Sorry, not possible. You can not evolve this monster.")
		return true
	end
	local stoneFinded = false;
	local playerLevel = player:getLevel()
	local isEvolutionSuccessfull = false
	local pokeName

	for _, evolution in ipairs(evolutionList) do
		pokeName = evolution.name
		local pokeChance = evolution.chance
		local minLevel = evolution.level
		local stones = evolution.stones
		local canEvolve = true

		for _, stoneInfo in ipairs(stones) do
			local stoneId = stoneInfo.stoneId
			local stoneCount = stoneInfo.stoneCount
			if stoneId == item.itemid then
				stoneFinded = true
			end
			if player:getItemCount(stoneId) < stoneCount then
				canEvolve = false
			end
		end

		if canEvolve and stoneFinded then

			if playerLevel < minLevel then
				player:sendCancelMessage("Você precisa estar level " .. minLevel .. " para evoluir seu pokémon.")
				return true
			end

			for _, stoneInfo in ipairs(stones) do
				player:removeItem(stoneInfo.stoneId, stoneInfo.stoneCount)
			end

			local randomChance = math.random(1, 100)
			if pokeChance < randomChance then
				player:sendCancelMessage("A evolução do seu pokémon falhou.")
				return true
			end
			isEvolutionSuccessfull = true
			break
		elseif stoneFinded and not canEvolve then
			player:sendCancelMessage("Você não possui todas as stones necessárias para evoluir seu pokémon.")
			return true
		end
	end

	if not stoneFinded then
		player:sendCancelMessage("Seu pokémon não evolui com essa stone.")
		return true
	end

	if isEvolutionSuccessfull then
		local newPokemon = pokeName
		player:say("Wow, meu " .. pokemon:getName() .. " está evoluindo!!!", TALKTYPE_ORANGE_1)
		local oldPosition = pokemon:getPosition()
		oldPosition:sendMagicEffect(20)
		ball:setSpecialAttribute("pokeName", newPokemon)
		doRemoveSummon(player:getId(), false, nil, false)
		doReleaseSummon(player:getId(), oldPosition, false, false)
		doSendPokeTeamByClient(player)
	end

	return true
end

local stones = {11450, 11445, 11446}
for _, id in pairs(stones ) do
	action:id(id)
end
action:allowFarUse(true)
action:register()