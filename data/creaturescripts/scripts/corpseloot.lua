local stones = {"leaf stone", "boost stone", "water stone", "venom stone", "thunder stone", "rock stone", "punch stone", "fire stone", "ice stone", "cocoon stone", "crystal stone", "darkness stone", "earth stone", "enigma stone", "heart stone", "metal coat", "sun stone", "feather stone", "king's rock stone", "dragon stone"}

local function doSendMultipleEffects(pos, effect, times, interval)
	for i = 1, times do
		addEvent(doSendMagicEffect, i * interval, pos, effect)
	end
	return
end

function onPostDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not corpse or not creature then
		return true
	end
	if type(corpse) ~= "userdata" then
		return true
	end
	local monsterType = MonsterType(creature:getName())
	if not monsterType or monsterType:getCorpseId() == 0 then
		return true
	end
	if not corpse:isContainer() then
		print("WARNING! Corpse not container, creature " .. creature:getName() .. ".")
		return true
	end
	if not corpse:hasAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) then
		return true
	end
	local owner = corpse:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
	if not owner then
		return true
	end
	local player = Player(owner)
	if player and player:isPlayer() and player:isAutoLooting() then
		local msg = "[AUTOLOOT] "
		local nItems = 0
		for i = corpse:getSize() - 1, 0, -1 do
			local item = corpse:getItem(i)				
			if item then
				local itemId = item:getId()
				local itemName = item:getName()
				local itemCount = item:getCount()
				msg = msg .. itemCount .. " " .. itemName .. ", "
				player:addItem(itemId, itemCount)
				item:remove()
				nItems = nItems + 1
				if isInArray(stones, itemName) then
					doSendMultipleEffects(corpse:getPosition(), 56, 10, 600)
				end
			end
		end
		if nItems >= 1 then
			player:sendTextMessage(MESSAGE_INFO_DESCR, msg:sub(1, -3) .. ".")
		end
	end
	return true
end
