TopGuilds = {}
local lastTopGuildsFetch = 0

function Guild:getRankPosition()
  local guildId = self:getId()
  for i = 1, #TopGuilds do
    if TopGuilds[i] == guildId then
      return i
    end
  end
  return 0
end

function Guild:addInboxMessage(msgType, text, targetId, guildId)
  targetId = targetId or 0
  guildId = guildId or 0
  text = db.escapeString(text)

  db.query(string.format("INSERT INTO `guilds_inbox` VALUES (NULL, %d, %d, %d, %d, %s, %d);", targetId, guildId, os.time(), msgType, text, 0))
  local inboxId = db.lastInsertId()

  local members = self:getMembers()
  for _, member in ipairs(members) do
    if msgType == GUILDS_CFG.MESSAGE_TYPES.JOIN_REQUEST then
      local rank = self:getRankByName(member.rank)
      if rankHasPermission(rank.permissions, GUILDS_CFG.PERMISSIONS.INVITE_MEMBERS) then
        db.query(string.format("INSERT INTO `guilds_player_inbox` VALUES (%d, %d);", member.guid, inboxId))
      end
    elseif msgType == GUILDS_CFG.MESSAGE_TYPES.WAR_DECLARATION then
      local rank = self:getRankByName(member.rank)
      if rankHasPermission(rank.permissions, GUILDS_CFG.PERMISSIONS.MANAGE_WARS) then
        db.query(string.format("INSERT INTO `guilds_player_inbox` VALUES (%d, %d);", member.guid, inboxId))
      end
    else
      db.query(string.format("INSERT INTO `guilds_player_inbox` VALUES (%d, %d);", member.guid, inboxId))
    end
  end

  return inboxId
end

function Guild:addNewMember(target)
  if self:getMemberCount() >= self:getMaxMembers() then
    return
  end

  local msgText = string.format("Player {%s} has joined the guild.", target:getName())
  local msgId = self:addInboxMessage(GUILDS_CFG.MESSAGE_TYPES.MEMBER_JOINED, msgText)

  local members = self:getMembersOnline()
  for _, member in ipairs(members) do
    member:sendInboxMessage(msgId, GUILDS_CFG.MESSAGE_TYPES.MEMBER_JOINED, msgText)
  end

  local guid = target:getGuid()
  local defaultRank = self:getDefaultRank()

  db.query(string.format("INSERT INTO `guild_members` VALUES (%d, %d, %d, '', 0, 0);", guid, self:getId(), defaultRank.id))

  local vocationId = target:getVocation():getId()
  local name = target:getName()
  local lastLogin = target:getLastLoginSaved()
  target:setGuild(self)
  self:addMember(guid, vocationId, name, defaultRank.name, target:getLevel(), lastLogin)

  target:fetchGuildGeneral()
  target:sendOnlineUpdate()

  local pid = target:getId()
  local data = {emblem = target:getGuildEmblem(members[1]), players = {pid}}
  for _, member in ipairs(members) do
    table.insert(data.players, member:getId())
  end
  target:sendGuildPacket("emblems", data)

  local spectators = Game.getSpectators(target:getPosition(), true, true)
  for _, player in ipairs(spectators) do
    if player:getId() ~= pid then
      player:sendGuildPacket("emblems", {emblem = player:getGuildEmblem(target), players = {pid}})
    end
  end

  local combinedLevels = self:getCombinedLevels()
  local newMembers = {self:getMemberCount(), self:getMaxMembers()}
  data = {
    member = {
      voc = vocationId,
      name = name,
      rank = defaultRank.name,
      level = target:getLevel(),
      online = true,
      last = lastLogin,
      contribution = 0
    },
    levels = combinedLevels,
    members = newMembers
  }
  for _, member in ipairs(members) do
    member:sendGuildPacket("joined", data)
  end

  data = {
    id = self:getId(),
    avgLevel = math.floor(combinedLevels / self:getMemberCount() + 0.5),
    levels = combinedLevels,
    members = newMembers
  }

  local players = Game.getPlayers()
  for _, player in ipairs(players) do
    player:sendGuildPacket("topUpdate", data)
  end
end

function Guild:addNewMemberOffline(guid)
  if self:getMemberCount() >= self:getMaxMembers() then
    return
  end

  local targetName, level, vocationId, lastLogin
  local resultId = db.storeQuery(string.format("SELECT `name`, `level`, `vocation`, `lastlogin` FROM `players` WHERE `id` = %d LIMIT 1;", guid))
  if resultId ~= false then
    targetName = result.getString(resultId, "name")
    level = result.getNumber(resultId, "level")
    vocationId = result.getNumber(resultId, "vocation")
    lastLogin = result.getNumber(resultId, "lastlogin")
    result.free(resultId)
  end

  if not targetName then
    return
  end

  local msgText = string.format("Player {%s} has joined the guild.", targetName)
  local msgId = self:addInboxMessage(GUILDS_CFG.MESSAGE_TYPES.MEMBER_JOINED, msgText)

  local members = self:getMembersOnline()
  for _, member in ipairs(members) do
    member:sendInboxMessage(msgId, GUILDS_CFG.MESSAGE_TYPES.MEMBER_JOINED, msgText)
  end

  local defaultRank = self:getDefaultRank()

  db.query(string.format("INSERT INTO `guild_members` VALUES (%d, %d, %d, '', 0, 0);", guid, self:getId(), defaultRank.id))

  self:addMember(guid, vocationId, targetName, defaultRank.name, level, lastLogin)

  local combinedLevels = self:getCombinedLevels()
  local newMembers = {self:getMemberCount(), self:getMaxMembers()}
  local data = {
    member = {
      voc = vocationId,
      name = targetName,
      rank = defaultRank.name,
      level = level,
      online = true,
      last = lastLogin,
      contribution = 0
    },
    levels = combinedLevels,
    members = newMembers
  }

  for _, member in ipairs(members) do
    member:sendGuildPacket("joined", data)
  end

  data = {
    id = self:getId(),
    avgLevel = math.floor(combinedLevels / self:getMemberCount() + 0.5),
    levels = combinedLevels,
    members = newMembers
  }

  local players = Game.getPlayers()
  for _, player in ipairs(players) do
    player:sendGuildPacket("topUpdate", data)
  end

  self:save()
end

function Guild:finishInboxMessage(msgId, type)
  db.query(string.format("UPDATE `guilds_inbox` SET `finished` = 1 WHERE `id` = %d;", msgId))
  local members = self:getMembers()
  for _, member in ipairs(members) do
    local continue = false
    local rank = self:getRankByName(member.rank)
    if type == GUILDS_CFG.MESSAGE_TYPES.JOIN_INVITATION or type == GUILDS_CFG.MESSAGE_TYPES.JOIN_REQUEST then
      if not rankHasPermission(rank.permissions, GUILDS_CFG.PERMISSIONS.INVITE_MEMBERS) then
        continue = true
      end
    elseif type == GUILDS_CFG.MESSAGE_TYPES.WAR_DECLARATION then
      if not rankHasPermission(rank.permissions, GUILDS_CFG.PERMISSIONS.MANAGE_WARS) then
        continue = true
      end
    end

    if not continue then
      local player = Player(member.guid)
      if player then
        player:finishInboxMessage(msgId)
        player:sendGuildPacket("finished", msgId)
      end
    end
  end
end

function Guild:startWar(targetId)
  local targetGuild = Game.getGuild(targetId)
  if not targetGuild then
    return
  end

  local guildId = self:getId()

  self:setWarStatus(targetId, GUILDS_CFG.WARS.STATUS.STARTED)
  targetGuild:setWarStatus(guildId, GUILDS_CFG.WARS.STATUS.STARTED)

  local war = self:getWar(targetId)

  db.asyncQuery(string.format("UPDATE `guild_wars` SET `status` = %d WHERE id = %d", GUILDS_CFG.WARS.STATUS.STARTED, war.warId))

  local members = self:getMembersOnline()
  local targetMembers = targetGuild:getMembersOnline()
  for _, member in ipairs(members) do
    member:sendGuildPacket("warStart", war.warId)
    for _, otherMember in ipairs(members) do
      member:sendGuildPacket("emblems", {emblem = member:getGuildEmblem(otherMember), players = {otherMember:getId()}})
    end
    for _, targetMember in ipairs(targetMembers) do
      member:sendGuildPacket("emblems", {emblem = member:getGuildEmblem(targetMember), players = {targetMember:getId()}})
    end
  end

  for _, targetMember in ipairs(targetMembers) do
    targetMember:sendGuildPacket("warStart", war.warId)
    for _, otherMember in ipairs(targetMembers) do
      targetMember:sendGuildPacket("emblems", {emblem = targetMember:getGuildEmblem(otherMember), players = {otherMember:getId()}})
    end
    for _, member in ipairs(members) do
      targetMember:sendGuildPacket("emblems", {emblem = targetMember:getGuildEmblem(member), players = {member:getId()}})
    end
  end
end

function Guild:endWar(targetId, endType)
  local targetGuild = Game.getGuild(targetId)
  if not targetGuild then
    return
  end

  local guildId = self:getId()

  local war = self:getWar(targetId)
  db.asyncQuery(string.format("UPDATE `guild_wars` SET `status` = %d, `ended` = %d WHERE id = %d", GUILDS_CFG.WARS.STATUS.ENDED, os.time(), war.warId))

  self:removeWar(targetId)
  targetGuild:removeWar(guildId)

  local members = self:getMembersOnline()
  for _, member in ipairs(members) do
    member:sendGuildPacket("warEnd", war.warId)
  end

  local targetMembers = targetGuild:getMembersOnline()
  for _, member in ipairs(targetMembers) do
    member:sendGuildPacket("warEnd", war.warId)
  end

  for _, member in ipairs(members) do
    for _, otherMember in ipairs(members) do
      member:sendGuildPacket("emblems", {emblem = member:getGuildEmblem(otherMember), players = {otherMember:getId()}})
    end
    for _, targetMember in ipairs(targetMembers) do
      member:sendGuildPacket("emblems", {emblem = member:getGuildEmblem(targetMember), players = {targetMember:getId()}})
    end
  end

  for _, targetMember in ipairs(targetMembers) do
    for _, otherMember in ipairs(targetMembers) do
      targetMember:sendGuildPacket("emblems", {emblem = targetMember:getGuildEmblem(otherMember), players = {otherMember:getId()}})
    end
    for _, member in ipairs(members) do
      targetMember:sendGuildPacket("emblems", {emblem = targetMember:getGuildEmblem(member), players = {member:getId()}})
    end
  end

  if endType == GUILDS_CFG.WARS.END_TYPE.EXPIERD then
    local leftKills = 0
    local rightKills = 0

    do
      local resultId =
        db.storeQuery(string.format("SELECT COUNT(*) AS kills FROM `guildwar_kills` WHERE `warid` = %d AND `killerguild` = %d", war.warId, guildId))

      if resultId ~= false then
        repeat
          leftKills = result.getNumber(resultId, "kills")
        until not result.next(resultId)
        result.free(resultId)
      end
    end

    do
      local resultId =
        db.storeQuery(string.format("SELECT COUNT(*) AS kills FROM `guildwar_kills` WHERE `warid` = %d AND `killerguild` = %d", war.warId, targetId))

      if resultId ~= false then
        repeat
          rightKills = result.getNumber(resultId, "kills")
        until not result.next(resultId)
        result.free(resultId)
      end
    end

    if leftKills > rightKills then
      self:addWarsWon(1)
      targetGuild:addWarsLost(1)
      self:addGold(war.goldBet * 2)
    elseif rightKills > leftKills then
      targetGuild:addWarsWon(1)
      self:addWarsLost(1)
      targetGuild:addGold(war.goldBet * 2)
    else
      -- draw, return gold, no winners or losers
      self:addGold(war.goldBet)
      targetGuild:addGold(war.goldBet)
    end
  else
    self:addWarsWon(1)
    targetGuild:addWarsLost(1)
    self:addGold(war.goldBet * 2)
  end

  getTopGuilds(true)
  local players = Game.getPlayers()
  for _, player in ipairs(players) do
    player:fetchTopGuilds(0, false, true)
  end
end

function Guild:sendGold()
  local gold = {
    gold = self:getGold(),
    next = getGoldForLevel(self:getLevel() + 1)
  }
  local online = self:getMembersOnline()
  for _, member in ipairs(online) do
    member:sendGuildPacket("gold", gold)
  end
end

function Guild:sendPacifismStatus()
  local pacifism = {
    serverTime = os.mtime(),
    pacifism = self:getPacifism(),
    pacifismStatus = self:getPacifismStatus()
  }
  local online = self:getMembersOnline()
  for _, member in ipairs(online) do
    member:sendGuildPacket("pacifism", pacifism)
  end
end

function Guild:cooldownPacifism()
  self:setPacifism(self:getPacifism() + getPacifismCooldown()) -- cooldown starts from when pacifism should end
  self:setPacifismStatus(GUILDS_CFG.PACIFISM.EXHAUSTED)
  self:save()

  self:sendPacifismStatus()

  local pacifismUp = {
    guildId = self:getId(),
    pacifismStatus = self:getPacifismStatus()
  }
  local players = Game.getPlayers()
  for _, player in ipairs(players) do
    player:sendGuildPacket("pacifismUp", pacifismUp)
  end
end

function Guild:inactivePacifism()
  self:setPacifism(0)
  self:setPacifismStatus(GUILDS_CFG.PACIFISM.INACTIVE)
  self:save()

  self:sendPacifismStatus()

  local pacifismUp = {
    guildId = self:getId(),
    pacifismStatus = self:getPacifismStatus()
  }
  local players = Game.getPlayers()
  for _, player in ipairs(players) do
    player:sendGuildPacket("pacifismUp", pacifismUp)
  end
end

function Guild:getMaxMembers()
  return GUILDS_CFG.MEMBERS_START + ((self:getLevel() - 1) * GUILDS_CFG.MEMBERS_PER_LEVEL)
end

function getTopGuilds(force)
  if force or lastTopGuildsFetch + GUILDS_CFG.TOP_GUILDS_CACHE < os.time() then
    TopGuilds = {}
    lastTopGuildsFetch = os.time()
    local tempTopGuilds = {}
    local guilds = Game.getGuilds()
    for _, guild in ipairs(guilds) do
      local points = 0
      points = points + (guild:getLevel() * GUILDS_CFG.SCORE_GUILD_LEVEL)
      points = points + (guild:getMemberCount() * GUILDS_CFG.SCORE_MEMBERS_COUNT)
      points = points + (guild:getCombinedLevels() * GUILDS_CFG.SCORE_COMBINED_LEVELS)
      points = points + (guild:getWarsWon() * GUILDS_CFG.SCORE_WON_WARS)
      points = points - (guild:getWarsLost() * GUILDS_CFG.SCORE_LOST_WARS)
      points = math.floor(points + 0.5)
      table.insert(tempTopGuilds, {guildId = guild:getId(), points = points})
    end

    table.sort(
      tempTopGuilds,
      function(a, b)
        return a.points > b.points
      end
    )

    for _, tempTop in ipairs(tempTopGuilds) do
      TopGuilds[#TopGuilds + 1] = tempTop.guildId
    end
  end
end

function getGoldForLevel(level)
  if level <= 0 then
    level = 1
  end

  return math.floor((math.pow(level - 1, GUILDS_CFG.GOLD_FOR_LEVEL_VALUE)) + 0.5) * 10000
end

function rankHasPermission(perms, value)
  if perms == -1 then
    return true
  end

  return bit.band(perms, math.pow(2, value)) ~= 0
end
