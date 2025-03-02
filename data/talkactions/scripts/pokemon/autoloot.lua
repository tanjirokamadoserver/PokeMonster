function onSay(player, words, param)
    local playerPos = player:getPosition()
    local minX, maxX = playerPos.x - 1, playerPos.x + 1
    local minY, maxY = playerPos.y - 1, playerPos.y + 1
    local z = playerPos.z

    -- Process player's surrounding tiles
    for x = minX, maxX do
        for y = minY, maxY do
            local tile = Tile(Position(x, y, z))
            if tile then
                local items = tile:getItems()
                for _, item in ipairs(items) do
                    if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == player:getId() or item:getSpecialAttribute("corpse_owner_name") == player:getName() then
                        for slot = 0, (getContainerSize(item:getUniqueId()) - 1) do
                            local containerItem = getContainerItem(item:getUniqueId(), slot)
                            while containerItem and containerItem.uid > 0 and containerItem.itemid ~= 0 do
                                player:addItem(containerItem.itemid, containerItem.type)
                                doRemoveItem(containerItem.uid)
                                containerItem = getContainerItem(item:getUniqueId(), slot)
                            end
                        end
                    end
                end
            end
        end
    end

    -- Process summon's surrounding tiles
    if hasSummons(player) then
      local itemsToLootAllWindow = {}
      local summon = player:getSummons()[1]
      local summonPos = summon:getPosition()
      local minX, maxX = summonPos.x - 1, summonPos.x + 1
      local minY, maxY = summonPos.y - 1, summonPos.y + 1
      local z = summonPos.z
	  
      -- Process player's surrounding tiles
      for x = minX, maxX do
          for y = minY, maxY do
              local tile = Tile(Position(x, y, z))
              if tile then
                  local items = tile:getItems()
				  if items then
                    for _, item in ipairs(items) do
                        if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == player:getId() or item:getSpecialAttribute("corpse_owner_name") == player:getName() then
                            for slot = 0, (getContainerSize(item:getUniqueId()) - 1) do
                                local containerItem = getContainerItem(item:getUniqueId(), slot)
                                while containerItem and containerItem.uid > 0 and containerItem.itemid ~= 0 do
                                    player:addItem(containerItem.itemid, containerItem.type)
                                    doRemoveItem(containerItem.uid)
                                    containerItem = getContainerItem(item:getUniqueId(), slot)
                                end
                            end
                        end
                    end
				  end
              end
          end
      end
    end

    return false
end