#ifndef PROTOCOLCREATEACCOUNT_H
#define PROTOCOLCREATEACCOUNT_H

#include "protocol.h"

class NetworkMessage;
class OutputMessage;

class ProtocolCreateAccount : public Protocol
{
	public:
		// static protocol information
		enum { server_sends_first = false };
		enum { protocol_identifier = 0x2 };
		enum { use_checksum = true };
		static const char* protocol_name() {
			return "create account protocol";
		}

		explicit ProtocolCreateAccount(Connection_ptr connection) : Protocol(connection) {}

		void onRecvFirstMessage(NetworkMessage& msg) override;


	private:
		void disconnectClient(const std::string& message);
		void doCreateAccount(const std::string& accountName, const std::string& email, const std::string& password, const std::string& passwordConfirmation, uint32_t connectionIp);
		
};

#endif