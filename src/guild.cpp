// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "guild.h"
#include "configmanager.h"
#include "game.h"

#include <fmt/format.h>

extern ConfigManager g_config;
extern Game g_game;

Guild::Guild(uint32_t id, std::string name) : m_iId(id), m_szName(std::move(name)) {
	m_vBuffs.resize(9);
}

void Guild::addMember(Player* player)
{
	m_vMembersOnline.push_back(player);
	for (Player* member : m_vMembersOnline) {
		g_game.updatePlayerHelpers(*member);
	}

	for (auto& member : m_vMembers) {
		if (member.guid == player->getGUID()) {
			member.lastLogin = player->getLastLoginSaved();
			break;
		}
	}
}

void Guild::removeMember(Player* player)
{
	m_vMembersOnline.remove(player);
	for (Player* member : m_vMembersOnline) {
		g_game.updatePlayerHelpers(*member);
	}
	g_game.updatePlayerHelpers(*player);
}

GuildRank_ptr Guild::getDefaultRank()
{
	for (auto rank : m_vRanks) {
		if (rank->isDefault) {
			return rank;
		}
	}
	return nullptr;
}

GuildRank_ptr Guild::getRankById(uint32_t rankId)
{
	for (auto rank : m_vRanks) {
		if (rank->id == rankId) {
			return rank;
		}
	}
	return nullptr;
}

GuildRank_ptr Guild::getRankByName(const std::string& name) const
{
	for (auto rank : m_vRanks) {
		if (rank->name == name) {
			return rank;
		}
	}
	return nullptr;
}

void Guild::addRank(uint32_t rankId, const std::string& rankName, int32_t permissions, bool isDefault, bool leader)
{
	m_vRanks.emplace_back(std::make_shared<GuildRank>(rankId, rankName, permissions, isDefault, leader));
}

void Guild::editRank(uint32_t rankId, const std::string& rankName, int32_t permissions, bool isDefault)
{
	if (isDefault) {
		for (auto rank : m_vRanks) {
			if (rank->isDefault) {
				rank->isDefault = false;
				break;
			}
		}
	}

	for (auto rank : m_vRanks) {
		if (rank->id == rankId) {
			for (auto& member : m_vMembers) {
				if (member.rank != rankName && member.rank == rank->name) {
					member.rank = rankName;
				}
			}
			rank->name = rankName;
			rank->permissions = permissions;
			rank->isDefault = isDefault;
			break;
		}
	}
}

void Guild::removeRank(uint32_t rankId)
{
	for (auto rank : m_vRanks) {
		if (rank->id == rankId) {
			if (rank->isDefault) {
				return;
			}

			rank->removed = true;
			break;
		}
	}
}

void Guild::addMember(uint32_t guid, uint32_t vocationId, const std::string& name, const std::string& rank, uint32_t level, uint64_t lastLogin, uint64_t contribution)
{
	m_vMembers.emplace_back(guid, vocationId, name, rank, level, lastLogin, contribution);
	m_iMemberCount++;
}

void Guild::removeMember(uint32_t guid)
{
	m_vMembers.erase(std::remove_if(m_vMembers.begin(), m_vMembers.end(), [guid](const GuildMember& m) { return m.guid == guid; }), m_vMembers.end());
	m_iMemberCount--;
}

void Guild::updateMemberLevel(Player* player)
{
	for (auto& member : m_vMembers) {
		if (member.guid == player->getGUID()) {
			member.level = player->getLevel();
			break;
		}
	}
}

void Guild::setMemberRank(uint32_t guid, uint32_t rankId)
{
	for (auto& member : m_vMembers) {
		if (member.guid == guid) {
			member.rank = getRankById(rankId)->name;
			break;
		}
	}
}

GuildRank_ptr Guild::getMemberRank(uint32_t guid)
{
	for (auto member : m_vMembers) {
		if (member.guid == guid) {
			return getRankByName(member.rank);
		}
	}
	return nullptr;
}

uint32_t Guild::getCombinedLevels()
{
	uint32_t combinedLevels = 0;
	for (auto& member : m_vMembers) {
		combinedLevels += member.level;
	}
	
	return combinedLevels;
}

const std::string& Guild::getLeaderName()
{
	if (m_iLastLeaderName + g_config.getNumber(ConfigManager::GUILDS_CACHE_TIME) < OTSYS_TIME()) {
		m_iLastLeaderName = OTSYS_TIME();

		Database& db = Database::getInstance();
		DBResult_ptr result = db.storeQuery(fmt::format("SELECT `players`.name AS leader FROM `players` INNER JOIN `guild_members` AS `gm` ON `players`.id = `gm`.player_id AND `gm`.leader = 1 AND `gm`.guild_id = {:d}", getId()));
		if (!result) {
			return m_szLeaderName;
		}

		m_szLeaderName = std::move(result->getString("leader"));
	}

	return m_szLeaderName;
}

void Guild::setBuff(uint8_t row, uint8_t buff)
{
	m_vBuffs[row] = buff;

	// if (row == DEFENSIVE_1) {
	// 	for (auto member : m_vMembersOnline) {
	// 		member->updateRegeneration();
	// 	}
	// }
}

bool Guild::addWar(uint32_t guildId, GuildWar& war)
{
	if (isInAnyWar(guildId))
		return false;

	m_mGuildWars.emplace(guildId, std::move(war));
	return true;
}

bool Guild::removeWar(uint32_t guildId, bool remove)
{
	if (!isInAnyWar(guildId))
		return false;

	if (remove) {
		Database& db = Database::getInstance();
		if (!db.executeQuery(fmt::format("DELETE FROM guild_wars WHERE ((guild1 = {:d} AND guild2 = {:d}) OR (guild1 = {:d} AND guild2 = {:d})) AND status = 0", getId(), guildId, guildId, getId())))
			return false;
	}

	m_mGuildWars.erase(guildId);
	return true;
}

bool Guild::isInWar(uint32_t guildId)
{
	if (m_mGuildWars.find(guildId) == m_mGuildWars.end())
		return false;

	const auto& war = getWar(guildId);
	if (war.status != 2)
		return false;

	return true;
}

bool Guild::isInAnyWar(uint32_t guildId)
{
	if (m_mGuildWars.find(guildId) == m_mGuildWars.end())
		return false;

	const auto& war = getWar(guildId);
	if (war.status == 3)
		return false;

	return true;
}

bool Guild::isInAnyWar()
{
	for (const auto& war : m_mGuildWars) {
		if (war.second.status == 2)
			return true;
	}

	return false;
}

void Guild::updateGoldContribution(uint32_t guid, uint64_t gold)
{
	for (auto& member : m_vMembers) {
		if (member.guid == guid) {
			member.contribution = gold;
			break;
		}
	}
}

bool IOGuild::saveGuild(const Guild* guild)
{
	if (!guild) return false;

	Database& db = Database::getInstance();

	PropWriteStream propWriteStream;
	for (uint8_t type : guild->getBuffs()) {
		propWriteStream.write<uint8_t>(type);
	}

	size_t buffsSize;
	const char* buffs = propWriteStream.getStream(buffsSize);

	if (!db.executeQuery(fmt::format("UPDATE `guilds` SET `level` = {:d}, `gold` = {:d}, `required_level` = {:d}, `emblem` = {:d}, `wars_won` = {:d}, `wars_lost` = {:d}, `language` = {:d}, `join_status` = {:d}, `motd` = {:s}, `buffs` = {:s}, `pacifism` = {:d}, `pacifism_status` = {:d}, `buffs_save` = {:d} WHERE `id` = {:d}",
		guild->getLevel(), guild->getGold(), guild->getRequiredLevel(), guild->getEmblem(), guild->getWarsWon(), guild->getWarsLost(),
		static_cast<uint16_t>(guild->getLanguage()), static_cast<uint16_t>(guild->getJoinStatus()), db.escapeString(guild->getMotd()), db.escapeBlob(buffs, buffsSize), guild->getPacifism(), static_cast<uint16_t>(guild->getPacifismStatus()), guild->getLastBuffSave(), guild->getId())))
		return false;

	for (auto member : guild->getMembers()) {
		auto rank = guild->getRankByName(member.rank);
		if (rank) {
			if (!db.executeQuery(fmt::format("UPDATE guild_members SET rank_id = {:d} WHERE player_id = {:d} AND guild_id = {:d}", rank->id, member.guid, guild->getId())))
				return false;
		}
	}

	for (auto rank : guild->getRanks()) {
		if (rank->removed) {
			if (!db.executeQuery(fmt::format("DELETE FROM guild_ranks WHERE id = {:d}", rank->id)))
				return false;
		}
		else {
			if (!db.executeQuery(fmt::format("UPDATE guild_ranks SET `name` = {:s}, permissions = {:d}, `default` = {:d} WHERE id = {:d}", db.escapeString(rank->name), rank->permissions, static_cast<uint16_t>(rank->isDefault), rank->id)))
				return false;
		}
	}

	return true;
}

uint32_t IOGuild::getGuildIdByName(const std::string& name)
{
	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `id` FROM `guilds` WHERE `name` = {:s}", db.escapeString(name)));
	if (!result) {
		return 0;
	}
	return result->getNumber<uint32_t>("id");
}

void IOGuild::getWarList(Guild* guild)
{
	uint32_t guildId = guild->getId();
	DBResult_ptr result = Database::getInstance().storeQuery(
		fmt::format("SELECT w.*, COUNT(k.`id`) AS `kills` FROM `guild_wars` AS w LEFT JOIN `guildwar_kills` AS k ON k.`killerguild` = {:d} WHERE (w.`guild1` = {:d} OR w.`guild2` = {:d}) AND `status` != 3 GROUP BY w.id",
			guildId, guildId, guildId)
	);
	if (!result) {
		return;
	}

	do {
		uint32_t guild1 = result->getNumber<uint32_t>("guild1");
		uint32_t guild2 = result->getNumber<uint32_t>("guild2");
		GuildWar war;
		war.id = result->getNumber<uint32_t>("id");
		war.status = result->getNumber<uint16_t>("status");
		war.kills = result->getNumber<uint16_t>("kills");
		war.killsMax = result->getNumber<uint16_t>("killsMax");
		war.goldBet = result->getNumber<uint64_t>("goldBet");
		war.duration = result->getNumber<time_t>("duration");
		war.started = result->getNumber<time_t>("started");
		war.ended = result->getNumber<time_t>("ended");
		war.forced = result->getNumber<uint16_t>("forced") == 1;
		if (guildId != guild1) {
			war.init = false;
			guild->addWar(guild1, war);
		}
		else {
			war.init = true;
			guild->addWar(guild2, war);
		}
	} while (result->next());
}
