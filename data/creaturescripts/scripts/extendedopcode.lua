local OPCODE_REQUEST_MANAGER = 1

function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_MARKET then
		player:handleMarket(buffer)
		return
	end

	if opcode == OPCODE_TASKS_KILL then
		player:handleTasksKill(buffer)
		return
	end

	if opcode == EXTENDED_OPCODE_CONTRACT then
		player:handleContract(buffer)
		return
	end

	if opcode == OPCODE_REQUEST_MANAGER then
		player:requestModule(buffer)
		return
	end

	if opcode == OPCODE_BANK then
		player:handleBank(buffer)
		return
	end

	if opcode == OPCODE_REDEEM_CODES then
		player:handleRedeemCodes(buffer)
		return
	end

	if opcode == OPCODE_NEW_SHOP then
		player:handleShop(buffer)
		return
	end

    if opcode == 53 then
        player:handlePokebar(buffer)
      	return
    end

    if opcode == POKEDEX_OPCODE then
        player:handlePokedex(buffer)
        return
    end


	if opcode == 78 then
		local data = json.decode(buffer)
		local type = data.type
		
		if type == "check" then
			if #player:getSummons() == 0 then
				doPlayerPopupFYI(player, "Você não possui o pokemon ativo.")
				return true
			end
			local ball = player:getUsingBall()
			if not ball then return end
			if ball:getSpecialAttribute("shader") then
				local shaderId = tonumber(data.shader)
				local shader = SHADERSLIST[shaderId]
				if shader then
					ball:setSpecialAttribute("shader", shaderId)
					doPlayerPopupFYI(player, "Particle aura alterado.")
					player:modifierPokemon(0, 0, SHADER_NAMES_TO_IDS[shader], -1)
				end
			else
				doPlayerPopupFYI(player, "Este pokémon não possui particle aura.")
			end
		end
		return true
	end
end