#include "otpch.h"
#include "iocreatecharacterdata.h"
#include "game.h"
#include "configmanager.h"
#include <fmt/format.h>

extern Game g_game;
extern ConfigManager g_config;

bool IOCreateCharacterData::isCharacterNameValid(const std::string& characterName) {
    return std::regex_match(characterName, std::regex("^[a-zA-Z]+( [a-zA-Z]+)*$"));
}

bool IOCreateCharacterData::doesCharacterNameExist(const std::string& characterName) {
	Database& db = Database::getInstance();
	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `id` FROM `players` WHERE `name` = {:s}", db.escapeString(characterName)));

	if (result) {
		return true;
	}

    //result = db.storeQuery(fmt::format("SELECT `player_id` FROM `player_oldnames` WHERE `oldname` = {:s}", db.escapeString(characterName)));
    //if (result) {
    //    return true;
   // }

	return false;
}

bool IOCreateCharacterData::insertCharacter(const Account account, const std::string& characterName, uint8_t playerSex, uint32_t connectionIp) {
    Database& db = Database::getInstance();
    std::cout << characterName << std::endl;
    std::string name = g_game.humanCase(characterName);
    trimString(name);

    int lookType = (playerSex == 0) ? g_config.getNumber(ConfigManager::FEMALE_OUTFIT)  : (playerSex == 1) ? g_config.getNumber(ConfigManager::MALE_OUTFIT)  : 0;

    // Use normal_random(param1, param2) para gerar valores aleatórios entre 0 e 132
    int lookbody = normal_random(0, 132);
    int lookfeet = normal_random(0, 132);
    int lookhead = normal_random(0, 132);
    int looklegs = normal_random(0, 132);

    if (db.executeQuery(fmt::format("INSERT INTO `players` SET `name` = {:s}, `account_id` = {:d}, `lastip` = {:d}, `sex` = {:d}, `creationdate` = {:d}, `lookType` = {:d}, `lookbody` = {:d}, `lookfeet` = {:d}, `lookhead` = {:d}, `looklegs` = {:d}, `level` = {:d}", db.escapeString(name), account.id, connectionIp, playerSex, time(nullptr), lookType, lookbody, lookfeet, lookhead, looklegs, 8))) {
       // uint32_t playerGUID = db.getLastInsertId();
        //sendFirstItens(playerGUID);
        return true;
    }

    return false;
}


bool IOCreateCharacterData::doesCharacterIPExist(uint32_t ipAddress) {
    Database& db = Database::getInstance();
    DBResult_ptr result = db.storeQuery(fmt::format("SELECT `id` FROM `players` WHERE `lastip` = {:d} AND `creationdate` >= {:d}", ipAddress, time(nullptr) - 300));
    if (result) {
        return true;
    }

    return false;
}

void IOCreateCharacterData::sendFirstItens(uint32_t playerGUID) {
	std::list<std::array<int, 4>> playerItems {
		{101, 1, 2120, 1},
    	{102, 2, 2580, 1},
    	{103, 3, 1987, 1},
    	{104, 4, 2550, 1},
    	{105, 5, 1988, 1},
    	{106, 6, 2382, 1},
    	{107, 7, 8495, 1}
    };
    Database& db = Database::getInstance();
    for (const auto &playerItem : playerItems)
		db.executeQuery(fmt::format("INSERT INTO `player_items` SET `player_id` = {:d}, `sid` = {:d}, `pid` = {:d}, `itemtype` = {:d}, `count` = {:d}, `attributes` = ''", playerGUID, playerItem[0], playerItem[1], playerItem[2], playerItem[3]));
}