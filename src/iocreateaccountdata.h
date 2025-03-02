#pragma once
#ifndef IOCREATEACCOUNTDATA_H
#define IOCREATEACCOUNTDATA_H

#include "account.h"
#include "player.h"
#include "database.h"
#include <regex>

class IOCreateAccountData
{
	public:
		static bool isAccountNameValid(const std::string& accountName);
		static bool isEmailValid(const std::string& email);
		static bool isPasswordValid(const std::string& password);
		static bool isPasswordConfirmationValid(const std::string& password, const std::string& passwordConfirmation);
		static bool doesAccountNameExist(const std::string& accountName);
		static bool doesEmailExist(const std::string& email);
		static bool insertAccount(const std::string& accountName, const std::string& email, const std::string& password, uint32_t ipAddress);
		static bool doesAccountIPExist(uint32_t ipAddress);

	private:
		static bool doesEntryExist(const std::string& fieldName, const std::string& entryValue);

};

#endif
