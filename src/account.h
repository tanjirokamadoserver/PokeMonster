// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_ACCOUNT_H_34817537BA2B4CB7B71AA562AFBB118F
#define FS_ACCOUNT_H_34817537BA2B4CB7B71AA562AFBB118F

#include "enums.h"

struct Account {
	std::vector<std::string> characters;
	std::string name;
	std::string key;
	time_t lastDay = 0;
	uint32_t id = 0;
	uint16_t premiumDays = 0;
	AccountType_t accountType = ACCOUNT_TYPE_NORMAL;

	Account() = default;
};

#endif
