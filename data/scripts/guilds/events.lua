local StartupEvent = GlobalEvent("GuildsStartUp")

function StartupEvent.onStartup()
  getTopGuilds()
end

local ThinkEvent = GlobalEvent("GuildWarsProcess")

-- I could spam addEvent for each guild but I can't be bothered
-- This is not that expensive, even with 50 guilds
-- Not every guild is in war with every other guild so we good
function ThinkEvent.onThink()
  local guilds = Game.getGuilds()
  for _, guild in ipairs(guilds) do
    if guild:getPacifismStatus() == GUILDS_CFG.PACIFISM.ACTIVE then
      if guild:getPacifism() <= os.mtime() then
        guild:cooldownPacifism()
      end
    elseif guild:getPacifismStatus() == GUILDS_CFG.PACIFISM.EXHAUSTED then
      if guild:getPacifism() <= os.mtime() then
        guild:inactivePacifism()
      end
    end

    local wars = guild:getWars()
    for _, war in ipairs(wars) do
      if war.status == GUILDS_CFG.WARS.STATUS.STARTED and war.started + war.duration <= os.time() then
        guild:endWar(war.guildId, GUILDS_CFG.WARS.END_TYPE.EXPIERD)
      elseif war.status == GUILDS_CFG.WARS.STATUS.PREPARING and war.started <= os.time() then
        guild:startWar(war.guildId)
      end
    end
  end
  return true
end

local LoginEvent = CreatureEvent("GuildsLogin")

function LoginEvent.onLogin(player)
  player:registerEvent("GuildsExtended")
  player:registerEvent("GuildWarDeath")
  player:sendOnlineUpdate()

  -- merging old contribution storing into new
  if player:getStorageValue(GUILDS_CFG.GOLD_STORAGE) > 0 then
    if player:getGuild() then
      player:addGuildContribution(player:getStorageValue(GUILDS_CFG.GOLD_STORAGE))
    end
    player:setStorageValue(GUILDS_CFG.GOLD_STORAGE, -1)
  end
  return true
end

local LogoutEvent = CreatureEvent("GuildsLogout")

function LogoutEvent.onLogout(player)
  player:sendOnlineUpdate(true)
  return true
end

local DeathEvent = CreatureEvent("GuildWarDeath")
function DeathEvent.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
  local byPlayer = false
  if killer then
    if killer:isPlayer() then
      byPlayer = true
    else
      local master = killer:getMaster()
      if master and master ~= killer and master:isPlayer() then
        killer = master
        byPlayer = true
      end
    end
  end

  if not byPlayer then
    return true
  end

  local killerGuild = killer:getGuild()
  local victimGuild = player:getGuild()
  if not killerGuild or not victimGuild then
    return true
  end

  local killerId = killerGuild:getId()
  local victimId = victimGuild:getId()

  if not killerGuild:isInWar(victimId) then
    return true
  end

  local war = killerGuild:getWar(victimId)
  if not war then
    return true
  end

  local kName = killer:getName()
  local vName = player:getName()

  killerGuild:addWarKill(victimId, 1)
  db.asyncQuery(
    string.format(
      "INSERT INTO `guildwar_kills` VALUES (0, %d, %s, %s, %d, %d, %d)",
      war.warId,
      db.escapeString(kName),
      db.escapeString(vName),
      killerId,
      victimId,
      os.time()
    )
  )

  local kMembers = killerGuild:getMembersOnline()
  local vMembers = victimGuild:getMembersOnline()

  local data = {
    warId = war.warId,
    killer = kName,
    victim = vName,
    ally = true
  }
  for _, member in ipairs(kMembers) do
    member:sendGuildPacket("warKill", data)
  end

  data.ally = false
  for _, member in ipairs(vMembers) do
    member:sendGuildPacket("warKill", data)
  end

  if war.kills + 1 >= war.killsMax then
    killerGuild:endWar(victimId, GUILDS_CFG.WARS.END_TYPE.KILLS)
  end

  return true
end

StartupEvent:type("startup")
StartupEvent:register()
ThinkEvent:interval(30 * 1000)
ThinkEvent:register()
LoginEvent:type("login")
LoginEvent:register()
LogoutEvent:type("logout")
LogoutEvent:register()
DeathEvent:type("death")
DeathEvent:register()
