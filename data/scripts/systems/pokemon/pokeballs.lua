CONST_EXHAUST_POKEBALL = 500

function Player.canSummonPokemon(self, ball)
    local pokeName = ball:getCustomAttribute("pokeName")
    if pokeName then
        local pokemonType = MonsterType(pokeName)
        if pokemonType then
            local minLevel = pokemonType:minimumLevel()
            local pLevel = self:getLevel()
            if pLevel < minLevel then
                self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need to be at least level " .. minLevel .. " to summon this pokemon.")
                return false
            end
        end
    end
    return true
end

local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local timeNow = os.mtime()
    if timeNow < player:getLastTimePokeballUse() then
        return true
    end
    if player:isSummonBlocked() then return true end

    player:setLastTimePokeballUse(timeNow + CONST_EXHAUST_POKEBALL)
    local ballKey = getBallKey(item:getId())

    if hasSummons(player) then
        local usingBall = player:getUsingBall()
        if not usingBall or usingBall ~= item then return true end
        doRemoveSummon(player:getId(), balls[ballKey].effectRelease, false, true, balls[ballKey].missile)
        player:setUsingPokeball(false)
        item:transform(balls[ballKey].usedOn)
    else
        if not player:canSummonPokemon(item) then return true end
        if item:getTopParent() == player then
            player:setUsingPokeball(item)

            item:transform(balls[ballKey].usedOff)
            item:setSpecialAttribute("isBeingUsed", 1)

            doReleaseSummon(player:getId(), player:getPosition(), balls[ballKey].effectRelease, true, balls[ballKey].missile)
        else
            if item:getSpecialAttribute("isBeingUsed") == 1 then
                item:transform(balls[ballKey].usedOn)
                item:setSpecialAttribute("isBeingUsed", 0)
            end
        end
    end
    return true
end

for _, pokeball in pairs(balls) do
    action:id(pokeball.usedOn)
    action:id(pokeball.usedOff)
end

action:register()

local talkaction = TalkAction("!p")

function talkaction.onSay(player, words, param)
    local timeNow = os.mtime()
    if timeNow < player:getLastTimePokeballUse() then
        return false
    end
    if player:isSummonBlocked() then return false end
    player:setLastTimePokeballUse(timeNow + CONST_EXHAUST_POKEBALL)

    local index = tonumber(param)
    if not index then return false end

    local pokeballs = player:getPokeballsCached()
    local ball = pokeballs[index]
    if not ball then
        doSendPokeTeamByClient(player)
        return false
    end

    local usingBall = player:getUsingBall()
    if hasSummons(player) then
        if not usingBall then
            doSendPokeTeamByClient(player)
            return false
        end
        local usingBallKey = getBallKey(usingBall:getId())
        doRemoveSummon(player:getId(), balls[usingBallKey].effectRelease, false, true, balls[usingBallKey].missile)
        player:setUsingPokeball(false)
        usingBall:transform(balls[usingBallKey].usedOn)
    end
    local position = player:getPosition()
    if ball ~= usingBall then
        if not player:canSummonPokemon(ball) then return false end
        local ballKey = getBallKey(ball:getId())
        ball:transform(balls[ballKey].usedOff)
        ball:setSpecialAttribute("isBeingUsed", 1)

        player:setUsingPokeball(ball)
        doReleaseSummon(player:getId(), position, balls[ballKey].effectRelease, true, balls[ballKey].missile)
    end
    return false
end

talkaction:separator(" ")
talkaction:register()

local creatureevent = CreatureEvent("testeBallLogin")

function creatureevent.onLogin(player)
    doSendPokeTeamByClient(player)
	return true
end

creatureevent:register()


function Player.handlePokebar(self, buffer)
    local payload = json.decode(buffer)
    if payload.type == "revive" then
        if not (self:revivePokemon(payload.info)) then
            self:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
	elseif payload.type == "update" then
		doSendPokeTeamByClient(self:getId())
    end
    return true
end

function Item:resetMoves()
	for i = 1, 12 do
		self:setSpecialAttribute("cd" .. i, 0)
	end
end

function isReviveClient(itemId)
    local revives = {25228}
    if isInArray(revives, itemId) then
        return true
    end
    return false
end

function Player:revivePokemon(info)
    -- dump(info)
    local pokeballs = self:getPokeballsCached()
    if not pokeballs or #pokeballs == 0 then
        return false
    end

	if not isReviveClient(info.clientId) then
		return false
	end

    local reviveItem = info.position and self:getItemByPos(info.position, info.stackpos, info.clientId) or Game.getItemIdByClientID(info.clientId)
    if not reviveItem then
       return
    end

    if type(reviveItem) ~= "userdata" then
        if self:getItemCount(reviveItem) < 1 then
            return false
        end
    end

    local pokeball = pokeballs[tonumber(info.index)]
    if not pokeball then
        return false
    end

	local ball = self:getUsingBall()
	if ball then
        if (pokeball == ball and #self:getSummons() > 0 and not self:isOnFly()) or (pokeball == ball and self:isOnFly() and #self:getSummons() == 0)then
	    	return false
	    end
    end

	local summonName = pokeball:getSpecialAttribute("pokeName")

	pokeball:resetMoves()

	pokeball:setSpecialAttribute("pokeHealth", MonsterType(summonName):getHealth() * 10000)
	local ballKey = getBallKey(pokeball:getId())
	pokeball:transform(balls[ballKey].usedOn)
	self:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	if type(reviveItem) == "userdata" and reviveItem:remove(1) or self:removeItem(reviveItem, 1) then
		doUpdatePokebarOnRevive(self, info.index)
	end
    return true
end

function doUpdatePokebarOnRevive(player, index)
	local player = type(player) == "userdata" and player or type(player) == "number" and Player(player)
	player:sendExtendedOpcode(53, json.encode({update = true, index = index}))
end

function doSendPokeTeamByClient(player)
    player = Player(player)
    local pokeballs = player:getPokeballsCached()
    local pokemons = {}

    local pokesHost = {}
    local isHosting = player:isHosting()
    for i, ball in ipairs(pokeballs) do
        local pokeName = ball:getSpecialAttribute("pokeName") or ""
        local monsterType = MonsterType(pokeName)
        -- if not monsterType then return error("Invalid Pokemon: " .. pokeName) end
        if not monsterType then return end
        local pokemon = {
            type = "PokeBar",
            pokeid = "!p " .. i,
            name = pokeName,
            nickname = ball:getSpecialAttribute("nickname"),
            use = ball:getSpecialAttribute("isBeingUsed") == 1 or false,
            ball = getBallKey(ball:getId()),
            health = ball:getSpecialAttribute("pokeHealth") or 0,
            maxHealth = monsterType:getTotalHealth(ball, player),
            looktype = monsterType:getOutfit().lookType,
            boost = ball:getSpecialAttribute("pokeBoost") or 0,
        }
		table.insert(pokemons, pokemon)
        if isHosting then
            pokesHost[i] = {name = pokemon.name, lookType = pokemon.looktype}
        end
    end
    if isHosting then
        Hosts[player:getId()].pokeballs = pokesHost
        local spectators = player:getSpectators()
        for i, spectator in ipairs(spectators) do
            spectator:sendHostData()
        end
    end
	player:sendExtendedOpcode(53, json.encode(pokemons))
end