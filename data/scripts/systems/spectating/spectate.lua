local CHANNEL_ID = 23

Hosts = {}

local TVAction = Action()

function TVAction.onUse(player)
    player:showCasts()
    return true
end

local LoginEvent = CreatureEvent("SpectateLogin")

function LoginEvent.onLogin(player)
    player:registerEvent("SpectateExtended")
    player:registerEvent("SpectateLogout")
    return true
end

local LogoutEvent = CreatureEvent("SpectateLogout")

function LogoutEvent.onLogout(player)
    player:stopSpectate()
    player:stopHosting(true)
    return true
end

local PrepareDeathEvent = CreatureEvent("SpectatePreDeath")

function PrepareDeathEvent.onPrepareDeath(target, killer)
    if target:isHosting() then
        target:stopHosting(true)
    end

    return true
end

local ExtendedEvent = CreatureEvent("SpectateExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
    if opcode == ExtendedOPCodes.CODE_SPECTATE then
        local status, json_data =
            pcall(
                function()
                    return json.decode(buffer)
                end
            )

        if not status then
            return
        end

        local action = json_data.action
        local data = json_data.data
        if action == "host" then
            player:startHosting(data)
        elseif action == "stopHost" then
            player:stopHosting(true)
        elseif action == "kick" then
            player:kickPlayer(data)
        elseif action == "ban" then
            player:banPlayer(data)
        elseif action == "spectate" then
            player:spectate(data)
        elseif action == "stopSpectate" then
            player:stopSpectate()
        end
    end
end

function Player:showCasts()
    local casts = {}
    for cid, host in pairs(Hosts) do
        table.insert(
            casts,
            {
                name = host.name,
                description = host.description,
                password = (host.password and host.password:len() > 0),
                viewers = host.viewers
            }
        )
    end
    table.sort(
        casts,
        function(a, b)
            return a.viewers > b.viewers
        end
    )
    self:sendExtendedOpcode(ExtendedOPCodes.CODE_SPECTATE, json.encode({ action = "show", data = casts }))
end

function Player:getPokeballsInfo()
    local data = {}
    local pokeballs = self:getPokeballsCached()

    for id, pokeball in ipairs(pokeballs) do
        local name  = pokeball:getSpecialAttribute("pokeName")
        local monsterType = MonsterType(name)
        data[id] = {name = name, lookType = monsterType:getOutfit().lookType}
    end

    return data
end

function Player:startHosting(data)
    if self:isHosting() then
        self:popupFYI("You are already hosting.")
        return
    end

    if self:getSpectating() then
        self:popupFYI("You can't host while watching someone.")
        return
    end

    local cid = self:getId()
    Hosts[cid] = {
        name = self:getName(),
        description = data.description,
        password = data.password,
        pokeballs = self:getPokeballsInfo(),
        viewers = 0,
        banned = {}
    }

    self:registerEvent("SpectatePreDeath")
    self:openChannel(CHANNEL_ID)
    self:sendExtendedOpcode(ExtendedOPCodes.CODE_SPECTATE, json.encode({ action = "hosting" }))
end

function Player:stopHosting(clear)
    local cid = self:getId()
    if Hosts[cid] then
        self:unregisterEvent("SpectatePreDeath")
        Hosts[cid] = nil
        self:sendExtendedOpcode(ExtendedOPCodes.CODE_SPECTATE, json.encode({ action = "stopHosting" }))
    end
    if clear then
        local spectators = self:getSpectators()
        for _, spectator in ipairs(spectators) do
            spectator:popupFYI("Player stopped hosting spectating session or left the game.")
            spectator:stopSpectating()
        end
    end
end

function Player:kickPlayer(name)
    local cid = self:getId()
    local target = Player(name)
    if target then
        local spectating = target:getSpectating()
        if spectating and spectating:getId() == cid then
            self:sendChannelMessage("", target:getName() .. " was kicked from spectating.", TALKTYPE_CHANNEL_R1,
                CHANNEL_ID)
            target:stopSpectating()
            Hosts[cid].viewers = Hosts[cid].viewers - 1
        end
    end
end

function Player:banPlayer(name)
    local cid = self:getId()
    local target = Player(name)
    if target then
        local spectating = target:getSpectating()
        if spectating and spectating:getId() == cid then
            self:sendChannelMessage("", target:getName() .. " was banned from spectating.", TALKTYPE_CHANNEL_R1,
                CHANNEL_ID)
            target:stopSpectating()
            table.insert(Hosts[cid].banned, target:getAccountId())
            Hosts[cid].viewers = Hosts[cid].viewers - 1
        end
    end
end

function Player:spectate(data)
    if self:isHosting() then
        self:popupFYI("You can't watch while hosting.")
        return
    end

    if self:getSpectating() then
        self:popupFYI("You are already watching someone.")
        return
    end

    local target = Player(data.name)
    if target then
        local cid = target:getId()
        if self:getId() == cid then
            self:popupFYI("You can't watch yourself.")
            return
        end

        if Hosts[cid] then
            if isInArray(Hosts[cid].banned, self:getAccountId()) then
                self:popupFYI("You are banned from watching this player.")
                return
            end

            if Hosts[cid].password then
                if Hosts[cid].password ~= data.password then
                    self:popupFYI("Incorrect password.")
                    return
                end
            end

            self:startSpectating(target)
            self:openChannel(CHANNEL_ID)
            target:sendChannelMessage("", self:getName() .. " is now spectating.", TALKTYPE_CHANNEL_R1, CHANNEL_ID)
            Hosts[cid].viewers = Hosts[cid].viewers + 1

            self:sendHostData()
        end
    end
end

function Player:sendHostData()
    local host = self:getSpectating()
    local cid = host:getId()
    local hostData = {
        name = host:getName(),
        description = Hosts[cid].description,
        pokeballs = Hosts[cid].pokeballs,
        viewers = Hosts[cid].viewers
    }
    self:sendExtendedOpcode(ExtendedOPCodes.CODE_SPECTATE, json.encode({ action = "hosterData", data = hostData}))
end

function Player:stopSpectate()
    local spectating = self:getSpectating()
    if spectating then
        if not spectating:isHosting() then
            self:stopGMSpectate()
            return
        end

        spectating:sendChannelMessage("", self:getName() .. " is no longer spectating.", TALKTYPE_CHANNEL_R1, CHANNEL_ID)
        local cid = spectating:getId()
        Hosts[cid].viewers = Hosts[cid].viewers - 1
    end

    self:stopSpectating()
end

function Player:isHosting()
    return Hosts[self:getId()] ~= nil
end

TVAction:id(26738)
TVAction:register()
LoginEvent:type("login")
LoginEvent:register()
LogoutEvent:type("logout")
LogoutEvent:register()
PrepareDeathEvent:type("preparedeath")
PrepareDeathEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()
