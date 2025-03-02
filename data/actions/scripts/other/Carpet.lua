-- Crie uma tabela de mapeamento para alternar entre os itens
local itemToggleMap = {
    [22717] = 22718,
    [22718] = 22717,
    [22719] = 22720,
    [22720] = 22719,
    [22721] = 22722,
    [22722] = 22721,
    [22723] = 22724,
    [22724] = 22723,
    [22725] = 22726,
    [22726] = 22725,
    [22727] = 22728,
    [22728] = 22727,
    [22729] = 22730,
    [22730] = 22729,
    [22731] = 22732,
    [22732] = 22731,
    [22733] = 22734,
    [22734] = 22733,
    [22735] = 22736,
    [22736] = 22735,
    [22737] = 22738,
    [22738] = 22737,
    [22740] = 22741,
    [22741] = 22740,
    [22742] = 22743,
    [22743] = 22742,
    [22744] = 22745,
    [22745] = 22744,
    [22746] = 22747,
    [22747] = 22746,
    [22748] = 22749,
    [22749] = 22748,
    [22750] = 22751,
    [22751] = 22750,
    [22752] = 22753,
    [22753] = 22752,
    [22754] = 22755,
    [22755] = 22754,
    [22756] = 22757,
    [22757] = 22756,
    [22758] = 22759,
    [22759] = 22758,
    [22760] = 22761,
    [22761] = 22760,
    [22767] = 22768,
    [22768] = 22767,
    [22770] = 22771,
    [22771] = 22770,
    [22774] = 22775,
    [22775] = 22774,
    [22776] = 22777,
    [22777] = 22776,
    [22778] = 22779,
    [22779] = 22778,

}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local closedItemID = item:getId()
    local openedItemID = itemToggleMap[closedItemID]

    if openedItemID then
        -- Se houver um item aberto correspondente, crie o item na posição alvo
        local newItem = Game.createItem(openedItemID, 1, toPosition)
        
        if newItem then
            -- Remova o item que o jogador usou
            item:remove(1)
            
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Você alterou o item.")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Não foi possível criar o novo item.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Este item não pode ser alternado.")
    end
    return true
end
