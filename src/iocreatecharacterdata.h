#pragma once
#include "database.h"
#include "account.h"
#include <regex>

class IOCreateCharacterData
{
	public:
		static bool isCharacterNameValid(const std::string& characterName);
		static bool doesCharacterNameExist(const std::string& characterName);

		static bool insertCharacter(const Account account, const std::string& characterName, uint8_t playerSex, uint32_t connectionIp);
		static bool doesCharacterIPExist(uint32_t ipAddress);
	private:

		static void sendFirstItens(uint32_t playerGUID);

};
