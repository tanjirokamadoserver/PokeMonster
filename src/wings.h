// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_WINGS_H
#define FS_WINGS_H

struct Wing
{
	Wing(uint8_t id, uint16_t clientId, std::string name, int32_t speed, bool premium) :
		name(std::move(name)), speed(speed), clientId(clientId), id(id), premium(premium) {}

	std::string name;
	int32_t speed;
	uint16_t clientId;
	uint8_t id;
	bool premium;
};

class Wings
{
	public:
		bool reload();
		bool loadFromXml();
		Wing* getWingByID(uint8_t id);
		Wing* getWingByName(const std::string& name);
		Wing* getWingByClientID(uint16_t clientId);

		const std::vector<Wing>& getWings() const {
			return wings;
		}

	private:
		std::vector<Wing> wings;
};

#endif