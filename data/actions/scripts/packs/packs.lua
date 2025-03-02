local packs = {
    [22933] = {
        bag = 1999,
        name = "Pacote Iniciante",
        rewards = {
            {itemId = 2145, qtd = 5},
            {itemId = 20653, qtd = 2},
            {itemId = 20649, qtd = 1},
            {itemId = 14511, qtd = 1},
            {itemId = 20652, qtd = 1},
        },
        globalReward = {itemId = 20652, qtd = 1}
    },
    [22934] = {
        bag = 1998,
        name = "Pacote M�dio",
        rewards = {
            {itemId = 2145, qtd = 10},
            {itemId = 22787, qtd = 1},
            {itemId = 20708, qtd = 2},
            {itemId = 14511, qtd = 1},
            {itemId = 20653, qtd = 5},
            {itemId = 20652, qtd = 5},
            {itemId = 22664, qtd = 2},
            {itemId = 6569, qtd = 100},

        },
        globalReward = {itemId = 20652, qtd = 2}
    },
    [22935] = {
        bag = 2000,
        name = "Pacote Intermedi�rio",
        rewards = {
            {itemId = 2145, qtd = 15},
            {itemId = 20669, qtd = 1},
            {itemId = 17166, qtd = 1},
            {itemId = 17165, qtd = 1},
            {itemId = 14511, qtd = 1},
            {itemId = 22664, qtd = 5},
            {itemId = 22787, qtd = 2},
            {itemId = 20708, qtd = 5},
            {itemId = 22666, qtd = 50},

        },
        globalReward = {itemId = 22664, qtd = 1}
    },
    [22936] = {
        bag = 2001,
        name = "Pacote Avan�ado",
        rewards = {
            {itemId = 13532, qtd = 1},
            {itemId = 20669, qtd = 2},
            {itemId = 17166, qtd = 1},
            {itemId = 17165, qtd = 1},
            {itemId = 2145, qtd = 50},
            {itemId = 22664, qtd = 15},
            {itemId = 22787, qtd = 5},
            {itemId = 20708, qtd = 10},
            {itemId = 22666, qtd = 100},

        },
        globalReward = {itemId = 20708, qtd = 1}
    },
    [22937] = {
        bag = 2365,
        name = "Pacote Monster",
        rewards = {
            {itemId = 14517, qtd = 1},
            {itemId = 22787, qtd = 10},
            {itemId = 2145, qtd = 100},
            {itemId = 20708, qtd = 25},
            {itemId = 22664, qtd = 25},
            {itemId = 21261, qtd = 1},
            {itemId = 20669, qtd = 5},
            {itemId = 22666, qtd = 200},
            {itemId = 17166, qtd = 1},
            {itemId = 17165, qtd = 1},
        },
        globalReward = {itemId = 2145, qtd = 2}
    }
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local packSelected = packs[item.itemid]
    local bag = player:addItem(packSelected.bag, 1)
    for _, itemInfo in pairs(packSelected.rewards) do
        bag:addItem(itemInfo.itemId, itemInfo.qtd)
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Parab�ns, voc� recebeu um %s", packSelected.name))
    Game.broadcastMessage(string.format("O Jogador %s, abriu um %s, e todos os jogadores online receberam um pr�mio!", player:getName(), packSelected.name))
    
    for _, rewaredPlayer in ipairs(Game.getPlayers()) do
        rewaredPlayer:addItem(packSelected.globalReward.itemId, packSelected.globalReward.qtd)
        rewaredPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voc� recebeu uma premia��o, gra�as a %s, por ter aberto um pacote", player:getName())
    end
    
    item:remove(1)
    return true
end