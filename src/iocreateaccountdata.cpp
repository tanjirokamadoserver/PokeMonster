#include "otpch.h"
#include "iocreateaccountdata.h"
#include "configmanager.h"
#include "game.h"
#include <fmt/format.h>

bool IOCreateAccountData::isAccountNameValid(const std::string& accountName) {
    return std::regex_match(accountName, std::regex("^[a-zA-Z0-9]{6,}$"));
}

bool IOCreateAccountData::isEmailValid(const std::string& email) {
	return std::regex_match(email, std::regex("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)"));
}

bool IOCreateAccountData::isPasswordValid(const std::string& password) {
	return password.length() >= 5 && password.length() <= 15;
}

bool IOCreateAccountData::isPasswordConfirmationValid(const std::string& password, const std::string& passwordConfirmation) {
	return password == passwordConfirmation;
}

bool IOCreateAccountData::doesEmailExist(const std::string& email) {
	return doesEntryExist("email", email);
}

bool IOCreateAccountData::doesAccountNameExist(const std::string& accountName) {
	return doesEntryExist("name", accountName);
}

bool IOCreateAccountData::insertAccount(const std::string& accountName, const std::string& email, const std::string& password, uint32_t ipAddress) {
	Database& db = Database::getInstance();
	if (db.executeQuery(fmt::format("INSERT INTO `accounts` SET `name` = {:s}, `email` = {:s}, `password` = {:s}, `creation` = {:d}, `creationIp` = {:d}", db.escapeString(accountName), db.escapeString(email), db.escapeString(transformToSHA1(password)), time(nullptr), ipAddress))) {
		return true;
	}

	return false;
}

bool IOCreateAccountData::doesEntryExist(const std::string& fieldName, const std::string& entryValue) {
	Database& db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id` FROM `accounts` WHERE `" << fieldName << "` = " << db.escapeString(entryValue);
	DBResult_ptr result = db.storeQuery(query.str());

	if (result) {
		return true;
	}

	return false;
}

bool IOCreateAccountData::doesAccountIPExist(uint32_t ipAddress) {
    Database& db = Database::getInstance();
    DBResult_ptr result = db.storeQuery(fmt::format("SELECT `id` FROM `accounts` WHERE `creationIp` = {:d} AND `creation` >= {:d}", ipAddress, time(nullptr) - 300));
    if (result) {
        return true;
    }

    return false;
}