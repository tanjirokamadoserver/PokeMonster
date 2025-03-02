function onStartup()
	math.randomseed(os.mtime())
	loadDexInfos()
	addEvent(loadShop, 100)
	-- loadHighscoreOnStartup()
	-- loadHighscorePvPOnStartup()

	-- createRandomHeavenBoss()

	db.query("TRUNCATE TABLE `players_online`")
	db.asyncQuery("DELETE FROM `players` WHERE `deletion` != 0 AND `deletion` < " .. os.time())
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. os.time())

	local resultId = db.storeQuery("SELECT * FROM `boss_ranking`")
	if resultId ~= false then
		repeat
			local playerName = result.getDataString(resultId, "player")
			local classificacao = result.getDataInt(resultId, "classificacao")
			bossRanking[playerName] = classificacao
		until not result.next(resultId)
		result.free(resultId)
	end
end
