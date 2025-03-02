// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_PROTOCOL_H_D71405071ACF4137A4B1203899DE80E1
#define FS_PROTOCOL_H_D71405071ACF4137A4B1203899DE80E1

#include <zlib.h>

#include "connection.h"
#include "xtea.h"

class Protocol : public std::enable_shared_from_this<Protocol>
{
	public:
		explicit Protocol(Connection_ptr connection) : connection(connection) {}
		virtual ~Protocol();

		// non-copyable
		Protocol(const Protocol&) = delete;
		Protocol& operator=(const Protocol&) = delete;

		virtual void parsePacket(NetworkMessage&) {}

		virtual void onSendMessage(const OutputMessage_ptr& msg) const;
		void onRecvMessage(NetworkMessage& msg);
		virtual void onRecvFirstMessage(NetworkMessage& msg) = 0;
		virtual void onConnect() {}

		bool isConnectionExpired() const {
			return connection.expired();
		}

		Connection_ptr getConnection() const {
			return connection.lock();
		}

		uint32_t getIP() const;

		//Use this function for autosend messages only
		OutputMessage_ptr getOutputBuffer(int32_t size);

		OutputMessage_ptr& getCurrentBuffer() {
			return outputBuffer;
		}

		void send(OutputMessage_ptr msg) const {
			if (auto connection = getConnection()) {
				connection->send(msg);
			}
		}

	protected:
		void disconnect() const {
			if (auto connection = getConnection()) {
				connection->close();
			}
		}
		void enableXTEAEncryption() {
			encryptionEnabled = true;
		}
		void setXTEAKey(xtea::key key) {
			this->key = std::move(key);
		}
		void disableChecksum() {
			checksumEnabled = false;
		}

		static bool RSA_decrypt(NetworkMessage& msg);

		void setRawMessages(bool value) {
			rawMessages = value;
		}

		void enableCompression();
	
		virtual void release() {}
		
	private:
		void XTEA_encrypt(OutputMessage& msg) const;
		bool XTEA_decrypt(NetworkMessage& msg) const;
		void compress(OutputMessage& msg) const;
		friend class Connection;

		OutputMessage_ptr outputBuffer;

		const ConnectionWeak_ptr connection;
		xtea::key key;
		bool encryptionEnabled = false;
		bool checksumEnabled = true;
		bool rawMessages = false;
		bool compression = false;
		mutable z_stream zstream = {0};
};

#endif
