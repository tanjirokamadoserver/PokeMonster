local NETWORK_ACTION = {
  ["fetch"] = function(player, data)
    player:fetchGuildsConfig()
    player:fetchGuildGeneral()
    player:fetchTopGuilds(0)
    player:fetchGuildInbox(0)
    player:fetchGuildWars()
  end,
  ["top"] = Player.fetchTopGuilds,
  ["inbox"] = Player.fetchGuildInbox,
  ["create"] = Player.createGuild,
  ["saveRanks"] = Player.saveGuildRanks,
  ["setRank"] = Player.setGuildMemberRank,
  ["invite"] = Player.invitePlayerToGuild,
  ["kick"] = Player.kickGuildMember,
  ["donate"] = Player.donateToGuild,
  ["levelUp"] = Player.levelUpGuild,
  ["settings"] = Player.updateGuildSettings,
  ["leave"] = Player.leaveGuild,
  ["accept"] = Player.acceptGuildMessage,
  ["reject"] = Player.rejectGuildMessage,
  ["request"] = Player.requestGuildJoin,
  ["buffs"] = Player.saveGuildBuffs,
  ["pacifist"] = Player.startPacifistMode,
  ["declaration"] = Player.declareGuildWar,
  ["revoke"] = Player.revokeGuildDeclaration,
  ["surrender"] = Player.surrenderGuildWar,
  ["passLeader"] = Player.passLeader
}

local ExtendedEvent = CreatureEvent("GuildsExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
  if opcode == GUILDS_CFG.EXTOPCODE then
    local json_status, json_data =
      pcall(
      function()
        return json.decode(buffer)
      end
    )

    if not json_status then
      g_logger.error("[Guild Management] JSON error: " .. json_data)
      return false
    end

    local action = json_data.action
    local data = json_data.data
    if NETWORK_ACTION[action] then
      NETWORK_ACTION[action](player, data)
    end
  end
end

ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()
