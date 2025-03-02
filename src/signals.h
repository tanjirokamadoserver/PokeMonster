// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_SIGNALHANDLINGTHREAD_H_01C6BF08B0EFE9E200175D108CF0B35F
#define FS_SIGNALHANDLINGTHREAD_H_01C6BF08B0EFE9E200175D108CF0B35F

#include <boost/asio.hpp>

class Signals
{
	boost::asio::signal_set set;
	public:
		explicit Signals(boost::asio::io_service& service);

	private:
		void asyncWait();
		static void dispatchSignalHandler(int signal);

		static void sigbreakHandler();
		static void sigintHandler();
		static void sighupHandler();
		static void sigtermHandler();
		static void sigusr1Handler();
};

#endif
