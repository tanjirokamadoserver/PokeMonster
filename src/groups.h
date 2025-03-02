// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
 
#ifndef FS_GROUPS_H_EE39438337D148E1983FB79D936DD8F3
#define FS_GROUPS_H_EE39438337D148E1983FB79D936DD8F3

#include "const.h"

struct Group {
	std::string name;
	uint64_t flags;
	uint32_t maxDepotItems;
	uint32_t maxVipEntries;
	uint16_t id;
	NameColor_t nameColor = NAMECOLOR_GREEN;
	bool access;
};

class Groups {
	public:
		bool load();
		Group* getGroup(uint16_t id);

	private:
		std::vector<Group> groups;
};

#endif
