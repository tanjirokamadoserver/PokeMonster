function Item:getHelds()
    local heldx = self:getAttribute(ITEM_ATTRIBUTE_HELDX)
    local heldy = self:getAttribute(ITEM_ATTRIBUTE_HELDY)
    local heldu = self:getAttribute(ITEM_ATTRIBUTE_HELDU)
    local str_to_return = ""
    if heldx > 0 then
        str_to_return = str_to_return .. " " .. HELDS_X_INFO[heldx].heldName
    end

    if heldy > 0 then
        str_to_return = str_to_return .. " " .. HELDS_Y_INFO[heldy].heldName
    end

    if heldu > 0 then
        str_to_return = str_to_return .. " " .. HELDS_U_INFO[heldu].heldName
    end

    local newStr = " Helds: "
    if str_to_return ~= "" then
        newStr = newStr .. str_to_return
    else
        return str_to_return
    end

    return newStr
end

function Player:dumpLogs(dumpBackpack, dumpDepot, dumpHouse)
    local date = os.date("%d-%m-%Y_%H-%M")
    local fileName = ("data/logs/auditoria/%s - %s.log"):format(self:getName(), date)
    local file = io.open(fileName, "w+")
    if not file then
		return error(("[AUDIT-ERROR] - CANNOT CREATE FILE " .. fileName))
	end

    local container = self:getSlotItem(3)
    if not container then dumpBackpack = false end

    if dumpBackpack then
        local containerItems = container:getItems(true)
        local qtdItems = #containerItems
        file:write(("\n[BACKPACK DUMP] - QUANTIDADE ITEMS: %d\n"):format(qtdItems))
        for _, item in ipairs(containerItems) do
            if item then
                local log;
                if item:isPokeball() then
                    log = ("    [POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
                else
                    log = ("    [%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
                end

                file:write(log, "\n")
            end
        end
    end

    if dumpDepot then
        file:write(("\n[DEPOTS DUMP]"):format(), "\n")
        local towns_range = 100
        for i = 1, towns_range do
            local town = Town(i)
            if town then
                local depot = self:getDepotChest(i)
                if depot then
                    local items = depot:getItems(true)
                    local qtdItems = #items
                    file:write(("[TOWN - %d] QUANTIDADE ITEMS: %d"):format(i, qtdItems), "\n")
                    for _, item in ipairs(items) do
                        if item then
                            local log;
                            if item:isPokeball() then
                                log = ("    [POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
                            else
                                log = ("    [%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
                            end
                            file:write(log, "\n")
                        end
                    end
                end
            end
        end
    end

    if dumpHouse then
        local house = self:getHouse()
        if house then
            local items = house:getItems()
            file:write(("\n[HOUSE (%d - %s) DUMP]"):format(house:getId(), house:getName(), #items), "\n")
            for _, item in ipairs(items) do
                if item and item:hasProperty(CONST_PROP_MOVEABLE) then
                    local log;
                    if item:isPokeball() then
                        log = ("[POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
                    else
                        log = ("[%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
                    end
                    file:write(log, "\n")
                    if item:isContainer() then
                        local pos = item:getPosition()
                        local items = item:getItems(true)
                        if #items > 0 then
                            file:write(("[CONTAINER(%s)] - POSITION: (%d, %d, %d)"):format(item:getName(), pos.x, pos.y, pos.z), "\n")
                            for _, item in ipairs(items) do
                                if item then
                                    local log;
                                    if item:isPokeball() then
                                        log = ("    [POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
                                    else
                                        log = ("    [%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
                                    end
                                    file:write(log, "\n")
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    file:write("\n\n--------------------------------------------------------------------------------------\n--------------------------------------------------------------------------------------")
    file:close()
end

function Player:dumpLogTrade(from, item, otherPlayer)
    local date = os.date("%d-%m-%Y_%H-%M")
    local fileName = ("data/logs/auditoria/%s/%s with %s- %s.log"):format(from, self:getName(), otherPlayer:getName(), date)
    local file = io.open(fileName, "w+")
    if not file then
		return error(("[AUDIT-ERROR] - CANNOT CREATE FILE " .. fileName))
	end
    if item:isContainer() then
        local items = item:getItems(true)
        local qtdItems = #items
        file:write(("\n[TRADE] - [%s] - QUANTIDADE ITEMS: %d\n"):format(item:getId(), qtdItems))
        for _, item in ipairs(items) do
            if item then
                local log;
                if item:isPokeball() then
                    log = ("    [POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
                else
                    log = ("    [%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
                end
                file:write(log, "\n")
            end
        end
    else
        local log;
        if item:isPokeball() then
            log = ("[POKEBALL] - (POKENAME): %s (BOOST): %d (LEVEL): %d%s"):format(item:getSpecialAttribute("pokeName"), item:getSpecialAttribute("pokeBoost"), item:getSpecialAttribute("pokeLevel"), item:getHelds())
        else
            log = ("[%d] - %s (%dx)"):format(item:getId(), item:getName(), item:getCount())
        end
        file:write(log, "\n")
    end
    file:close()
end