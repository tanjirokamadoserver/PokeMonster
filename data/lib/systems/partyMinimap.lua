function Party:updateMinimapOnJoin(player)
    local newPlayerData = json.encode({type = "join", name = player:getName(), outfit = {type = player:getOutfit().lookType}, dir = player:getDirection(), pos = player:getPosition()})
	local members = self:getMembers()
	local leader = self:getLeader()
	for _, member in ipairs(members) do
		if member ~= player then
			member:sendExtendedOpcode(76, newPlayerData)
			leader:sendExtendedOpcode(76, newPlayerData)
			local memberData = json.encode({type = "join", name = member:getName(), outfit = {type = member:getOutfit().lookType}, dir = member:getDirection(), pos = member:getPosition()})
			player:sendExtendedOpcode(76, memberData)
		end
	end
	
	leader:sendExtendedOpcode(76, newPlayerData)
	local leaderData = json.encode({type = "join", name = leader:getName(), outfit = {type = leader:getOutfit().lookType}, dir = leader:getDirection(), pos = leader:getPosition()})

	player:sendExtendedOpcode(76, leaderData)
end

function Party:updateMinimapOnLeave(player)
    local newPlayerData = json.encode({type = "leave", name = player:getName()})
	local members = self:getMembers()

	for _, member in ipairs(members) do
		if member ~= player then
			member:sendExtendedOpcode(76, newPlayerData)
		end
	end
	local leader = self:getLeader()
	if leader ~= player then
		leader:sendExtendedOpcode(76, newPlayerData)
	end
	player:sendExtendedOpcode(76, json.encode({type = "disband"}))
end

function Party:updateOnWalk(player, newPos)
	local members = self:getMembers()
    local playerData = json.encode({type = "walk", name = player:getName(), outfit = {type = player:getOutfit().lookType}, dir = player:getDirection(), pos = newPos})
	
	for _, member in ipairs(members) do
		if member ~= player then
			member:sendExtendedOpcode(76, playerData)
		end
	end
	local leader = self:getLeader()
	if leader ~= player then
		leader:sendExtendedOpcode(76, playerData)
	end
end

function Party:disbandPartyMinimap()
	local leader = self:getLeader()
	local data =  json.encode({type = "disband"})
	leader:sendExtendedOpcode(76, data)

	local members = self:getMembers()
	for _, member in ipairs(members) do
		member:sendExtendedOpcode(76, data)
	end
end