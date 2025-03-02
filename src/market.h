#pragma once

#include "otpch.h"
#include "database.h"

enum MarketCurrency_t : uint8_t {
	MONEY = 0,
	DIAMOND = 1,
};

enum MarketCategory_t : uint8_t {
	Helds = 1,
	Potions = 2,
	Pokeballs = 3,
	Pokemons = 4,
	ValuableItem = 5,
};

struct PokeballAttributes { 
	std::string name;
	uint16_t boost;
	uint16_t heldX;
	uint16_t heldY;
	uint16_t heldU;
	std::vector<uint16_t> addons;
};

struct MarketItem {
	std::string attributes;
	std::string itemName;
	std::string playerName;

    uint16_t amount;
	uint16_t category;
	uint16_t itemtype;

    uint32_t id;
	uint32_t playerId;
	
    uint64_t price;
	int64_t created;

    bool anonymous;
	bool expired;

	MarketCurrency_t currency;
	size_t attributesSize;
	PokeballAttributes pokeballAttributes;
};

using MarketItemMap = std::unordered_map<uint32_t, MarketItem>;
using MarketItemPlayer = std::unordered_map<uint32_t, std::vector<uint32_t>>;


#include "enums.h"
#include "database.h"

class IOMarket
{
	public:
		static IOMarket& getInstance() {
			static IOMarket instance;
			return instance;
		}
    
        static MarketItemMap getMarketItems() { return marketItems; }
		static std::vector<uint32_t> getPlayerItems(uint32_t guid) { return playerItems[guid]; }

		static MarketItemMap getMarketItemsPage(uint32_t page, uint32_t pageSize);
		static std::vector<uint32_t> getPlayerMarketItemsPage(uint32_t guid, uint32_t page, uint32_t pageSize);

        static void loadMarketItems();
		static void addMarketItem(MarketItem newItem);
		static void recalculateLastIdIncrement();
		static void saveMarketItems();
		static MarketItem getMarketItem(uint32_t id) { return marketItems[id]; }
		static void updateMarketItemAmount(uint32_t id, uint16_t amount) { marketItems[id].amount = amount; }
		static void setMarketItemExpired(uint32_t id) { marketItems[id].expired = true; }

		static size_t getMarketItemsSize();
		static size_t getPlayerItemsSize(uint32_t guid) { return playerItems[guid].size(); }

		static MarketItemMap getMarketItemsByNameAndCategory(std::string nameToFind, uint16_t category, uint16_t page, uint16_t pageSize);
		static size_t getMarketItemsByNameAndCategorySize(std::string nameToFind, uint16_t category);

		static void removeMarketItem(uint32_t id);
	private:
		IOMarket() = default;
		static uint32_t lastIdIncrement;
        static MarketItemMap marketItems;
		static MarketItemPlayer playerItems;
};