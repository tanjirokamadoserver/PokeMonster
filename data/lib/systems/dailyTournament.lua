local config = {
    MIN_TOURNAMENT_HOUR = {hour = 21, min = 0, sec = 0},
    MAX_TOURNAMENT_HOUR = {hour = 21, min = 10, sec = 0},

    STORAGE_TORNEIO = 606300,
    STORAGE_TORNEIO_COIN = 606300 + 1,
    waitZone = {
        center = Position(2276, 2595, 6),
        radiusX = 10,
        radiusY = 10
    },
    tournamentZone = {
        center = Position(2230, 2595, 6),
        radiusX = 32,
        radiusY = 20
    },
    templePosition = Position(3089, 2904, 7)
}

function isTournamentRegistrationTime()
    local now = os.time()
    local minTime = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d"), hour=config.MIN_TOURNAMENT_HOUR.hour, min=config.MIN_TOURNAMENT_HOUR.min, sec=config.MIN_TOURNAMENT_HOUR.sec}
    local maxTime = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d"), hour=config.MAX_TOURNAMENT_HOUR.hour, min=config.MAX_TOURNAMENT_HOUR.min, sec=config.MAX_TOURNAMENT_HOUR.sec}

    if now >= minTime and now <= maxTime then
        return true
    else
        return false
    end
end

function Player:sendPlayerToWaitingZone()
    self:teleportTo(Position(2276, 2595, 6))
end

function timeUntilTournamentStart()
    local now = os.time()
    local minTime = os.time{year=os.date("%Y"), month=os.date("%m"), day=os.date("%d"), hour=config.MIN_TOURNAMENT_HOUR.hour, min=config.MIN_TOURNAMENT_HOUR.min, sec=config.MIN_TOURNAMENT_HOUR.sec}

    if now < minTime then
        local timeDifference = minTime - now
        local hours = math.floor(timeDifference / 3600)
        local minutes = math.floor((timeDifference % 3600) / 60)
        local seconds = timeDifference % 60
        return hours, minutes, seconds
    else
        return 0, 0, 0 -- Se já passou do horário de início do torneio, retorna 0 tempo restante
    end
end

function getCountWaitingZone()
    local spectators = Game.getSpectators(config.waitZone.center, false, true, config.waitZone.radiusX, config.waitZone.radiusX, config.waitZone.radiusY, config.waitZone.radiusY)
    return #spectators
end

function getCountTournament()
    local spectators = Game.getSpectators(config.tournamentZone.center, false, true, config.tournamentZone.radiusX, config.tournamentZone.radiusX, config.tournamentZone.radiusY, config.tournamentZone.radiusY)
    return #spectators
end

function Player:winTournament()
    local wins = math.max(0, self:getStorageValue(config.STORAGE_TORNEIO))
    local coins = math.max(0, self:getStorageValue(config.STORAGE_TORNEIO_COIN))
    self:setStorageValue(config.STORAGE_TORNEIO, wins + 1)
    self:setStorageValue(config.STORAGE_TORNEIO_COIN, coins + 5)
    self:teleportTo(config.templePosition)
    local newWins = math.max(0, self:getStorageValue(config.STORAGE_TORNEIO))
    Game.broadcastMessage(string.format("O jogador %s, ganhou o torneio diário. total de vitórias do jogador: %d", self:getName(), newWins))
end

function Player:teleportToTournament()
    local pos = config.tournamentZone.center
    pos.x = pos.x + math.random(-10, 10)
    pos.y = pos.y + math.random(-10, 10)

    local tile = Tile(pos)
    local isWalkable = tile and tile:isWalkable()

    if not isWalkable then
        repeat
            pos.x = pos.x + math.random(-10, 10)
            pos.y = pos.y + math.random(-10, 10)
            tile = Tile(pos)
            if tile then
                isWalkable = tile:isWalkable()
            end
        until isWalkable
    end

    self:teleportTo(pos)
    return true
end

function removeAllFromTournamentArea()
    local spectators = Game.getSpectators(config.tournamentZone.center, false, true, config.tournamentZone.radiusX, config.tournamentZone.radiusX, config.tournamentZone.radiusY, config.tournamentZone.radiusY)
    for _, player in ipairs(spectators) do
        player:teleportTo(config.templePosition)
    end
end