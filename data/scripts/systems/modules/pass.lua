PASS = {
    ITEM_FREE = 1,
    ITEM_PREMIUM = 2,
}

PASS.ITEMS = {
    [1] = {
        [PASS.ITEM_FREE] = {
            itemId = 2160,
        },
        [PASS.ITEM_PREMIUM] = {
            itemId = 2160,
        },
    },
    [2] = {
        [PASS.ITEM_FREE] = {
            itemId = 2160,
        },
        [PASS.ITEM_PREMIUM] = {
            itemId = 2160,
        },
    }
}

CONSTANT_PASS = {
    callbackId = 0x1,
    rewardFree = 9250000,
    rewardPremium = 9260000,
    missionsStates = 9270000
}

function Player.hasCollectedPassReward(self, level, passItemType)
    local stoId = passItemType == PASS.ITEM_FREE and CONSTANT_PASS.rewardFree or passItemType == PASS.ITEM_PREMIUM and CONSTANT_PASS.rewardPremium
    local value = math.max(0, self:getStorageValue(stoId))
    if value < 1 then
        return false
    end
    return true
end

function NetworkMessage:sendPassItems(items)
    self:addU16(#items)
    for id, levelItems in ipairs(items) do
        for passItemType, item in pairs(levelItems) do
            local itemType = ItemType(item.itemId)
            self:addByte(passItemType)
            self:addString(itemType:getName())
            self:addString(itemType:getDescription())
            self:addU16(itemType:getClientId())
        end
    end
end

function NetworkMessage:setCallbackId(id)
    self:addByte(0xFF)
    self:addByte(id)
end

function NetworkMessage:finish(player)
	self:sendToPlayer(player)
	self:delete()
end

function Player.sendPassData(self)
	local msg = NetworkMessage()
	msg:setCallbackId(CONSTANT_PASS.callbackId)
    msg:sendPassItems(PASS.ITEMS)
    msg:finish(self)
end

local callback = CallbackHandler(CONSTANT_PASS.callbackId)
function callback.onReceive(player, msg)
    print("recebendo:" .. msg:getString())
end
callback:register()