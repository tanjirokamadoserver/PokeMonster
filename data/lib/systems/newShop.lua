OPCODE_NEW_SHOP = 87

SHOP_DATA = {}

SHOP_DATA.ORDEM = {
    [1] = "ITEMS",
    [2] = "HOUSE",
    [3] = "POKEBALLS",
    [4] = "OUTFITS",
    [5] = "POKEMONS",
    [6] = "PACKS",
    [7] = "ASSINATURA",
    [8] = "AURAS",
    [9] = "WINGS",
    [10] = "SHADERS",
}

SHOP_DATA.STYLES = {
    ["outfit"] = "baseOutfit",
    ["item"] = "baseItem",
    ["pokemon"] = "basePokemon",
}

SHOP_DATA.CATEGORYINFO = {

    ["ITEMS"] = {icon = "assets/categories/icon_items", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["HOUSE"] = {icon = "assets/categories/icon_house", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["POKEBALLS"] = {icon = "assets/categories/icon_pokeballs", size = '34 34', iconOffet = {x = 8, y = 8}},

    ["OUTFITS"] = {icon = "assets/categories/icon_outfit", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["POKEMONS"] = {icon = "assets/categories/icon_pokemon", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["PACKS"] = {icon = "assets/categories/icon_packs", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["ASSINATURA"] = {icon = "assets/categories/icon_clube", size = '34 34', iconOffet = {x = 8, y = 8}},

    ["AURAS"] = {icon = "assets/categories/icon_aura", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["WINGS"] = {icon = "assets/categories/icon_wings", size = '34 34', iconOffet = {x = 8, y = 8}},
    ["SHADERS"] = {icon = "assets/categories/icon_outfit", size = '34 34', iconOffet = {x = 8, y = 8}},
}

SHOP_DATA.CATEGORY = {
    ["ITEMS"] = {
		{type = "item", valor = 1, moeda = 23498, item = {id = 24405, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 1, moeda = 23498, item = {id = 23155, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 10, moeda = 12237, item = {id = 2160, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 5, moeda = 23497, item = {id = 16230, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 35, moeda = 23498, item = {id = 21261, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 200, moeda = 23498, item = {id = 23499, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Caixa dos Espiritos Duelo do Destino
		{type = "item", valor = 1000, moeda = 23498, item = {id = 22869, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Monster Ticket Vip
		{type = "item", valor = 20, moeda = 23498, item = {id = 23150, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Particle Aura
		{type = "item", valor = 3, moeda = 23498, item = {id = 23149, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Fusion Charm 1Hr
		{type = "item", valor = 15, moeda = 23498, item = {id = 23151, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Fusion Charm 1D
		{type = "item", valor = 40, moeda = 23498, item = {id = 23152, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Fusion Charm 1S
		{type = "item", valor = 8, moeda = 23498, item = {id = 22919, qtd = 100, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Especial Pokeball
		{type = "item", valor = 20, moeda = 23498, item = {id = 22930, qtd = 100, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Esfera Lendaria
		{type = "item", valor = 10, moeda = 23498, item = {id = 5785, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- VIP
		{type = "item", valor = 20, moeda = 23498, item = {id = 22965, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Holder de Luxo
		{type = "item", valor = 5, moeda = 23498, item = {id = 22787, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Held Box T20
		{type = "item", valor = 8, moeda = 23498, item = {id = 20669, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Star Fusion
		{type = "item", valor = 10, moeda = 23498, item = {id = 17165, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Regen Orb
		{type = "item", valor = 10, moeda = 23498, item = {id = 17166, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Exp Orb
		{type = "item", valor = 5, moeda = 23498, item = {id = 22666, qtd = 64, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Mega Candy
		{type = "item", valor = 16, moeda = 23497, item = {id = 20653, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 20653
		{type = "item", valor = 1, moeda = 23497, item = {id = 20682, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 20682
		{type = "item", valor = 20, moeda = 23497, item = {id = 17165, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 17165
		{type = "item", valor = 30, moeda = 23497, item = {id = 17166, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 17166
		{type = "item", valor = 50, moeda = 23497, item = {id = 20669, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 20669
		{type = "item", valor = 30, moeda = 23497, item = {id = 22787, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 20652
		{type = "item", valor = 1, moeda = 23497, item = {id = 6569, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 6569
		{type = "item", valor = 100, moeda = 23497, item = {id = 23150, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- ID 6569
        {type = "item", valor = 100, moeda = 12237, item = {id = 13572, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 300, moeda = 12237, item = {id = 13214, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 500, moeda = 12237, item = {id = 20680, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 700, moeda = 12237, item = {id = 20681, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1000, moeda = 12237, item = {id = 20682, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 200, moeda = 12237, item = {id = 20648, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1, moeda = 12237, item = {id = 14435, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1, moeda = 12237, item = {id = 13198, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1, moeda = 12237, item = {id = 14434, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1000, moeda = 12237, item = {id = 16237, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 1000, moeda = 12237, item = {id = 16238, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 10000, moeda = 12237, item = {id = 16239, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 10000, moeda = 12237, item = {id = 16240, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 10000, moeda = 12237, item = {id = 2145, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 3, moeda = 2145, item = {id = 20682, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 10, moeda = 2145, item = {id = 4874, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 5, moeda = 2145, item = {id = 20679, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 30, moeda = 2145, item = {id = 20709, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 60, moeda = 2145, item = {id = 20708, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 20, moeda = 2145, item = {id = 20661, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 40, moeda = 2145, item = {id = 20669, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 20, moeda = 2145, item = {id = 17165, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 20, moeda = 2145, item = {id = 17166, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 5, moeda = 2145, item = {id = 20652, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 20, moeda = 2145, item = {id = 6569, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
    },
    ["HOUSE"] = {
        {type = "item", valor = 2500, moeda = 12237, item = {id = 14360, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 2500, moeda = 12237, item = {id = 14359, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 2500, moeda = 12237, item = {id = 17844, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 2500, moeda = 12237, item = {id = 22773, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 2500, moeda = 12237, item = {id = 22792, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20632, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20606, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20604, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20603, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20602, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20601, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20600, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20599, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20598, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20597, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20596, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20595, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20594, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20593, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20592, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20558, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20477, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20475, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20474, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20473, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20470, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20469, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20464, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20463, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20461, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 20460, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
        {type = "item", valor = 250, moeda = 12237, item = {id = 18412, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item2"}, 
    },
    ["POKEBALLS"] = {
        {type = "item", valor = 2, moeda = 12237, item = {id = 16743, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16744, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16745, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16746, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16747, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16748, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16749, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16750, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16751, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16752, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 2, moeda = 12237, item = {id = 16753, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
        {type = "item", valor = 750, moeda = 12237, item = {id = 7439, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, 
    },
    ["OUTFITS"] = {
		{type = "outfit", valor = 10, moeda = 23498, name = "Cavaleiro Da Abobora", lookType = {type = 2992}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Esqueletron", lookType = {type = 3799}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Majin Boo Gordo", lookType = {type = 3830}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Super Gyarados", lookType = {type = 4425}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "outfit", valor = 10, moeda = 23498, name = "Black Trainer", lookType = {type = 4765}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "outfit", valor = 10, moeda = 23498, name = "Lobisomem", lookType = {type = 4314}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "outfit", valor = 10, moeda = 23498, name = "Brutus", lookType = {type = 4006}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "outfit", valor = 10, moeda = 23498, name = "Toph", lookType = {type = 3975}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Super Man", lookType = {type = 3926}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Killer", lookType = {type = 3899}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 10, moeda = 23498, name = "Trunks do Futuro", lookType = {type = 3842}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 30, moeda = 23498, name = "All Might", lookType = {type = 4984}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 20, moeda = 23497, name = "Profundo", lookType = {type = 4010}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 30, moeda = 23497, name = "Brutus", lookType = {type = 4006}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 30, moeda = 23497, name = "Translucid", lookType = {type = 4005}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 35, moeda = 23497, name = "Trem Bala", lookType = {type = 4002}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 30, moeda = 23497, name = "Black Noir", lookType = {type = 4003}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 40, moeda = 23497, name = "Tempesta", lookType = {type = 4004}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 25, moeda = 23497, name = "Luz Estrela", lookType = {type = 4007}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", valor = 30, moeda = 23497, name = "Maeve", lookType = {type = 4008}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},

        {type = "outfit", valor = 10000, moeda = 12237, name = "Monkey D Luffy", lookType = {type = 4289}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Bartholomew Kuma", lookType = {type = 4293}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Barba Negra", lookType = {type = 4295}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Usopp", lookType = {type = 4298}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Tony Tony Chopper", lookType = {type = 4306}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Princesa Vivi", lookType = {type = 4288}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", valor = 10000, moeda = 12237, name = "Reiju", lookType = {type = 4299}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
    ["POKEMONS"] = {
        -- {type = "pokemon", valor = 9500, moeda = 12237, pokeName = "Legendary Caterpie", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 10000, moeda = 12237, pokeName = "Rayquaza Natalino", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 6250, moeda = 12237, pokeName = "Black Greninja", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 6250, moeda = 12237, pokeName = "Black Sky Shaymin", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 3500, moeda = 12237, pokeName = "Perfect Jirachi", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 15, moeda = 2145, pokeName = "Prime Arcanine", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 20, moeda = 2145, pokeName = "Mech Pidgeot", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 30, moeda = 2145, pokeName = "Infinite Golurk", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 40, moeda = 2145, pokeName = "Dylveon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 50, moeda = 2145, pokeName = "Mini Metagross", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 60, moeda = 2145, pokeName = "Ditteon", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 120, moeda = 2145, pokeName = "Perfect Regirock", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 120, moeda = 2145, pokeName = "Perfect Registeel", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 150, moeda = 2145, pokeName = "Certamente Charizard", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 180, moeda = 2145, pokeName = "Iluminus Kyurem", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 200, moeda = 2145, pokeName = "Black Zygarde", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        -- {type = "pokemon", valor = 300, moeda = 2145, pokeName = "Magnos Caterpie", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},

        -- {type = "pokemon", valor = 1800, moeda = 23496, pokeName = "Mewtwo Fire", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23496, pokeName = "Black Gardevoir", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23496, pokeName = "Black Blastoise", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 90, moeda = 23496, pokeName = "Black Scizor", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 90, moeda = 23496, pokeName = "Black Vileplume", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 180, moeda = 23496, pokeName = "Ultra Zygarde", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 1600, moeda = 23496, pokeName = "Zaytios", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 300, moeda = 23496, pokeName = "Pluss Ho-oh", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 360, moeda = 23496, pokeName = "Pluss Solgaleo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 210, moeda = 23496, pokeName = "Lunala Necromante", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 210, moeda = 23496, pokeName = "Pluss Yveltal", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 210, moeda = 23496, pokeName = "Black Abosmanow", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 150, moeda = 23496, pokeName = "Pluss Regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 150, moeda = 23496, pokeName = "Pluss Giratina", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 60, moeda = 23496, pokeName = "Green Heatran", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23496, pokeName = "Magmortar Robotic", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23496, pokeName = "Crobat Robotic", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23496, pokeName = "Crawdaunt Robotic", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 15, moeda = 23496, pokeName = "Dark Ash Greninja", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 15, moeda = 23496, pokeName = "White Zeraora", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 15, moeda = 23496, pokeName = "Prime Lugia", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 15, moeda = 23496, pokeName = "Feraligatr Robotic", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},

		-- {type = "pokemon", valor = 200, moeda = 23498, pokeName = "Hoopa Florecer Espiritual", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 180, moeda = 23498, pokeName = "Zygarde All Might Mode", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 175, moeda = 23498, pokeName = "Regigigas Sword of Lush", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 150, moeda = 23498, pokeName = "Regidrake", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 135, moeda = 23498, pokeName = "Draknus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 135, moeda = 23498, pokeName = "Eternatus", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 90, moeda = 23498, pokeName = "Esquelect Regigigas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 85, moeda = 23498, pokeName = "Mewtwo Estrela Negra", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 75, moeda = 23498, pokeName = "Plasma Mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 50, moeda = 23498, pokeName = "Celestial Mewtwo", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 40, moeda = 23498, pokeName = "Lucario Souls", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 30, moeda = 23498, pokeName = "Perfect Xerneas", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		-- {type = "pokemon", valor = 15, moeda = 23498, pokeName = "Giratina Poison Star", lookType = {}, bonus = {boost = 0}, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},

    },
    ["PACKS"] = {
		{type = "item", valor = 5, moeda = 23498, item = {id = 22933, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Noob
		{type = "item", valor = 15, moeda = 23498, item = {id = 22934, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Iniciante
		{type = "item", valor = 25, moeda = 23498, item = {id = 22935, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Intermediario
		{type = "item", valor = 50, moeda = 23498, item = {id = 22936, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Avancado
		{type = "item", valor = 90, moeda = 23498, item = {id = 22937, qtd = 1, name = ""}, offset = {x = 0, y = 0}, size = "32 32", backgroundImage = "default_item"}, -- Space
    },
    ["ASSINATURA"] = {
        {   type = "clube",
            beneficios = "     35% Bônus:\nBônus Experiência\nBônus Catch Points\nBônus Loot Rate\nKit Anime: (Outfit+Poke) Boku No Hero",
			info = "Ao comprar o vip plus, você receberá 31 dias do benefício,\napenas no personagem no qual você comprar. Necessário: 40 Space Coin",
			price = 40,
			moeda = 23498
        }
    },
    -- aura nome, wing nome, shader id
    ["AURAS"] = {
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Fire Dragon", lookType = {type = 0, aura = 4616}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Leaf Dragon", lookType = {type = 0, aura = 4617}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Water Dragon", lookType = {type = 0, aura = 4618}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Dark Dragon", lookType = {type = 0, aura = 4619}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Super", lookType = {type = 0, aura = 4628}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Darkness", lookType = {type = 0, aura = 4667}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circular Red", lookType = {type = 0, aura = 4635}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Yellow", lookType = {type = 0, aura = 4725}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Red", lookType = {type = 0, aura = 4724}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "White", lookType = {type = 0, aura = 4723}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Aura Amarelo", lookType = {type = 0, aura = 4610}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Aura Azul", lookType = {type = 0, aura = 4611}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Aura Laranja", lookType = {type = 0, aura = 4612}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Vaivem Laranja", lookType = {type = 0, aura = 4613}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
 
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Vaivem Azul", lookType = {type = 0, aura = 4614}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Glow Effects", lookType = {type = 0, aura = 4621}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Efeitos Verdes", lookType = {type = 0, aura = 4622}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Glow Yellow", lookType = {type = 0, aura = 4623}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Glow Azul", lookType = {type = 0, aura = 4624}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulos Azuis", lookType = {type = 0, aura = 4625}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulos Laranjas", lookType = {type = 0, aura = 4626}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulos Laranjas Slow", lookType = {type = 0, aura = 4629}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulos Azuis Slow", lookType = {type = 0, aura = 4630}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulos Verdes Slow", lookType = {type = 0, aura = 4631}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Caveiras Vermelhas", lookType = {type = 0, aura = 4657}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Circulo de Fogo", lookType = {type = 0, aura = 4658}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Coracao", lookType = {type = 0, aura = 4659}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Smoke", lookType = {type = 0, aura = 4660}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Conexoes", lookType = {type = 0, aura = 4661}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Raio 1", lookType = {type = 0, aura = 4662}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Smoke 2", lookType = {type = 0, aura = 4663}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Raio Roxo", lookType = {type = 0, aura = 4698}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Espada", lookType = {type = 0, aura = 4699}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
	
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Raio Solar", lookType = {type = 0, aura = 4703}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Dragao Verde", lookType = {type = 0, aura = 4704}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Fortune Effect", lookType = {type = 0, aura = 4706}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Thor Effect", lookType = {type = 0, aura = 4707}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Enel Effect", lookType = {type = 0, aura = 4708}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Dark Effect", lookType = {type = 0, aura = 4709}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Piso 1", lookType = {type = 0, aura = 4712}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Piso 2", lookType = {type = 0, aura = 4713}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Piso 3", lookType = {type = 0, aura = 4714}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
		{type = "outfit", subtype = "aura", valor = 20, moeda = 23498, name = "Piso 4", lookType = {type = 0, aura = 4715}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
	},
    ["WINGS"] = {
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Golden", lookType = {type = 0, wings = 79}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Purple", lookType = {type = 0, wings = 81}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Fire and Ice", lookType = {type = 0, wings = 4649}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Molten", lookType = {type = 0, wings = 4726}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Smoke", lookType = {type = 0, wings = 4727}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Angelic", lookType = {type = 0, wings = 4728}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Archangel", lookType = {type = 0, wings = 4729}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Smile", lookType = {type = 0, wings = 4730}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Demonic", lookType = {type = 0, wings = 4700}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Flamingo", lookType = {type = 0, wings = 4608}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Evil", lookType = {type = 0, wings = 4609}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Balloon", lookType = {type = 0, wings = 4638}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "White", lookType = {type = 0, wings = 4639}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Blue", lookType = {type = 0, wings = 4640}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Fire", lookType = {type = 0, wings = 4641}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Fairy", lookType = {type = 0, wings = 4642}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Phoenix", lookType = {type = 0, wings = 4643}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Phoenix Blue", lookType = {type = 0, wings = 4644}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Phoenix Black", lookType = {type = 0, wings = 4645}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Phoenix Golden", lookType = {type = 0, wings = 4646}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Eagle", lookType = {type = 0, wings = 4647}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Reecarnation", lookType = {type = 0, wings = 4648}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Grey", lookType = {type = 0, wings = 4650}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Golden", lookType = {type = 0, wings = 4651}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Sanguine", lookType = {type = 0, wings = 4652}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Black and Red", lookType = {type = 0, wings = 4653}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Blue and Blue", lookType = {type = 0, wings = 4654}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Green", lookType = {type = 0, wings = 4655}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "wing", valor = 20, moeda = 23498, name = "Grey 2", lookType = {type = 0, wings = 4656}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
    ["SHADERS"] = {
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Rainbow", lookType = {type = 511, shader = "outfit_rainbow"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Calor", lookType = {type = 510, shader = "outfit_heat"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Party", lookType = {type = 511, shader = "outfit_party"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Light Blue", lookType = {type = 510, shader = "ShaderLightBlue"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Blue", lookType = {type = 511, shader = "ShaderBlue"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Red", lookType = {type = 510, shader = "ShaderRed"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Dark Red", lookType = {type = 511, shader = "ShaderDarkRed"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Purple", lookType = {type = 510, shader = "ShaderPurple"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "White", lookType = {type = 511, shader = "ShaderWhite"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Light Blue Static", lookType = {type = 510, shader = "ShaderLightBlueStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Blue Static", lookType = {type = 511, shader = "ShaderBlueStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Red Static", lookType = {type = 510, shader = "ShaderRedStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Dark Red Static", lookType = {type = 511, shader = "ShaderDarkRedStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Purple Static", lookType = {type = 510, shader = "ShaderPurpleStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "White Static", lookType = {type = 511, shader = "ShaderWhiteStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Rage", lookType = {type = 510, shader = "ShaderRage"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Freeze", lookType = {type = 511, shader = "ShaderFreeze"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Green", lookType = {type = 510, shader = "ShaderGreen"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Green Static", lookType = {type = 511, shader = "ShaderGreenStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Yellow", lookType = {type = 510, shader = "ShaderYellow"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Yellow Static", lookType = {type = 511, shader = "ShaderYellowStatic"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Highlight", lookType = {type = 510, shader = "ShaderCreatureHighlight"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Outline", lookType = {type = 511, shader = "Outfit_3line"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Circle", lookType = {type = 510, shader = "Outfit_circle"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Outline 2", lookType = {type = 511, shader = "Outfit_Line"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Outline 3", lookType = {type = 510, shader = "Outfit_Outline"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Cintilante", lookType = {type = 511, shader = "Outfit_Shimmering"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Brilho", lookType = {type = 510, shader = "Outfit_Shine"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Brazil", lookType = {type = 511, shader = "Outfit_brazil"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Gold", lookType = {type = 511, shader = "Outfit_Gold"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Stars", lookType = {type = 510, shader = "Outfit_Stars"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Blood", lookType = {type = 511, shader = "Outfit_blood"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Camuflagem", lookType = {type = 510, shader = "Outfit_camouflage"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Flash", lookType = {type = 511, shader = "Outfit_Flash"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Glitch", lookType = {type = 510, shader = "Outfit_Glitch"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Ice", lookType = {type = 511, shader = "Outfit_Ice"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Purple Neon", lookType = {type = 510, shader = "Outfit_Purpleneon"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Cosmos", lookType = {type = 511, shader = "Outfit_Cosmos"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Purple Sky", lookType = {type = 510, shader = "Outfit_Purplesky"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Static", lookType = {type = 511, shader = "Outfit_Static"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Sun", lookType = {type = 510, shader = "Outfit_Sun"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Red", lookType = {type = 511, shader = "outfit_red"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Blue", lookType = {type = 510, shader = "outfit_blue"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Green", lookType = {type = 511, shader = "outfit_green"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Purple", lookType = {type = 510, shader = "outfit_purple"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Yellow", lookType = {type = 511, shader = "outfit_yellow"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Grey", lookType = {type = 510, shader = "outfit_gray"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Black", lookType = {type = 511, shader = "outfit_black"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "White", lookType = {type = 510, shader = "outfit_white"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Rainbow 2", lookType = {type = 511, shader = "outfit_rainbow"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Rainbow 3", lookType = {type = 510, shader = "poke_friends"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Circle White", lookType = {type = 511, shader = "outfit_circle_white"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
        {type = "outfit", subtype = "shader", valor = 20, moeda = 23498, name = "Circle Red", lookType = {type = 510, shader = "outfit_circle_red"}, animated = true, offset = {x = 0, y = 0}, size = "48 48", backgroundImage = "default_item"},
    },
}

local isShopLoaded = false

SHOP_CACHE = {}
SHOP_JSON = {}

function Player:handleShop(buffer)
    if not buffer then return false end
    local data = json.decode(buffer)
    if not data then return false end
    local type = data.type
    if not type then return false end
    if type == "buy" then
        local infos = data.info
        local category = infos.category
        local selectedCat = SHOP_DATA.CATEGORY[category]
        local quantityClient = infos.quantity or 1
        if not selectedCat then
            return false
        end
		
		if category == "ASSINATURA" then
			local currency = selectedCat[1].moeda
			local price = selectedCat[1].price
			if self:getItemCount(currency) < price then
				self:popupFYI("Você nðo possui dinheiro suficiente para comprar.")
			else
				self:removeItem(currency, price)
				self:addVipPlus(31)
				doAddPokeball(self, "Gang Kyogre")
				self:addOutfit(4996)
				self:popupFYI("Você adquiriu o vip plus mensal!")
			end
			return true
		end

		local idItem = tonumber(infos.id)
        local item = selectedCat[idItem]
        local currency = tonumber(item.moeda)
        local price = tonumber(item.valor) * quantityClient

        if self:getItemCount(currency) < price then
             self:popupFYI("Você nðo possui dinheiro suficiente para comprar.")
        else
            self:removeItem(currency, price)
            if item.type == "item" then
                self:addItem(item.item.id, item.item.qtd * quantityClient)
            elseif item.type == "outfit" then
                if not item.subtype then
                    self:addOutfit(item.lookType.type)
                else
                    local subtype = item.subtype
                    if subtype == "wing" then
                        self:addWing(item.name)
                    elseif subtype == "aura" then
                        self:addAura(item.name)
                    elseif subtype == "shader" then
                        self:addShader(item.lookType.shader)
                    end
                end
            elseif item.type == "pokemon" then
				local pokeName = item.pokeName
				if currency == 23498 then
					if price >= 100 then
						doAddPokeballFull(self:getId(), pokeName)
					else
						doAddPokeballSupreme(self:getId(), pokeName)
					end
				else
					local boost = item.bonus.boost
					doAddPokeball(self:getId(), pokeName)
				end
            end

            self:popupFYI(string.format("Parabéns, sua compra foi bem sucedida."))
        end
    end
    return true
end

function loadShopJSONCache()
    SHOP_JSON = json.encode(SHOP_CACHE)
end

function loadShopCache()
    SHOP_CACHE = {}
    SHOP_CACHE.CATEGORY = {}
    SHOP_CACHE.ORDEM = SHOP_DATA.ORDEM
    SHOP_CACHE.STYLES = SHOP_DATA.STYLES
    SHOP_CACHE.CATEGORYINFO = SHOP_DATA.CATEGORYINFO
    for category, list in pairs(SHOP_DATA.CATEGORY) do
        SHOP_CACHE.CATEGORY[category] = {}
        for id, itemData in ipairs(list) do
            SHOP_CACHE.CATEGORY[category][id] = {}
            SHOP_CACHE.CATEGORY[category][id].type = itemData.type

            if itemData.type == "outfit" then
                SHOP_CACHE.CATEGORY[category][id].lookType     = itemData.lookType
                SHOP_CACHE.CATEGORY[category][id].name         = itemData.name
                SHOP_CACHE.CATEGORY[category][id].animated     = itemData.animated or false
            elseif itemData.type == "item" then
                local itemType = ItemType(itemData.item.id)
                SHOP_CACHE.CATEGORY[category][id].item = {id = itemType:getClientId(), qtd = itemData.item.qtd, name = itemType:getName()}
            elseif itemData.type == "pokemon" then
                local mType = MonsterType(itemData.pokeName)
                if mType then
                    SHOP_CACHE.CATEGORY[category][id].lookType = {type =  mType and mType:outfit().lookType or 0}
                    SHOP_CACHE.CATEGORY[category][id].bonus = {boost = itemData.bonus.boost}
                    SHOP_CACHE.CATEGORY[category][id].pokeName = itemData.pokeName
                    SHOP_CACHE.CATEGORY[category][id].rank = mType:pokemonRank()
                else
                    print("[ERROR - SHOP]" .. itemData.pokeName .. " Invalid MonsterType")
                end

            elseif itemData.type == "clube" then
                SHOP_CACHE.CATEGORY[category][id].beneficios = itemData.beneficios
                SHOP_CACHE.CATEGORY[category][id].info = itemData.info
            end
            if itemData.type ~= "clube" then
                SHOP_CACHE.CATEGORY[category][id].valor = itemData.valor
                SHOP_CACHE.CATEGORY[category][id].offset = itemData.offset
                SHOP_CACHE.CATEGORY[category][id].size = itemData.size
                SHOP_CACHE.CATEGORY[category][id].backgroundImage = itemData.backgroundImage  
                SHOP_CACHE.CATEGORY[category][id].moeda = ItemType(itemData.moeda):getClientId()
            end
        end
    end
end

function loadShop()
    if not isShopLoaded then
        local time = os.mtime()
        loadShopCache()
        loadShopJSONCache()
        isShopLoaded = true
        print("Loaded Shop in: " .. (os.mtime() - time)/1000 .. " seconds")
    end
end

function Player:sendShopData()
    loadShop()
    if self:sendExtendedOpcode(OPCODE_NEW_SHOP, SHOP_JSON) then
        return true
    end
    return false
end