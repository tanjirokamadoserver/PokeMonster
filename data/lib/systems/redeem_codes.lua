OPCODE_REDEEM_CODES = 88


REDEEM_CODES_TYPES = {
    --@ [type] @-
    [1] = { --@ tables inside type are rewards, individually separated by types ( pokemon, item, outfit, [ aura / wings ?])
        --[[
        {
            type = "pokemon",
            pokeName = "Arceus",
            power = "normal" -- // normal, semi, full
        },
        ]] 
        {
            type = "item", -- 1x ho-oh card
            item_id = 16289,
            item_quantity = 1,
            unique = true
        },
        {
            type = "item", -- 3x boost stone 70
            item_id = 13559,
            item_quantity = 3,
            unique = true
        },
        {
            type = "item", -- 1x picareta de madeira
            item_id = 4257,
            item_quantity = 1,
            unique = true
        },
        {
            type = "item", -- 200x notas azuis
            item_id = 2160,
            item_quantity = 200,
            unique = true
        },
        {
            type = "item", -- 1x essencia white
            item_id = 23039,
            item_quantity = 1,
            unique = true
        },
        {
            type = "item", -- 1x essencia dark
            item_id = 23036,
            item_quantity = 1,
            unique = true
        },
        --[[
        {
            type = "outfit",
            outfit_male = 645,
            outfit_female = 656
        }
        ]]
    },

    [2] = { --@ tables inside type are rewards, individually separated by types ( pokemon, item, outfit, [ aura / wings ?])
        --[[
        {
            type = "pokemon",
            pokeName = "Arceus",
            power = "normal" -- // normal, semi, full
        },
        ]] 
        {
            type = "item",
            item_id = 22664,
            item_quantity = 1,
            unique = true
        },
        {
            type = "item",
            item_id = 14508,
            item_quantity = 1,
            unique = true
        },
        {
            type = "item",
            item_id = 23149,
            item_quantity = 2,
            unique = true
        },
        {
            type = "item",
            item_id = 22868,
            item_quantity = 2,
            unique = true
        },
		{
            type = "item",
            item_id = 13215,
            item_quantity = 20,
            unique = true
        },
    }
}

REDEEM_CODES_EXPIRATION = {
    [1] = {year = 2024, month = 10, day = 1, hour = 23},
    [2] = {year = 2024, month = 07, day = 4, hour = 23}
}


function isValidCodeTime(info)
    local currentTime = os.date('*t')
    
    local currentDateValue = os.time{year = currentTime.year, month = currentTime.month, day = currentTime.day, hour = currentTime.hour}
    local endDateValue = os.time{year = info.year, month = info.month, day = info.day, hour = info.hour}

    if currentDateValue >= endDateValue then 
        return false
    end

    return true
end

CODIGOS_MANUAIS = {
    -- = 1 ho-oh card, 3 boost stone 70, 1 picareta de madeira, 200 notas azuis, 1 essencia white e 1 essencia dark.
    ["ICAROBAIANO"] = {type = 1, storage = 395000},
    ["MONSTER"] = {type = 2, storage = 395010},
}

function Player:handleRedeemCodes(buffer)
    -- manuais
    if buffer then
        local infos = json.decode(buffer)
        local typeOpcode = infos.type
        if typeOpcode and typeOpcode ==  "doRedeemCode" then
            local clientInfo = infos.info
            if clientInfo then
                local redeemCode = clientInfo.code
                if redeemCode then
                    local codigoInfo = CODIGOS_MANUAIS[redeemCode]
                    if codigoInfo then
                        local prizeStorage = codigoInfo.storage
                        local prizeType = codigoInfo.type
                        local expirationDate = REDEEM_CODES_EXPIRATION[prizeType]
                        if expirationDate and not isValidCodeTime(expirationDate) then
                            return self:popupFYI("Código Expirado.")
                        end
                        if self:getStorageValue(prizeStorage) ~= 1 then
                            self:setStorageValue(prizeStorage, 1)
                            self:receiveRedeemCode(prizeType)
                            self:popupFYI("Você resgatou o código, e recebeu os prêmios.")
                        else
                            self:popupFYI("Você já resgatou o código.")
                        end
                    else
                        self:popupFYI("Código Inválido.")
                        return 
                    end
                end
            end
        end
    end
end

function Player:addLevel(level)
    local function getExpForLevel(level)
        level = level - 1
        return ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
    end

    local experienceNeeded = getExpForLevel(self:getLevel() + level)
    local currentExperience = self:getExperience()
    local experienceToAdd = experienceNeeded - currentExperience
    if self:addExperience(experienceToAdd) then
        return true
    end
    return false
end

function Player:receiveRedeemCode(type)
    local rewards = REDEEM_CODES_TYPES[tonumber(type)]
    for _, prize in pairs(rewards) do
        local prizeType = prize.type
        if prizeType == "item" then
			local isStackable = ItemType(prize.item_id):isStackable()
            local item = self:addItem(prize.item_id, prize.item_quantity)
            if prize.unique and item then
				if prize.item_quantity == 1 or isStackable then
					item:setAttribute(ITEM_ATTRIBUTE_UNIQUE_ITEM, 1)
				elseif  prize.item_quantity > 1 and not isStackable then
					for _, stackItem in pairs(item) do
						stackItem:setAttribute(ITEM_ATTRIBUTE_UNIQUE_ITEM, 1)
					end
				end
            end
        elseif prizeType == "pokemon" then
			local item
            local pokemonPower = prize.power
            if pokemonPower == "normal" then
                item = doAddPokeball(self:getId(), prize.pokeName)
            elseif pokemonPower == "semi" then
                item = doAddPokeballSupreme(self:getId(), prize.pokeName)
            elseif pokemonPower == "full" then
                item = doAddPokeballFull(self:getId(), prize.pokeName)
            end
            if prize.unique and item then
                item:setAttribute(ITEM_ATTRIBUTE_UNIQUE_ITEM, 1)
            end
        elseif prizeType == "outfit" then
            if self:getSex() == PLAYERSEX_MALE then
                self:addOutfit(prize.outfit_male)
            elseif self:getSex() == PLAYERSEX_FEMALE then
                self:addOutfit(prize.outfit_female)
            end
        elseif prizeType == "level" then
            self:addLevel(prize.level)
        end
    end
end
