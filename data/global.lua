dofile('data/lib/lib.lua')

donates = {  }

ExtendedOPCodes = {
    CODE_SPECTATE = 114,
    CODE_GMTOOLS = 118
  }

bossesToSend = {
	"Lugia",
}

bossRanking = {}
imagesBossRanking = {
	[1] = { image = "firstPlace", x = 13, y = 9 },
	[2] = { image = "secondPlace", x = 13, y = 9 },
	[3] = { image = "thirdPlace", x = 13, y = 9 },
}
STORAGEVALUE_PROMOTION = 30018

AUTO_LOOT_MAX_ITEMS = 10
AUTOLOOT_STORAGE_START = 105200
AUTOLOOT_STORAGE_END = AUTOLOOT_STORAGE_START + AUTO_LOOT_MAX_ITEMS
AUTOLOOT_ALL_ENABLED = AUTOLOOT_STORAGE_END + 1

ropeSpots = { 384, 418, 8278, 8592, 13189, 14435, 14436, 15635, 19518 }

doors = {
    [15937] = 15936,
    [15936] = 15937,
    [15940] = 15941,
    [15941] = 15940,
    [19603] = 19595,
    [19595] = 19603,
    [19790] = 19788,
    [19788] = 19790,
    [19791] = 19789,
    [19789] = 19791,
    [19604] = 19596,
    [19596] = 19604,
    [19606] = 19598,
    [19598] = 19606,
    [19605] = 19597,
    [19597] = 19605,
    [1210] = 1211,
    [1212] = 1214,
    [1213] = 1214,
    [1219] = 1220,
    [1221] = 1222,
    [1231] = 1233,
    [1232] = 1233,
    [1234] = 1236,
    [1235] = 1236,
    [1237] = 1238,
    [1239] = 1240,
    [1249] = 1251,
    [1250] = 1251,
    [1252] = 1254,
    [1253] = 1254,
    [1539] = 1540,
    [1541] = 1542,
    [3535] = 3537,
    [3536] = 3537,
    [3538] = 3539,
    [3544] = 3546,
    [3545] = 3546,
    [3547] = 3548,
    [4913] = 4915,
    [4914] = 4915,
    [4916] = 4918,
    [4917] = 4918,
    [5082] = 5083,
    [5084] = 5085,
    [5098] = 5100,
    [5099] = 5100,
    [5101] = 5102,
    [5107] = 5109,
    [5108] = 5109,
    [5110] = 5111,
    [5116] = 5118,
    [5117] = 5118,
    [5119] = 5120,
    [5125] = 5127,
    [5126] = 5127,
    [5128] = 5129,
    [5134] = 5136,
    [5135] = 5136,
    [5137] = 5139,
    [5138] = 5139,
    [5140] = 5142,
    [5141] = 5142,
    [5143] = 5145,
    [5144] = 5145,
    [5278] = 5280,
    [5279] = 5280,
    [5281] = 5283,
    [5282] = 5283,
    [5284] = 5285,
    [5286] = 5287,
    [5515] = 5516,
    [5517] = 5518,
    [5732] = 5734,
    [5733] = 5734,
    [5735] = 5737,
    [5736] = 5737,
    [6192] = 6194,
    [6193] = 6194,
    [6195] = 6197,
    [6196] = 6197,
    [6198] = 6199,
    [6200] = 6201,
    [6249] = 6251,
    [6250] = 6251,
    [6252] = 6254,
    [6253] = 6254,
    [6255] = 6256,
    [6257] = 6258,
    [6795] = 6796,
    [6797] = 6798,
    [6799] = 6800,
    [6801] = 6802,
    [6891] = 6893,
    [6892] = 6893,
    [6894] = 6895,
    [6900] = 6902,
    [6901] = 6902,
    [6903] = 6904,
    [7033] = 7035,
    [7034] = 7035,
    [7036] = 7037,
    [7042] = 7044,
    [7043] = 7044,
    [7045] = 7046,
    [7054] = 7055,
    [7056] = 7057,
    [8541] = 8543,
    [8542] = 8543,
    [8544] = 8546,
    [8545] = 8546,
    [8547] = 8548,
    [8549] = 8550,
    [9165] = 9167,
    [9166] = 9167,
    [9168] = 9170,
    [9169] = 9170,
    [9171] = 9172,
    [9173] = 9174,
    [9267] = 9269,
    [9268] = 9269,
    [9270] = 9272,
    [9271] = 9272,
    [9273] = 9274,
    [9275] = 9276,
    [10276] = 10277,
    [10274] = 10275,
    [10268] = 10270,
    [10269] = 10270,
    [10271] = 10273,
    [10272] = 10273,
    [10471] = 10472,
    [10480] = 10481,
    [10477] = 10479,
    [10478] = 10479,
    [10468] = 10470,
    [10469] = 10470,
    [10775] = 10777,
    [10776] = 10777,
    [12092] = 12094,
    [12093] = 12094,
    [12188] = 12190,
    [12189] = 12190,
    [19840] = 19842,
    [19841] = 19842,
    [19843] = 19844,
    [19980] = 19982,
    [19981] = 19982,
    [19983] = 19984,
    [20273] = 20275,
    [20274] = 20275,
    [20276] = 20277,
    [17235] = 17236,
    [18208] = 18209,
    [13022] = 13023,
    [10784] = 10786,
    [10785] = 10786,
    [12099] = 12101,
    [12100] = 12101,
    [12197] = 12199,
    [12198] = 12199,
    [19849] = 19851,
    [19850] = 19851,
    [19852] = 19853,
    [19989] = 19991,
    [19990] = 19991,
    [19992] = 19993,
    [20282] = 20284,
    [20283] = 20284,
    [20285] = 20286,
    [17237] = 17238,
    [13020] = 13021,
    [10780] = 10781,
    [12095] = 12096,
    [12195] = 12196,
    [19845] = 19846,
    [19985] = 19986,
    [20278] = 20279,
    [10789] = 10790,
    [12102] = 12103,
    [12204] = 12205,
    [19854] = 19855,
    [19994] = 19995,
    [20287] = 20288,
    [10782] = 10783,
    [12097] = 12098,
    [12193] = 12194,
    [19847] = 19848,
    [19987] = 19988,
    [20280] = 20281,
    [10791] = 10792,
    [12104] = 12105,
    [12202] = 12203,
    [19856] = 19857,
    [19996] = 19997,
    [20289] = 20290,
    [35091] = 35092,
    [35089] = 35090,
    [34695] = 34694,
    [34694] = 34695
}

verticalOpenDoors = { 1211, 1220, 1224, 1228, 1233, 1238, 1242, 1246, 1251, 1256, 1260, 1540, 3546, 3548, 3550, 3552, 4915, 5083, 5109, 5111, 5113, 5115, 5127, 5129, 5131, 5133, 5142, 5145, 5283, 5285, 5289, 5293, 5516, 5737, 5749, 6194, 6199, 6203, 6207, 6251, 6256, 6260, 6264, 6798, 6802, 6902, 6904, 6906, 6908, 7044, 7046, 7048, 7050, 7055, 8543, 8548, 8552, 8556, 9167, 9172, 9269, 9274, 9274, 9269, 9278, 9282, 10270, 10275, 10279, 10283, 10479, 10481, 10485, 10483, 10786, 12101, 12199, 19851, 19853, 19991, 19993, 20284, 20286, 17238, 13021, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290, 35092 }
horizontalOpenDoors = { 1214, 1222, 1226, 1230, 1236, 1240, 1244, 1248, 1254, 1258, 1262, 1542, 3537, 3539, 3541, 3543, 4918, 5085, 5100, 5102, 5104, 5106, 5118, 5120, 5122, 5124, 5136, 5139, 5280, 5287, 5291, 5295, 5518, 5734, 5746, 6197, 6201, 6205, 6209, 6254, 6258, 6262, 6266, 6796, 6800, 6893, 6895, 6897, 6899, 7035, 7037, 7039, 7041, 7057, 8546, 8550, 8554, 8558, 9170, 9174, 9272, 9276, 9280, 9284, 10273, 10277, 10281, 10285, 10470, 10472, 10476, 10474, 10777, 12094, 12190, 19842, 19844, 19982, 19984, 20275, 20277, 17236, 18209, 13023, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 35090 }
openSpecialDoors = { 1224, 1226, 1228, 1230, 1242, 1244, 1246, 1248, 1256, 1258, 1260, 1262, 3541, 3543, 3550, 3552, 5104, 5106, 5113, 5115, 5122, 5124, 5131, 5133, 5289, 5291, 5293, 5295, 6203, 6205, 6207, 6209, 6260, 6262, 6264, 6266, 6897, 6899, 6906, 6908, 7039, 7041, 7048, 7050, 8552, 8554, 8556, 8558, 9176, 9178, 9180, 9182, 9278, 9280, 9282, 9284, 10279, 10281, 10283, 10285, 10474, 10476, 10483, 10485, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290 }
questDoors = { 1223, 1225, 1241, 1243, 1255, 1257, 3542, 3551, 5105, 5114, 5123, 5132, 5288, 5290, 5745, 5748, 6202, 6204, 6259, 6261, 6898, 6907, 7040, 7049, 8551, 8553, 9175, 9177, 9277, 9279, 10278, 10280, 10475, 10484, 10782, 10791, 12097, 12104, 12202, 19847, 19856, 19987, 19996, 20280, 20289 }
levelDoors = { 12193, 1227, 1229, 1245, 1247, 1259, 1261, 3540, 3549, 5103, 5112, 5121, 5130, 5292, 5294, 6206, 6208, 6263, 6265, 6896, 6905, 7038, 7047, 8555, 8557, 9179, 9181, 9281, 9283, 10282, 10284, 10473, 10482, 10780, 10789, 10780, 12095, 12102, 12204, 12195, 19845, 19854, 19985, 19994, 20278, 20287 }
keys = { 2086, 2087, 2088, 2089, 2090, 2091, 2092, 10032 }

function getDistanceBetween(firstPosition, secondPosition)
	local xDif = math.abs(firstPosition.x - secondPosition.x)
	local yDif = math.abs(firstPosition.y - secondPosition.y)
	local posDif = math.max(xDif, yDif)
	if firstPosition.z ~= secondPosition.z then
		posDif = posDif + 15
	end
	return posDif
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function isNumber(str)
	return tonumber(str) ~= nil
end

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

function getAccountNumberByPlayerName(name)
	local player = Player(name)
	if player ~= nil then
		return player:getAccountId()
	end

	local resultId = db.storeQuery("SELECT `account_id` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId ~= false then
		local accountId = result.getNumber(resultId, "account_id")
		result.free(resultId)
		return accountId
	end
	return 0
end

function getMoneyCount(string)
	local b, e = string:find("%d+")
	local money = b and e and tonumber(string:sub(b, e)) or -1
	if isValidMoney(money) then
		return money
	end
	return -1
end

function getMoneyWeight(money)
	local gold = money
	local crystal = math.floor(gold / 10000)
	gold = gold - crystal * 10000
	local platinum = math.floor(gold / 100)
	gold = gold - platinum * 100
	return (ItemType(2160):getWeight() * crystal) + (ItemType(2152):getWeight() * platinum) +
	(ItemType(2148):getWeight() * gold)
end

function getRealDate()
	local month = tonumber(os.date("%m", os.time()))
	local day = tonumber(os.date("%d", os.time()))

	if month < 10 then
		month = '0' .. month
	end
	if day < 10 then
		day = '0' .. day
	end
	return day .. '/' .. month
end

function getRealTime()
	local hours = tonumber(os.date("%H", os.time()))
	local minutes = tonumber(os.date("%M", os.time()))

	if hours < 10 then
		hours = '0' .. hours
	end
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function isValidMoney(money)
	return isNumber(money) and money > 0 and money < 4294967296
end

function iterateArea(func, from, to)
	for z = from.z, to.z do
		for y = from.y, to.y do
			for x = from.x, to.x do
				func(Position(x, y, z))
			end
		end
	end
end

function playerExists(name)
	local resultId = db.storeQuery('SELECT `name` FROM `players` WHERE `name` = ' .. db.escapeString(name))
	if resultId then
		result.free(resultId)
		return true
	end
	return false
end

if nextUseStaminaTime == nil then
	nextUseStaminaTime = {}
end

if not math.pow then
  math.pow = function(base, expoente)
    return base ^ expoente
  end
end
