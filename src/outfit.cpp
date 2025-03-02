// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "outfit.h"

#include "pugicast.h"
#include "tools.h"

bool Outfits::reload()
{
	for (auto &outfitsVector : outfits) {
		outfitsVector.clear();
	}
	std::cout << "Reloading outfits..." << std::endl;
	return loadFromXml();
}

bool Outfits::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/outfits.xml");
	if (!result) {
		printXMLError("Error - Outfits::loadFromXml", "data/XML/outfits.xml", result);
		return false;
	}

	outfits[PLAYERSEX_FEMALE].clear();
	outfits[PLAYERSEX_MALE].clear();

	for (auto outfitNode : doc.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			std::cout << "[Warning - Outfits::loadFromXml] Missing outfit type: " << outfitNode.attribute("name").as_string() << std::endl;
			continue;
		}

		uint16_t type = pugi::cast<uint16_t>(attr.value());
		if (type > PLAYERSEX_LAST) {
			std::cout << "[Warning - Outfits::loadFromXml] Invalid outfit type " << type << "." << std::endl;
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		if (!lookTypeAttribute) {
			std::cout << "[Warning - Outfits::loadFromXml] Missing looktype on outfit." << std::endl;
			continue;
		}

		outfits[type].emplace_back(
			outfitNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true)
		);
	}
	return true;
}

const Outfit* Outfits::getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const
{
	for (const Outfit& outfit : outfits[sex]) {
		if (outfit.lookType == lookType) {
			return &outfit;
		}
	}
	return nullptr;
}
