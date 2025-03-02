local buttonMachineId_on = 26694
local buttonMachineId_off = 26693
local ballMachineId_on = 26695
local ballMachineId_off = 26696
local stoneMachineId_on = 26697
local stoneMachineId_off = 26698

function necessaryStones(boostLevel)
	return math.ceil(1.3 * boostLevel)
end

function doChangeBackBoostMachine(buttonMachinePos, ballMachinePos, stoneMachinePos)
	local button = Tile(buttonMachinePos):getItemById(buttonMachineId_on)
	local ball = Tile(ballMachinePos):getItemById(ballMachineId_on)
	local stone = Tile(stoneMachinePos):getItemById(stoneMachineId_on)
	doTransformItem(button.uid, buttonMachineId_off)
	doTransformItem(ball.uid, ballMachineId_off)
	doTransformItem(stone.uid, stoneMachineId_off)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local buttonMachinePos = Position(fromPosition.x, fromPosition.y, fromPosition.z)
	local ballMachinePos = Position(fromPosition.x+1, fromPosition.y, fromPosition.z)
	local stoneMachinePos = Position(fromPosition.x-1, fromPosition.y, fromPosition.z)

	local buttonMachine = Tile(buttonMachinePos):getItemById(buttonMachineId_off)
	local ballMachine = Tile(ballMachinePos):getItemById(ballMachineId_off)
	local stoneMachine = Tile(stoneMachinePos):getItemById(stoneMachineId_off)

	if buttonMachine and ballMachine and stoneMachine then
		local ball = ballMachine:getItem(0)
		local stone = stoneMachine:getItem(0)
		if ball and stone and ball:isPokeball() then
			local pokeName = ball:getSpecialAttribute("pokeName")
			local race = MonsterType(pokeName):getRaceName()
			if race == "psychic" then race = "enigma" end
			if race == "grass" then race = "leaf" end
			if race == "normal" then race = "heart" end
			if race == "electric" then race = "thunder" end
			if race == "poison" then race = "venom" end
			if race == "flying" then race = "feather" end
			if race == "ground" then race = "earth" end
			if race == "bug" then race = "cocoon" end
			if race == "dark" then race = "darkness" end
			if race == "ghost" then race = "darkness" end
			if race == "steel" then race = "metal" end
			if race == "fairy" then race = "heart" end
			if race == "fighting" then race = "punch" end
			if race == "dragon" then race = "crystal" end
			local race2 = MonsterType(pokeName):getRace2Name()
			if race2 == "psychic" then race2 = "enigma" end
			if race2 == "grass" then race2 = "leaf" end
			if race2 == "normal" then race2 = "heart" end
			if race2 == "electric" then race2 = "thunder" end
			if race2 == "poison" then race2 = "venom" end
			if race2 == "flying" then race2 = "feather" end
			if race2 == "ground" then race2 = "earth" end
			if race2 == "bug" then race2 = "cocoon" end
			if race2 == "dark" then race2 = "darkness" end
			if race2 == "ghost" then race2 = "darkness" end
			if race2 == "steel" then race2 = "metal" end
			if race2 == "fairy" then race2 = "heart" end
			if race2 == "fighting" then race2 = "punch" end
			if race2 == "dragon" then race2 = "crystal" end
			local stoneName = race .. " stone"
			if stoneName == "metal stone" then stoneName = "metal coat" end
			local stone2Name = race2 .. " stone"
			if stone2Name == "metal stone" then stone2Name = "metal coat" end
			if stone:getName() == stoneName or stone:getName() == stone2Name then
				local currentBoost = ball:getSpecialAttribute("pokeBoost") or 0
				if currentBoost >= maxBoost then
					player:sendCancelMessage("Sorry, not possible. Your pokemon is at the maximum boost.")
					return true
				end
				local newBoost = currentBoost + 1
				local neededStones = necessaryStones(newBoost)
				if stone:remove(neededStones) then
					buttonMachine:transform(buttonMachineId_on)
					ballMachine:transform(ballMachineId_on)
					stoneMachine:transform(stoneMachineId_on)
					ball:setSpecialAttribute("pokeBoost", newBoost)
					addEvent(doChangeBackBoostMachine, 3000, buttonMachinePos, ballMachinePos, stoneMachinePos)
				else
					player:sendCancelMessage("Sorry, not possible. You need " .. neededStones .. " stones to boost this pokemon.")
					return true
				end
			else
				local word = stoneName
				if race2 ~= nil and race2 ~= "none" and race2 ~= race then word = word .. " or " .. stone2Name end
				player:sendCancelMessage("Sorry, not possible. You need " .. word .." to boost this pokemon.")
				return true
			end
		else
			player:sendCancelMessage("Sorry, not possible. Please use the correct items.")
			return true
		end
	else
		print("WARNING: Boost machine not working.")
		player:sendCancelMessage("Sorry, not possible. This problem was reported.")
		return true
	end
	return true
end
