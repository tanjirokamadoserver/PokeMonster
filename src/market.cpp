#include "otpch.h"

#include "market.h"
#include "configmanager.h"
#include "databasetasks.h"
#include "iologindata.h"
#include "game.h"
#include "scheduler.h"

#include <fmt/format.h>

extern ConfigManager g_config;
extern Game g_game;

MarketItemMap IOMarket::marketItems;
MarketItemPlayer IOMarket::playerItems;

uint32_t IOMarket::lastIdIncrement = 0;

void IOMarket::loadMarketItems()
{  
    DBResult_ptr result = Database::getInstance().storeQuery("SELECT `id`, `player_id`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `currency`, `attributes`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `player_name` FROM `market_offers`");

    if (!result) 
        return;
    
    do {
        MarketItem offer;
        offer.id = result->getNumber<uint32_t>("id");
        offer.playerId = result->getNumber<uint32_t>("player_id");
        offer.itemtype = result->getNumber<uint16_t>("itemtype"); 
        offer.amount = result->getNumber<uint16_t>("amount");
        offer.created = result->getNumber<int64_t>("created");

        const ItemType& itemType = Item::items[offer.itemtype];
        offer.category = itemType.marketCategory;
        offer.itemName = itemType.name;

        if (offer.created + (86400000*2) < OTSYS_TIME()) {
            offer.expired = true;
        } else {
            offer.expired = false;
        }
        
		unsigned long attrSize;
		const char* attr = result->getStream("attributes", attrSize);

		PropStream propStream;
		propStream.init(attr, attrSize);

        Item* tmpItem = Item::CreateItem(offer.itemtype, 1);
        if (!tmpItem) {
            std::cout << "Error loading market item from database. CreateItem" << std::endl;
            delete tmpItem;
            continue;
        }

        if (!tmpItem->unserializeAttr(propStream)) {
            std::cout << "Error loading market item from database. unserializeAttr" << std::endl;
            delete tmpItem;
            continue;
        }

        std::string pokeName = tmpItem->getPokemonName();
        if (!pokeName.empty()) {
            offer.pokeballAttributes.name = pokeName;
	        offer.pokeballAttributes.boost = tmpItem->getPokemonBoost();
        }
        
        offer.attributes = std::string(attr, attrSize);
        offer.attributesSize = attrSize;
        delete tmpItem;

        if (result->getNumber<uint16_t>("anonymous") == 0) {
            offer.anonymous = false;
            offer.playerName = result->getString("player_name");
        } else {
            offer.anonymous = true;
            offer.playerName = "Anonymous";
        }

        offer.price = result->getNumber<uint64_t>("price");
        offer.currency = static_cast<MarketCurrency_t>(result->getNumber<int>("currency"));

        playerItems[offer.playerId].push_back(offer.id);
        marketItems[offer.id] = offer;
    } while (result->next()); 

    recalculateLastIdIncrement();
}

void IOMarket::recalculateLastIdIncrement()
{
    DBResult_ptr result = Database::getInstance().storeQuery("SELECT MAX(`id`) AS `max_id` FROM `market_offers`");
    if (result) {
        lastIdIncrement = result->getNumber<uint32_t>("max_id");
    }
}

void IOMarket::addMarketItem(MarketItem newItem) {
    lastIdIncrement++;
    newItem.id = lastIdIncrement;
    playerItems[newItem.playerId].insert(playerItems[newItem.playerId].begin(), newItem.id);
    marketItems[lastIdIncrement] = newItem;
}

void IOMarket::removeMarketItem(uint32_t id)
{
    auto& playerItemsList = playerItems[marketItems[id].playerId];
    playerItemsList.erase(std::remove(playerItemsList.begin(), playerItemsList.end(), id), playerItemsList.end());
    
    marketItems.erase(id);
}

void IOMarket::saveMarketItems()
{
    Database& db = Database::getInstance();

    std::ostringstream queryOffers;
    queryOffers << "DELETE FROM `market_offers`;";
    db.executeQuery(queryOffers.str());
    lastIdIncrement = 0;

    DBInsert offersQuery("INSERT INTO `market_offers` (`id`, `player_id`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `currency`, `attributes`) VALUES ");
    for (const auto& it : marketItems) {
        const MarketItem& item = it.second;

        if (item.playerId == 0) {
            continue;
        }
    
        lastIdIncrement++;
        std::ostringstream query;
        
        const char* attributesData = item.attributes.c_str();

        query << fmt::format("{:d}, {:d}, {:d}, {:d}, {:d}, {:d}, {:d}, {:d}, {:s}",
            lastIdIncrement, item.playerId, item.itemtype, item.amount, item.created, 
            item.anonymous ? 1 : 0, item.price, static_cast<int>(item.currency), db.escapeBlob(attributesData, item.attributesSize));

        if (!offersQuery.addRow(query)) {
            std::cout << "Error saving market items to database. addRow" << std::endl;
            return;
        }
    }

    if (!offersQuery.execute()) {
        std::cout << "Error saving market items to database. execute" << std::endl;
        return;
    }

    std::cout << "\nMarket items saved to database." << std::endl;
}

MarketItemMap IOMarket::getMarketItemsPage(uint32_t page, uint32_t pageSize) {
    MarketItemMap items;
    MarketItemMap sendItems;
    uint32_t start = (page - 1) * pageSize;
    uint32_t end = start + pageSize;

    for (const auto& it : marketItems) {
		if (it.second.expired == true) {
			continue;
		} else if (it.second.created + (86400000 * 2) < OTSYS_TIME()) {
			setMarketItemExpired(it.first);
			continue;
		}
        sendItems[it.first] = it.second;
    }

    if (end > sendItems.size()) {
        end = sendItems.size();
    }

    uint32_t i = 0;
    for (const auto& it : sendItems) {
        if (i >= start && i < end) {
            items[it.first] = it.second;
        }
        i++;
    }

    return items;
}

size_t IOMarket::getMarketItemsSize()
{
    size_t count = 0;
    for (const auto& it : marketItems) {
		if (it.second.expired == true) {
			continue;
		} else if (it.second.created + (86400000 * 2) < OTSYS_TIME()) {
			setMarketItemExpired(it.first);
			continue;
		}
        count++;
    }
    return count;
}

std::vector<uint32_t> IOMarket::getPlayerMarketItemsPage(uint32_t guid, uint32_t page, uint32_t pageSize)
{
    std::vector<uint32_t> items;
    uint32_t start = (page - 1) * pageSize;
    uint32_t end = start + pageSize;

    if (end > playerItems[guid].size()) {
        end = playerItems[guid].size();
    }

    uint32_t i = 0;
    for (const auto& it : playerItems[guid]) {
        if (i >= start && i < end) {
            items.push_back(it);
        }
        i++;
    }

    return items;

}

MarketItemMap IOMarket::getMarketItemsByNameAndCategory(std::string nameToFind, uint16_t category, uint16_t page, uint16_t pageSize)
{
    MarketItemMap items;
    uint32_t start = (page - 1) * pageSize;
    uint32_t end = start + pageSize;

    if (end > marketItems.size()) {
        end = marketItems.size();
    }

    std::vector<std::pair<uint32_t, MarketItem>> itemList(marketItems.begin(), marketItems.end());

    uint32_t i = 0;
    for (auto it = itemList.rbegin(); it != itemList.rend(); ++it) {
        if (i >= start && i < end) {
            if ((category == 0 || it->second.category == category) && 
                (asLowerCaseString(it->second.itemName).find(nameToFind) != std::string::npos || asLowerCaseString(it->second.pokeballAttributes.name).find(nameToFind) != std::string::npos)) 
            {
                items[it->first] = it->second;
            }
            if (items.size() == pageSize) {
                break;
            }
        }
        i++;
    }

    return items;
}

size_t IOMarket::getMarketItemsByNameAndCategorySize(std::string nameToFind, uint16_t category)
{
    size_t size = 0;
    for (const auto& it : marketItems) {
        if ((category == 0 || it.second.category == category) && 
            (asLowerCaseString(it.second.itemName).find(nameToFind) != std::string::npos || asLowerCaseString(it.second.pokeballAttributes.name).find(nameToFind) != std::string::npos)) 
        {
            size++;
        }
    }

    return size;
}