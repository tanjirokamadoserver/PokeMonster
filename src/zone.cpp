#include "otpch.h"
#include "zone.h"
#include "game.h"

Zone::Zone(uint16_t id) : id(id) {}


void Zone::clean(){
   g_game.map.cleanZone(this);
 }
 
void Zone::addPositions(const zoneInfos& positions) {
   zonePositions.push_back(positions);
}

