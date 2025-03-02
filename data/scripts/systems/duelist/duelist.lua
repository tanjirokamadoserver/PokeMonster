DUELISTS_VOICES = {
    startDuelVoices = {
        "Você está condenado!",
        "Prepare-se para a batalha!",
        "Este será o seu fim!",
        "Você não tem chance contra mim!",
        "Vamos ver do que você é capaz!",
        "Seu destino está selado!",
        "Vou esmagar você!",
        "Nenhum de nós sairá ileso!",
        "Sua derrota é certa!",
        "Enfrente o seu pior pesadelo!"
    },
    deathDuelVoices = {
        "Você me venceu, mas não a guerra!",
        "Isso não acabou... eu voltarei!",
        "Hoje você venceu, mas eu me vingarei!",
        "A vitória é sua, por enquanto!",
        "Este é apenas um revés temporário!",
        "Você pode ter ganho a batalha, mas não a guerra!",
        "Minha derrota não será em vão!",
        "Lembre-se, um dia eu retornarei mais forte!",
        "Você teve sorte desta vez!",
        "Minha queda será sua ruína!"
    },
    fleeingVoices = {
        "Você ainda não me venceu!",
        "Preciso recuar, mas não acabou!",
        "Vou me reagrupando, espere por mim!",
        "Isso não está indo bem, preciso sair daqui!",
        "Retirada estratégica!",
        "Você teve sorte, mas eu voltarei!",
        "Vou me preparar melhor para nossa próxima batalha!",
        "Isso não é o fim, apenas um recuo temporário!",
        "Eu voltarei mais forte!",
        "Não pense que isso acabou!"
    },
}

DUELIST_SPAWNS_PLACES = {
    {
        positions = {
            Position(2550, 2285, 7),
            Position(2617, 2280, 7),
            Position(2615, 2312, 7)
        },
        mapDescription = "%s Foi visto pela ultima vez ao norte de cerulean."
    },
    {
        positions = {
            Position(2704, 2516, 7),
            Position(2719, 2536, 7),
            Position(2731, 2500, 7)
        },
        mapDescription = "%s Foi visto pela ultima vez a oeste de saffron."
    },
}

DUELISTS_POKEMONS_TYPE = {
    ["comum"] = {
        "Charizard",
        "Blastoise",
        "Sceptile",
        "Alakazam",
        "Pikachu",
        "Gengar",
        "Machamp",
        "Arcanine",
        "Gyarados",
        "Venusaur",
    },
    ["incomum"] = {
        "Dragonite",
        "Tyranitar",
        "Garchomp",
        "Metagross",
        "Salamence",
        "Scizor",
        "Electivire",
        "Magmortar",
    },
    ["raro"] = {
        "Lucario",
        "Gardevoir",
        "Blaziken",
        "Milotic",
        "Togekiss",
        "Gliscor",
        "Mamoswine",
        "Hydreigon",
    },
    ["mitico"] = {
        "Mew",
        "Celebi",
        "Jirachi",
        "Deoxys",
        "Manaphy",
        "Shaymin",
        "Victini",
        "Meloetta",
    },
    ["lendario"] = {
        "Mewtwo",
        "Lugia",
        "Ho-oh",
        "Rayquaza",
        "Groudon",
        "Kyogre",
        "Dialga",
        "Palkia",
        "Giratina",
        "Zekrom",
        "Reshiram",
        "Xerneas",
        "Yveltal",
    },
}

--[[
   {itemId = 2365, maxCount = 1,  chance = 10000,
         childLoot = {
            { itemId = 2152, maxCount = 4, chance = 10000 }
         }
   },
]]

DUELISTS_TYPE = {
    ["Sombrio"] = {
        outfit = { lookType = 2819 },
        health = 5000,
        type = "comum",
        pokesNumber = { 4, 6 },
        maxHealth = 5000,
        speed = 150,
        desc = "um duelista do mundo sombrio.",
        minTargetDist = 1,
        maxTargetDist = 3,
        pokemons = {},
        corpse = 3058,
        experience = 100000,
        startDuelVoices = DUELISTS_VOICES.startDuelVoices,
        deathDuelVoices = DUELISTS_VOICES.deathDuelVoices,
        fleeingVoices = DUELISTS_VOICES.fleeingVoices,
        loot = {
            { itemId = 18423, maxCount = 6, chance = 10000 },
        },
    },
    ["Benicio"] = {
        outfit = { lookType = 3120 },
        health = 5000,
        type = "incomum",
        pokesNumber = { 4, 6 },
        maxHealth = 5000,
        speed = 150,
        desc = "um duelista do mundo sombrio.",
        minTargetDist = 1,
        maxTargetDist = 3,
        pokemons = {},
        corpse = 3058,
        experience = 100000,
        startDuelVoices = DUELISTS_VOICES.startDuelVoices,
        deathDuelVoices = DUELISTS_VOICES.deathDuelVoices,
        fleeingVoices = DUELISTS_VOICES.fleeingVoices,
        loot = {
            { itemId = 18423, maxCount = 6, chance = 10000 },
        },
    },
    ["Baia"] = {
        outfit = { lookType = 3304 },
        health = 5000,
        type = "raro",
        pokesNumber = { 4, 6 },
        maxHealth = 5000,
        speed = 150,
        desc = "um duelista do mundo sombrio.",
        minTargetDist = 1,
        maxTargetDist = 3,
        pokemons = {},
        corpse = 3058,
        experience = 100000,
        startDuelVoices = DUELISTS_VOICES.startDuelVoices,
        deathDuelVoices = DUELISTS_VOICES.deathDuelVoices,
        fleeingVoices = DUELISTS_VOICES.fleeingVoices,
        loot = {
            { itemId = 18423, maxCount = 6, chance = 10000 },
        },
    },
    ["Guiboi"] = {
        outfit = { lookType = 3305 },
        health = 5000,
        type = "mitico",
        pokesNumber = { 4, 6 },
        maxHealth = 5000,
        speed = 150,
        desc = "um duelista do mundo sombrio.",
        minTargetDist = 1,
        maxTargetDist = 3,
        pokemons = {},
        corpse = 3058,
        experience = 100000,
        startDuelVoices = DUELISTS_VOICES.startDuelVoices,
        deathDuelVoices = DUELISTS_VOICES.deathDuelVoices,
        fleeingVoices = DUELISTS_VOICES.fleeingVoices,
        loot = {
            { itemId = 18423, maxCount = 6, chance = 10000 },
        },
    },
    ["Capivara"] = {
        outfit = { lookType = 3306 },
        health = 5000,
        type = "lendario",
        pokesNumber = { 4, 6 },
        maxHealth = 5000,
        speed = 150,
        desc = "um duelista do mundo sombrio.",
        minTargetDist = 1,
        maxTargetDist = 3,
        pokemons = {},
        corpse = 3058,
        experience = 100000,
        startDuelVoices = DUELISTS_VOICES.startDuelVoices,
        deathDuelVoices = DUELISTS_VOICES.deathDuelVoices,
        fleeingVoices = DUELISTS_VOICES.fleeingVoices,
        loot = {
            { itemId = 18423, maxCount = 6, chance = 10000 },
        },
    },
}

DUELISTS_NAMES = {}

function createDuelist(name, pos, contract)
    local duelist = Game.createDuelist(name, pos)
    if not duelist then
        return error("Failed to create duelist.")
    end

    local events = { "MonsterHealthChange", "onDeathDuelist" }

    for _, event in ipairs(events) do
        duelist:registerEvent(event)
    end
    if contract then
        duelist:setContract(contract)
    end
    return duelist
end

local eventLoot = CreatureEvent("onDeathDuelist")

function eventLoot.onDeath(duelist, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if not corpse then
        return true
    end

    local player = Player(corpse:getCorpseOwner())
    if not player then
        return true
    end
    local guid = player:getGuid()
    PLAYER_GUID_BH[guid][duelist:getContractId()].done = true
    -- PLAYER_GUID_BH_IDS[guid][duelist:getContractId()] = nil
    local loot = duelist:getLoot()
    local zoneId = duelist:getZoneId()
    local luckyBonus = false

    for i = 1, #loot do
        local item = corpse:createLootItem(loot[i], zoneId, player)
        if not item.bool then
            print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
        end

        if item.isFromLucky then
            luckyBonus = true
        end

        local msgEvent = ""
        if ACTIVE_ZONE_EVENT and ACTIVE_ZONE_TYPE == "loot" and ACTIVE_ZONE_EVENT_ID == zoneId then
            msgEvent = " [Bônus Zone " .. ACTIVE_ZONE_EVENT_RATE_LOOT .. "x]"
        end

        local luckMsg = "[ LUCKY BONUS ]"
        local text = ("Loot of %s: %s%s"):format(duelist:getName(), corpse:getContentDescription(), msgEvent)

        if luckyBonus then
            text = text .. " " .. luckMsg
        end

        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            player:sendTextMessage(MESSAGE_LOOT, text)
        end
    end

    local items = corpse:getItems()
    for _, item in pairs(items) do
        if player:getStorageValue(AUTOLOOT_ALL_ENABLED) ~= 1 then
            for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
                if player:getStorageValue(i) == item:getId() then
                    if not item:moveTo(player) then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                            "Você não tem capacidade, então o loot foi deixado no corpo.")
                        break
                    end
                end
            end
        else
            if not item:moveTo(player) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                    "Você não tem capacidade, então o loot foi deixado no corpo.")
                break
            end
        end
    end

    return true
end

eventLoot:register()

function Duelist.getLoot(self)
    return DUELISTS_TYPE[self:getName()].loot
end

function getDuelistDifficulty(name)
    return DUELISTS_TYPE[name].type
end

function getDuelistRandomPokemons(duelist, diff)
    local pokemons = {}
    local pokesNumber = math.random(DUELISTS_TYPE[duelist].pokesNumber[1], DUELISTS_TYPE[duelist].pokesNumber[2])
    local availablePokes = { unpack(DUELISTS_POKEMONS_TYPE[diff]) }

    for i = 1, pokesNumber do
        if #availablePokes == 0 then
            break
        end

        local index = math.random(1, #availablePokes)
        local poke = table.remove(availablePokes, index)
        table.insert(pokemons, poke)
    end

    return pokemons
end

function generateDuelistType(name)
    local data = DUELISTS_TYPE[name]
    data.name = name
    local pokemons = getDuelistRandomPokemons(name, data.type)
    data.pokemons = pokemons
    addDuelistType(
        name,
        data.outfit,
        data.health,
        data.maxHealth,
        data.speed,
        data.desc,
        data.minTargetDist,
        data.maxTargetDist,
        pokemons,
        data.corpse,
        data.experience,
        data.startDuelVoices,
        data.deathDuelVoices,
        data.fleeingVoices)
    return data
end

function generateDuelistFromCache(buffer)
    local data = DUELISTS_TYPE[buffer.name]
    addDuelistType(
        buffer.name,
        data.outfit,
        data.health,
        data.maxHealth,
        data.speed,
        data.desc,
        data.minTargetDist,
        data.maxTargetDist,
        buffer.pokemons,
        data.corpse,
        data.experience,
        data.startDuelVoices,
        data.deathDuelVoices,
        data.fleeingVoices)
end

function loadDuelists()
    DUELISTS_NAMES = {}
    for name, data in pairs(DUELISTS_TYPE) do
        data.pokemons = getDuelistRandomPokemons(name, data.type)
        addDuelistType(
            name,
            data.outfit,
            data.health,
            data.maxHealth,
            data.speed,
            data.desc,
            data.minTargetDist,
            data.maxTargetDist,
            data.pokemons,
            data.corpse,
            data.experience,
            data.startDuelVoices,
            data.deathDuelVoices,
            data.fleeingVoices)
        table.insert(DUELISTS_NAMES, name)
    end
end

loadDuelists()

local globalevent = GlobalEvent("loadDuelists")
function globalevent.onStartup()
    loadDuelists()
    db.query("DELETE FROM `player_storage` WHERE `key` = 67500000;")
    return true
end

globalevent:register()

PLAYER_GUID_BH = {}
PLAYER_GUID_BH_IDS = {}

MAX_CONTRACT_DAILY = 6
STORAGE_DUELISTS = 67500000
EXTENDED_OPCODE_CONTRACT = 97

function Player.canGetContracts(self)
    return self:getStorageValue(STORAGE_DUELISTS) < MAX_CONTRACT_DAILY
end

function Player.startNewContract(self, contractId)
    contractId = tonumber(contractId)

    if (not contractId) or (contractId ~= contractId) or (contractId > MAX_CONTRACT_DAILY) then return error("invalid contract number") end
    local duelistPlace = DUELIST_SPAWNS_PLACES[math.random(1, #DUELIST_SPAWNS_PLACES)]
    local name = DUELISTS_NAMES[math.random(1, #DUELISTS_NAMES)]

    local data = {
        guid = self:getGuid(),
        position = self:getPosition(),--duelistPlace.positions[math.random(1, #duelistPlace.positions)],
        name = name,
        desc = (duelistPlace.mapDescription):format(name),
    }

    local buffer = generateDuelistType(data.name)
    local totalContracts = math.max(1, self:getStorageValue(STORAGE_DUELISTS) + 1)

    if not PLAYER_GUID_BH[self:getGuid()] then
        PLAYER_GUID_BH[self:getGuid()] = {}
        PLAYER_GUID_BH_IDS[self:getGuid()] = {}
    end

    local duelist = createDuelist(data.name, data.position, data.guid)
    if not duelist then
        error("Failed to create duelist.")
    end
    duelist:setContractId(contractId)
    PLAYER_GUID_BH[self:getGuid()][contractId] = {name = name, position = data.position, rarity = DUELISTS_TYPE[name].type,
            pokemons = buffer.pokemons, desc = data.desc, outfit = {type = DUELISTS_TYPE[name].outfit.lookType}, active = true, done = false}
    PLAYER_GUID_BH_IDS[self:getGuid()][contractId] = duelist:getId()
    duelist:sendFirstTitle(self:getName(), "verdana-11px-rounded", "#A020F0")
    -- self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, data.desc)
    self:setStorageValue(STORAGE_DUELISTS, totalContracts)
    return true
end

function Player.handleContract(self, buffer)
    local data = json.decode(buffer)
    local action = data.action
    if action then
        if action == "cancel" then
            local contractToCancel = data.contract
            if contractToCancel then
                if (self:cancelContract(contractToCancel)) then
                    self:sendDataBH()
                end
                return
            end
        elseif action == "accept" then
            local contractToAccept = data.contract
            if contractToAccept then
                if (self:startContract(contractToAccept)) then
                    self:sendDataBH()
                end
                return
            end
        end
    end
end

function Player.startContract(self, id)
    id = tonumber(id)
    if not id or id ~= id or id > MAX_CONTRACT_DAILY then return false end

    local guid = self:getGuid()
    local buffer = PLAYER_GUID_BH[guid]

    if buffer and buffer[id] then
        if not PLAYER_GUID_BH_IDS[guid] then
            return error("Invalid contract.")
        end
        local buffer_type = PLAYER_GUID_BH_IDS[guid][id]
        if not buffer_type then
            generateDuelistFromCache(buffer[id])
            local duelist = createDuelist(buffer[id].name, buffer[id].position, guid)
            if duelist then
                PLAYER_GUID_BH_IDS[guid][id] = duelist:getId()
                PLAYER_GUID_BH[guid][id].active = true
                duelist:setContractId(id)
                duelist:sendFirstTitle(self:getName(), "verdana-11px-rounded", "#A020F0")
            else
                return error(string.format("Failed to create duelist %s, player: %s", buffer[id].name, self:getName()))
            end
        end
        return true
    end

    if not self:canGetContracts() then
        self:popupFYI("Você já pegou o máximo de contratos diários.")
        return false
    end
    self:startNewContract(id)
    return true
end

function Player.cancelContract(self, id)
    id = tonumber(id)
    if not id or id ~= id or id > MAX_CONTRACT_DAILY then return false end
    if not PLAYER_GUID_BH[self:getGuid()] or not PLAYER_GUID_BH_IDS[player:getGuid()] then
        player:popupFYI("Você não tem contratos ativos.")
        return false
    end
    if not PLAYER_GUID_BH_IDS[player:getGuid()][id] then
        player:popupFYI("Contrato não encontrado.")
        return false
    end
    local duelist = Duelist(PLAYER_GUID_BH_IDS[player:getGuid()][id])
    if duelist then
        duelist:remove()
        PLAYER_GUID_BH_IDS[self:getGuid()][id] = nil
        PLAYER_GUID_BH[self:getGuid()][id].active = false
        return true
    else
        player:popupFYI("Contrato não encontrado.")
    end
end

function Player.getActiveContracts(self)
    if not PLAYER_GUID_BH[self:getGuid()] then
        return {}
    end
    local contracts = {}
    for id, data in pairs(PLAYER_GUID_BH[self:getGuid()]) do
        local newId = conversor_id[id]
        contracts[newId] = data
    end
    return contracts
end

function Player.sendDataBH(self)
    local buffer = {
        type = "open",
        openContracts = self:getActiveContracts(),
        remainingContracts = MAX_CONTRACT_DAILY - math.max(0, self:getStorageValue(STORAGE_DUELISTS))
    }
    self:sendExtendedOpcode(EXTENDED_OPCODE_CONTRACT, json.encode(buffer))
end

local LoginEvent = CreatureEvent("loginDuelist")
function LoginEvent.onLogin(player)
    local guid = player:getGuid()
    local allCachedBH = PLAYER_GUID_BH[guid]
    if not allCachedBH then return true end
    if not PLAYER_GUID_BH_IDS[guid] then
        PLAYER_GUID_BH_IDS[guid] = {}
    end
    for contractId, data in pairs(allCachedBH) do
        if data.active and not data.done then
            generateDuelistFromCache(data)
            local duelist = createDuelist(data.name, data.position, guid)
            if duelist then
                PLAYER_GUID_BH_IDS[guid][contractId] = duelist:getId()
                duelist:setContractId(contractId)
                duelist:sendFirstTitle(player:getName(), "verdana-11px-rounded", "#A020F0")
            end
        end
    end
    return true
end

local LogoutEvent = CreatureEvent("logoutDuelist")
function LogoutEvent.onLogout(player)
    local guid = player:getGuid()
    local allBHLive = PLAYER_GUID_BH_IDS[guid]
    if not allBHLive then return true end
    for _, duelistId in pairs(allBHLive) do
        local duelist = Duelist(duelistId)
        if duelist then
            duelist:remove()
        end
    end
    PLAYER_GUID_BH_IDS[guid] = nil
    return true
end

LoginEvent:type("login")
LoginEvent:register()
LogoutEvent:type("logout")
LogoutEvent:register()