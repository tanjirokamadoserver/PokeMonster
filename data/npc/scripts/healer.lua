local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

local function creatureGreetCallback(cid, message)
	if message == nil then
		return true
	end
	local player = Player(cid)
	local playerHealth = player:getHealth()
	local playerMaxHealth = player:getMaxHealth()

	if playerHealth < playerMaxHealth then
		player:addHealth(playerMaxHealth - playerHealth)
	end

	if hasSummons(player) then
		local summon = player:getSummons()[1]
		summon:addHealth(-summon:getHealth() + summon:getMaxHealth())
	end

	local pokeballs = player:getPokeballsCached()
	for i = 1, #pokeballs do
		local ball = pokeballs[i]
		local ballId = ball:getId()
		local ballKey = getBallKey(ballId)

		local poke_level = ball:getSpecialAttribute("pokeLevel") or 1
		local pokeCard = ball:getSpecialAttribute("pokeCard") or 0
		local summonName = ball:getSpecialAttribute("pokeName")

		local status_poke = statusGainFormula(poke_level)
		local bonus = 0
		if pokeCard ~= 0 then
			bonus = status_poke * cardsInfo[pokeCard] / 100
		end

		local total = status_poke + bonus
		ball:setSpecialAttribute("pokeHealth", MonsterType(summonName):getHealth() * total * 103)

		local isBallBeingUsed = ball:getSpecialAttribute("isBeingUsed")
		if ballId == balls[ballKey].usedOff and isBallBeingUsed ~= 1 then
			ball:transform(balls[ballKey].usedOn)
		end
	end
		
	local message = "Todos os seus Pokémons estão completamente recuperados e prontos para a próxima aventura!"
	local closeTime = 2
	doSendCallForNpc(getNpcCid(), player, "HiNpc", "#ff768e", nil, message, nil, closeTime)
	
	selfSay('Take care yourself.', cid)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	doSendPokeTeamByClient(player)
	return false
end

npcHandler:setCallback(CALLBACK_GREET, creatureGreetCallback)
npcHandler:addModule(FocusModule:new())
