#ifndef _ZONE_SYSTEM_
#define _ZONE_SYSTEM_

#include <iostream>
#include <vector>
#include <string>
#include <unordered_set>

#include "position.h"
#include "tile.h"

struct zoneInfos {
    Position topleft;
    Position bottomright;
};

class Zone
{
   
    public:
        Zone(uint16_t id);
        void addPositions(const zoneInfos& positions);
        uint16_t getId() {
            return id;
        }

    bool isPositionInsideZone(const Position& position) {
        for (auto it = zonePositions.begin(); it != zonePositions.end(); ++it) {
            const zoneInfos& zoneInfo = *it;
            if (position.x >= zoneInfo.topleft.x && position.x <= zoneInfo.bottomright.x &&
                position.y >= zoneInfo.topleft.y && position.y <= zoneInfo.bottomright.y &&
                position.z >= zoneInfo.topleft.z && position.z <= zoneInfo.bottomright.z) {
                return true;
            }
        }
        return false;
    }

    std::unordered_set<Tile*> tiles;

    std::vector<zoneInfos> getZoneRange() {
        return zonePositions;
    }

    std::unordered_set<Tile*> getTiles() const {
        return tiles;
    }

    void setName(std::string nome) {
        name = nome;
    }

    void addTile(Tile* tile) {
        tiles.emplace(tile);
    }
    void removeTile(Tile* tile) {
        tiles.erase(tile);
    }
    void clearTiles() {
        tiles.clear();
    }

    void clean();

    std::string getName() {
        return name;
    }

    
    private:
    
    uint16_t id;
    std::string name;
    std::vector<zoneInfos> zonePositions;
};
#endif