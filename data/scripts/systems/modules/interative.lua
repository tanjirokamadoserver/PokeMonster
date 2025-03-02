START_CONVERSATION = "HiNpc"
CONVERSATION = "conversation"

COLORS = {
    white = "#ffffff"
}
function Player:testeStone()
    print("oi")
    dialog =
    "Ol·°, jovem treinador! Me chamo [a]Dr Stone[a/] e estou aqui para entregar alguns itens para quem tiver o c√≥digo promocional de inicio de servidor, digite a baixo o c√≥digo para receber sua recompensa!"
    closeTime = nil
    buttons = {
        { type = "TextEdit",   title = "Digite apenas numeros:", validStg = "1234567890",                                                                                                      maxStg = 10, placeHolder = "VALIDO APENAS NUMEROS" },
        { type = "TextEdit",   title = "Digite apenas letras:",  validStg = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",                                                            maxStg = 10, placeHolder = "VALIDO APENAS LETRAS" },

        { type = "PokeSelect", poke = "Venusaur",                text = "While it basks in the sun, it can convert the light into energy. As a result, it is more powerful in the summertime.", response = "teste1"},
        { type = "PokeSelect", poke = "Blastoise",               text = "It deliberately increases its body weight so it can withstand the recoil of the water jets it fires.",  response = "teste2"},
        { type = "PokeSelect", poke = "Charizard",               text = "If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade.",  response = "teste3"},

        {
            type = "ItemList",
            title = "Receber item:",
            response = "ItemList",
            items = {
                { id = 2160, count = 1 },
                { id = 2160, count = 1 },
                { id = 2160, count = 1 },
                { id = 2160, count = 5 },
                { id = 2160, count = 1 },
                { id = 2160, count = 100 },
            }
        },
        {
            type = "PokeList",
            title = "Aceito derrotar seguintes PokÈmons:",
            response = "PokeList",
            pokes = {
                { name = "Charmander", count = 1,   outfit = 0 },
                { name = "Blastoise",  count = 1,   outfit = 0 },
                { name = "Caterpie",   count = 1,   outfit = 0 },
                { name = "Butterfree", count = 5,   outfit = 0 },
                { name = "Magneton",   count = 1,   outfit = 0 },
                { name = "Gyarados",   count = 100, outfit = 0 },
                { name = "Kingler",    count = 100, outfit = 0 },
            }
        },

        { type = "Text", text = "Neque porro quisquam est qui dolorem [8]Dr Stone[8/] ipsum quia dolor sit amet, consectetur, adipisci velit..[8]Dr Stone[8/].", response = "teste4"},

    }
    doSendCallForNpc(self, self, "HiNpc", "#00d2ff", nil, dialog, buttons, closeTime)
end

function doSendCallForNpc(npc, player, NpcType, colorName, NpcImage, dialogNpc, buttonsNpc, closeTime)
    if buttonsNpc then
        for i, button in ipairs(buttonsNpc) do
            if button.rewards then
                for j, reward in ipairs(button.rewards) do
                    local itemType = ItemType(reward.item)
                    reward.item = itemType:getClientId()
                end
            end

            if button.items then
                for j, item in ipairs(button.items) do
                    local itemType = ItemType(item.id)
                    item.name = itemType:getName()
                    item.id = itemType:getClientId()
                end
            end

            if button.pokes then
                for j, pokemon in ipairs(button.pokes) do
                    local pType = MonsterType(pokemon.name)
                    local pokemonOutfit = pType:outfit()
                    pokemon.outfit = pokemonOutfit.lookType
                end
            end
        end
    end

    local npcDialog = {
        npcInfo = {
            NpcName = { name = getCreatureName(npc), color = colorName },
            type = NpcType,
            outfit = getCreatureOutfit(npc),
            image = NpcImage,
        },
        closeTime = closeTime,
        dialog = dialogNpc,
        Buttons = buttonsNpc,
    }
    player:sendExtendedOpcode(54, json.encode(npcDialog))
end
