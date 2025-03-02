function Container.isContainer(self)
	return true
end

function dump(tbl, indent)
    indent = indent or 0

    for k, v in pairs(tbl) do
        local formattedKey = tostring(k)
        local formattedValue = tostring(v)

        if type(v) == "table" then
            print(string.rep("  ", indent) .. formattedKey .. " =>")
            dump(v, indent + 1)
        else
            print(string.rep("  ", indent) .. formattedKey .. " => " .. formattedValue)
        end
    end
end


function Container.createLootItem(self, item, zoneId, player)
	local function getLootRandom()
		math.randomseed(os.time() * math.random(1,10000))
		return math.random(0, 10000000)
	end

	local MAX_ITEM_COUNT = item.maxCount or 1

	if self:getEmptySlots() == 0 then
        return {bool = true, isFromLucky = false, count = 0}
	end

	local itemCount = 0
	local randvalue = getLootRandom()
	local oldItemChance = 0
	local luckyActive = false
	if player then
		-- if player:isVipPlus() then
		-- 	item.chance = math.floor(item.chance * 1.35)
		-- end
		local guild = player:getGuild()
		if guild then
			local hasLuckyBuff = guild:hasBuff(COLUMN_4, LUCKY_BUFF)
			if (hasLuckyBuff) then
				item.chance = item.chance + (item.chance * GUILD_BUFF_LUCKY / 100)
			end
		end

		local ball = player:getUsingBall()
		if ball then
			local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
			local type = "lucky"
			local isHeldLucky = isHeld(type, heldx)
			if isHeldLucky then
				local tier  = HELDS_X_INFO[heldx].tier
				local bonus = HELDS_BONUS[type][tier]
				oldItemChance = item.chance
				luckyActive = true
				item.chance = math.floor(item.chance + (item.chance * bonus / 100))
			end
		end
	end
	local isFromLucky = false

	if randvalue < item.chance then
		if randvalue > oldItemChance and luckyActive then
			isFromLucky = true
		end
		if ItemType(item.itemId):isStackable() then
			itemCount = randvalue % item.maxCount + 1
		else
			itemCount = 1
		end
	end

	if tonumber(getGlobalStorageValue(2)) > os.time() then
		itemCount = itemCount * 2
	end

	if ACTIVE_ZONE_EVENT and ACTIVE_ZONE_TYPE == "loot" and ACTIVE_ZONE_EVENT_ID == zoneId then
		itemCount = itemCount * ACTIVE_ZONE_EVENT_RATE_LOOT
	end

	if itemCount > 0 then
		local tmpItem = self:addItem(item.itemId, math.min(itemCount, MAX_ITEM_COUNT))
		if not tmpItem then
			return {bool = false, isFromLucky = false, count = 0}
		end

		if tmpItem:isContainer() then
			for i = 1, #item.childLoot do
				if not tmpItem:createLootItem(item.childLoot[i]) then
					tmpItem:remove()
					return {bool = false, isFromLucky = false, count = math.min(itemCount, MAX_ITEM_COUNT)}
				end
			end
		end

		if item.subType ~= -1 then
			tmpItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, item.subType)
		end

		if item.actionId ~= -1 then
			tmpItem:setActionId(item.actionId)
		end

		if item.text and item.text ~= "" then
			tmpItem:setText(item.text)
		end
	end

	return {bool = true, isFromLucky = isFromLucky, count = math.min(itemCount, MAX_ITEM_COUNT)}
end