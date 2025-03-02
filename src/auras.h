// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_AURAS_H
#define FS_AURAS_H

struct Aura
{
	Aura(uint8_t id, uint16_t clientId, std::string name, int32_t speed, bool premium) :
		name(std::move(name)), speed(speed), clientId(clientId), id(id), premium(premium) {}

	std::string name;
	int32_t speed;
	uint16_t clientId;
	uint8_t id;
	bool premium;
};

class Auras
{
	public:
		bool reload();
		bool loadFromXml();
		Aura* getAuraByID(uint8_t id);
		Aura* getAuraByName(const std::string& name);
		Aura* getAuraByClientID(uint16_t clientId);

		const std::vector<Aura>& getAuras() const {
			return auras;
		}

	private:
		std::vector<Aura> auras;
};

#endif