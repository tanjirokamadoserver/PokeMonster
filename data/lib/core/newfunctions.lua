

cardsInfo = {
	["Arceus"] = 10,
	["Articuno"] = 3,
	["Dialga"] = 7,
	["Moltres"] = 3,
	["Zapdos"] = 3,
	["Zygarde"] = 10,
	["Regirock"] = 3,
	["Registeel"] = 3,
	["Regice"] = 3,
	["Kyogre"] = 3,
	["Groudon"] = 3,
	["Rayquaza"] = 5,
	["Palkia"] = 5,
	["Yveltal"] = 10,
	["Ho-oh"] = 5,
	["Latias"] = 5,
	["Latios"] = 5,
	["Celebi"] = 3,
	["Genesect"] = 5,
	["Terrakion"] = 12,
	["Deoxys"] = 5,
	["Virizion"] = 12,
	["Giratina"] = 5,
	["Heatran"] = 5,
	["Shaymin"] = 10,
	["Xerneas"] = 12,
	["Jirachi"] = 5,
	["Phione"] = 3,
	["Cresselia"] = 12,
	["Mini Hoopa"] = 3,
	["Lunala"] = 15,
	["Halloween"] = 30,
	["Rei do Trovao"] = 50,
	["Exodia"] = 60,
	["Supreme"] = 80,
}

orbCura = 10
maxBoost = 15000
summonMaxLevel = 100
shinyChance = 2
flyFloor = 460
moveWords = {"m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10", "m11", "m12"}
legendaryIndex = {144, 145, 146, 150, 151, 243, 244, 245, 249, 250, 251, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386}
arenaLastPlayerId = 0

damageMultiplierMoves = {areawaves = 2.75, singletargetweak = 2.0, singletarget = 3.5, singletargetstrong = 6.0, areatarget = 3.0, frontlinear = 3.0, frontarea = 2.0, passive = 2.0, softarea = 4.0, ultimate = 6.0}
summonLevelDamageBuff = 0.02
playerLevelDamageBuff = 0.03 -- buff due to player's level
summonBoostDamageBuff = 0.06 -- buff due to summon's boost
vitaminStatusBuff = 1.2
hunterDamageBuff = 1.1
blockerHealthBuff = 1.25
catcherCatchBuff = 1.1
explorerExperienceBuff = 1.15
healerHealBuff = 2.0

storageDelay = 1000
storageDelayBag = 1001
baseStorageTries = 61000
baseStorageCatches = 64000
baseStorageDex = 67000
baseStorageMove = 45000

storageRide = 5000
storageFly = 5001
storageSurf = 5002
storageEvolving = 5003
storageTutorial = 5004
storageDelayTeleport = 5005
storageBike = 5006
storageDelayDesbugar = 5007
storageDive = 5008
storageAutoLoot = 5009
storageBagEvent = 5010
storageArenaEvent = 5011
storageSoccerEvent = 5012
storageEvent = 5013
storageTokens = 5014
storageLastLegendaryKilled = 5015
storageDuelNpc = 5016
storageDuelNpcStatus = 5017
storageTeleportTc = 5018
storageEvolutionAncient = 5019
storageArenaPvpEvent = 5020
storageLogoutSpeed = 5021


slotItems = {1987, 2270, 2382, 7731, 2580}

waterIds = {493, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 7236, 10499, 15401, 15402, 4820, 4821, 4822, 4823, 4824, 4825, 4664, 4665, 4666}
-- 11826,11832,11835,11829,10975
balls = {
	pokeball = {emptyId = 26662, usedOn = 26677, usedOff = 26672, effectFail = 1521, effectSucceed = 1522, missile = 58, effectRelease = 1520, chanceMultiplier = 0.50}, --  0.25
	great = {emptyId = 26660, usedOn = 26663, usedOff = 26675, effectFail = 1524, effectSucceed = 1525, missile = 59, effectRelease = 190, chanceMultiplier = 1.0},
	super = {emptyId = 26659, usedOn = 26686, usedOff = 26674, effectFail = 1527, effectSucceed = 1527, missile = 60, effectRelease = 1526, chanceMultiplier = 2.0},
	ultra = {emptyId = 26688, usedOn = 26670, usedOff = 26681, effectFail = 200, effectSucceed = 201, missile = 61, effectRelease = 192, chanceMultiplier = 4.0},
	saffari = {emptyId = 12617, usedOn = 10975, usedOff = 10977, effectFail = 1530, effectSucceed = 1531, missile = 62, effectRelease = 1529, chanceMultiplier = 1000.0},
	master = {emptyId = 13228, usedOn = 13231, usedOff = 13229, effectFail = 1509, effectSucceed = 1510, missile = 57, effectRelease = 24, chanceMultiplier = 1000.0},
	moon = {emptyId = 32516, usedOn = 16704, usedOff = 16706, effectFail = 1536, effectSucceed = 1537, missile = 63, effectRelease = 1535, chanceMultiplier = 1.0},
	tinker = {emptyId = 32520, usedOn = 16707, usedOff = 16709, effectFail = 1539, effectSucceed = 1540, missile = 64, effectRelease = 1538, chanceMultiplier = 1.0},
	sora = {emptyId = 32510, usedOn = 16710, usedOff = 16712, effectFail = 1542, effectSucceed = 1543, missile = 65, effectRelease = 1541, chanceMultiplier = 1.0},
	dusk = {emptyId = 32512, usedOn = 16713, usedOff = 16715, effectFail = 1545, effectSucceed = 1546, missile = 66, effectRelease = 1544, chanceMultiplier = 1.0},
	yume = {emptyId = 32511, usedOn = 16716, usedOff = 16718, effectFail = 1548, effectSucceed = 1549, missile = 67, effectRelease = 1547, chanceMultiplier = 1.0},
	tale = {emptyId = 32515, usedOn = 16719, usedOff = 16721, effectFail = 1551, effectSucceed = 1552, missile = 68, effectRelease = 1550, chanceMultiplier = 1.0},
	net = {emptyId = 32517, usedOn = 16722, usedOff = 16724, effectFail = 1554, effectSucceed = 1555, missile = 69, effectRelease = 1553, chanceMultiplier = 1.0},
	janguru = {emptyId = 32518, usedOn = 16725, usedOff = 16727, effectFail = 1557, effectSucceed = 1558, missile = 70, effectRelease = 1556, chanceMultiplier = 1.0},
	magu = {emptyId = 32509, usedOn = 16728, usedOff = 16730, effectFail = 1512, effectSucceed = 1513, missile = 71, effectRelease = 1511, chanceMultiplier = 1.0},
	fast = {emptyId = 32513, usedOn = 16731, usedOff = 16733, effectFail = 1563, effectSucceed = 1564, missile = 72, effectRelease = 1562, chanceMultiplier = 1.0},
	heavy = {emptyId = 32514, usedOn = 16734, usedOff = 16736, effectFail = 1557, effectSucceed = 1558, missile = 73, effectRelease = 1556, chanceMultiplier = 1.0},
	premier = {emptyId = 32519, usedOn = 16737, usedOff = 16739, effectFail = 1569, effectSucceed = 1570, missile = 74, effectRelease = 1568, chanceMultiplier = 1.0},
	police = {emptyId = 32535, usedOn = 16740, usedOff = 16742, effectFail = 23, effectSucceed = 24, missile = 75, effectRelease = 1572, chanceMultiplier = 1.0},
	especial = {emptyId = 22919, usedOn = 22922, usedOff = 22921, effectFail = 2347, effectSucceed = 2345, missile = 83, effectRelease = 2346, chanceMultiplier = 1.0},
	-- gengar = {emptyId = 17121, usedOn = 17124, usedOff = 17121, effectFail = 23, effectSucceed = 24, missile = 47, effectRelease = 17121, chanceMultiplier = 5.0},
	-- abobora = {emptyId = 17125, usedOn = 17128, usedOff = 17125, effectFail = 23, effectSucceed = 24, missile = 47, effectRelease = 17125, chanceMultiplier = 5.0},
	-- natalina = {emptyId = 17483, usedOn = 17486, usedOff = 17483, effectFail = 23, effectSucceed = 24, missile = 47, effectRelease = 17483, chanceMultiplier = 5.0},
	esferadepal = {emptyId = 22927, usedOn = 22942, usedOff = 22948, effectFail = 2354, effectSucceed = 2348, missile = 84, effectRelease = 2366, chanceMultiplier = 5.0},
	esferamega = {emptyId = 22932, usedOn = 22947, usedOff = 22953, effectFail = 2357, effectSucceed = 2351, missile = 88, effectRelease = 2369, chanceMultiplier = 5.0},
	esferagiga = {emptyId = 22928, usedOn = 22943, usedOff = 22949, effectFail = 2355, effectSucceed = 2349, missile = 85, effectRelease = 2367, chanceMultiplier = 5.0},
	esferatera = {emptyId = 22929, usedOn = 22944, usedOff = 22950, effectFail = 2358, effectSucceed = 2352, missile = 89, effectRelease = 2370, chanceMultiplier = 5.0},
	esferaultra = {emptyId = 22931, usedOn = 22946, usedOff = 22952, effectFail = 2359, effectSucceed = 2353, missile = 86, effectRelease = 2368, chanceMultiplier = 5.0},
	esferalendaria = {emptyId = 22930, usedOn = 22945, usedOff = 22951, effectFail = 2359, effectSucceed = 2350, missile = 87, effectRelease = 2371, chanceMultiplier = 5.0},
	yugiohDisco = {emptyId = 0, usedOn = 23456, usedOff = 23455, effectFail = 0, effectSucceed = 0, missile = 79, effectRelease = 2328, chanceMultiplier = 0},
	divine = {emptyId = 24407, usedOn = 24407, usedOff = 24406, effectFail = 2375, effectSucceed = 2372, missile = 78, effectRelease = 2374, chanceMultiplier = 10.00},
}

function getBlessingsCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 120 then
		return 20000
	else
		return (level - 20) * 200
	end
end

function getPvpBlessingCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 270 then
		return 50000
	else
		return (level - 20) * 200
	end
end

function getTibianTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function getNeededExp(level) return (500000000 * (level * level * level - 6 * level * level + 17 * level - 12)) end

function statusGainFormula(summonLevel)
	return (1.0 * summonLevelDamageBuff)
end

function damageFormula(summonLevel)
	return statusGainFormula(summonLevel)
end

function defenseFormula(summonLevel) -- def calculo
	return (1.0 / 600.0 * statusGainFormula(summonLevel))
end

function getBallKey(uid)
	for key, value in pairs(balls) do
		if uid == value.emptyId or uid == value.usedOn or uid == value.usedOff then
			return key
		end
	end
	return "pokeball"
end

function Monster.getTotalHealth(self)

	local monsterType = MonsterType(self:getName())
	if not monsterType then return 0 end
	if self:isPokemon() then
		local total = math.floor(monsterType:maxHealth())

		local master = self:getMaster()
		local bonusTotal = 0
		local masterLevel = master:getLevel()

		local ball = master:getUsingBall()
		local boost = ball:getSpecialAttribute("pokeBoost") or 0
		local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
		local isHeldBoost = isHeld("boost", heldx)
		local isHeldVitality = isHeld("vitality", heldx)

		if isHeldBoost then
			local type = "boost"
			local tier = HELDS_X_INFO[heldx].tier
			local bonusHeld = HELDS_BONUS[type][tier]
			boost = boost + bonusHeld
		elseif isHeldVitality then
			local type = "vitality"
			local tier = HELDS_X_INFO[heldx].tier
			local bonusHeld = HELDS_BONUS[type][tier]
			bonusTotal = math.floor(total * bonusHeld)
		end

		local bonusBoost = total * ( boost * 0.015 )
		local levelBoost = total * ( masterLevel * 0.008 )

		total = total + bonusBoost + levelBoost

		total = total + bonusTotal
		self:setOldMaxHealth(total)
		local guild = master:getGuild()
		if guild then
			local pokemonHealthBuff = guild:hasBuff(COLUMN_6, POKEMON_HEALTH_BUFF)
			if pokemonHealthBuff then
				total = total + (total * GUILD_BUFF_POKEMON_HEALTH / 100)
			end
		end

		return math.floor(total)
	elseif self:isMonster() then
		return math.floor(monsterType:maxHealth())
	end
	return 0
end

function MonsterType.getTotalHealth(self, ball, master)
	local total = math.floor(self:maxHealth())
	local bonusTotal = 0

	local masterLevel = master:getLevel()
	local boost = ball:getSpecialAttribute("pokeBoost") or 0
	local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
	local isHeldBoost = isHeld("boost", heldx)
	local isHeldVitality = isHeld("vitality", heldx)

	if isHeldBoost then
		local type = "boost"
		local tier = HELDS_X_INFO[heldx].tier
		local bonusHeld = HELDS_BONUS[type][tier]
		boost = boost + bonusHeld
	elseif isHeldVitality then
		local type = "vitality"
		local tier = HELDS_X_INFO[heldx].tier
		local bonusHeld = HELDS_BONUS[type][tier]
		bonusTotal = math.floor(total * bonusHeld)
	end

	local bonusBoost = total * ( boost * 0.015 )
	local levelBoost = total * ( masterLevel * 0.008 )

	total = total + bonusBoost + levelBoost

	local guild = master:getGuild()
	if guild then
		local pokemonHealthBuff = guild:hasBuff(COLUMN_6, POKEMON_HEALTH_BUFF)
		if pokemonHealthBuff then
			total = total + (total * GUILD_BUFF_POKEMON_HEALTH / 100)
		end
	end

	return math.floor(total)
end

function Monster.getTotalMeleeAttack(self, cid)
	local monsterType = MonsterType(self:getName())
	if not monsterType then return 0 end
	if self:isPokemon() then
		local total = math.floor(monsterType:moveMagicAttackBase())
		local master = self:getMaster()
		local ball = master:getUsingBall()
		if not ball then return 0 end

		local star  = ball and ball:getSpecialAttribute("starFusion") or 0
		local maestria = ball and ball:getSpecialAttribute("maestria") or 0
		local cards = ball:getSpecialAttribute("pokeCard")

		if cards then total = total + (total * cardsInfo[cards] / 100) end
		if star >= 1 then total = total * (1 +(0.2*star)) end
		if maestria >= 2 then total = total * 1.1 end

		return total * bonus
	elseif self:isMonster() then
		return math.floor(monsterType:moveMagicAttackBase()) / 5
	end
	return 0
end

function Monster.getTotalMagicAttack(self)

	local monsterType = MonsterType(self:getName())
	if not monsterType then return 0 end
	if self:isPokemon() then
		local total = math.floor(monsterType:moveMagicAttackBase())
		local master = self:getMaster()
		if not master then return 0 end
		local ball = master:getUsingBall()
		if not ball then return 0 end
		local star = ball:getSpecialAttribute("starFusion") or 0
		local maestria = ball:getSpecialAttribute("maestria") or 0
		local cards = ball:getSpecialAttribute("pokeCard")

		if cards then total = total + (total * cardsInfo[cards] / 100) end
		if star >= 1 then total = total * (1 +(0.2*star)) end
		if maestria >= 2 then total = total * 1.1 end

		return total * bonus
	elseif self:isMonster() then
		return math.floor(monsterType:moveMagicAttackBase() * statusGainFormula(self:getLevel())) / 5
	end
	return 0
end

function Monster.getTotalDefense(self)

	local monsterType = MonsterType(self:getName())
	if not monsterType then return 0 end
	if self:isPokemon() then
		local total = math.floor(monsterType:moveMagicDefenseBase())

		local master = self:getMaster()
		local ball = master:getUsingBall()
		local bonusTotal = 0
		if ball then
			local heldType = "defense"
			local ident = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
			local isDefenseHeld = isHeld(heldType, ident)
			if isDefenseHeld then
				local tier = HELDS_X_INFO[ident].tier
				local bonusHeld = HELDS_BONUS[heldType][tier]
				bonusTotal = math.floor(total * bonusHeld / 100)
			end
		end

		total = total + bonusTotal

		local guild = master:getGuild()
		if guild then
			local pokemonHealthBuff = guild:hasBuff(COLUMN_1, DEFENSE_BUFF)
			if pokemonHealthBuff then
				total = total + (total * GUILD_BUFF_DEFENSE / 100)
			end
		end

		return total
	elseif self:isMonster() then
		return math.floor(monsterType:moveMagicDefenseBase())
	end
	return 0
end


function Duelist.getTotalDefense(self)
	return 50
end

function Monster.getTotalSpeed(self)
	local monsterType = MonsterType(self:getName())
	if not monsterType then return 0 end
	if self:isPokemon() then
		local total = math.floor(monsterType:getBaseSpeed())

		local master = self:getMaster()
		local ball = master:getUsingBall()
		local bonusTotal = 0
		if ball then
			local heldType = "haste"
			local ident = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
			local isHasteHeld = isHeld(heldType, ident)
			if isHasteHeld then
				local tier = HELDS_X_INFO[ident].tier
				local bonusHeld = HELDS_BONUS[heldType][tier]
				bonusTotal = math.floor(total * bonusHeld / 100)
			end
		end
		total = total + bonusTotal
		return total
	elseif self:isMonster() then
		return math.floor(monsterType:getBaseSpeed() * statusGainFormula(self:getLevel()))
	end
	return 0
end

function MonsterType.getTotalSpeed(self)
	return  self:getBaseSpeed()
end

function Item.getPokeName(self)
	return self:getSpecialAttribute("pokeName")
end
function Item.getPokeLevel(self)
	return self:getSpecialAttribute("pokeLevel")
end

function Creature.isPokemon(self)
	local master = self:getMaster()
	if master and master:isPlayer() then
		return true
	end
	return false
end

function MonsterType.getNumber(self)
	return self:dexEntry()

end

function hasSummons(cid)
	local summons = cid:getSummons()
	if #summons > 0 then
		return true
	end
	return false
end

function Player.checkExhaustion(self, storage, delay)
	if os.time() > self:getStorageValue(storage) then
		self:setStorageValue(storage, os.time() + delay)
	else
		self:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
	return false
end

function Player.checkMoveExhaustion(self, storage, delay)
	local item = self:getUsingBall()
	if item then
		local move = "cd" .. tostring(storage)
		local moveCooldown = item:getSpecialAttribute(move) or 0
		local orbCooldown = item:getSpecialAttribute("orbCooldown")
		if orbCooldown then
			delay = delay * 0.7
		end
		if os.time() > moveCooldown then
			item:setSpecialAttribute(move, os.time() + delay)
		else
			--self:sendTextMessage(MESSAGE_INFO_DESCR, "You must wait " .. math.floor(item:getSpecialAttribute(move) + 1 - os.time()) .. " seconds to use this move again")
			self:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
	return false
end

function Player.getSummonNameFromBall(self)
	local item = self:getUsingBall()
	if item then
		local pokeName = item:getSpecialAttribute("pokeName")
		if pokeName ~= nil then
			return pokeName
		end
	end
	return "unamed"
end

function Player.getSummonLevelFromBall(self)
	local item = self:getUsingBall()
	if item then
		local pokeLevel = item:getSpecialAttribute("pokeLevel")
		if pokeLevel ~= nil then
			return pokeLevel
		end
	end
	return 1
end

function Player.getSummonBoostFromBall(self)
	local item = self:getUsingBall()
	if item then
		local pokeBoost = item:getSpecialAttribute("pokeBoost")
		if pokeBoost ~= nil then
			return pokeBoost
		end
	end
	return 0
end

function MonsterType.getRaceName(self)
	local raceNumber = self:race()
	return CONSTANT_RACE_NAME[raceNumber]
end

function MonsterType.getRace2Name(self)
	local raceNumber = self:race2()
	return CONSTANT_RACE_NAME[raceNumber]
end

function Player.getSummon(self)
	if hasSummons(self) then
		return self:getSummons()[1]
	end
	return false
end

function Player.isOnRide(self)
	if self:getStorageValue(storageRide) > 0 then
		return true
	end
	return false
end

function Player.isOnFly(self)
	if self:getStorageValue(storageFly) > 0 then
		return true
	end
	return false
end

function Player.isOnSurf(self)
	if self:getStorageValue(storageSurf) > 0 then
		return true
	end
	return false
end

function Player.isOnBike(self)
	if self:getStorageValue(storageBike) == 1 then
		return true
	end
	return false
end

function Player.isOnEvent(self)
	if self:getStorageValue(storageEvent) == 1 then
		return true
	end
	return false
end

function Player.isOnDive(self)
	if self:getStorageValue(storageDive) == 1 then
		return true
	end
	return false
end

function Player.isAutoLooting(self)
	if self:getStorageValue(storageAutoLoot) == 1 then
		return true
	end
	return false
end

function Player.enableAutoLoot(self)
	if self:getStorageValue(storageAutoLoot) < 0 then
		self:setStorageValue(storageAutoLoot, 1)
		return true
	end
	return false
end

function Player.disableAutoLoot(self)
	if self:getStorageValue(storageAutoLoot) == 1 then
		self:setStorageValue(storageAutoLoot, -1)
		return true
	end
	return false
end

function Monster.getSummonLevel(self)
	if self:isPokemon() then
		local master = self:getMaster()
		local item = master:getUsingBall()
		if not item then return 1 end
		local pokeLevel = item:getSpecialAttribute("pokeLevel")
		if pokeLevel ~= nil then
			return pokeLevel
		end
	elseif isMonster(self) then
		return self:getLevel()
	end
	return 1
end

function Monster.getBoost(self)
	if self:isPokemon() then
		local master = self:getMaster()
		local ball = master:getUsingBall()
		if not ball then error("ball not found") end
		local summonBoost = ball:getSpecialAttribute("pokeBoost") or 0
		local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
		local isHeldBoost = isHeld("boost", heldx)
		if isHeldBoost then
			local tier = HELDS_X_INFO[heldx].tier
			local bonusHeld = HELDS_BONUS["boost"][tier]
			summonBoost = summonBoost + bonusHeld
		end
		return summonBoost
	end
	return 0
end

function Monster.getSummonName(self)
	if isSummon(self) then
		local master = self:getMaster()
		local item = master:getUsingBall()
		if not item then return "unamed" end
		local pokeName = item:getSpecialAttribute("pokeName")
		if pokeName ~= nil then
			return pokeName
		end
	end
	return "unamed"
end

function Monster.isEvolving(self)
	if self:isPokemon() then
		local master = self:getMaster()
		if master and master:getStorageValue(storageEvolving) == 1 then return true end
	end
	return false
end

function doChangeOutfit(cid, outfit, time)
	local creature = Creature(cid)
	if not creature then return false end
	if time == nil then time = -1 end
	doSetCreatureOutfit(creature, outfit, time)
	return true
end

function doSendDelayedEffect(pos, effect)
	local tile = Tile(pos)
	if tile then
		pos:sendMagicEffect(effect)
	end
	return true
end

function doReleaseSummon(cid, pos, effect, message, missile)
	local player = Player(cid)
	if not player then return false end

	local ball = player:getUsingBall()
	if not ball then return false end

	if effect == nil then effect = CONST_ME_TELEPORT end
	if message == nil then message = true end
	local name = ball:getSpecialAttribute("pokeName")

	local monsterType = MonsterType(name)

	local health = ball:getSpecialAttribute("pokeHealth") or 0
	if health <= 0 then
		player:sendCancelMessage("Sorry, not possible. Your summon is dead.")
		ball:setSpecialAttribute("isBeingUsed", 0)
		return true
	end

	local summonLevel = ball:getSpecialAttribute("pokeLevel") or 1
	local outfitId = ball:getSpecialAttribute("looktype") or 0
	if outfitId == 0 then
		ball:setSpecialAttribute("looktype", monsterType:outfit().lookType)
	end

	local summonBoost = ball:getSpecialAttribute("pokeBoost") or 0
	local heldx = ball:getAttribute(ITEM_ATTRIBUTE_HELDX)
	local isHeldBoost = isHeld("boost", heldx)
	if isHeldBoost then
		local tier = HELDS_X_INFO[heldx].tier
		local bonusHeld = HELDS_BONUS["boost"][tier]
		summonBoost = summonBoost + bonusHeld
	end

	local newPos = player:getClosestFreePosition(pos, 2) or pos
	if newPos.x == 0 then
		newPos = pos
	end
	local monster = Game.createMonster(name, newPos, true, true, summonLevel, summonBoost, player)

	if monster ~= nil then
		player:addSummon(monster)
		if message then
			player:say(monster:getName() .. ", I need your help!", TALKTYPE_MONSTER_SAY)
		end

		local particle = ball:getSpecialAttribute("shader")
		if particle then
			local shader = SHADERSLIST[particle]
			player:modifierPokemon(0, 0, SHADER_NAMES_TO_IDS[shader], -1)
		end

		local maxHealth = monster:getTotalHealth()
		monster:setMaxHealth(maxHealth)
		monster:setHealth(health)

		monster:cleanCustomIcons()
		monster:setRankIcon(false)

		local nickname = ball:getSpecialAttribute("nickname")
		if nickname then
			monster:setNickname(nickname .. " +"..summonBoost)
		end

		monster:changeSpeed(-monster:getSpeed() + monster:getTotalSpeed())

		local guild = player:getGuild()
		if guild then
			local hasPokemonSpeedBuff = guild:hasBuff(COLUMN_3, POKEMON_SPEED_BUFF)
			if hasPokemonSpeedBuff then
				monster:changeSpeed(GUILD_BUFF_POKEMON_SPEED)
			end
		end

		if effect then
			monster:getPosition():sendMagicEffect(effect)
		end

		if missile then
			doSendDistanceShoot(player:getPosition(), monster:getPosition(), missile)
		end

		monster:registerEvent("MonsterHealthChange")
		monster:registerEvent("MonsterDeath")

		local heldy = ball:getAttribute(ITEM_ATTRIBUTE_HELDY)
		local isHeldHeal = isHeld("heal", heldy)
		if isHeldHeal then
			local tier = HELDS_Y_INFO[heldy].tier
			local bonusHeld = HELDS_BONUS["heal"][tier]
			local function healPokemon(id, health)
				local pokemon = Monster(id)
				if pokemon and not pokemon:getMaster():hasCondition(CONDITION_INFIGHT) then
					pokemon:addHealth(health)
					pokemon:getPosition():sendMagicEffect(13)
				end
				addEvent(healPokemon, 1000, id, health)
			end
			healPokemon(monster:getId(), bonusHeld)
		end

		for _, cond in pairs(CONST_NEGATIVE_CONDITIONS) do
			local conditionTicks = ball:getCustomAttribute(CONST_CONVERT_CONDITIONS_TO_TEXT[cond])
			if conditionTicks then
				local condition = Condition(cond)
				condition:setTicks(conditionTicks)
				local eff = CONDITION_EFFECTS[cond]
				if eff then
					condition:setParameter(CONDITION_PARAM_EFFECT, eff)
					condition:setParameter(CONDITION_PARAM_EFFECT_TICKS, 1000)
				end
				monster:addCondition(condition)
			end
		end

		player:sendSummonMoves()
		doSendGobackInformations(player, monster, "release")
		doSendPokeTeamByClient(player:getId())
		player:sendShaderList()
		return monster
	end
	return false
end

function Player:sendSummonMoves()
	local summon = self:getSummon()
	if not summon then
		return false
	end
	local monsterType = MonsterType(summon:getName())
	if not monsterType then
		return false
	end
	local ball = self:getUsingBall()
	if not ball then
		return false
	end

	local movesTable = {}
	local moves = monsterType:getMoveList()
	for moveId, movesInfo in ipairs(moves) do
		local move = string.format("cd%d", moveId)
		local moveCooldown = ball:getSpecialAttribute(move) or 0
		if os.time() > moveCooldown then
			movesInfo.cooldownReal = 0
		else
			movesInfo.cooldownReal = 1000 * math.floor(moveCooldown - os.time())
		end
	end
	self:sendExtendedOpcode(52, json.encode(moves))
end

function Player:modifierPokemon(wing, aura, shader, tempo)
	if not aura then aura = 0 end
	if not wing then wing = 0 end
	if not shader then shader = 0 end

	local summons = self:getSummons()
	if #summons == 0 then
		return false
	end
	local summon = summons[1]

	if not summon then
		return false
	end

	local condition = Condition(CONDITION_OUTFIT)
	local ball = self:getUsingBall()
	if not ball then return false end
	local name = ball:getSpecialAttribute("pokeName")
	local monsterType = MonsterType(name)
	if not monsterType then return false end
	local outfitpoke = monsterType:getOutfit()
	if not outfitpoke then return false end
	condition:setOutfit(outfitpoke.lookTypeEx, outfitpoke.lookType, outfitpoke.lookHead, outfitpoke.lookBody, outfitpoke.lookLegs, outfitpoke.lookFeet, 0, 0, wing , aura, shader)
	if tempo == -1 then
		condition:setTicks(-1)
	else
		condition:setTicks(1000*tempo)
	end
	summon:addCondition(condition)
	return true
end

function doRemoveSummon(cid, effect, uid, message, missile)
	local player = Player(cid)
	if not player then return false end
	if effect == nil then effect = CONST_ME_POFF end
	if message == nil then message = true end
	local summons = player:getSummons()
	if not summons then return false end
	local summon = Creature(summons[1])
	if not summon then
		return false
	end
	local summonPos = summon:getPosition()
	local attackers = Game.getSpectators(summonPos, true, false)
	for i = 1, #attackers do
		local attacker = attackers[i]
		if attacker and attacker:isMonster() then
			local targetList = attacker:getTargetList()
			for j = 1, #targetList do
				if targetList[j] == summon then
					attacker:removeTarget(summon)
					attacker:setIdle()
				end
			end
		end
	end
	if effect then
		summonPos:sendMagicEffect(effect)
	end
	if missile then
		doSendDistanceShoot(summonPos, player:getPosition(), missile)
	end
	summon:unregisterEvent("MonsterGetExperience")
	summon:unregisterEvent("MonsterHealthChange")
	player:unregisterEvent("RemoveSummon")

	local ball = player:getUsingBall()
	if not ball then
		summon:remove()
		return false
	end

	if uid and not ball then
		ball = Item(uid)
		if not ball then summon:remove() return false end
	end

	for _, cond in pairs(CONST_NEGATIVE_CONDITIONS) do
		if summon:hasCondition(cond) then
			local condition = summon:getCondition(cond)
			local ticks = condition:getTicks()
			ball:setCustomAttribute(CONST_CONVERT_CONDITIONS_TO_TEXT[cond], ticks)
		else
			ball:removeCustomAttribute(CONST_CONVERT_CONDITIONS_TO_TEXT[cond])
		end
	end

	ball:setSpecialAttribute("pokeHealth", summon:getHealth())
	ball:setSpecialAttribute("pokeLookDir", summon:getDirection())

	if not (player:isOnFly() or player:isOnRide() or player:isOnSurf() or summon:isEvolving()) then
		if ball then
			ball:setSpecialAttribute("isBeingUsed", 0)
		else
			print("WARNING! Player " .. player:getName() .. " had problems on remove summon: ball does not exist.")
		end
	end
	if summon:isEvolving() then
		player:setStorageValue(storageEvolving, -1)
	end
	if message then
		player:say("Thanks, " .. summon:getName() .. "!", TALKTYPE_MONSTER_SAY)
	end

	doSendGobackInformations(player, summon, "remove")
	summon:remove()
	doSendPokeTeamByClient(player:getId())
	return true
end

function Position:sendAnimatedNumber(message_type, text, value, color)
	local message_type = message_type or MESSAGE_EXPERIENCE
	local color = color or TEXTCOLOR_BLUE
	local valid_message_types = {
		MESSAGE_DAMAGE_DEALT,
		MESSAGE_DAMAGE_OTHERS,
		MESSAGE_DAMAGE_RECEIVED,
		MESSAGE_EXPERIENCE,
		MESSAGE_EXPERIENCE_OTHERS,
		MESSAGE_HEALED,
		MESSAGE_HEALED_OTHERS,
	}
	assert(isInArray(valid_message_types, message_type), "invalid 'message_type', must output to server log")
	for _, v in ipairs(Game.getSpectators(self, false, true)) do
		if v:isPlayer() then
			v:sendTextMessage(message_type, text, self, value, color)
		end
	end
end

function Item.isPokeball(self)
	local attribute = self:getSpecialAttribute("pokeName")
	if attribute then
		return true
	end
	return false
end

local KEYS_SEARCH = {
	[26662] = balls.pokeball,
	[26660] = balls.great,
	[26659] = balls.super,
	[26688] = balls.ultra,
	[12617] = balls.saffari,
	[13228] = balls.master,
	[16743] = balls.moon,
	[16744] = balls.tinker,
	[16745] = balls.sora,
	[16746] = balls.dusk,
	[16747] = balls.yume,
	[16748] = balls.tale,
	[16749] = balls.net,
	[16750] = balls.janguru,
	[16751] = balls.magu,
	[16752] = balls.fast,
	[16753] = balls.heavy,
	[16754] = balls.premier,
	[16755] = balls.delta,
	[22919] = balls.especial,
	[17121] = balls.gengar,
	[17125] = balls.abobora,
	[17483] = balls.natalina,
	[22927] = balls.esferadepal,
	[22932] = balls.esferamega,
	[22928] = balls.esferagiga,
	[22929] = balls.esferatera,
	[22931] = balls.esferaultra,
	[22930] = balls.esferalendaria,
	[23456] = balls.yugiohDisco,
}

function Player:addPokemon(pokeName, ballId)
	local ballKey
	if not ballId then
		ballKey = balls.pokeball
	else
		ballKey = KEYS_SEARCH[ballId]
	end

	local monsterType = MonsterType(pokeName)
	if not monsterType then
		return error("Invalid Pokemon: " .. pokeName) and self:sendCancelMessage("Sorry, not possible. This problem was reported.")
	end
	local sendPokeballToDepot = false
	local pokeball

	local playerCapacity = self:getFreeCapacity()
	if playerCapacity == 0 then
		sendPokeballToDepot = true
	end

	if not sendPokeballToDepot then
		pokeball = self:addItem(ballKey.usedOn, 1, false)
	else
		local depot = self:getInbox()
		pokeball = depot:addItem(ballKey.usedOn, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
	end
	if not pokeball then return error(("Could not add pokeball %s to player %s."):format(pokeName, self:getName())) end
	local maxHealth = monsterType:getMaxHealth() * 10
	pokeball:setSpecialAttribute("pokeName", pokeName)
	pokeball:setSpecialAttribute("pokeBoost", 0)
	pokeball:setSpecialAttribute("pokeHealth", maxHealth)

	if not sendPokeballToDepot then
		doSendPokeTeamByClient(self)
	end
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

-- function Position:createFlyFloor()
-- 	local toTile = Tile(self)
-- 	if not toTile or not toTile:getItems() or not toTile:getGround() then
-- 		doAreaCombatHealth(0, 0, self, 0, 0, 0, CONST_ME_NONE)
-- 		Game.createItem(flyFloor, 1, self)
-- 	end
-- 	return true
-- end

function Tile:hasValidGround()
	local ground = self:getGround()
	local nilItem = self:getItemById(flyFloor)
	if ground and not nilItem then
		return true
	end
	return false
end

function Player:activateFly()
	self:setStorageValue(storageFly, 1)
	self:registerEvent("FlyEvent")
	return true
end

function Player:deactivateFly()
	local can, floor = self:canDeactivateFly()
	local pos = self:getPosition()
	if can then
		local curtile = Tile(pos)
		local nilItem = curtile:getItemById(flyFloor)
		if nilItem then
			nilItem:remove()
		end
		self:unregisterEvent("FlyEvent")
		if pos.z ~= floor then
			pos.z = floor
			self:teleportTo(pos)
			pos:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return can
end

function Player:canDeactivateFly()
	local pos = self:getPosition()
	--    for z = pos.z, 15 do
	local tmp = Tile(pos.x, pos.y, pos.z)
	if tmp and tmp:hasValidGround() then
		if self:canFlyDown(pos.z) then
			return true, pos.z
		else
			return false
		end
	end
	--    end

	return false
end

function Player:canFlyUp()
	local pos = self:getPosition()
	local tmp = Tile(pos.x, pos.y, pos.z-1)
	if tmp and tmp:hasValidGround() then
		return false
	end
	tmp = Tile(pos.x, pos.y, pos.z-1)

	if tmp and (tmp:getHouse() or tmp:hasFlag(TILESTATE_PROTECTIONZONE) or tmp:hasFlag(TILESTATE_FLOORCHANGE) or tmp:hasFlag(TILESTATE_BLOCKSOLID) ) then
		return false
	end

	if tmp and tmp:getGround() and isInArray(waterIds, tmp:getGround():getId()) then
		return false
	end
	return true
end

function Player:canFlyDown(floor)
	local pos = self:getPosition()
	local tmp = Tile(pos)
	if floor and floor == pos.z then
		return true
	end
	if tmp:hasValidGround() then
		return false
	end
	tmp = Tile(pos.x, pos.y, floor or pos.z+1)

	if tmp and (tmp:getHouse() or tmp:hasFlag(TILESTATE_PROTECTIONZONE) or tmp:hasFlag(TILESTATE_FLOORCHANGE) or tmp:hasFlag(TILESTATE_BLOCKSOLID) ) then
		return false
	end

	if tmp and tmp:getGround() and isInArray(waterIds, tmp:getGround():getId()) then
		return false
	end
	return true
end

function Player:flyUp()
	if self:isOnFly() then
		if self:canFlyUp() then
			local pos = self:getPosition()
			local tile = Tile(pos)
			local itemfloor = tile:getItemById(flyFloor)
			if itemfloor then
				itemfloor:remove()
			end
			pos.z = pos.z-1
			pos:createFlyFloor()
			self:teleportTo(pos)
			-- self:say(pos.x .. " " .. pos.y .. " " .. pos.z, TALKTYPE_SAY)
			-- pos:sendMagicEffect(CONST_ME_TELEPORT) 
			return true
		end
		return false
	else
		self:sendCancelMessage("You are not flying.")
		return false
	end
end

function Player:flyDown()
	if self:isOnFly() then
		if self:canFlyDown() then
			local pos = self:getPosition()
			local tile = Tile(pos)
			local itemfloor = tile:getItemById(flyFloor)
			if itemfloor then
				itemfloor:remove()
			end
			pos.z = pos.z+1
			pos:createFlyFloor()
			self:teleportTo(pos)
			-- pos:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		return false
	else
		self:sendCancelMessage("You are not flying.")
		return false
	end
end

function Player:addTokens(number)
	if self:getStorageValue(storageTokens) < 0 then
		self:setStorageValue(storageTokens, number)
	else
		self:setStorageValue(storageTokens, self:getStorageValue(storageTokens) + number)
	end
	return true
end

function Player:removeTokens(number)
	if self:getStorageValue(storageTokens) < number then
		return false
	else
		self:setStorageValue(storageTokens, self:getStorageValue(storageTokens) - number)
	end
	return true
end

function Player:getTokens()
	if self:getStorageValue(storageTokens) < 0 then
		return 0
	end
	return self:getStorageValue(storageTokens)
end

function Creature:hasKilledLegendaryPokemon()
	if self:isPlayer() and (os.time() < self:getStorageValue(storageLastLegendaryKilled)) then
		return true
	end
	return false
end

function Player:setKilledLegendaryPokemon()
	self:setStorageValue(storageLastLegendaryKilled, os.time() + 10 * 60)
	return true
end

function Player:isDuelingWithNpc()
	if self:getStorageValue(storageDuelNpc) > 0 then
		return true
	end
	return false
end

function Player:setDuelWithNpc()
	self:setStorageValue(storageDuelNpc, 1)
	self:setStorageValue(storageDuelNpcStatus, 1)
	return true
end

function Player:setOnLeague()
	self:setStorageValue(storageLeague, 1)
	self:setStorageValue(storageLeaguePotion, 0)
	self:setStorageValue(storageLeagueRevive, 0)
	self:setStorageValue(storageLeagueTime, os.time())
	return true
end

function Player:setOutLeague()
	self:setStorageValue(storageLeague, -1)
	return true
end

function Player:isOnLeague()
	if self:getStorageValue(storageLeague) == 1 then
		return true
	end
	return false
end

function Player:canUsePotionOnLeague()
	if self:getStorageValue(storageLeaguePotion) < 0 then self:setStorageValue(storageLeaguePotion, 0) end
	if self:getStorageValue(storageLeaguePotion) < 25 then
		self:setStorageValue(storageLeaguePotion, self:getStorageValue(storageLeaguePotion) + 1)
		self:sendTextMessage(MESSAGE_INFO_DESCR, "Usando potion " .. self:getStorageValue(storageLeaguePotion) .. " de 25.")
		return true
	end
	return false
end

function Player:canUseReviveOnLeague()
	if self:getStorageValue(storageLeagueRevive) < 0 then self:setStorageValue(storageLeagueRevive, 0) end
	if self:getStorageValue(storageLeagueRevive) < 5 then
		self:setStorageValue(storageLeagueRevive, self:getStorageValue(storageLeagueRevive) + 1)
		self:sendTextMessage(MESSAGE_INFO_DESCR, "Usando revive " .. self:getStorageValue(storageLeagueRevive) .. " de 5.")
		return true
	end
	return false
end

function Player:unsetDuelWithNpc()
	self:setStorageValue(storageDuelNpc, -1)
	return true
end

function Player:getDuelWithNpcStatus()
	if self:getStorageValue(storageDuelNpcStatus) < 1 then
		return 1
	end
	return self:getStorageValue(storageDuelNpcStatus)
end

function Player:increaseDuelWithNpcStatus()
	if self:getStorageValue(storageDuelNpcStatus) < 1 then
		self:setStorageValue(storageDuelNpcStatus, 1)
	else
		self:setStorageValue(storageDuelNpcStatus, self:getStorageValue(storageDuelNpcStatus) + 1)
	end
	return true
end

function Player:addSlotItems()
	for i = 1, #slotItems do
		local itemId = slotItems[i]
		if not self:getItemById(itemId) then
			local item = self:addItem(itemId)
		end
	end
end

function Position:getClosestTownId()
	local distances = {}

	for i = 1, 59 do
		local town = Town(i)
		if town then
			local templePosition = town:getTemplePosition()
			distances[i] = getDistanceBetween(templePosition, self)
		end
	end

	local key = next(distances)
	local min = distances[key]

	for k, v in pairs(distances) do
		if distances[k] < min then
			key, min = k, v
		end
	end

	return key
end

function Player:isSummonBlocked()

	if self:getStorageValue(storageRide) == 1 then
		self:sendCancelMessage("Sorry, not possible while on ride.")
		return true
	end

	if self:getStorageValue(storageFly) == 1 then
		self:sendCancelMessage("Sorry, not possible while on fly.")
		return true
	end

	if self:getStorageValue(storageSurf) > 0 then
		self:sendCancelMessage("Sorry, not possible while on surf.")
		return true
	end

	if self:getStorageValue(storageEvent) > 0 then
		self:sendCancelMessage("Sorry, not possible while on event.")
		return true
	end

	if self:getStorageValue(storageEvolving) == 1 then
		self:sendCancelMessage("Sorry, not possible while evolving.")
		return true
	end

	return false
end


function Item:getSummonLevel()
	return self:getSpecialAttribute("pokeLevel")
end

function Item:getSummonName()
	return self:getSpecialAttribute("pokeName")
end

function Item:getSummonBoost()
	return self:getSpecialAttribute("pokeBoost")
end

function Item:getSummonOwner()
	return self:getSpecialAttribute("owner")
end

function Item:isBeingUsed()
	local isBallBeingUsed = self:getSpecialAttribute("isBeingUsed")
	if isBallBeingUsed and isBallBeingUsed == 1 then
		return true
	end
	return false
end

function Item:setBeingUsed()
	self:setSpecialAttribute("isBeingUsed", 1)
	return true
end

function Item:unsetBeingUsed()
	self:setSpecialAttribute("isBeingUsed", 0)
	return true
end

function doRegenOrb(cid)
	local player = Player(cid)
	if not player then return end

	local ball = player:getUsingBall()
	if not ball then return end
	local orb_id = ball:getSpecialAttribute("regenOrb")
	if not orb_id then return end
	local summons = player:getSummons()
	if #summons == 0 or not summons[1] then return end
	local summon = summons[1]

	if player:getZone() ~= ZONE_PVP then
		local maxHealth = summon:getMaxHealth()
		local curinha = maxHealth * varCura / 150
		local heal = math.floor(curinha)
		local summonPos = summon:getPosition()
		Game.sendAnimatedText(summonPos, "+Regen", math.random(1, 255))
		summon:addHealth(heal)
	end
	addEvent(doRegenOrb, 10000, cid)
end


function doSendGobackInformations(player, summon, actionId)
	if not summon then return end
	local data = {
		action = actionId,
		creature = summon:getId(),
	}
	if data then
		player:sendExtendedOpcode(17, json.encode(data))
	end
end

opcodeSound = 74

function Player:sendSound(data)
	local data = data or ""
	self:sendExtendedOpcode(opcodeSound, data)
end

function Player:sendSoundAround(data)
	local data = data or ""
	local position = self:getPosition() -- posi��o do player alvo.
	local minRangeX = 0
	local maxRangeX = 17
	local minRangeY = 0
	local maxRangeY = 13

	local players = Game.getSpectators(position, false, true, minRangeX, maxRangeX, minRangeY, maxRangeY)

	for id, creature in pairs(players) do
		if creature:isPlayer() then
			creature:sendExtendedOpcode(opcodeSound, data)
		end
	end
end

function sendSoundToEveryone(data)
	local data = data or ""
	local players = Game.getPlayers()

	for _,player in ipairs(players) do
		player:sendSound(data)
	end
end

temporaryStorage = {}

function Player:setTemporaryStorage(key, value)
	if not temporaryStorage[key] then
		temporaryStorage[key] = {}
		temporaryStorage[key][self:getId()] = value
	else
		temporaryStorage[key][self:getId()] = value
	end
end

function Player:getTemporaryStorage(key)
	if temporaryStorage[key] and temporaryStorage[key][self:getId()] then
		return temporaryStorage[key][self:getId()]
	end
	return nil
end


function Position:createFlyFloor()
	local toTile = Tile(self)
	if not toTile or not toTile:getItems() or not toTile:getGround() then
		doAreaCombat(0, 0, self, 0, 0, 0, CONST_ME_NONE)
		Game.createItem(CONST_FLY_FLOOR, 1, self)
		local newTile = Tile(self)
		if newTile then
			newTile:loadZoneId()
		end
		for y = -1, 1 do
			for x = -1, 1 do
				local pos = Position(self.x + x, self.y + y, self.z)
				local toTileN = Tile(pos)
				if not toTileN or not toTileN:getItems() or not toTileN:getGround() then
					doAreaCombat(0, 0, pos, 0, 0, 0, CONST_ME_NONE)
					Game.createItem(CONST_FLY_FLOOR, 1, pos)
					local newTile = Tile(pos)
					if newTile then
						newTile:loadZoneId()
					end
				end
			end
		end
	end
	return true
end


function Tile:hasValidGroundToFly()
	local ground = self:getGround()
	local nilItem = self:getItemById(CONST_FLY_FLOOR)
	if ground and not nilItem then
		return true
	end
	return false
end

function Player:ativeFly()
	self:setStorageValue(storageFly, 1)
	self:registerEvent("FlyEvent")
	return true
end

function Player:desativeFly()
	local can, floor = self:canDesativeFly()
	local pos = self:getPosition()
	if can then
		local curtile = Tile(pos)
		local nilItem = curtile:getItemById(CONST_FLY_FLOOR)
		if nilItem then
			nilItem:remove()
		end
		for y = -2, 2 do
			for x = -2, 2 do
				local currtile = Tile({x = pos.x + x, y = pos.y + y, z = pos.z, stackpos = 0})
				if currtile then
					local nillItem = currtile:getItemById(CONST_FLY_FLOOR)
					if nillItem then
						nillItem:remove()
					end
				end
			end
		end
		self:unregisterEvent("FlyEvent")
		if pos.z ~= floor then
			pos.z = floor
			self:teleportTo(pos)
			pos:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return can
end

function Player:canDesativeFly()
	local pos = self:getPosition()
	--    for z = pos.z, 15 do
	local tmp = Tile(pos.x, pos.y, pos.z)
	if tmp and tmp:hasValidGroundToFly() then
		if self:canDownFly(pos.z) then
			return true, pos.z
		else
			return false
		end
	end
	--    end

	return false
end

function Player:canUpFly()
	local pos = self:getPosition()
	local tmp = Tile(pos.x, pos.y, pos.z-1)
	if tmp and tmp:hasValidGroundToFly() then
		return false
	end
	tmp = Tile(pos.x, pos.y, pos.z-1)

	if tmp and (tmp:getHouse() or tmp:hasFlag(TILESTATE_PROTECTIONZONE) or tmp:hasFlag(TILESTATE_FLOORCHANGE) or tmp:hasFlag(TILESTATE_BLOCKSOLID) ) then
		return false
	end

	if tmp and tmp:getGround() and isInArray(waterIds, tmp:getGround():getId()) then
		-- if tmp and tmp:getGround() then
		return false
	end
	return true
end

function Player:canDownFly(floor)
	local pos = self:getPosition()
	local tmp = Tile(pos)
	if floor and floor == pos.z then
		return true
	end
	if tmp:hasValidGroundToFly() then
		return false
	end
	tmp = Tile(pos.x, pos.y, floor or pos.z+1)

	if tmp and (tmp:getHouse() or tmp:hasFlag(TILESTATE_PROTECTIONZONE) or tmp:hasFlag(TILESTATE_FLOORCHANGE) or tmp:hasFlag(TILESTATE_BLOCKSOLID) ) then
		return false
	end

	if tmp and tmp:getGround() and isInArray(waterIds, tmp:getGround():getId()) then
		-- if tmp and tmp:getGround() then
		return false
	end
	return true
end

function Player:upFly()
	if self:isOnFly() then
		if self:canUpFly() then
			local pos = self:getPosition()
			local tile = Tile(pos)
			local itemfloor = tile:getItemById(CONST_FLY_FLOOR)
			if itemfloor then
				itemfloor:remove()
			end
			for y = -2, 2 do
				for x = -2, 2 do
					local currtile = Tile({x = pos.x + x, y = pos.y + y, z = pos.z, stackpos = 0})
					if currtile then
						local nillItem = currtile:getItemById(CONST_FLY_FLOOR)
						if nillItem then
							nillItem:remove()
						end
					end
				end
			end
			pos.z = pos.z-1
			pos:createFlyFloor()
			self:teleportTo(pos)
			pos:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		return false
	else
		self:sendCancelMessage("You are not flying.")
		return false
	end
end

function Player:downFly()
	if self:isOnFly() then
		if self:canDownFly() then
			local pos = self:getPosition()
			local tile = Tile(pos)
			local itemfloor = tile:getItemById(CONST_FLY_FLOOR)
			if itemfloor then
				itemfloor:remove()
			end
			for y = -2, 2 do
				for x = -2, 2 do
					local currtile = Tile({x = pos.x + x, y = pos.y + y, z = pos.z, stackpos = 0})
					if currtile then
						local nillItem = currtile:getItemById(CONST_FLY_FLOOR)
						if nillItem then
							nillItem:remove()
						end
					end
				end
			end
			pos.z = pos.z+1
			pos:createFlyFloor()
			self:teleportTo(pos)
			pos:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		return false
	else
		self:sendCancelMessage("You are not flying.")
		return false
	end
end

function sendShaderEveryone(data)
	local data = data or ""
	local players = Game.getPlayers()
	for _,player in ipairs(players) do
		player:sendExtendedOpcode(70, data)
	end
end

function addOnlineBonus(playerId)
	local player = Player(playerId)
	if player then
		if player:getStorageValue(71344) < 0 then
			player:setStorageValue(71344, 0) -- set to 0 / -1
		end

		if player:getStorageValue(72703) < 0 then
			player:setStorageValue(72703, 0) -- set to 0 / -1
		end

		if player:getStorageValue(72703) >= 60 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Por completar uma hora online sem deslogar, voc� ganhou 1 Online Point. Total: " ..player:getStorageValue(71344) .. ".")
			player:setStorageValue(71344, player:getStorageValue(71344) + 1)
			player:setStorageValue(72703, 0)
		end

		player:setStorageValue(72703, player:getStorageValue(72703) + 1)
		addEvent(addOnlineBonus, 60000, playerId)
	end
end

function convertTime(a)

	if(type(tonumber(a)) == "number" and a > 0) then
		if (a <= 3599) then
			local minute = math.floor(a/60)
			local second = a - (60 * minute)

			if(second == 0) then
				return ((minute)..((minute > 1) and " minutos" or " minuto"))
			else
				return ((minute ~= 0) and ((minute>1) and minute.." minutos e " or minute.." minuto e ").. ((second>1) and second.." segundos" or second.." segundo") or ((second>1) and second.." segundos" or second.. " segundo"))
			end
		elseif (a <= 86400) then
			local hour = math.floor(a/3600)
			local minute = math.floor((a - (hour * 3600))/60)
			local second = (a - (3600 * hour) - (minute * 60))

			if (minute == 0 and second > 0) then
				return (hour..((hour > 1) and " horas e " or " hora e "))..(second..((second > 1) and " segundos" or " segundo"))
			elseif (second == 0 and minute > 0) then
				return (hour..((hour > 1) and " horas e " or " hora e "))..(minute..((minute > 1) and " minutos" or " minuto"))
			elseif (second == 0 and minute == 0) then
				return (hour..((hour > 1) and " horas" or " hora"))
			end
			return (hour..((hour > 1) and " horas, " or " hora, "))..(minute..((minute > 1) and " minutos e " or " minuto e "))..(second..((second > 1) and " segundos" or " segundo"))
		elseif (a <= 31536000) then
			local day = math.floor(a/86400)
			local hour = math.floor((a - (day * 86400))/3600)
			local minute = math.floor((a - (86400 * day) - (hour * 3600))/60)
			local second = (a - (86400 * day) - (3600 * hour) - (minute * 60))

			if (hour == 0 and minute > 0) then
				return (day..((day > 1) and " dias e " or " dia e "))..(hour..((hour > 1) and " horas e " or " hora e "))..(minute..((minute > 1) and " minutos" or " minuto"))
			elseif (minute == 0 and second > 0) then
				return (day..((day > 1) and " dias e " or " dia e "))..(hour..((hour > 1) and " horas e " or " hora e "))..(second..((second > 1) and " segundos" or " segundo"))
			elseif (second == 0 and minute == 0) then
				return (day..((day > 1) and " dias e " or " dia e "))..(hour..((hour > 1) and " horas" or " hora"))
			end
			return (day..((day > 1) and " dias, " or " dia, "))..(hour..((hour > 1) and " horas, " or " hora, "))..(minute..((minute > 1) and " minutos e " or " minuto e "))..(second..((second > 1) and " segundos" or " segundo"))
		else
			local year = math.floor(a/31536000)
			local day = math.floor((a - (year * 31536000))/86400)
			local hour = math.floor((a - (year * 31536000) - (day * 86400))/3600)
			local minute = math.floor((a - (year * 31536000) - (86400 * day) - (hour * 3600))/60)
			local second = (a - (year * 31536000) - (86400 * day) - (3600 * hour) - (minute * 60))

			-- modifique as strings de retorno para incluir anos
			if (day == 0 and hour > 0) then
				return (year..((year > 1) and " anos e " or " ano e "))..(day..((day > 1) and " dias e " or " dia e "))..(hour..((hour > 1) and " horas" or " hora"))
			elseif (hour == 0 and minute > 0) then
				return (year..((year > 1) and " anos e " or " ano e "))..(day..((day > 1) and " dias e " or " dia e "))..(minute..((minute > 1) and " minutos" or " minuto"))
			elseif (minute == 0 and second > 0) then
				return (year..((year > 1) and " anos e " or " ano e "))..(day..((day > 1) and " dias e " or " dia e "))..(second..((second > 1) and " segundos" or " segundo"))
			end
			return (year..((year > 1) and " anos, " or " ano, "))..(day..((day > 1) and " dias, " or " dia, "))..(hour..((hour > 1) and " horas, " or " hora, "))..(minute..((minute > 1) and " minutos e " or " minuto e "))..(second..((second > 1) and " segundos" or " segundo"))

		end
	end
end

