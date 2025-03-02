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

function onTime(interval)
    local waitZoneCount = getCountWaitingZone()
    removeAllFromTournamentArea()
    if waitZoneCount < 4 then
        Game.broadcastMessage("O Torneio não iniciou devido a falta de players.")
        local spectators = Game.getSpectators(config.waitZone.center, false, true, config.waitZone.radiusX, config.waitZone.radiusX, config.waitZone.radiusY, config.waitZone.radiusY)
        for _, player in ipairs(spectators) do
            player:teleportTo(Position(3089, 2904, 7))
        end
        return true
    end
    Game.broadcastMessage("O Torneio iniciou! boa sorte!")
    local spectators = Game.getSpectators(config.waitZone.center, false, true, config.waitZone.radiusX, config.waitZone.radiusX, config.waitZone.radiusY, config.waitZone.radiusY)
    for _, player in ipairs(spectators) do
        player:teleportToTournament()
    end
    return true
end
