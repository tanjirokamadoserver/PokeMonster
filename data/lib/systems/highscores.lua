POSITIONS_HIGHSCORES_DUMMIES = {
    [1] = Position(3085, 2925, 7),
    [2] = Position(3084, 2925, 7),
    [3] = Position(3086, 2925, 7)
}

POSITIONS_HIGHSCORES_DUMMIES_ = {
    [1] = Position(3089, 2925, 7),
    [2] = Position(3088, 2925, 7),
    [3] = Position(3090, 2925, 7)
}

CACHE_TOP_RESET = {}
CACHE_NPC_ID = {}

CACHE_NPC_ID_2 = {}
CACHE_TOP_TORNEIO = {}

function loadHighscoreOnStartup()
    local id = 0
    local query = "SELECT player_id, SUM(total_resets) AS total_resets FROM (SELECT player_id, SUM(CASE WHEN `key` = 102231 THEN `value` ELSE 0 END) AS resets, SUM(CASE WHEN `key` = 102331 THEN `value` ELSE 0 END) AS mega_resets, SUM(CASE WHEN `key` = 102231 THEN `value` ELSE 0 END) + (SUM(CASE WHEN `key` = 102331 THEN `value` ELSE 0 END) * 100) AS total_resets FROM player_storage WHERE `key` IN (102231, 102331) GROUP BY player_id) AS subquery GROUP BY player_id ORDER BY total_resets DESC LIMIT 3;"
    local resultId = db.storeQuery(query)
    if(resultId ~= false) then
        while(true) do 
            id = id + 1
            local pid = result.getDataInt(resultId, "player_id")
            local resets = result.getDataInt(resultId, "total_resets")
            CACHE_TOP_RESET[id] = {id = pid, resets = resets}
            if not(result.next(resultId)) then
				break
			end
        end
    end
    result.free(resultId)
    createNpcsFromCache()
end

function loadHighscorePvPOnStartup()
    local id = 0
    local query = "SELECT player_id, SUM(CASE WHEN `key` = 606300 THEN `value` ELSE 0 END) AS total_wins FROM player_storage WHERE `key` = 606300 GROUP BY player_id ORDER BY total_wins DESC LIMIT 3;"
    local resultId = db.storeQuery(query)
    if(resultId ~= false) then
        while(true) do 
            id = id + 1
            local pid = result.getDataInt(resultId, "player_id")
            local wins = result.getDataInt(resultId, "total_wins")
            CACHE_TOP_TORNEIO[id] = {id = pid, wins = wins}
            if not(result.next(resultId)) then
                break
            end
        end
    end
    result.free(resultId)
    createNpcsFromCachePvP()
end


function createNpcsFromCache()
    for _, npcId in ipairs(CACHE_NPC_ID) do
        local dummy = Creature(npcId)
        if dummy then
            dummy:remove()
        end
    end

	CACHE_NPC_ID = {}
    for index, data in ipairs(CACHE_TOP_RESET) do
        if data then
            local player_id = data.id
            local player_resets = data.resets 
            local player_name = getPlayerNameByGUID(player_id)
            local player_outfit = getPlayerOutfitByGUID(player_id)
            local npc = Game.createNpc("rank", POSITIONS_HIGHSCORES_DUMMIES[index], false, true)
            if npc then
                table.insert(CACHE_NPC_ID, npc:getId())
                npc:setNickname("[" .. index  .. "] " .. player_name)
                npc:sendFirstTitle("Resets: " .. player_resets, "verdana-11px-rounded", "#A020F0")
                npc:setSpeechBubble(0)
                doSetCreatureOutfit(npc, player_outfit, -1)
            end
        end
    end
end

function createNpcsFromCachePvP()
    for _, npcId in ipairs(CACHE_NPC_ID_2) do
        local dummy = Creature(npcId)
        if dummy then
            dummy:remove()
        end
    end

	CACHE_NPC_ID_2 = {}
    for index, data in ipairs(CACHE_TOP_TORNEIO) do
        if data then
            local player_id = data.id
            local player_wins = data.wins 
            local player_name = getPlayerNameByGUID(player_id)
            local player_outfit = getPlayerOutfitByGUID(player_id)
            local npc = Game.createNpc("rank", POSITIONS_HIGHSCORES_DUMMIES_[index], false, true)
            if npc then
                table.insert(CACHE_NPC_ID_2, npc:getId())
                npc:setNickname("[" .. index  .. "] " .. player_name)
                npc:sendFirstTitle("Wins: " .. player_wins, "verdana-11px-rounded", "#A020F0")
                npc:setSpeechBubble(0)
                doSetCreatureOutfit(npc, player_outfit, -1)
            end
        end
    end
end

