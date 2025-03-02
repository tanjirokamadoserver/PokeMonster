// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_GUILD_H_C00F0A1D732E4BA88FF62ACBE74D76BC
#define FS_GUILD_H_C00F0A1D732E4BA88FF62ACBE74D76BC

#include "tools.h"

class Player;

struct GuildRank {
	uint32_t id;
	std::string name;
	int32_t permissions;
	bool isDefault;
	bool leader;
	bool removed;

	GuildRank(uint32_t id, std::string name, int32_t permissions, bool isDefault, bool leader = false, bool removed = false) :
		id(id), name(std::move(name)), permissions(permissions), isDefault(isDefault), leader(leader), removed(removed) {}
};

struct GuildMember {
	uint32_t guid;
	uint32_t vocationId;
	std::string name;
	std::string rank;
	uint32_t level;
	uint64_t lastLogin;
	uint64_t contribution;

	GuildMember(uint32_t guid, uint32_t vocationId, std::string name, std::string rank, uint32_t level, uint64_t lastLogin, uint64_t contribution) :
		guid(guid), vocationId(vocationId), name(std::move(name)), rank(std::move(rank)), level(level), lastLogin(lastLogin), contribution(contribution){}
};

// Guild Buffs Config
#define GUILD_BUFF_DEFENSE 3 // 3% 
#define GUILD_BUFF_ATTACK 5 // 5%

#define GUILD_BUFF_CRITICAL_CHANCE 5 // 5%
#define GUILD_BUFF_CRITICAL_DAMAGE 5 // 5%

#define GUILD_BUFF_PLAYER_SPEED 50 // +50
#define GUILD_BUFF_POKEMON_SPEED 40 // +40

#define GUILD_BUFF_CRITICAL_CATCH 10 // 10%
#define GUILD_BUFF_LUCKY 15 // 15%

#define GUILD_BUFF_DUNGEON_REWARD 10 // 10%
#define GUILD_BUFF_DUNGEON_EXP 50 // 50%

#define GUILD_BUFF_POKEMON_HEALTH 5 // 5%
#define GUILD_BUFF_BLOCK 5 // 5%

// Guild Buffs Config end

enum GuildBuffRow : uint8_t {
	COLUMN_1 = 0,
	COLUMN_2 = 1,
	COLUMN_3 = 2,
	COLUMN_4 = 3,
	COLUMN_5 = 4,
	COLUMN_6 = 5,
	COLUMN_7 = 6,
	COLUMN_8 = 7,
	COLUMN_9 = 8,
};

enum GuildBuffType : uint8_t {

	DEFENSE_BUFF = 1,
	ATTACK_BUFF = 2,

	CRITICAL_CHANCE_BUFF = 1,
	CRITICAL_DAMAGE_BUFF = 2,

	PLAYER_SPEED_BUFF = 1,
	POKEMON_SPEED_BUFF = 2,

	CRITICAL_CATCH_BUFF = 1,
	LUCKY_BUFF = 2,

	DUNGEON_REWARD_BUFF = 1,
	DUNGEON_EXP_BUFF = 2,

	POKEMON_HEALTH_BUFF = 1,
	BLOCK_CHANCE_BUFF = 2,
};

using GuildRank_ptr = std::shared_ptr<GuildRank>;
using GuildBuffsVec = std::vector<uint8_t>;

struct GuildWar {
	uint32_t id = 0;
	uint8_t status = 0;
	uint16_t kills = 0;
	uint16_t killsMax = 0;
	uint64_t goldBet = 0;
	time_t duration = 0;
	time_t started = 0;
	time_t ended = 0;
	bool forced = false;
	bool init = false;

	GuildWar() = default;
};
using GuildWarMap = std::map<uint32_t, GuildWar>;

class Guild
{
	public:
		Guild(uint32_t id, std::string name);

		void addMember(Player* player);
		void addMember(uint32_t guid, uint32_t vocationId, const std::string& name, const std::string& rank, uint32_t level, uint64_t lastLogin, uint64_t contribution = 0);
		void removeMember(Player* player);
		void removeMember(uint32_t guid);
		void updateMemberLevel(Player* player);
		void setMemberRank(uint32_t guid, uint32_t rankId);
		GuildRank_ptr getMemberRank(uint32_t guid);

		uint32_t getId() const {
			return m_iId;
		}
		const std::string& getName() const {
			return m_szName;
		}
		const std::list<Player*>& getMembersOnline() const {
			return m_vMembersOnline;
		}
		uint32_t getMemberCount() const {
			return m_iMemberCount;
		}
		void setMemberCount(uint32_t count) {
			m_iMemberCount = count;
		}
		const std::vector<GuildMember>& getMembers() const {
			return m_vMembers;
		}

		const std::vector<GuildRank_ptr>& getRanks() const {
			return m_vRanks;
		}
		GuildRank_ptr getDefaultRank();
		GuildRank_ptr getRankById(uint32_t rankId);
		GuildRank_ptr getRankByName(const std::string& name) const;
		void addRank(uint32_t rankId, const std::string& rankName, int32_t permissions, bool isDefault, bool leader = false);
		void editRank(uint32_t rankId, const std::string& rankName, int32_t permissions, bool isDefault);
		void removeRank(uint32_t rankId);

		const std::string& getMotd() const {
			return m_szMotd;
		}
		void setMotd(const std::string& motd) {
			this->m_szMotd = motd;
		}

		GuildBuffsVec getBuffs() const {
			return m_vBuffs;
		}
		void setBuff(uint8_t row, uint8_t buff);
		bool hasBuff(uint8_t row, uint8_t buff) {
			return m_vBuffs[row] == buff;
		}

		uint16_t getLevel() const {
			return m_iLevel;
		}
		void setLevel(uint16_t value) {
			m_iLevel = value;
		}

		uint64_t getGold() const {
			return m_iGold;
		}
		void setGold(uint64_t value) {
			m_iGold = value;
		}
		void addGold(uint64_t value) {
			m_iGold += value;
		}
		void removeGold(uint64_t value) {
			m_iGold -= value;
		}

		uint32_t getRequiredLevel() const {
			return m_iRequiredLevel;
		}
		void setRequiredLevel(uint32_t value) {
			m_iRequiredLevel = value;
		}

		uint16_t getEmblem() const {
			return m_iEmblem;
		}
		void setEmblem(uint16_t value) {
			m_iEmblem = value;
		}

		uint16_t getWarsWon() const {
			return m_iWarsWon;
		}
		void setWarsWon(uint16_t value) {
			m_iWarsWon = value;
		}
		void addWarsWon(uint16_t value) {
			m_iWarsWon += value;
		}

		uint16_t getWarsLost() const {
			return m_iWarsLost;
		}
		void setWarsLost(uint16_t value) {
			m_iWarsLost = value;
		}
		void addWarsLost(uint16_t value) {
			m_iWarsLost += value;
		}

		uint8_t getLanguage() const {
			return m_iLanguage;
		}
		void setLanguage(uint8_t value) {
			m_iLanguage = value;
		}

		uint8_t getJoinStatus() const {
			return m_iJoinStatus;
		}
		void setJoinStatus(uint8_t value) {
			m_iJoinStatus = value;
		}

		void setPacifism(int64_t pacifismEnd) {
			m_iPacifism = pacifismEnd;
		}
		int64_t getPacifism() const {
			return m_iPacifism;
		}
		bool isPacifist() const {
			return m_iPacifismStatus == 1 && m_iPacifism > OTSYS_TIME();
		}

		void setPacifismStatus(uint8_t status) {
			m_iPacifismStatus = status;
		}
		uint8_t getPacifismStatus() const {
			return m_iPacifismStatus;
		}

		uint32_t getCombinedLevels();

		const std::string& getLeaderName();
		void setLeaderName(const std::string& leaderName) {
			this->m_szLeaderName = leaderName;
			m_iLastLeaderName = OTSYS_TIME();
		}

		bool addWar(uint32_t guildId, GuildWar& war);
		bool removeWar(uint32_t guildId, bool remove = false);
		bool isInWar(uint32_t guildId);
		bool isInAnyWar(uint32_t guildId);
		bool isInAnyWar();
		GuildWar& getWar(uint32_t guildId) {
			return m_mGuildWars[guildId];
		}
		GuildWarMap& getWars() {
			return m_mGuildWars;
		}

		void updateGoldContribution(uint32_t guid, uint64_t gold);

		void setLastBuffSave(uint64_t value) {
			m_iLastBuffSave = value;
		}
		uint64_t getLastBuffSave() const {
			return m_iLastBuffSave;
		}

	private:
		std::list<Player*> m_vMembersOnline;
		std::vector<GuildMember> m_vMembers;
		std::vector<GuildRank_ptr> m_vRanks;
		GuildBuffsVec m_vBuffs;
		GuildWarMap m_mGuildWars;

		uint32_t m_iId;
		uint32_t m_iMemberCount = 0;
		uint32_t m_iRequiredLevel = 1;

		std::string m_szName;
		std::string m_szMotd;
		std::string m_szLeaderName;

		uint64_t m_iGold = 0;
		uint64_t m_iLastBuffSave = 0;

		int64_t m_iLastLeaderName = 0;
		int64_t m_iPacifism = 0;

		uint16_t m_iLevel = 1;
		uint16_t m_iEmblem = 1;
		uint16_t m_iWarsWon = 0;
		uint16_t m_iWarsLost = 0;

		uint8_t m_iLanguage = 1;
		uint8_t m_iJoinStatus = 1;
		uint8_t m_iPacifismStatus = 0;
};

namespace IOGuild
{
		bool saveGuild(const Guild* guild);
		uint32_t getGuildIdByName(const std::string& name);
		void getWarList(Guild* guild);
};

#endif
