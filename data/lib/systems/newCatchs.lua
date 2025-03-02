LIST_CATCHES_SPAWN = {
	["Xerneas"] =   {timer = 10000, quantidade = 320, spawn = "Xerneas Thundervine", index = 1},
	["Mewtwo"] =    {timer = 10000, quantidade = 320, spawn = "Mewtwo Psyfire Y", index = 2},
	["Deoxys"] =    {timer = 10000, quantidade = 320, spawn = "Shadowoxys", index = 3},
	["Darkrai"] =   {timer = 10000, quantidade = 320, spawn = "Shadowoxys", index = 3},
	["Entei"] =   {timer = 10000, quantidade = 80, spawn = "Entei Galante", index = 4},
	["Arcanine Nv2"] =   {timer = 10000, quantidade = 80, spawn = "Black Arcanine", index = 5},
	["Arcanine Nv3"] =   {timer = 10000, quantidade = 80, spawn = "Black Arcanine", index = 5},
	["Regigigas"] =   {timer = 10000, quantidade = 50, spawn = "Giant Regigigas", index = 6},
	["Lugia"] =   {timer = 10000, quantidade = 50, spawn = "Giant Lugia", index = 7},
	["Celesteela"] =   {timer = 10000, quantidade = 50, spawn = "Giant Celesteela", index = 8},
  }
CONST_EFFECT_SPAWN = 2303
CONST_STORAGE_SPAWN = 764000
OPCODE_CATCH = 77

MASTERBALL_BLOCKED = {
    "Lugia Ascensao Divina","Mewtwo Water", "Rayquaza Ascensao Divina", "Xerneas Ascensao Divina", "Zeraora Ascensao Divina"
}

LOWER_MASTERBALL_BLOCKED = {
    "lugia ascensao divina","mewtwo water", "rayquaza ascensao divina", "xerneas ascensao divina", "zeraora ascensao divina"
}

PALWORLD_MONSTERS = {"Grizzbolt And Rayne", "Alfa Grizzbolt", "Grizzbolt", "Depresso", "Jetragon"}
LOWER_PALWORLD_MONSTERS = {"grizzbolt and rayne", "alfa grizzbolt", "grizzbolt", "depresso", "jetragon"}
FAST_PALWORLD_MONSTERS = {
	["Grizzbolt And Rayne"] = 0,
	["Alfa Grizzbolt"] = 0,
	["Grizzbolt"] = 0,
	["Depresso"] = 0,
	["Jetragon"] = 0,
}
ALLOWED_POKEBALLS_PALWORLD = {22927, 22928, 22929, 22930, 22931, 22932}

FAST_YUGI_MONSTERS = {
    ["Exodia"] = 0,
    ["Dragao Branco Dos Olhos Azuis"] = 0,
    ["Mago Do Tempo"] = 0,
}

FAST_JUJUTSU_MONSTERS = {
    ["Nue"] = 0,
}

FAST_BOKU_MONSTERS = {
    ["Zygarde All Might Mode"] = 0,
}

FAST_FUSION_MONSTERS = {
    ["Xerneas Thundervine"] = 0,
    ["Mewtwo Psyfire Y"] = 0,
    ["Shadowoxys"] = 0,
    ["Entei Galante"] = 0,
    ["Black Arcanine"] = 0,
    ["Giant Regigigas"] = 0,
    ["Giant Lugia"] = 0,
    ["Giant Celesteela"] =0,
}

FAST_HALLOWEEN_MONSTERS = {
    ["Halloween Venusaur"] = 0,
    ["Halloween Guzzlord"] = 0,
    ["Halloween Xurkitree"] = 0,
    ["Halloween Jirachi"] = 0,
    ["Halloween Meloetta"] = 0,
    ["Halloween Exeggutor"] = 0,
    ["Esquelect Regigigas"] = 0,
    ["Halloween Regigigas"] = 0,
}

BALLS_CATCH_ID = {
    [26662] = "poke",
    -- [2391] = "great",
    -- [2393] = "super",
    -- [2392] = "ultra",
    -- [12617] = "saffari",
    -- [13228] = "master",
    -- [16743] = "moon",
    -- [16744] = "tinker",
    -- [16745] = "sora",
    -- [16746] = "dusk",
    -- [16747] = "yume",
    -- [16748] = "tale",
    -- [16749] = "net",
    -- [16750] = "janguru",
    -- [16751] = "magu",
    -- [16752] = "fast",
    -- [16753] = "heavy",
    -- [16754] = "premier",
    -- [16755] = "delta",
    -- [22919] = "especial",
    -- [22927] = "esferadepal",
    -- [22932] = "esferamega",
    -- [22928] = "esferagiga",
    -- [22929] = "esferatera",
    -- [22931] = "esferaultra",
    -- [22930] = "esferalendaria",
}

INFOS_CATCH = {
    ["tangela"] = { pontos = 10000, id = 1 },
  
}

TYPES_POINTS = {
    ["water"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16749] = 10, -- net
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["ghost"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16743] = 10, -- moon
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["dark"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16743] = 10, -- moon
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["steel"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16744] = 10, -- tinker
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["electric"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16744] = 10, -- tinker
        -- [16753] = 5, -- heavy
        -- [16752] = 5, -- fast
        -- [16754] = 0, -- premier
        -- [22919] = 15, -- especial
        -- [16755] = 0, -- delta
    },
    ["ice"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16745] = 10, -- sora
        -- [16753] = 5, -- heavy
        -- [16752] = 5, -- fast
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["flying"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16745] = 10, -- sora
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["rock"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16746] = 10, -- dusk
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["fighting"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16746] = 10, -- dusk
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["normal"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16747] = 10, -- yume
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["psychic"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16747] = 10, -- yume
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["dragon"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16748] = 10, -- tale
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["fairy"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16748] = 10, -- tale
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["bug"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16749] = 10, -- net
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["poison"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16750] = 10, -- janguru
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["grass"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16750] = 10, -- janguru
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["fire"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16751] = 10, -- magu
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["ground"] = {
        [26662] = 1, -- poke
        -- [2391] = 2, -- great
        -- [2393] = 3, -- super
        -- [2392] = 4, -- ultra
        -- [12617] = 1, -- saffari
        -- [16751] = 10, -- magu
        -- [16752] = 5, -- fast
        -- [16753] = 5, -- heavy
        -- [16754] = 0, -- premier
        -- [16755] = 0, -- delta
        -- [22919] = 15, -- especial
    },
    ["palworld"] = {
        [26662] = 1, -- pal
        -- [22932] = 2, -- mega
        -- [22928] = 3, -- giga
        -- [22929] = 4, -- tera
        -- [22931] = 5, -- ultra
        -- [22930] = 10, -- lendaria
    },
	["none"] = {}
}

function Player:sendBrokesToPlayer()
    local data = {}
    for pokeName, info in pairs(INFOS_CATCH) do
        pokeName = capitalizeFirstLetter(pokeName)
        local monsterType = MonsterType(pokeName)
        local lookType = 0
        local type = "none"
        local type2 = "none"
        if monsterType then
            lookType = monsterType:getOutfit().lookType
            if isInArray(LOWER_PALWORLD_MONSTERS, string.lower(pokeName)) then
                type = "palworld"
                type2 = "palworld"
            else
                type = monsterType:getRaceName()
                type2 = monsterType:getRace2Name()
            end
        end
        local newData = {type = type, type2 = type2, pokeName = pokeName, pontosTotais = info.pontos, pontos = self:getCatchPoints(pokeName), id = info.id, brokes = self:getBrokes(pokeName), lookType = lookType}
        data[info.id] = newData
    end

    self:sendCatchBuffer("startModule", data)
end

function Player:sendCatchBuffer(type, data)

    local infos = {
        data = data,
        type = type
    }

    if not self:sendExtendedOpcode(OPCODE_CATCH, json.encode(infos)) then 
        return false
    end
    return true
end

function Player:updatePokemonCatchInfo(pokemon, pokeball, pontos)
    if not self:sendCatchBuffer("updateData", {pokemonName = pokemon, pokeball = pokeball, pontos = pontos}) then
        return false
    end
    return true
end

function Player:resetPokemonCatchInfo(pokeName)
    if not self:sendCatchBuffer("resetData", {pokemonName = pokeName, brokes = self:getBrokes(pokeName), pontos = self:getCatchPoints(pokeName)}) then
        return false
    end
    return true
end

function Player:addCatchTry(pokeName, pokeball, points)
	if not INFOS_CATCH[string.lower(pokeName)] then return end

	if self:isVipPlus() then
		points = math.floor(points * 1.35)
	end

    self:addBrokes(pokeName, pokeball)
    self:addCatchPoints(pokeName, points)
    self:updatePokemonCatchInfo(pokeName, pokeball, points)
    self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Você ganhou %d pontos, total: %d", points, self:getCatchPoints(pokeName)))
end

function Player:resetCatchTry(pokeName)
    self:resetCatchPoints(pokeName)
    self:resetBrokes(pokeName)
    self:resetPokemonCatchInfo(pokeName)
end