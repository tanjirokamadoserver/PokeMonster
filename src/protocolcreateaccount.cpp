#include "otpch.h"

#include "protocolcreateaccount.h"

#include "outputmessage.h"
#include "tasks.h"

#include "configmanager.h"
#include "iocreateaccountdata.h"
#include "ban.h"
#include "game.h"

#include <fmt/format.h>

extern ConfigManager g_config;
extern Game g_game;

void ProtocolCreateAccount::disconnectClient(const std::string& message)
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0xFF);
	output->addString(message);
	send(output);
	disconnect();
}

void ProtocolCreateAccount::doCreateAccount(const std::string& accountName, const std::string& email, const std::string& password, const std::string& passwordConfirmation, uint32_t connectionIp)
{
	if (!IOCreateAccountData::isAccountNameValid(accountName)) {
		disconnectClient("Account name is invalid.");
		return;
	}

	if (IOCreateAccountData::doesAccountNameExist(accountName)) {
		disconnectClient("Account name already exist.");
		return;
	}

	if (!IOCreateAccountData::isEmailValid(email)) {
		disconnectClient("Email is invalid.");
		return;
	}

	if (IOCreateAccountData::doesEmailExist(email)) {
		disconnectClient("Email already exist.");
		return;
	}

	if (!IOCreateAccountData::isPasswordValid(password)) {
		disconnectClient("Password is invalid.");
		return;
	}

	if (!IOCreateAccountData::isPasswordConfirmationValid(password, passwordConfirmation)) {
		disconnectClient("Password Confirmation is invalid.");
		return;
	}

	if (!IOCreateAccountData::insertAccount(accountName, email, password, connectionIp)) {
		disconnectClient("Something went wrong, please contact administrator!");
		return;
	}
	
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(0xFF);
	output->addString("Congratulations, your account has been created");

	send(output);

	disconnect();
}

void ProtocolCreateAccount::onRecvFirstMessage(NetworkMessage& msg)
{
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}
	uint16_t version = msg.get<uint16_t>();

	if (version <= 760) {
		disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR));
		return;
	}


	if (!Protocol::RSA_decrypt(msg)) {
		disconnect();
		return;
	}

	xtea::key key;
	key[0] = msg.get<uint32_t>();
	key[1] = msg.get<uint32_t>();
	key[2] = msg.get<uint32_t>();
	key[3] = msg.get<uint32_t>();
	enableXTEAEncryption();
	setXTEAKey(std::move(key));

	if (version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX) {
		disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", CLIENT_VERSION_STR));
		return;
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	auto connection = getConnection();
	if (!connection) {
		return;
	}
	uint32_t connectionIp = connection->getIP();
	if (IOBan::isIpBanned(connectionIp, banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		disconnectClient(fmt::format("Your IP has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
		return;
	}

	if (IOCreateAccountData::doesAccountIPExist(connectionIp)) {
		disconnectClient("Please wait 5 minutes to create other account.");
		return;
	}

	std::string accountName = msg.getString();
	if (accountName.empty()) {
		disconnectClient("Invalid account name.");
		return;
	}

	std::string email = msg.getString();
	if (email.empty()) {
		disconnectClient("Invalid email");
		return;
	}

	std::string password = msg.getString();
	if (password.empty()) {
		disconnectClient("Invalid password.");
		return;
	}

	std::string passwordConfirmation = msg.getString();
	if (passwordConfirmation.empty()) {
		disconnectClient("Invalid password confirmation.");
		return;
	}
	auto thisPtr = std::static_pointer_cast<ProtocolCreateAccount>(shared_from_this());
	g_dispatcher.addTask(createTask(std::bind(&ProtocolCreateAccount::doCreateAccount, thisPtr, accountName, email, password, passwordConfirmation, connectionIp)));
}
