// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_CONFIGMANAGER_H_6BDD23BD0B8344F4B7C40E8BE6AF6F39
#define FS_CONFIGMANAGER_H_6BDD23BD0B8344F4B7C40E8BE6AF6F39

#include <lua.hpp>

class ConfigManager
{
	public:
		ConfigManager();
		enum boolean_config_t {
			ALLOW_CHANGEOUTFIT,
			ONE_PLAYER_ON_ACCOUNT,
			AIMBOT_HOTKEY_ENABLED,
			REMOVE_RUNE_CHARGES,
			EXPERIENCE_FROM_PLAYERS,
			FREE_PREMIUM,
			REPLACE_KICK_ON_LOGIN,
			ALLOW_CLONES,
			BIND_ONLY_GLOBAL_ADDRESS,
			OPTIMIZE_DATABASE,
			EMOTE_SPELLS,
			STAMINA_SYSTEM,
			WARN_UNSAFE_SCRIPTS,
			CONVERT_UNSAFE_SCRIPTS,
			FORCE_MONSTERTYPE_LOAD,
			CLASSIC_EQUIPMENT_SLOTS,
			CLEAN_PROTECTION_ZONES,
			PACKET_COMPRESSION,
			SCRIPTS_CONSOLE_LOGS,
			CLASSIC_ATTACK_SPEED,
			SERVER_SAVE_NOTIFY_MESSAGE,
			SERVER_SAVE_CLEAN_MAP,
			SERVER_SAVE_CLOSE,
			SERVER_SAVE_SHUTDOWN,
			ONLINE_OFFLINE_CHARLIST,
			YELL_ALLOW_PREMIUM,

			LAST_BOOLEAN_CONFIG /* this must be the last one */
		};

		enum double_config_t { //pota
			MONSTERLEVEL_BONUSEXP,
			MONSTERLEVEL_BONUSDMG,
			MONSTERLEVEL_BONUSSPEED,
			MONSTERLEVEL_BONUSLOOT,
			MONSTERLEVEL_BONUSHEALTH,

			LAST_DOUBLE_CONFIG
		};

		enum string_config_t {
			// DUMMY_STR,
			MAP_NAME,
			HOUSE_RENT_PERIOD,
			SERVER_NAME,
			OWNER_NAME,
			OWNER_EMAIL,
			URL,
			LOCATION,
			IP,
			MOTD,
			WORLD_TYPE,
			MYSQL_HOST,
			MYSQL_USER,
			MYSQL_PASS,
			MYSQL_DB,
			MYSQL_SOCK,
			DEFAULT_PRIORITY,
			MAP_AUTHOR,
			CONFIG_FILE,
			MONSTERLEVEL_PREFIX, //pota

			LAST_STRING_CONFIG /* this must be the last one */
		};

		enum integer_config_t {
			SQL_PORT,
			MAX_PLAYERS,
			PZ_LOCKED,
			DEFAULT_DESPAWNRANGE,
			DEFAULT_DESPAWNRADIUS,
			RATE_EXPERIENCE,
			RATE_SKILL,
			RATE_LOOT,
			RATE_MAGIC,
			RATE_SPAWN,
			HOUSE_PRICE,
			KILLS_TO_RED,
			KILLS_TO_BLACK,
			MAX_MESSAGEBUFFER,
			ACTIONS_DELAY_INTERVAL,
			EX_ACTIONS_DELAY_INTERVAL,
			KICK_AFTER_MINUTES,
			PROTECTION_LEVEL,
			DEATH_LOSE_PERCENT,
			STATUSQUERY_TIMEOUT,
			FRAG_TIME,
			WHITE_SKULL_TIME,
			GAME_PORT,
			CREATEACCOUNT_PORT,
			CREATECHARACTER_PORT,
			LOGIN_PORT,
			STATUS_PORT,
			STAIRHOP_DELAY,
			EXP_FROM_PLAYERS_LEVEL_RANGE,
			MAX_PACKETS_PER_SECOND,
			SERVER_SAVE_NOTIFY_DURATION,
			YELL_MINIMUM_LEVEL,
			MALE_OUTFIT,
			FEMALE_OUTFIT,
			STATS_DUMP_INTERVAL,
			STATS_SLOW_LOG_TIME,
			STATS_VERY_SLOW_LOG_TIME,
			GUILDS_CACHE_TIME,

			LAST_INTEGER_CONFIG /* this must be the last one */
		};

		bool load();
		bool reload();

		const std::string& getString(string_config_t what) const;
		int32_t getNumber(integer_config_t what) const;
		bool getBoolean(boolean_config_t what) const;
		double getDouble(double_config_t what) const; //pota

	private:
		// static std::string getGlobalString(lua_State* L, const char* identifier, const char* defaultValue);
		// static int32_t getGlobalNumber(lua_State* L, const char* identifier, const int32_t defaultValue = 0);
		// static bool getGlobalBoolean(lua_State* L, const char* identifier, const bool defaultValue);
		
		static double getGlobalDouble(lua_State* L, const char* identifier, const double defaultValue = 0.0); //pota

		std::string string[LAST_STRING_CONFIG] = {};
		int32_t integer[LAST_INTEGER_CONFIG] = {};
		bool boolean[LAST_BOOLEAN_CONFIG] = {};
		double decimal[LAST_DOUBLE_CONFIG] = {}; //pota

		bool loaded = false;
};

#endif
