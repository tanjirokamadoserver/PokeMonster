#pragma once
#include "protocol.h"

class NetworkMessage;
class OutputMessage;

class ProtocolCreateCharacter : public Protocol
{
	public:
		enum { server_sends_first = false };
		enum { protocol_identifier = 0x3 };
		enum { use_checksum = true };
		static const char* protocol_name() {
			return "create character protocol";
		}

		explicit ProtocolCreateCharacter(Connection_ptr connection) : Protocol(connection) {}

		void onRecvFirstMessage(NetworkMessage& msg) override;

	private:
		void disconnectClient(const std::string& message);
		void doCreateCharacter(const std::string& accountName, const std::string& password, const std::string& characterName, uint8_t playerSex, uint32_t connectionIp);
};
