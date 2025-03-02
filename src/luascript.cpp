// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include <boost/range/adaptor/reversed.hpp>
#include <boost/algorithm/string.hpp>


#include "luascript.h"
#include "chat.h"
#include "player.h"
#include "game.h"
#include "script.h"
#include "protocolstatus.h"
#include "spells.h"
#include "iologindata.h"
#include "configmanager.h"
#include "teleport.h"
#include "databasemanager.h"
#include "bed.h"
#include "monster.h"
#include "duelist.h"
#include "scheduler.h"
#include "databasetasks.h"
#include "events.h"
#include "zone.h"
#include "movement.h"
#include "globalevent.h"
#include "market.h"

extern Chat* g_chat;
extern Game g_game;
extern Monsters g_monsters;
extern ConfigManager g_config;
extern Vocations g_vocations;
extern Spells* g_spells;
extern Actions* g_actions;
extern TalkActions* g_talkActions;
extern CreatureEvents* g_creatureEvents;
extern MoveEvents* g_moveEvents;
extern GlobalEvents* g_globalEvents;
extern Events* g_events;
extern Scripts* g_scripts;

ScriptEnvironment::DBResultMap ScriptEnvironment::tempResults;
uint32_t ScriptEnvironment::lastResultId = 0;

std::multimap<ScriptEnvironment*, Item*> ScriptEnvironment::tempItems;

LuaEnvironment g_luaEnvironment;

ScriptEnvironment::ScriptEnvironment()
{
	resetEnv();
}

ScriptEnvironment::~ScriptEnvironment()
{
	resetEnv();
}

void ScriptEnvironment::resetEnv()
{
	scriptId = 0;
	callbackId = 0;
	timerEvent = false;
	interface = nullptr;
	localMap.clear();
	tempResults.clear();

	auto pair = tempItems.equal_range(this);
	auto it = pair.first;
	while (it != pair.second) {
		Item* item = it->second;
		if (item->getParent() == VirtualCylinder::virtualCylinder) {
			g_game.ReleaseItem(item);
		}
		it = tempItems.erase(it);
	}
}

bool ScriptEnvironment::setCallbackId(int32_t callbackId, LuaScriptInterface* scriptInterface)
{
	if (this->callbackId != 0) {
		//nested callbacks are not allowed
		if (interface) {
			interface->reportErrorFunc("Nested callbacks!");
		}
		return false;
	}

	this->callbackId = callbackId;
	interface = scriptInterface;
	return true;
}

void ScriptEnvironment::getEventInfo(int32_t& scriptId, LuaScriptInterface*& scriptInterface, int32_t& callbackId, bool& timerEvent) const
{
	scriptId = this->scriptId;
	scriptInterface = interface;
	callbackId = this->callbackId;
	timerEvent = this->timerEvent;
}

uint32_t ScriptEnvironment::addThing(Thing* thing)
{
	if (!thing || thing->isRemoved()) {
		return 0;
	}

	Creature* creature = thing->getCreature();
	if (creature) {
		return creature->getID();
	}

	Item* item = thing->getItem();
	if (item && item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		return item->getUniqueId();
	}

	for (const auto& it : localMap) {
		if (it.second == item) {
			return it.first;
		}
	}

	localMap[++lastUID] = item;
	return lastUID;
}




void ScriptEnvironment::insertItem(uint32_t uid, Item* item)
{
	auto result = localMap.emplace(uid, item);
	if (!result.second) {
		std::cout << std::endl << "Lua Script Error: Thing uid already taken.";
	}
}

Thing* ScriptEnvironment::getThingByUID(uint32_t uid)
{
	if (uid >= 0x10000000) {
		return g_game.getCreatureByID(uid);
	}

	if (uid <= std::numeric_limits<uint16_t>::max()) {
		Item* item = g_game.getUniqueItem(uid);
		if (item && !item->isRemoved()) {
			return item;
		}
		return nullptr;
	}

	auto it = localMap.find(uid);
	if (it != localMap.end()) {
		Item* item = it->second;
		if (!item->isRemoved()) {
			return item;
		}
	}
	return nullptr;
}

Item* ScriptEnvironment::getItemByUID(uint32_t uid)
{
	Thing* thing = getThingByUID(uid);
	if (!thing) {
		return nullptr;
	}
	return thing->getItem();
}

Container* ScriptEnvironment::getContainerByUID(uint32_t uid)
{
	Item* item = getItemByUID(uid);
	if (!item) {
		return nullptr;
	}
	return item->getContainer();
}

void ScriptEnvironment::removeItemByUID(uint32_t uid)
{
	if (uid <= std::numeric_limits<uint16_t>::max()) {
		g_game.removeUniqueItem(uid);
		return;
	}

	auto it = localMap.find(uid);
	if (it != localMap.end()) {
		localMap.erase(it);
	}
}

void ScriptEnvironment::addTempItem(Item* item)
{
	tempItems.emplace(this, item);
}

void ScriptEnvironment::removeTempItem(Item* item)
{
	for (auto it = tempItems.begin(), end = tempItems.end(); it != end; ++it) {
		if (it->second == item) {
			tempItems.erase(it);
			break;
		}
	}
}

uint32_t ScriptEnvironment::addResult(DBResult_ptr res)
{
	tempResults[++lastResultId] = res;
	return lastResultId;
}

bool ScriptEnvironment::removeResult(uint32_t id)
{
	auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return false;
	}

	tempResults.erase(it);
	return true;
}

DBResult_ptr ScriptEnvironment::getResultByID(uint32_t id)
{
	auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return nullptr;
	}
	return it->second;
}

std::string LuaScriptInterface::getErrorDesc(ErrorCode_t code)
{
	switch (code) {
		case LUA_ERROR_PLAYER_NOT_FOUND: return "Player not found";
		case LUA_ERROR_CREATURE_NOT_FOUND: return "Creature not found";
		case LUA_ERROR_ITEM_NOT_FOUND: return "Item not found";
		case LUA_ERROR_THING_NOT_FOUND: return "Thing not found";
		case LUA_ERROR_TILE_NOT_FOUND: return "Tile not found";
		case LUA_ERROR_HOUSE_NOT_FOUND: return "House not found";
		case LUA_ERROR_COMBAT_NOT_FOUND: return "Combat not found";
		case LUA_ERROR_CONDITION_NOT_FOUND: return "Condition not found";
		case LUA_ERROR_AREA_NOT_FOUND: return "Area not found";
		case LUA_ERROR_CONTAINER_NOT_FOUND: return "Container not found";
		case LUA_ERROR_VARIANT_NOT_FOUND: return "Variant not found";
		case LUA_ERROR_VARIANT_UNKNOWN: return "Unknown variant type";
		case LUA_ERROR_SPELL_NOT_FOUND: return "Spell not found";
		default: return "Bad error code";
	}
}

ScriptEnvironment LuaScriptInterface::scriptEnv[16];
int32_t LuaScriptInterface::scriptEnvIndex = -1;

LuaScriptInterface::LuaScriptInterface(std::string interfaceName) : interfaceName(std::move(interfaceName))
{
	if (!g_luaEnvironment.getLuaState()) {
		g_luaEnvironment.initState();
	}
}

LuaScriptInterface::~LuaScriptInterface()
{
	closeState();
}

bool LuaScriptInterface::reInitState()
{
	g_luaEnvironment.clearCombatObjects(this);
	g_luaEnvironment.clearAreaObjects(this);

	closeState();
	return initState();
}

/// Same as lua_pcall, but adds stack trace to error strings in called function.
int LuaScriptInterface::protectedCall(lua_State* L, int nargs, int nresults)
{
	int error_index = lua_gettop(L) - nargs;
	lua_pushcfunction(L, luaErrorHandler);
	lua_insert(L, error_index);

	int ret = lua_pcall(L, nargs, nresults, error_index);
	lua_remove(L, error_index);
	return ret;
}

int32_t LuaScriptInterface::loadFile(const std::string& file, Npc* npc /* = nullptr*/)
{
	//loads file as a chunk at stack top
	int ret = luaL_loadfile(luaState, file.c_str());
	if (ret != 0) {
		lastLuaError = popString(luaState);
		return -1;
	}

	//check that it is loaded as a function
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	loadingFile = file;

	if (!reserveScriptEnv()) {
		return -1;
	}

	ScriptEnvironment* env = getScriptEnv();
	env->setScriptId(EVENT_ID_LOADING, this);
	env->setNpc(npc);

	//execute it
	ret = protectedCall(luaState, 0, 0);
	if (ret != 0) {
		reportError(nullptr, popString(luaState));
		resetScriptEnv();
		return -1;
	}

	resetScriptEnv();
	return 0;
}

int32_t LuaScriptInterface::getEvent(const std::string& eventName)
{
	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//get current event function pointer
	lua_getglobal(luaState, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -3, runningEventId);
	lua_pop(luaState, 2);

	//reset global value of this event
	lua_pushnil(luaState);
	lua_setglobal(luaState, eventName.c_str());

	cacheFiles[runningEventId] = loadingFile + ":" + eventName;
	return runningEventId++;
}


int32_t LuaScriptInterface::getEvent()
{
	//check if function is on the stack
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -2);
	lua_rawseti(luaState, -2, runningEventId);
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":callback";
	return runningEventId++;
}


int32_t LuaScriptInterface::getMetaEvent(const std::string& globalName, const std::string& eventName)
{
	//get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	//get current event function pointer
	lua_getglobal(luaState, globalName.c_str());
	lua_getfield(luaState, -1, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 3);
		return -1;
	}

	//save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -4, runningEventId);
	lua_pop(luaState, 1);

	//reset global value of this event
	lua_pushnil(luaState);
	lua_setfield(luaState, -2, eventName.c_str());
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":" + globalName + "@" + eventName;
	return runningEventId++;
}

void LuaScriptInterface::removeEvent(int32_t scriptId)
{
	if (scriptId == -1) {
		return;
	}

	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return;
	}

	// remove event from table
	lua_pushnil(luaState);
	lua_rawseti(luaState, -2, scriptId);
	lua_pop(luaState, 1);

	cacheFiles.erase(scriptId);
}

const std::string& LuaScriptInterface::getFileById(int32_t scriptId)
{
	if (scriptId == EVENT_ID_LOADING) {
		return loadingFile;
	}

	auto it = cacheFiles.find(scriptId);
	if (it == cacheFiles.end()) {
		static const std::string& unk = "(Unknown scriptfile)";
		return unk;
	}
	return it->second;
}


const std::string& LuaScriptInterface::getFileByIdForStats(int32_t scriptId)
{
	auto it = cacheFiles.find(scriptId);
	if (it == cacheFiles.end()) {
		static const std::string& unk = "(Unknown scriptfile)";
		return unk;
	}
	return it->second;
}

std::string LuaScriptInterface::getStackTrace(const std::string& error_desc)
{
	lua_getglobal(luaState, "debug");
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return error_desc;
	}

	lua_getfield(luaState, -1, "traceback");
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		return error_desc;
	}

	lua_replace(luaState, -2);
	pushString(luaState, error_desc);
	lua_call(luaState, 1, 1);
	return popString(luaState);
}

void LuaScriptInterface::reportError(const char* function, const std::string& error_desc, bool stack_trace/* = false*/)
{
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);

	std::cout << std::endl << "Lua Script Error: ";

	if (scriptInterface) {
		std::cout << '[' << scriptInterface->getInterfaceName() << "] " << std::endl;

		if (timerEvent) {
			std::cout << "in a timer event called from: " << std::endl;
		}

		if (callbackId) {
			std::cout << "in callback: " << scriptInterface->getFileById(callbackId) << std::endl;
		}

		std::cout << scriptInterface->getFileById(scriptId) << std::endl;
	}

	if (function) {
		std::cout << function << "(). ";
	}

	if (stack_trace && scriptInterface) {
		std::cout << scriptInterface->getStackTrace(error_desc) << std::endl;
	} else {
		std::cout << error_desc << std::endl;
	}
}

bool LuaScriptInterface::pushFunction(int32_t functionId)
{
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		return false;
	}

	lua_rawgeti(luaState, -1, functionId);
	lua_replace(luaState, -2);
	return isFunction(luaState, -1);
}

bool LuaScriptInterface::initState()
{
	luaState = g_luaEnvironment.getLuaState();
	if (!luaState) {
		return false;
	}

	lua_newtable(luaState);
	eventTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
	runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaScriptInterface::closeState()
{
	if (!g_luaEnvironment.getLuaState() || !luaState) {
		return false;
	}

	cacheFiles.clear();
	if (eventTableRef != -1) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, eventTableRef);
		eventTableRef = -1;
	}

	luaState = nullptr;
	return true;
}

int LuaScriptInterface::luaErrorHandler(lua_State* L)
{
	const std::string& errorMessage = popString(L);
	auto interface = getScriptEnv()->getScriptInterface();
	assert(interface); //This fires if the ScriptEnvironment hasn't been setup
	pushString(L, interface->getStackTrace(errorMessage));
	return 1;
}

bool LuaScriptInterface::callFunction(int params)
{

	#ifdef STATS_ENABLED
		int32_t scriptId;
		int32_t callbackId;
		bool timerEvent;
		LuaScriptInterface* scriptInterface;
		getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);
		std::chrono::high_resolution_clock::time_point time_point = std::chrono::high_resolution_clock::now();
	#endif

	bool result = false;
	int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::getString(luaState, -1));
	} else {
		result = LuaScriptInterface::getBoolean(luaState, -1);
	}

	lua_pop(luaState, 1);
	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	#ifdef STATS_ENABLED
		uint64_t ns = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::high_resolution_clock::now() - time_point).count();
		g_stats.addLuaStats(new Stat(ns, getFileByIdForStats(scriptId), ""));
	#endif

	resetScriptEnv();
	return result;
}

void LuaScriptInterface::callVoidFunction(int params)
{
	int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(luaState));
	}

	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
}

void LuaScriptInterface::pushVariant(lua_State* L, const LuaVariant& var)
{
	lua_createtable(L, 0, 2);
	setField(L, "type", var.type);
	switch (var.type) {
		case VARIANT_NUMBER:
			setField(L, "number", var.number);
			break;
		case VARIANT_STRING:
			setField(L, "string", var.text);
			break;
		case VARIANT_TARGETPOSITION:
		case VARIANT_POSITION: {
			pushPosition(L, var.pos);
			lua_setfield(L, -2, "pos");
			break;
		}
		default:
			break;
	}
	setMetatable(L, -1, "Variant");
}

void LuaScriptInterface::pushThing(lua_State* L, Thing* thing)
{
	if (!thing) {
		lua_createtable(L, 0, 4);
		setField(L, "uid", 0);
		setField(L, "itemid", 0);
		setField(L, "actionid", 0);
		setField(L, "type", 0);
		return;
	}

	if (Item* item = thing->getItem()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else if (Creature* creature = thing->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
}

void LuaScriptInterface::pushCylinder(lua_State* L, Cylinder* cylinder)
{
	if (Creature* creature = cylinder->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else if (Item* parentItem = cylinder->getItem()) {
		pushUserdata<Item>(L, parentItem);
		setItemMetatable(L, -1, parentItem);
	} else if (Tile* tile = cylinder->getTile()) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else if (cylinder == VirtualCylinder::virtualCylinder) {
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
}

void LuaScriptInterface::pushString(lua_State* L, const std::string& value)
{
	lua_pushlstring(L, value.c_str(), value.length());
}

void LuaScriptInterface::pushCallback(lua_State* L, int32_t callback)
{
	lua_rawgeti(L, LUA_REGISTRYINDEX, callback);
}

std::string LuaScriptInterface::popString(lua_State* L)
{
	if (lua_gettop(L) == 0) {
		return std::string();
	}

	std::string str(getString(L, -1));
	lua_pop(L, 1);
	return str;
}

int32_t LuaScriptInterface::popCallback(lua_State* L)
{
	return luaL_ref(L, LUA_REGISTRYINDEX);
}

// Metatables
void LuaScriptInterface::setMetatable(lua_State* L, int32_t index, const std::string& name)
{
	luaL_getmetatable(L, name.c_str());
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setWeakMetatable(lua_State* L, int32_t index, const std::string& name)
{
	static std::set<std::string> weakObjectTypes;
	const std::string& weakName = name + "_weak";

	auto result = weakObjectTypes.emplace(name);
	if (result.second) {
		luaL_getmetatable(L, name.c_str());
		int childMetatable = lua_gettop(L);

		luaL_newmetatable(L, weakName.c_str());
		int metatable = lua_gettop(L);

		static const std::vector<std::string> methodKeys = {"__index", "__metatable", "__eq"};
		for (const std::string& metaKey : methodKeys) {
			lua_getfield(L, childMetatable, metaKey.c_str());
			lua_setfield(L, metatable, metaKey.c_str());
		}

		static const std::vector<int> methodIndexes = {'h', 'p', 't'};
		for (int metaIndex : methodIndexes) {
			lua_rawgeti(L, childMetatable, metaIndex);
			lua_rawseti(L, metatable, metaIndex);
		}

		lua_pushnil(L);
		lua_setfield(L, metatable, "__gc");

		lua_remove(L, childMetatable);
	} else {
		luaL_getmetatable(L, weakName.c_str());
	}
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setItemMetatable(lua_State* L, int32_t index, const Item* item)
{
	if (item->getContainer()) {
		luaL_getmetatable(L, "Container");
	} else if (item->getTeleport()) {
		luaL_getmetatable(L, "Teleport");
	} else {
		luaL_getmetatable(L, "Item");
	}
	lua_setmetatable(L, index - 1);
}

void LuaScriptInterface::setCreatureMetatable(lua_State* L, int32_t index, const Creature* creature)
{
	if (creature->getPlayer()) {
		luaL_getmetatable(L, "Player");
	} else if (creature->getMonster()) {
		luaL_getmetatable(L, "Monster");
	} else if (creature->getDuelist()) {
		luaL_getmetatable(L, "Duelist");
	} else {
		luaL_getmetatable(L, "Npc");
	}
	lua_setmetatable(L, index - 1);
}

// Get
std::string LuaScriptInterface::getString(lua_State* L, int32_t arg)
{
	size_t len;
	const char* c_str = lua_tolstring(L, arg, &len);
	if (!c_str || len == 0) {
		return std::string();
	}
	return std::string(c_str, len);
}

Position LuaScriptInterface::getPosition(lua_State* L, int32_t arg, int32_t& stackpos)
{
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_getfield(L, arg, "stackpos");
	if (lua_isnil(L, -1) == 1) {
		stackpos = 0;
	} else {
		stackpos = getNumber<int32_t>(L, -1);
	}

	lua_pop(L, 4);
	return position;
}

Position LuaScriptInterface::getPosition(lua_State* L, int32_t arg)
{
	Position position;
	position.x = getField<uint16_t>(L, arg, "x");
	position.y = getField<uint16_t>(L, arg, "y");
	position.z = getField<uint8_t>(L, arg, "z");

	lua_pop(L, 3);
	return position;
}

Outfit_t LuaScriptInterface::getOutfit(lua_State* L, int32_t arg)
{
	Outfit_t outfit;
	outfit.lookMount = getField<uint16_t>(L, arg, "lookMount");
	outfit.lookWings = getField<uint16_t>(L, arg, "lookWings");
	outfit.lookAura = getField<uint16_t>(L, arg, "lookAura");
	outfit.lookAddons = getField<uint8_t>(L, arg, "lookAddons");

	outfit.lookFeet = getField<uint8_t>(L, arg, "lookFeet");
	outfit.lookLegs = getField<uint8_t>(L, arg, "lookLegs");
	outfit.lookBody = getField<uint8_t>(L, arg, "lookBody");
	outfit.lookHead = getField<uint8_t>(L, arg, "lookHead");

	outfit.lookTypeEx = getField<uint16_t>(L, arg, "lookTypeEx");
	outfit.lookType = getField<uint16_t>(L, arg, "lookType");
	
	outfit.lookShader = getField<uint16_t>(L, arg, "lookShader");

	lua_pop(L, 8);
	return outfit;
}

LuaVariant LuaScriptInterface::getVariant(lua_State* L, int32_t arg)
{
	LuaVariant var;
	switch (var.type = getField<LuaVariantType_t>(L, arg, "type")) {
		case VARIANT_NUMBER: {
			var.number = getField<uint32_t>(L, arg, "number");
			lua_pop(L, 2);
			break;
		}

		case VARIANT_STRING: {
			var.text = getFieldString(L, arg, "string");
			lua_pop(L, 2);
			break;
		}

		case VARIANT_POSITION:
		case VARIANT_TARGETPOSITION: {
			lua_getfield(L, arg, "pos");
			var.pos = getPosition(L, lua_gettop(L));
			lua_pop(L, 2);
			break;
		}

		default: {
			var.type = VARIANT_NONE;
			lua_pop(L, 1);
			break;
		}
	}
	return var;
}

Thing* LuaScriptInterface::getThing(lua_State* L, int32_t arg)
{
	Thing* thing;
	if (lua_getmetatable(L, arg) != 0) {
		lua_rawgeti(L, -1, 't');
		switch(getNumber<uint32_t>(L, -1)) {
			case LuaData_Item:
				thing = getUserdata<Item>(L, arg);
				break;
			case LuaData_Container:
				thing = getUserdata<Container>(L, arg);
				break;
			case LuaData_Teleport:
				thing = getUserdata<Teleport>(L, arg);
				break;
			case LuaData_Player:
				thing = getUserdata<Player>(L, arg);
				break;
			case LuaData_Monster:
				thing = getUserdata<Monster>(L, arg);
				break;
			case LuaData_Npc:
				thing = getUserdata<Npc>(L, arg);
				break;
			default:
				thing = nullptr;
				break;
		}
		lua_pop(L, 2);
	} else {
		thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, arg));
	}
	return thing;
}

Creature* LuaScriptInterface::getCreature(lua_State* L, int32_t arg)
{
	if (isUserdata(L, arg)) {
		return getUserdata<Creature>(L, arg);
	}
	return g_game.getCreatureByID(getNumber<uint32_t>(L, arg));
}

Player* LuaScriptInterface::getPlayer(lua_State* L, int32_t arg)
{
	if (isUserdata(L, arg)) {
		return getUserdata<Player>(L, arg);
	}
	return g_game.getPlayerByID(getNumber<uint32_t>(L, arg));
}

std::string LuaScriptInterface::getFieldString(lua_State* L, int32_t arg, const std::string& key)
{
	lua_getfield(L, arg, key.c_str());
	return getString(L, -1);
}

LuaDataType LuaScriptInterface::getUserdataType(lua_State* L, int32_t arg)
{
	if (lua_getmetatable(L, arg) == 0) {
		return LuaData_Unknown;
	}
	lua_rawgeti(L, -1, 't');

	LuaDataType type = getNumber<LuaDataType>(L, -1);
	lua_pop(L, 2);

	return type;
}

// Push
void LuaScriptInterface::pushBoolean(lua_State* L, bool value)
{
	lua_pushboolean(L, value ? 1 : 0);
}

void LuaScriptInterface::pushCombatDamage(lua_State* L, const CombatDamage& damage)
{
	lua_pushnumber(L, damage.primary.value);
	lua_pushnumber(L, damage.primary.type);
	lua_pushstring(L, damage.spellName.c_str());
	lua_pushnumber(L, damage.origin);
}

void LuaScriptInterface::pushInstantSpell(lua_State* L, const InstantSpell& spell)
{
	lua_createtable(L, 0, 6);
	setField(L, "name", spell.getName());
	setField(L, "words", spell.getWords());
	setField(L, "level", spell.getLevel());
	setField(L, "mlevel", spell.getMagicLevel());
	setField(L, "mana", spell.getMana());
	setField(L, "manapercent", spell.getManaPercent());
	setMetatable(L, -1, "Spell");
}

void LuaScriptInterface::pushPosition(lua_State* L, const Position& position, int32_t stackpos/* = 0*/)
{
	lua_createtable(L, 0, 4);

	setField(L, "x", position.x);
	setField(L, "y", position.y);
	setField(L, "z", position.z);
	setField(L, "stackpos", stackpos);

	setMetatable(L, -1, "Position");
}

void LuaScriptInterface::pushOutfit(lua_State* L, const Outfit_t& outfit)
{
	lua_createtable(L, 0, 8);
	setField(L, "lookType", outfit.lookType);
	setField(L, "lookTypeEx", outfit.lookTypeEx);
	setField(L, "lookHead", outfit.lookHead);
	setField(L, "lookBody", outfit.lookBody);
	setField(L, "lookLegs", outfit.lookLegs);
	setField(L, "lookFeet", outfit.lookFeet);
	setField(L, "lookAddons", outfit.lookAddons);
	setField(L, "lookMount", outfit.lookMount);
	setField(L, "lookWings", outfit.lookWings);
	setField(L, "lookAura", outfit.lookAura);
	setField(L, "lookShader", outfit.lookShader);
}

void LuaScriptInterface::pushLoot(lua_State* L, const std::vector<LootBlock>& lootList)
{
	lua_createtable(L, lootList.size(), 0);

	int index = 0;
	for (const auto& lootBlock : lootList) {
		lua_createtable(L, 0, 7);

		setField(L, "itemId", lootBlock.id);
		setField(L, "chance", lootBlock.chance);
		setField(L, "subType", lootBlock.subType);
		setField(L, "maxCount", lootBlock.countmax);
		setField(L, "actionId", lootBlock.actionId);
		setField(L, "text", lootBlock.text);

		pushLoot(L, lootBlock.childLoot);
		lua_setfield(L, -2, "childLoot");

		lua_rawseti(L, -2, ++index);
	}
}

#define registerEnum(value) { std::string enumName = #value; registerGlobalVariable(enumName.substr(enumName.find_last_of(':') + 1), value); }
#define registerEnumIn(tableName, value) { std::string enumName = #value; registerVariable(tableName, enumName.substr(enumName.find_last_of(':') + 1), value); }

void LuaScriptInterface::registerFunctions()
{

	//doCreatureCastSpell(creature, spellName)
	lua_register(luaState, "doCreatureCastSpell", LuaScriptInterface::luaDoCreatureCastSpell);


	//getMonstersName()
	lua_register(luaState, "getMonstersName", LuaScriptInterface::luaGetMonstersName);

	//getPlayerInstantSpellCount(cid)
	lua_register(luaState, "getPlayerInstantSpellCount", LuaScriptInterface::luaGetPlayerInstantSpellCount);

	//getPlayerInstantSpellInfo(cid, index)
	lua_register(luaState, "getPlayerInstantSpellInfo", LuaScriptInterface::luaGetPlayerInstantSpellInfo);

	//doPlayerAddItem(uid, itemid, <optional: default: 1> count/subtype)
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	//Returns uid of the created item
	lua_register(luaState, "doPlayerAddItem", LuaScriptInterface::luaDoPlayerAddItem);

	//doMoveCreature(cid, direction)
	// lua_register(luaState, "doMoveCreature", LuaScriptInterface::luaDoMoveCreature);

	//doSetCreatureLight(cid, lightLevel, lightColor, time)
	lua_register(luaState, "doSetCreatureLight", LuaScriptInterface::luaDoSetCreatureLight);

	//getCreatureCondition(cid, condition[, subId])
	// lua_register(luaState, "getCreatureCondition", LuaScriptInterface::luaGetCreatureCondition);

	//getCombatName(COMBAT_TYPE)
	lua_register(luaState, "getCombatName", LuaScriptInterface::luaGetCombatName);

	//isValidUID(uid)
	lua_register(luaState, "isValidUID", LuaScriptInterface::luaIsValidUID);

	lua_register(luaState, "addDuelistType", LuaScriptInterface::luaAddDuelistType);

	////////////////////////////////////////////////////////////////////////////////////////////////
	// MARKET SYSTEM
	lua_register(luaState, "addMarketItem", LuaScriptInterface::luaAddMarketItem);
	lua_register(luaState, "removeMarketItem", LuaScriptInterface::luaRemoveMarketItem);
	lua_register(luaState, "getMarketItems", LuaScriptInterface::luaGetMarketItems);
	lua_register(luaState, "getPlayerMarketItems", LuaScriptInterface::luaGetPlayerMarketItems);
	lua_register(luaState, "getMarketItemById", LuaScriptInterface::luaGetMarketItemById);
	lua_register(luaState, "playerAddMarketItem", LuaScriptInterface::luaPlayerAddMarketItem);
	lua_register(luaState, "updateMarketItemAmount", LuaScriptInterface::luaUpdateMarketItemAmount);
	lua_register(luaState, "setMarketItemExpired", LuaScriptInterface::luaSetMarketItemExpired);

	// paginação
	lua_register(luaState, "getMarketItemsPage", LuaScriptInterface::luaGetMarketItemsPage);
	lua_register(luaState, "getPlayerMarketItemsPage", LuaScriptInterface::luaGetPlayerMarketItemsPage);

	lua_register(luaState, "getMarketItemsSize", LuaScriptInterface::luaGetMarketItemsSize);
	lua_register(luaState, "getPlayerMarketItemsSize", LuaScriptInterface::luaGetPlayerMarketItemsSize);

	lua_register(luaState, "getMarketItemsByNameAndCategory", LuaScriptInterface::luaGetMarketItemsByNameAndCategory);
	lua_register(luaState, "getMarketItemsByNameAndCategorySize", LuaScriptInterface::luaGetMarketItemsByNameAndCategorySize);
	////////////////////////////////////////////////////////////////////////////////////////////////

	//isDepot(uid)
	lua_register(luaState, "isDepot", LuaScriptInterface::luaIsDepot);

	//isMovable(uid)
	lua_register(luaState, "isMovable", LuaScriptInterface::luaIsMoveable);

	//doAddContainerItem(uid, itemid, <optional> count/subtype)
	lua_register(luaState, "doAddContainerItem", LuaScriptInterface::luaDoAddContainerItem);

	//getDepotId(uid)
	lua_register(luaState, "getDepotId", LuaScriptInterface::luaGetDepotId);

	//getWorldTime()
	lua_register(luaState, "getWorldTime", LuaScriptInterface::luaGetWorldTime);

	//getWorldLight()
	lua_register(luaState, "getWorldLight", LuaScriptInterface::luaGetWorldLight);

	//getWorldUpTime()
	lua_register(luaState, "getWorldUpTime", LuaScriptInterface::luaGetWorldUpTime);

	//createCombatArea( {area}, <optional> {extArea} )
	lua_register(luaState, "createCombatArea", LuaScriptInterface::luaCreateCombatArea);

	// doAreaCombat(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield =
	// false[, ignoreResistances = false]]]])
	lua_register(luaState, "doAreaCombat", LuaScriptInterface::luaDoAreaCombat);

	//doTargetCombat(cid, target, type, min, max, effect)
	lua_register(luaState, "doTargetCombat", LuaScriptInterface::luaDoTargetCombat);

	//doChallengeCreature(cid, target)
	lua_register(luaState, "doChallengeCreature", LuaScriptInterface::luaDoChallengeCreature);

	//doSetMonsterOutfit(cid, name, time)
	// lua_register(luaState, "doSetMonsterOutfit", LuaScriptInterface::luaSetMonsterOutfit);
	
	
	//doSetItemOutfit(cid, item, time)
	// lua_register(luaState, "doSetItemOutfit", LuaScriptInterface::luaSetItemOutfit);

	//doSetCreatureOutfit(cid, outfit, time)
	// lua_register(luaState, "doSetCreatureOutfit", LuaScriptInterface::luaSetCreatureOutfit);

	//isInArray(array, value)
	// lua_register(luaState, "isInArray", LuaScriptInterface::luaIsInArray);

	//addEvent(callback, delay, ...)
	lua_register(luaState, "addEvent", LuaScriptInterface::luaAddEvent);

	//stopEvent(eventid)
	lua_register(luaState, "stopEvent", LuaScriptInterface::luaStopEvent);

	//saveServer()
	lua_register(luaState, "saveServer", LuaScriptInterface::luaSaveServer);

	//cleanMap()
	lua_register(luaState, "cleanMap", LuaScriptInterface::luaCleanMap);

	//debugPrint(text)
	lua_register(luaState, "debugPrint", LuaScriptInterface::luaDebugPrint);

	//isInWar(cid, target)
	lua_register(luaState, "isInWar", LuaScriptInterface::luaIsInWar);

	//getWaypointPosition(name)
	lua_register(luaState, "getWaypointPositionByName", LuaScriptInterface::luaGetWaypointPositionByName);

	//sendChannelMessage(channelId, type, message)
	lua_register(luaState, "sendChannelMessage", LuaScriptInterface::luaSendChannelMessage);

	//sendGuildChannelMessage(guildId, type, message)
	lua_register(luaState, "sendGuildChannelMessage", LuaScriptInterface::luaSendGuildChannelMessage);

	//isScriptsInterface()
	lua_register(luaState, "isScriptsInterface", LuaScriptInterface::luaIsScriptsInterface);


#ifndef LUAJIT_VERSION
	//bit operations for Lua, based on bitlib project release 24
	//bit.bnot, bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
	luaL_register(luaState, "bit", LuaScriptInterface::luaBitReg);
#endif

	//configManager table
	luaL_register(luaState, "configManager", LuaScriptInterface::luaConfigManagerTable);

	//db table
	luaL_register(luaState, "db", LuaScriptInterface::luaDatabaseTable);

	//result table
	luaL_register(luaState, "result", LuaScriptInterface::luaResultTable);

	/* New functions */
	//registerClass(className, baseClass, newFunction)
	//registerTable(tableName)
	//registerMethod(className, functionName, function)
	//registerMetaMethod(className, functionName, function)
	//registerGlobalMethod(functionName, function)
	//registerVariable(tableName, name, value)
	//registerGlobalVariable(name, value)
	//registerEnum(value)
	//registerEnumIn(tableName, value)

	// Enums

	registerEnum(ACCOUNT_TYPE_NORMAL)
	registerEnum(ACCOUNT_TYPE_HELP)
	registerEnum(ACCOUNT_TYPE_TUTOR)
	registerEnum(ACCOUNT_TYPE_GAMEMASTER)
	registerEnum(ACCOUNT_TYPE_COMMUNITYMANAGER)
	registerEnum(ACCOUNT_TYPE_GOD)

	registerEnum(BUG_CATEGORY_MAP)
	registerEnum(BUG_CATEGORY_TYPO)
	registerEnum(BUG_CATEGORY_TECHNICAL)
	registerEnum(BUG_CATEGORY_OTHER)

	registerEnum(RACE_NONE)
	registerEnum(RACE_VENOM)
	registerEnum(RACE_FIRE)
	registerEnum(RACE_ENERGY)
	registerEnum(RACE_GRASS)
	registerEnum(RACE_NORMAL)
	registerEnum(RACE_WATER)
	registerEnum(RACE_FLYING)
	registerEnum(RACE_POISON)
	registerEnum(RACE_ELECTRIC)
	registerEnum(RACE_GROUND)
	registerEnum(RACE_PSYCHIC)
	registerEnum(RACE_ROCK)
	registerEnum(RACE_ICE)
	registerEnum(RACE_BUG)
	registerEnum(RACE_DRAGON)
	registerEnum(RACE_GHOST)
	registerEnum(RACE_DARK)
	registerEnum(RACE_STEEL)
	registerEnum(RACE_FAIRY)
	registerEnum(RACE_FIGHTING)

	registerEnum(CALLBACK_PARAM_LEVELMAGICVALUE)
	registerEnum(CALLBACK_PARAM_SKILLVALUE)
	registerEnum(CALLBACK_PARAM_TARGETTILE)
	registerEnum(CALLBACK_PARAM_TARGETCREATURE)

	registerEnum(COMBAT_FORMULA_UNDEFINED)
	registerEnum(COMBAT_FORMULA_LEVELMAGIC)
	registerEnum(COMBAT_FORMULA_SKILL)
	registerEnum(COMBAT_FORMULA_DAMAGE)

	registerEnum(DIRECTION_NORTH)
	registerEnum(DIRECTION_EAST)
	registerEnum(DIRECTION_SOUTH)
	registerEnum(DIRECTION_WEST)
	registerEnum(DIRECTION_SOUTHWEST)
	registerEnum(DIRECTION_SOUTHEAST)
	registerEnum(DIRECTION_NORTHWEST)
	registerEnum(DIRECTION_NORTHEAST)

	registerEnum(COMBAT_NONE)
	registerEnum(COMBAT_PHYSICALDAMAGE)
	registerEnum(COMBAT_ENERGYDAMAGE)
	registerEnum(COMBAT_EARTHDAMAGE)
	registerEnum(COMBAT_FIREDAMAGE)
	registerEnum(COMBAT_UNDEFINEDDAMAGE)
	registerEnum(COMBAT_LIFEDRAIN)
	registerEnum(COMBAT_MANADRAIN)
	registerEnum(COMBAT_HEALING)
	registerEnum(COMBAT_DROWNDAMAGE)
	registerEnum(COMBAT_ICEDAMAGE)
	registerEnum(COMBAT_HOLYDAMAGE)
	registerEnum(COMBAT_DEATHDAMAGE)
	registerEnum(COMBAT_PSYCHICDAMAGE)
	registerEnum(COMBAT_GRASSDAMAGE)
	registerEnum(COMBAT_NORMALDAMAGE)
	registerEnum(COMBAT_WATERDAMAGE)
	registerEnum(COMBAT_FLYINGDAMAGE)
	registerEnum(COMBAT_POISONDAMAGE)
	registerEnum(COMBAT_ELECTRICDAMAGE)
	registerEnum(COMBAT_GROUNDDAMAGE)
	registerEnum(COMBAT_ROCKDAMAGE)
	registerEnum(COMBAT_BUGDAMAGE)
	registerEnum(COMBAT_DRAGONDAMAGE)
	registerEnum(COMBAT_GHOSTDAMAGE)
	registerEnum(COMBAT_DARKDAMAGE)
	registerEnum(COMBAT_STEELDAMAGE)
	registerEnum(COMBAT_FAIRYDAMAGE)
	registerEnum(COMBAT_FIGHTINGDAMAGE)

	registerEnum(COMBAT_PARAM_TYPE)
	registerEnum(COMBAT_PARAM_EFFECT)
	registerEnum(COMBAT_PARAM_DISTANCEEFFECT)
	registerEnum(COMBAT_PARAM_BLOCKSHIELD)
	registerEnum(COMBAT_PARAM_BLOCKARMOR)
	registerEnum(COMBAT_PARAM_TARGETCASTERORTOPMOST)
	registerEnum(COMBAT_PARAM_CREATEITEM)
	registerEnum(COMBAT_PARAM_AGGRESSIVE)
	registerEnum(COMBAT_PARAM_DISPEL)
	registerEnum(COMBAT_PARAM_USECHARGES)
	registerEnum(COMBAT_PARAM_STRING_SPELLNAME)

	registerEnum(CONDITION_NONE)
	registerEnum(CONDITION_POISON)
	registerEnum(CONDITION_FIRE)
	registerEnum(CONDITION_ENERGY)
	registerEnum(CONDITION_BLEEDING)
	registerEnum(CONDITION_HASTE)
	registerEnum(CONDITION_PARALYZE)
	registerEnum(CONDITION_OUTFIT)
	registerEnum(CONDITION_INVISIBLE)
	registerEnum(CONDITION_LIGHT)
	registerEnum(CONDITION_MANASHIELD)
	registerEnum(CONDITION_INFIGHT)
	registerEnum(CONDITION_DRUNK)
	registerEnum(CONDITION_EXHAUST_WEAPON)
	registerEnum(CONDITION_REGENERATION)
	registerEnum(CONDITION_SOUL)
	registerEnum(CONDITION_DROWN)
	registerEnum(CONDITION_MUTED)
	registerEnum(CONDITION_CHANNELMUTEDTICKS)
	registerEnum(CONDITION_YELLTICKS)
	registerEnum(CONDITION_ATTRIBUTES)
	registerEnum(CONDITION_FREEZING)
	registerEnum(CONDITION_DAZZLED)
	registerEnum(CONDITION_CURSED)
	registerEnum(CONDITION_EXHAUST_COMBAT)
	registerEnum(CONDITION_EXHAUST_HEAL)
	registerEnum(CONDITION_PACIFIED)
	registerEnum(CONDITION_SPELLCOOLDOWN)
	registerEnum(CONDITION_SPELLGROUPCOOLDOWN)
	registerEnum(CONDITION_SLEEP)
	registerEnum(CONDITION_SEED)
	registerEnum(CONDITION_MOVING)
	registerEnum(CONDITION_NOMOVE)
	registerEnum(CONDITION_ATTACKBONUS)

	registerEnum(CONDITION_CONFUSION)
	registerEnum(CONDITION_STUN)
	registerEnum(CONDITION_SILENCE)
	registerEnum(CONDITION_BLIND)
	registerEnum(CONDITION_FEAR)
	registerEnum(CONDITION_DEFENSEBONUS)
	registerEnum(CONDITION_SNARE)
	registerEnum(CONDITION_RAGE)

	registerEnum(CONDITIONID_DEFAULT)
	registerEnum(CONDITIONID_COMBAT)
	registerEnum(CONDITIONID_HEAD)
	registerEnum(CONDITIONID_NECKLACE)
	registerEnum(CONDITIONID_BACKPACK)
	registerEnum(CONDITIONID_ARMOR)
	registerEnum(CONDITIONID_RIGHT)
	registerEnum(CONDITIONID_LEFT)
	registerEnum(CONDITIONID_LEGS)
	registerEnum(CONDITIONID_FEET)
	registerEnum(CONDITIONID_RING)
	registerEnum(CONDITIONID_AMMO)
	registerEnum(CONDITIONID_ORDER)
	registerEnum(CONDITIONID_INFO)

	registerEnum(CONDITION_PARAM_OWNER)
	registerEnum(CONDITION_PARAM_TICKS)
	registerEnum(CONDITION_PARAM_HEALTHGAIN)
	registerEnum(CONDITION_PARAM_HEALTHTICKS)
	registerEnum(CONDITION_PARAM_MANAGAIN)
	registerEnum(CONDITION_PARAM_MANATICKS)
	registerEnum(CONDITION_PARAM_DELAYED)
	registerEnum(CONDITION_PARAM_SPEED)
	registerEnum(CONDITION_PARAM_LIGHT_LEVEL)
	registerEnum(CONDITION_PARAM_LIGHT_COLOR)
	registerEnum(CONDITION_PARAM_SOULGAIN)
	registerEnum(CONDITION_PARAM_SOULTICKS)
	registerEnum(CONDITION_PARAM_MINVALUE)
	registerEnum(CONDITION_PARAM_MAXVALUE)
	registerEnum(CONDITION_PARAM_STARTVALUE)
	registerEnum(CONDITION_PARAM_TICKINTERVAL)
	registerEnum(CONDITION_PARAM_FORCEUPDATE)
	registerEnum(CONDITION_PARAM_SKILL_MELEE)
	registerEnum(CONDITION_PARAM_SKILL_FIST)
	registerEnum(CONDITION_PARAM_SKILL_CLUB)
	registerEnum(CONDITION_PARAM_SKILL_SWORD)
	registerEnum(CONDITION_PARAM_SKILL_AXE)
	registerEnum(CONDITION_PARAM_SKILL_DISTANCE)
	registerEnum(CONDITION_PARAM_SKILL_SHIELD)
	registerEnum(CONDITION_PARAM_SKILL_FISHING)
	registerEnum(CONDITION_PARAM_STAT_MAXHITPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAXMANAPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAGICPOINTS)
	registerEnum(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT)
	registerEnum(CONDITION_PARAM_PERIODICDAMAGE)
	registerEnum(CONDITION_PARAM_SKILL_MELEEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_FISTPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_CLUBPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_SWORDPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_AXEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_DISTANCEPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_SHIELDPERCENT)
	registerEnum(CONDITION_PARAM_SKILL_FISHINGPERCENT)
	registerEnum(CONDITION_PARAM_BUFF_SPELL)
	registerEnum(CONDITION_PARAM_SUBID)
	registerEnum(CONDITION_PARAM_AGGRESSIVE)
	registerEnum(CONDITION_PARAM_FIELD)
	registerEnum(CONDITION_PARAM_DISABLE_DEFENSE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_CRITICALHITCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_CRITICALHITAMOUNT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_LIFELEECHCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_LIFELEECHAMOUNT)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_MANALEECHCHANCE)
	registerEnum(CONDITION_PARAM_SPECIALSKILL_MANALEECHAMOUNT)

	registerEnum(CONDITION_PARAM_EFFECT)
	registerEnum(CONDITION_PARAM_EFFECT_TICKS)

	registerEnum(CONDITION_PARAM_SAVE_CONDITION)

	registerEnum(CONST_ME_NONE)
	registerEnum(CONST_ME_DRAWBLOOD)
	registerEnum(CONST_ME_LOSEENERGY)
	registerEnum(CONST_ME_POFF)
	registerEnum(CONST_ME_BLOCKHIT)
	registerEnum(CONST_ME_EXPLOSIONAREA)
	registerEnum(CONST_ME_EXPLOSIONHIT)
	registerEnum(CONST_ME_FIREAREA)
	registerEnum(CONST_ME_YELLOW_RINGS)
	registerEnum(CONST_ME_GREEN_RINGS)
	registerEnum(CONST_ME_HITAREA)
	registerEnum(CONST_ME_TELEPORT)
	registerEnum(CONST_ME_ENERGYHIT)
	registerEnum(CONST_ME_MAGIC_BLUE)
	registerEnum(CONST_ME_MAGIC_RED)
	registerEnum(CONST_ME_MAGIC_GREEN)
	registerEnum(CONST_ME_HITBYFIRE)
	registerEnum(CONST_ME_HITBYPOISON)
	registerEnum(CONST_ME_MORTAREA)
	registerEnum(CONST_ME_SOUND_GREEN)
	registerEnum(CONST_ME_SOUND_RED)
	registerEnum(CONST_ME_POISONAREA)
	registerEnum(CONST_ME_SOUND_YELLOW)
	registerEnum(CONST_ME_SOUND_PURPLE)
	registerEnum(CONST_ME_SOUND_BLUE)
	registerEnum(CONST_ME_SOUND_WHITE)
	registerEnum(CONST_ME_BUBBLES)
	registerEnum(CONST_ME_CRAPS)
	registerEnum(CONST_ME_GIFT_WRAPS)
	registerEnum(CONST_ME_FIREWORK_YELLOW)
	registerEnum(CONST_ME_FIREWORK_RED)
	registerEnum(CONST_ME_FIREWORK_BLUE)
	registerEnum(CONST_ME_STUN)
	registerEnum(CONST_ME_SLEEP)
	registerEnum(CONST_ME_WATERCREATURE)
	registerEnum(CONST_ME_GROUNDSHAKER)
	registerEnum(CONST_ME_HEARTS)
	registerEnum(CONST_ME_FIREATTACK)
	registerEnum(CONST_ME_ENERGYAREA)
	registerEnum(CONST_ME_SMALLCLOUDS)
	registerEnum(CONST_ME_HOLYDAMAGE)
	registerEnum(CONST_ME_BIGCLOUDS)
	registerEnum(CONST_ME_ICEAREA)
	registerEnum(CONST_ME_ICETORNADO)
	registerEnum(CONST_ME_ICEATTACK)
	registerEnum(CONST_ME_STONES)
	registerEnum(CONST_ME_SMALLPLANTS)
	registerEnum(CONST_ME_CARNIPHILA)
	registerEnum(CONST_ME_PURPLEENERGY)
	registerEnum(CONST_ME_YELLOWENERGY)
	registerEnum(CONST_ME_HOLYAREA)
	registerEnum(CONST_ME_BIGPLANTS)
	registerEnum(CONST_ME_CAKE)
	registerEnum(CONST_ME_GIANTICE)
	registerEnum(CONST_ME_WATERSPLASH)
	registerEnum(CONST_ME_PLANTATTACK)
	registerEnum(CONST_ME_TUTORIALARROW)
	registerEnum(CONST_ME_TUTORIALSQUARE)
	registerEnum(CONST_ME_MIRRORHORIZONTAL)
	registerEnum(CONST_ME_MIRRORVERTICAL)
	registerEnum(CONST_ME_SKULLHORIZONTAL)
	registerEnum(CONST_ME_SKULLVERTICAL)
	registerEnum(CONST_ME_ASSASSIN)
	registerEnum(CONST_ME_STEPSHORIZONTAL)
	registerEnum(CONST_ME_BLOODYSTEPS)
	registerEnum(CONST_ME_STEPSVERTICAL)
	registerEnum(CONST_ME_YALAHARIGHOST)
	registerEnum(CONST_ME_BATS)
	registerEnum(CONST_ME_SMOKE)
	registerEnum(CONST_ME_INSECTS)
	registerEnum(CONST_ME_DRAGONHEAD)
	registerEnum(CONST_ME_ORCSHAMAN)
	registerEnum(CONST_ME_ORCSHAMAN_FIRE)
	registerEnum(CONST_ME_THUNDER)
	registerEnum(CONST_ME_FERUMBRAS)
	registerEnum(CONST_ME_CONFETTI_HORIZONTAL)
	registerEnum(CONST_ME_CONFETTI_VERTICAL)
	registerEnum(CONST_ME_BLACKSMOKE)
	registerEnum(CONST_ME_REDSMOKE)
	registerEnum(CONST_ME_YELLOWSMOKE)
	registerEnum(CONST_ME_GREENSMOKE)
	registerEnum(CONST_ME_PURPLESMOKE)
	registerEnum(CONST_ME_EARLY_THUNDER)
	registerEnum(CONST_ME_RAGIAZ_BONECAPSULE)
	registerEnum(CONST_ME_CRITICAL_DAMAGE)
	registerEnum(CONST_ME_PLUNGING_FISH)

	registerEnum(CONST_ANI_NONE)
	registerEnum(CONST_ANI_SPEAR)
	registerEnum(CONST_ANI_BOLT)
	registerEnum(CONST_ANI_ARROW)
	registerEnum(CONST_ANI_FIRE)
	registerEnum(CONST_ANI_ENERGY)
	registerEnum(CONST_ANI_POISONARROW)
	registerEnum(CONST_ANI_BURSTARROW)
	registerEnum(CONST_ANI_THROWINGSTAR)
	registerEnum(CONST_ANI_THROWINGKNIFE)
	registerEnum(CONST_ANI_SMALLSTONE)
	registerEnum(CONST_ANI_DEATH)
	registerEnum(CONST_ANI_LARGEROCK)
	registerEnum(CONST_ANI_SNOWBALL)
	registerEnum(CONST_ANI_POWERBOLT)
	registerEnum(CONST_ANI_POISON)
	registerEnum(CONST_ANI_INFERNALBOLT)
	registerEnum(CONST_ANI_HUNTINGSPEAR)
	registerEnum(CONST_ANI_ENCHANTEDSPEAR)
	registerEnum(CONST_ANI_REDSTAR)
	registerEnum(CONST_ANI_GREENSTAR)
	registerEnum(CONST_ANI_ROYALSPEAR)
	registerEnum(CONST_ANI_SNIPERARROW)
	registerEnum(CONST_ANI_ONYXARROW)
	registerEnum(CONST_ANI_PIERCINGBOLT)
	registerEnum(CONST_ANI_WHIRLWINDSWORD)
	registerEnum(CONST_ANI_WHIRLWINDAXE)
	registerEnum(CONST_ANI_WHIRLWINDCLUB)
	registerEnum(CONST_ANI_ETHEREALSPEAR)
	registerEnum(CONST_ANI_ICE)
	registerEnum(CONST_ANI_EARTH)
	registerEnum(CONST_ANI_HOLY)
	registerEnum(CONST_ANI_SUDDENDEATH)
	registerEnum(CONST_ANI_FLASHARROW)
	registerEnum(CONST_ANI_FLAMMINGARROW)
	registerEnum(CONST_ANI_SHIVERARROW)
	registerEnum(CONST_ANI_ENERGYBALL)
	registerEnum(CONST_ANI_SMALLICE)
	registerEnum(CONST_ANI_SMALLHOLY)
	registerEnum(CONST_ANI_SMALLEARTH)
	registerEnum(CONST_ANI_EARTHARROW)
	registerEnum(CONST_ANI_EXPLOSION)
	registerEnum(CONST_ANI_CAKE)
	registerEnum(CONST_ANI_TARSALARROW)
	registerEnum(CONST_ANI_VORTEXBOLT)
	registerEnum(CONST_ANI_PRISMATICBOLT)
	registerEnum(CONST_ANI_CRYSTALLINEARROW)
	registerEnum(CONST_ANI_DRILLBOLT)
	registerEnum(CONST_ANI_ENVENOMEDARROW)
	registerEnum(CONST_ANI_GLOOTHSPEAR)
	registerEnum(CONST_ANI_SIMPLEARROW)
	registerEnum(CONST_ANI_WEAPONTYPE)

	registerEnum(CONST_PROP_BLOCKSOLID)
	registerEnum(CONST_PROP_HASHEIGHT)
	registerEnum(CONST_PROP_BLOCKPROJECTILE)
	registerEnum(CONST_PROP_BLOCKPATH)
	registerEnum(CONST_PROP_ISVERTICAL)
	registerEnum(CONST_PROP_ISHORIZONTAL)
	registerEnum(CONST_PROP_MOVEABLE)
	registerEnum(CONST_PROP_IMMOVABLEBLOCKSOLID)
	registerEnum(CONST_PROP_IMMOVABLEBLOCKPATH)
	registerEnum(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH)
	registerEnum(CONST_PROP_NOFIELDBLOCKPATH)
	registerEnum(CONST_PROP_SUPPORTHANGABLE)

	registerEnum(CONST_SLOT_HEAD)
	registerEnum(CONST_SLOT_NECKLACE)
	registerEnum(CONST_SLOT_BACKPACK)
	registerEnum(CONST_SLOT_ARMOR)
	registerEnum(CONST_SLOT_RIGHT)
	registerEnum(CONST_SLOT_LEFT)
	registerEnum(CONST_SLOT_LEGS)
	registerEnum(CONST_SLOT_FEET)
	registerEnum(CONST_SLOT_RING)
	registerEnum(CONST_SLOT_AMMO)
	registerEnum(CONST_SLOT_ORDER) 
	registerEnum(CONST_SLOT_INFO) 

	registerEnum(CREATURE_EVENT_NONE)
	registerEnum(CREATURE_EVENT_LOGIN)
	registerEnum(CREATURE_EVENT_LOGOUT)
	registerEnum(CREATURE_EVENT_THINK)
	registerEnum(CREATURE_EVENT_PREPAREDEATH)
	registerEnum(CREATURE_EVENT_DEATH)
	registerEnum(CREATURE_EVENT_KILL)
	registerEnum(CREATURE_EVENT_ADVANCE)
	registerEnum(CREATURE_EVENT_MODALWINDOW)
	registerEnum(CREATURE_EVENT_TEXTEDIT)
	registerEnum(CREATURE_EVENT_HEALTHCHANGE)
	registerEnum(CREATURE_EVENT_MANACHANGE)
	registerEnum(CREATURE_EVENT_EXTENDED_OPCODE)
	registerEnum(CREATURE_EVENT_POSTDEATH)

	registerEnum(GAME_STATE_STARTUP)
	registerEnum(GAME_STATE_INIT)
	registerEnum(GAME_STATE_NORMAL)
	registerEnum(GAME_STATE_CLOSED)
	registerEnum(GAME_STATE_SHUTDOWN)
	registerEnum(GAME_STATE_CLOSING)
	registerEnum(GAME_STATE_MAINTAIN)

	registerEnum(MESSAGE_STATUS_CONSOLE_BLUE)
	registerEnum(MESSAGE_STATUS_CONSOLE_RED)
	registerEnum(MESSAGE_STATUS_DEFAULT)
	registerEnum(MESSAGE_STATUS_WARNING)
	registerEnum(MESSAGE_EVENT_ADVANCE)
	registerEnum(MESSAGE_STATUS_SMALL)
	registerEnum(MESSAGE_INFO_DESCR)
	registerEnum(MESSAGE_DAMAGE_DEALT)
	registerEnum(MESSAGE_DAMAGE_RECEIVED)
	registerEnum(MESSAGE_HEALED)
	registerEnum(MESSAGE_EXPERIENCE)
	registerEnum(MESSAGE_DAMAGE_OTHERS)
	registerEnum(MESSAGE_HEALED_OTHERS)
	registerEnum(MESSAGE_EXPERIENCE_OTHERS)
	registerEnum(MESSAGE_EVENT_DEFAULT)
	registerEnum(MESSAGE_GUILD)
	registerEnum(MESSAGE_PARTY_MANAGEMENT)
	registerEnum(MESSAGE_PARTY)
	registerEnum(MESSAGE_EVENT_ORANGE)
	registerEnum(MESSAGE_STATUS_CONSOLE_ORANGE)
	registerEnum(MESSAGE_LOOT)

	registerEnum(CREATURETYPE_PLAYER)
	registerEnum(CREATURETYPE_MONSTER)
	registerEnum(CREATURETYPE_NPC)
	registerEnum(CREATURETYPE_SUMMON_OWN)
	registerEnum(CREATURETYPE_SUMMON_OTHERS)

	registerEnum(CLIENTOS_LINUX)
	registerEnum(CLIENTOS_WINDOWS)
	registerEnum(CLIENTOS_FLASH)
	registerEnum(CLIENTOS_OTCLIENT_LINUX)
	registerEnum(CLIENTOS_OTCLIENT_WINDOWS)
	registerEnum(CLIENTOS_OTCLIENT_MAC)

	registerEnum(FIGHTMODE_ATTACK)
	registerEnum(FIGHTMODE_BALANCED)
	registerEnum(FIGHTMODE_DEFENSE)

	registerEnum(ITEM_ATTRIBUTE_NONE)
	registerEnum(ITEM_ATTRIBUTE_ACTIONID)
	registerEnum(ITEM_ATTRIBUTE_UNIQUEID)
	registerEnum(ITEM_ATTRIBUTE_DESCRIPTION)
	registerEnum(ITEM_ATTRIBUTE_TEXT)
	registerEnum(ITEM_ATTRIBUTE_DATE)
	registerEnum(ITEM_ATTRIBUTE_WRITER)
	registerEnum(ITEM_ATTRIBUTE_NAME)
	registerEnum(ITEM_ATTRIBUTE_ARTICLE)
	registerEnum(ITEM_ATTRIBUTE_PLURALNAME)
	registerEnum(ITEM_ATTRIBUTE_WEIGHT)
	registerEnum(ITEM_ATTRIBUTE_ATTACK)
	registerEnum(ITEM_ATTRIBUTE_DEFENSE)
	registerEnum(ITEM_ATTRIBUTE_EXTRADEFENSE)
	registerEnum(ITEM_ATTRIBUTE_ARMOR)
	registerEnum(ITEM_ATTRIBUTE_HITCHANCE)
	registerEnum(ITEM_ATTRIBUTE_SHOOTRANGE)
	registerEnum(ITEM_ATTRIBUTE_OWNER)
	registerEnum(ITEM_ATTRIBUTE_DURATION)
	registerEnum(ITEM_ATTRIBUTE_DECAYSTATE)
	registerEnum(ITEM_ATTRIBUTE_CORPSEOWNER)
	registerEnum(ITEM_ATTRIBUTE_CHARGES)
	registerEnum(ITEM_ATTRIBUTE_FLUIDTYPE)
	registerEnum(ITEM_ATTRIBUTE_DOORID)
	registerEnum(ITEM_ATTRIBUTE_SPECIAL)
  	registerEnum(ITEM_ATTRIBUTE_UNIQUE_ITEM)
  	registerEnum(ITEM_ATTRIBUTE_BLINK)
  	registerEnum(ITEM_ATTRIBUTE_POKEMONHOLDER)
  	registerEnum(ITEM_ATTRIBUTE_POKEMONHOLDERINFO)
  	registerEnum(ITEM_ATTRIBUTE_POKEMONHOLDERCREATUREID)
  	registerEnum(ITEM_ATTRIBUTE_HELDX)
  	registerEnum(ITEM_ATTRIBUTE_HELDY)
  	registerEnum(ITEM_ATTRIBUTE_HELDU)
  	registerEnum(ITEM_ATTRIBUTE_CUSTOM)

	registerEnum(ITEM_TYPE_DEPOT)
	registerEnum(ITEM_TYPE_MAILBOX)
	registerEnum(ITEM_TYPE_TRASHHOLDER)
	registerEnum(ITEM_TYPE_CONTAINER)
	registerEnum(ITEM_TYPE_DOOR)
	registerEnum(ITEM_TYPE_MAGICFIELD)
	registerEnum(ITEM_TYPE_TELEPORT)
	registerEnum(ITEM_TYPE_BED)
	registerEnum(ITEM_TYPE_KEY)
	registerEnum(ITEM_TYPE_RUNE)

	registerEnum(ITEM_BAG)
	registerEnum(ITEM_SHOPPING_BAG)
	registerEnum(ITEM_GOLD_COIN)
	registerEnum(ITEM_PLATINUM_COIN)
	registerEnum(ITEM_CRYSTAL_COIN)
	registerEnum(ITEM_AMULETOFLOSS)
	registerEnum(ITEM_PARCEL)
	registerEnum(ITEM_LABEL)
	registerEnum(ITEM_FIREFIELD_PVP_FULL)
	registerEnum(ITEM_FIREFIELD_PVP_MEDIUM)
	registerEnum(ITEM_FIREFIELD_PVP_SMALL)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_FULL)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_MEDIUM)
	registerEnum(ITEM_FIREFIELD_PERSISTENT_SMALL)
	registerEnum(ITEM_FIREFIELD_NOPVP)
	registerEnum(ITEM_POISONFIELD_PVP)
	registerEnum(ITEM_POISONFIELD_PERSISTENT)
	registerEnum(ITEM_POISONFIELD_NOPVP)
	registerEnum(ITEM_ENERGYFIELD_PVP)
	registerEnum(ITEM_ENERGYFIELD_PERSISTENT)
	registerEnum(ITEM_ENERGYFIELD_NOPVP)
	registerEnum(ITEM_MAGICWALL)
	registerEnum(ITEM_MAGICWALL_PERSISTENT)
	registerEnum(ITEM_MAGICWALL_SAFE)
	registerEnum(ITEM_WILDGROWTH)
	registerEnum(ITEM_WILDGROWTH_PERSISTENT)
	registerEnum(ITEM_WILDGROWTH_SAFE)

	registerEnum(PlayerFlag_CannotUseCombat)
	registerEnum(PlayerFlag_CannotAttackPlayer)
	registerEnum(PlayerFlag_CannotAttackMonster)
	registerEnum(PlayerFlag_CannotBeAttacked)
	registerEnum(PlayerFlag_CanConvinceAll)
	registerEnum(PlayerFlag_CanSummonAll)
	registerEnum(PlayerFlag_CanIllusionAll)
	registerEnum(PlayerFlag_CanSenseInvisibility)
	registerEnum(PlayerFlag_IgnoredByMonsters)
	registerEnum(PlayerFlag_NotGainInFight)
	registerEnum(PlayerFlag_HasInfiniteMana)
	registerEnum(PlayerFlag_HasInfiniteSoul)
	registerEnum(PlayerFlag_HasNoExhaustion)
	registerEnum(PlayerFlag_CannotUseSpells)
	registerEnum(PlayerFlag_CannotPickupItem)
	registerEnum(PlayerFlag_CanAlwaysLogin)
	registerEnum(PlayerFlag_CanBroadcast)
	registerEnum(PlayerFlag_CanEditHouses)
	registerEnum(PlayerFlag_CannotBeBanned)
	registerEnum(PlayerFlag_CannotBePushed)
	registerEnum(PlayerFlag_HasInfiniteCapacity)
	registerEnum(PlayerFlag_CanPushAllCreatures)
	registerEnum(PlayerFlag_CanTalkRedPrivate)
	registerEnum(PlayerFlag_CanTalkRedChannel)
	registerEnum(PlayerFlag_TalkOrangeHelpChannel)
	registerEnum(PlayerFlag_NotGainExperience)
	registerEnum(PlayerFlag_NotGainMana)
	registerEnum(PlayerFlag_NotGainHealth)
	registerEnum(PlayerFlag_NotGainSkill)
	registerEnum(PlayerFlag_SetMaxSpeed)
	registerEnum(PlayerFlag_SpecialVIP)
	registerEnum(PlayerFlag_NotGenerateLoot)
	registerEnum(PlayerFlag_CanTalkRedChannelAnonymous)
	registerEnum(PlayerFlag_IgnoreProtectionZone)
	registerEnum(PlayerFlag_IgnoreSpellCheck)
	registerEnum(PlayerFlag_IgnoreWeaponCheck)
	registerEnum(PlayerFlag_CannotBeMuted)
	registerEnum(PlayerFlag_IsAlwaysPremium)

	registerEnum(PLAYERSEX_FEMALE)
	registerEnum(PLAYERSEX_MALE)

	registerEnum(REPORT_REASON_NAMEINAPPROPRIATE)
	registerEnum(REPORT_REASON_NAMEPOORFORMATTED)
	registerEnum(REPORT_REASON_NAMEADVERTISING)
	registerEnum(REPORT_REASON_NAMEUNFITTING)
	registerEnum(REPORT_REASON_NAMERULEVIOLATION)
	registerEnum(REPORT_REASON_INSULTINGSTATEMENT)
	registerEnum(REPORT_REASON_SPAMMING)
	registerEnum(REPORT_REASON_ADVERTISINGSTATEMENT)
	registerEnum(REPORT_REASON_UNFITTINGSTATEMENT)
	registerEnum(REPORT_REASON_LANGUAGESTATEMENT)
	registerEnum(REPORT_REASON_DISCLOSURE)
	registerEnum(REPORT_REASON_RULEVIOLATION)
	registerEnum(REPORT_REASON_STATEMENT_BUGABUSE)
	registerEnum(REPORT_REASON_UNOFFICIALSOFTWARE)
	registerEnum(REPORT_REASON_PRETENDING)
	registerEnum(REPORT_REASON_HARASSINGOWNERS)
	registerEnum(REPORT_REASON_FALSEINFO)
	registerEnum(REPORT_REASON_ACCOUNTSHARING)
	registerEnum(REPORT_REASON_STEALINGDATA)
	registerEnum(REPORT_REASON_SERVICEATTACKING)
	registerEnum(REPORT_REASON_SERVICEAGREEMENT)

	registerEnum(REPORT_TYPE_NAME)
	registerEnum(REPORT_TYPE_STATEMENT)
	registerEnum(REPORT_TYPE_BOT)

	registerEnum(VOCATION_NONE)

	registerEnum(SKILL_FIST)
	registerEnum(SKILL_CLUB)
	registerEnum(SKILL_SWORD)
	registerEnum(SKILL_AXE)
	registerEnum(SKILL_DISTANCE)
	registerEnum(SKILL_SHIELD)
	registerEnum(SKILL_FISHING)
	registerEnum(SKILL_MAGLEVEL)
	registerEnum(SKILL_LEVEL)

	registerEnum(SPECIALSKILL_CRITICALHITCHANCE)
	registerEnum(SPECIALSKILL_CRITICALHITAMOUNT)
	registerEnum(SPECIALSKILL_LIFELEECHCHANCE)
	registerEnum(SPECIALSKILL_LIFELEECHAMOUNT)
	registerEnum(SPECIALSKILL_MANALEECHCHANCE)
	registerEnum(SPECIALSKILL_MANALEECHAMOUNT)

	registerEnum(SKULL_NONE)
	registerEnum(SKULL_YELLOW)
	registerEnum(SKULL_GREEN)
	registerEnum(SKULL_WHITE)
	registerEnum(SKULL_RED)
	registerEnum(SKULL_BLACK)
	registerEnum(SKULL_ORANGE)

	registerEnum(TALKTYPE_SAY)
	registerEnum(TALKTYPE_WHISPER)
	registerEnum(TALKTYPE_YELL)
	registerEnum(TALKTYPE_PRIVATE_FROM)
	registerEnum(TALKTYPE_PRIVATE_TO)
	registerEnum(TALKTYPE_CHANNEL_Y)
	registerEnum(TALKTYPE_CHANNEL_O)
	registerEnum(TALKTYPE_PRIVATE_NP)
	registerEnum(TALKTYPE_PRIVATE_PN)
	registerEnum(TALKTYPE_BROADCAST)
	registerEnum(TALKTYPE_CHANNEL_R1)
	registerEnum(TALKTYPE_PRIVATE_RED_FROM)
	registerEnum(TALKTYPE_PRIVATE_RED_TO)
	registerEnum(TALKTYPE_MONSTER_SAY)
	registerEnum(TALKTYPE_MONSTER_YELL)
	registerEnum(TALKTYPE_CHANNEL_R2)

	registerEnum(TEXTCOLOR_BLUE)
	registerEnum(TEXTCOLOR_LIGHTGREEN)
	registerEnum(TEXTCOLOR_LIGHTBLUE)
	registerEnum(TEXTCOLOR_MAYABLUE)
	registerEnum(TEXTCOLOR_DARKRED)
	registerEnum(TEXTCOLOR_LIGHTGREY)
	registerEnum(TEXTCOLOR_SKYBLUE)
	registerEnum(TEXTCOLOR_PURPLE)
	registerEnum(TEXTCOLOR_ELECTRICPURPLE)
	registerEnum(TEXTCOLOR_RED)
	registerEnum(TEXTCOLOR_PASTELRED)
	registerEnum(TEXTCOLOR_ORANGE)
	registerEnum(TEXTCOLOR_YELLOW)
	registerEnum(TEXTCOLOR_WHITE_EXP)
	registerEnum(TEXTCOLOR_NONE)

	registerEnum(TILESTATE_NONE)
	registerEnum(TILESTATE_PROTECTIONZONE)
	registerEnum(TILESTATE_NOPVPZONE)
	registerEnum(TILESTATE_NOLOGOUT)
	registerEnum(TILESTATE_PVPZONE)
	registerEnum(TILESTATE_FLOORCHANGE)
	registerEnum(TILESTATE_FLOORCHANGE_DOWN)
	registerEnum(TILESTATE_FLOORCHANGE_NORTH)
	registerEnum(TILESTATE_FLOORCHANGE_SOUTH)
	registerEnum(TILESTATE_FLOORCHANGE_EAST)
	registerEnum(TILESTATE_FLOORCHANGE_WEST)
	registerEnum(TILESTATE_TELEPORT)
	registerEnum(TILESTATE_MAGICFIELD)
	registerEnum(TILESTATE_MAILBOX)
	registerEnum(TILESTATE_TRASHHOLDER)
	registerEnum(TILESTATE_BED)
	registerEnum(TILESTATE_DEPOT)
	registerEnum(TILESTATE_BLOCKSOLID)
	registerEnum(TILESTATE_BLOCKPATH)
	registerEnum(TILESTATE_IMMOVABLEBLOCKSOLID)
	registerEnum(TILESTATE_IMMOVABLEBLOCKPATH)
	registerEnum(TILESTATE_IMMOVABLENOFIELDBLOCKPATH)
	registerEnum(TILESTATE_NOFIELDBLOCKPATH)
	registerEnum(TILESTATE_FLOORCHANGE_SOUTH_ALT)
	registerEnum(TILESTATE_FLOORCHANGE_EAST_ALT)
	registerEnum(TILESTATE_SUPPORTS_HANGABLE)

	registerEnum(WEAPON_NONE)
	registerEnum(WEAPON_SWORD)
	registerEnum(WEAPON_CLUB)
	registerEnum(WEAPON_AXE)
	registerEnum(WEAPON_SHIELD)
	registerEnum(WEAPON_DISTANCE)
	registerEnum(WEAPON_WAND)
	registerEnum(WEAPON_AMMO)

	registerEnum(WORLD_TYPE_NO_PVP)
	registerEnum(WORLD_TYPE_PVP)
	registerEnum(WORLD_TYPE_PVP_ENFORCED)

	// Use with container:addItem, container:addItemEx and possibly other functions.
	registerEnum(FLAG_NOLIMIT)
	registerEnum(FLAG_IGNOREBLOCKITEM)
	registerEnum(FLAG_IGNOREBLOCKCREATURE)
	registerEnum(FLAG_CHILDISOWNER)
	registerEnum(FLAG_PATHFINDING)
	registerEnum(FLAG_IGNOREFIELDDAMAGE)
	registerEnum(FLAG_IGNORENOTMOVEABLE)
	registerEnum(FLAG_IGNOREAUTOSTACK)

	// Use with itemType:getSlotPosition
	registerEnum(SLOTP_WHEREEVER)
	registerEnum(SLOTP_HEAD)
	registerEnum(SLOTP_NECKLACE)
	registerEnum(SLOTP_BACKPACK)
	registerEnum(SLOTP_ARMOR)
	registerEnum(SLOTP_RIGHT)
	registerEnum(SLOTP_LEFT)
	registerEnum(SLOTP_LEGS)
	registerEnum(SLOTP_FEET)
	registerEnum(SLOTP_RING)
	registerEnum(SLOTP_AMMO)
	registerEnum(SLOTP_DEPOT)
	registerEnum(SLOTP_TWO_HAND)
	registerEnum(SLOTP_ORDER)
	registerEnum(SLOTP_INFO)

	// Use with combat functions
	registerEnum(ORIGIN_NONE)
	registerEnum(ORIGIN_CONDITION)
	registerEnum(ORIGIN_SPELL)
	registerEnum(ORIGIN_MELEE)
	registerEnum(ORIGIN_RANGED)
	registerEnum(ORIGIN_RETURN)

	// Use with house:getAccessList, house:setAccessList
	registerEnum(GUEST_LIST)
	registerEnum(SUBOWNER_LIST)

	// Use with npc:setSpeechBubble
	registerEnum(SPEECHBUBBLE_NONE)
	registerEnum(SPEECHBUBBLE_NORMAL)
	registerEnum(SPEECHBUBBLE_TRADE)
	registerEnum(SPEECHBUBBLE_QUEST)
	registerEnum(SPEECHBUBBLE_QUESTTRADER)

	// Use with player:addMapMark
	registerEnum(MAPMARK_TICK)
	registerEnum(MAPMARK_QUESTION)
	registerEnum(MAPMARK_EXCLAMATION)
	registerEnum(MAPMARK_STAR)
	registerEnum(MAPMARK_CROSS)
	registerEnum(MAPMARK_TEMPLE)
	registerEnum(MAPMARK_KISS)
	registerEnum(MAPMARK_SHOVEL)
	registerEnum(MAPMARK_SWORD)
	registerEnum(MAPMARK_FLAG)
	registerEnum(MAPMARK_LOCK)
	registerEnum(MAPMARK_BAG)
	registerEnum(MAPMARK_SKULL)
	registerEnum(MAPMARK_DOLLAR)
	registerEnum(MAPMARK_REDNORTH)
	registerEnum(MAPMARK_REDSOUTH)
	registerEnum(MAPMARK_REDEAST)
	registerEnum(MAPMARK_REDWEST)
	registerEnum(MAPMARK_GREENNORTH)
	registerEnum(MAPMARK_GREENSOUTH)

	// Use with Game.getReturnMessage
	registerEnum(RETURNVALUE_NOERROR)
	registerEnum(RETURNVALUE_NOTPOSSIBLE)
	registerEnum(RETURNVALUE_NOTENOUGHROOM)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKED)
	registerEnum(RETURNVALUE_PLAYERISNOTINVITED)
	registerEnum(RETURNVALUE_CANNOTTHROW)
	registerEnum(RETURNVALUE_THEREISNOWAY)
	registerEnum(RETURNVALUE_DESTINATIONOUTOFREACH)
	registerEnum(RETURNVALUE_CREATUREBLOCK)
	registerEnum(RETURNVALUE_NOTMOVEABLE)
	registerEnum(RETURNVALUE_DROPTWOHANDEDITEM)
	registerEnum(RETURNVALUE_BOTHHANDSNEEDTOBEFREE)
	registerEnum(RETURNVALUE_CANONLYUSEONEWEAPON)
	registerEnum(RETURNVALUE_NEEDEXCHANGE)
	registerEnum(RETURNVALUE_CANNOTBEDRESSED)
	registerEnum(RETURNVALUE_PUTTHISOBJECTINYOURHAND)
	registerEnum(RETURNVALUE_PUTTHISOBJECTINBOTHHANDS)
	registerEnum(RETURNVALUE_TOOFARAWAY)
	registerEnum(RETURNVALUE_FIRSTGODOWNSTAIRS)
	registerEnum(RETURNVALUE_FIRSTGOUPSTAIRS)
	registerEnum(RETURNVALUE_CONTAINERNOTENOUGHROOM)
	registerEnum(RETURNVALUE_NOTENOUGHCAPACITY)
	registerEnum(RETURNVALUE_CANNOTPICKUP)
	registerEnum(RETURNVALUE_THISISIMPOSSIBLE)
	registerEnum(RETURNVALUE_DEPOTISFULL)
	registerEnum(RETURNVALUE_CREATUREDOESNOTEXIST)
	registerEnum(RETURNVALUE_CANNOTUSETHISOBJECT)
	registerEnum(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
	registerEnum(RETURNVALUE_NOTREQUIREDLEVELTOUSERUNE)
	registerEnum(RETURNVALUE_YOUAREALREADYTRADING)
	registerEnum(RETURNVALUE_THISPLAYERISALREADYTRADING)
	registerEnum(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT)
	registerEnum(RETURNVALUE_DIRECTPLAYERSHOOT)
	registerEnum(RETURNVALUE_NOTENOUGHLEVEL)
	registerEnum(RETURNVALUE_NOTENOUGHMAGICLEVEL)
	registerEnum(RETURNVALUE_NOTENOUGHMANA)
	registerEnum(RETURNVALUE_NOTENOUGHSOUL)
	registerEnum(RETURNVALUE_YOUAREEXHAUSTED)
	registerEnum(RETURNVALUE_YOUCANNOTUSEOBJECTSTHATFAST)
	registerEnum(RETURNVALUE_PLAYERISNOTREACHABLE)
	registerEnum(RETURNVALUE_CANONLYUSETHISRUNEONCREATURES)
	registerEnum(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE)
	registerEnum(RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE)
	registerEnum(RETURNVALUE_YOUCANONLYUSEITONCREATURES)
	registerEnum(RETURNVALUE_CREATUREISNOTREACHABLE)
	registerEnum(RETURNVALUE_TURNSECUREMODETOATTACKUNMARKEDPLAYERS)
	registerEnum(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
	registerEnum(RETURNVALUE_YOUNEEDTOLEARNTHISSPELL)
	registerEnum(RETURNVALUE_YOURVOCATIONCANNOTUSETHISSPELL)
	registerEnum(RETURNVALUE_YOUNEEDAWEAPONTOUSETHISSPELL)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKEDLEAVEPVPZONE)
	registerEnum(RETURNVALUE_PLAYERISPZLOCKEDENTERPVPZONE)
	registerEnum(RETURNVALUE_ACTIONNOTPERMITTEDINANOPVPZONE)
	registerEnum(RETURNVALUE_YOUCANNOTLOGOUTHERE)
	registerEnum(RETURNVALUE_YOUNEEDAMAGICITEMTOCASTSPELL)
	registerEnum(RETURNVALUE_CANNOTCONJUREITEMHERE)
	registerEnum(RETURNVALUE_YOUNEEDTOSPLITYOURSPEARS)
	registerEnum(RETURNVALUE_NAMEISTOOAMBIGUOUS)
	registerEnum(RETURNVALUE_CANONLYUSEONESHIELD)
	registerEnum(RETURNVALUE_NOPARTYMEMBERSINRANGE)
	registerEnum(RETURNVALUE_YOUARENOTTHEOWNER)
	registerEnum(RETURNVALUE_TRADEPLAYERFARAWAY)
	registerEnum(RETURNVALUE_YOUDONTOWNTHISHOUSE)
	registerEnum(RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE)
	registerEnum(RETURNVALUE_TRADEPLAYERHIGHESTBIDDER)
	registerEnum(RETURNVALUE_YOUCANNOTTRADETHISHOUSE)
	registerEnum(RELOAD_TYPE_ALL)
	registerEnum(RELOAD_TYPE_ACTIONS)
	registerEnum(RELOAD_TYPE_CHAT)
	registerEnum(RELOAD_TYPE_CONFIG)
	registerEnum(RELOAD_TYPE_CREATURESCRIPTS)
	registerEnum(RELOAD_TYPE_EVENTS)
	registerEnum(RELOAD_TYPE_GLOBAL)
	registerEnum(RELOAD_TYPE_GLOBALEVENTS)
	registerEnum(RELOAD_TYPE_ITEMS)
	registerEnum(RELOAD_TYPE_LIBSCRIPT)
	registerEnum(RELOAD_TYPE_SCRIPTS)
	registerEnum(RELOAD_TYPE_MONSTERS)
	registerEnum(RELOAD_TYPE_MOUNTS)
	registerEnum(RELOAD_TYPE_MOVEMENTS)
	registerEnum(RELOAD_TYPE_NPCS)
	registerEnum(RELOAD_TYPE_QUESTS)
	registerEnum(RELOAD_TYPE_RAIDS)
	registerEnum(RELOAD_TYPE_SPELLS)
	registerEnum(RELOAD_TYPE_TALKACTIONS)
	registerEnum(RELOAD_TYPE_STAGE)
	registerEnum(RELOAD_TYPE_WEAPONS)

	registerEnum(RELOAD_TYPE_SHADERS)
	registerEnum(RELOAD_TYPE_WINGS)
	registerEnum(RELOAD_TYPE_AURAS)
	registerEnum(RELOAD_TYPE_OUTFITS)
	
	registerEnum(ZONE_PROTECTION)
	registerEnum(ZONE_NOPVP)
	registerEnum(ZONE_PVP)
	registerEnum(ZONE_NOLOGOUT)
	registerEnum(ZONE_NORMAL)
	
	registerEnum(MAX_LOOTCHANCE)

	registerEnum(SPELL_INSTANT);
	registerEnum(SPELL_RUNE);

	registerEnum(MONSTERS_EVENT_THINK)
	registerEnum(MONSTERS_EVENT_APPEAR)
	registerEnum(MONSTERS_EVENT_DISAPPEAR)
	registerEnum(MONSTERS_EVENT_MOVE)
	registerEnum(MONSTERS_EVENT_SAY)

	registerEnum(GUILDEMBLEM_NONE)
	registerEnum(GUILDEMBLEM_ALLY)
	registerEnum(GUILDEMBLEM_ENEMY)
	registerEnum(GUILDEMBLEM_NEUTRAL)
	registerEnum(GUILDEMBLEM_MEMBER)
	registerEnum(GUILDEMBLEM_OTHER)

	registerEnum(COLUMN_1)
	registerEnum(COLUMN_2)
	registerEnum(COLUMN_3)

	registerEnum(COLUMN_4)
	registerEnum(COLUMN_5)
	registerEnum(COLUMN_6)

	registerEnum(COLUMN_7)
	registerEnum(COLUMN_8)
	registerEnum(COLUMN_9)

	registerEnum(GUILD_BUFF_DEFENSE)
	registerEnum(GUILD_BUFF_ATTACK)
	registerEnum(GUILD_BUFF_CRITICAL_CHANCE)
	registerEnum(GUILD_BUFF_CRITICAL_DAMAGE)
	registerEnum(GUILD_BUFF_PLAYER_SPEED)
	registerEnum(GUILD_BUFF_POKEMON_SPEED)

	registerEnum(GUILD_BUFF_CRITICAL_CATCH)
	registerEnum(GUILD_BUFF_LUCKY)
	registerEnum(GUILD_BUFF_DUNGEON_REWARD)
	registerEnum(GUILD_BUFF_DUNGEON_EXP)
	registerEnum(GUILD_BUFF_POKEMON_HEALTH)
	registerEnum(GUILD_BUFF_BLOCK)


	registerEnum(DEFENSE_BUFF)
	registerEnum(ATTACK_BUFF)

	registerEnum(CRITICAL_CHANCE_BUFF)
	registerEnum(CRITICAL_DAMAGE_BUFF)

	registerEnum(PLAYER_SPEED_BUFF)
	registerEnum(POKEMON_SPEED_BUFF)

	registerEnum(CRITICAL_CATCH_BUFF)
	registerEnum(LUCKY_BUFF)

	registerEnum(DUNGEON_REWARD_BUFF)
	registerEnum(DUNGEON_EXP_BUFF)

	registerEnum(POKEMON_HEALTH_BUFF)
	registerEnum(BLOCK_CHANCE_BUFF)

	

	// _G
	registerGlobalVariable("INDEX_WHEREEVER", INDEX_WHEREEVER);
	registerGlobalBoolean("VIRTUAL_PARENT", true);

	registerGlobalMethod("isType", LuaScriptInterface::luaIsType);
	registerGlobalMethod("rawgetmetatable", LuaScriptInterface::luaRawGetMetatable);

	// configKeys
	registerTable("configKeys");

	registerEnumIn("configKeys", ConfigManager::ALLOW_CHANGEOUTFIT)
	registerEnumIn("configKeys", ConfigManager::ONE_PLAYER_ON_ACCOUNT)
	registerEnumIn("configKeys", ConfigManager::AIMBOT_HOTKEY_ENABLED)
	registerEnumIn("configKeys", ConfigManager::REMOVE_RUNE_CHARGES)
	registerEnumIn("configKeys", ConfigManager::EXPERIENCE_FROM_PLAYERS)
	registerEnumIn("configKeys", ConfigManager::FREE_PREMIUM)
	registerEnumIn("configKeys", ConfigManager::REPLACE_KICK_ON_LOGIN)
	registerEnumIn("configKeys", ConfigManager::ALLOW_CLONES)
	registerEnumIn("configKeys", ConfigManager::BIND_ONLY_GLOBAL_ADDRESS)
	registerEnumIn("configKeys", ConfigManager::OPTIMIZE_DATABASE)
	registerEnumIn("configKeys", ConfigManager::EMOTE_SPELLS)
	registerEnumIn("configKeys", ConfigManager::STAMINA_SYSTEM)
	registerEnumIn("configKeys", ConfigManager::WARN_UNSAFE_SCRIPTS)
	registerEnumIn("configKeys", ConfigManager::CONVERT_UNSAFE_SCRIPTS)
	registerEnumIn("configKeys", ConfigManager::CLASSIC_EQUIPMENT_SLOTS)
	registerEnumIn("configKeys", ConfigManager::CLASSIC_ATTACK_SPEED)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_NOTIFY_MESSAGE)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_NOTIFY_DURATION)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_CLEAN_MAP)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_CLOSE)
	registerEnumIn("configKeys", ConfigManager::SERVER_SAVE_SHUTDOWN)
	registerEnumIn("configKeys", ConfigManager::ONLINE_OFFLINE_CHARLIST)

	registerEnumIn("configKeys", ConfigManager::MAP_NAME)
	registerEnumIn("configKeys", ConfigManager::HOUSE_RENT_PERIOD)
	registerEnumIn("configKeys", ConfigManager::SERVER_NAME)
	registerEnumIn("configKeys", ConfigManager::OWNER_NAME)
	registerEnumIn("configKeys", ConfigManager::OWNER_EMAIL)
	registerEnumIn("configKeys", ConfigManager::URL)
	registerEnumIn("configKeys", ConfigManager::LOCATION)
	registerEnumIn("configKeys", ConfigManager::IP)
	registerEnumIn("configKeys", ConfigManager::MOTD)
	registerEnumIn("configKeys", ConfigManager::WORLD_TYPE)
	registerEnumIn("configKeys", ConfigManager::MYSQL_HOST)
	registerEnumIn("configKeys", ConfigManager::MYSQL_USER)
	registerEnumIn("configKeys", ConfigManager::MYSQL_PASS)
	registerEnumIn("configKeys", ConfigManager::MYSQL_DB)
	registerEnumIn("configKeys", ConfigManager::MYSQL_SOCK)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_PRIORITY)
	registerEnumIn("configKeys", ConfigManager::MAP_AUTHOR)

	registerEnumIn("configKeys", ConfigManager::SQL_PORT)
	registerEnumIn("configKeys", ConfigManager::MAX_PLAYERS)
	registerEnumIn("configKeys", ConfigManager::PZ_LOCKED)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_DESPAWNRANGE)
	registerEnumIn("configKeys", ConfigManager::DEFAULT_DESPAWNRADIUS)
	registerEnumIn("configKeys", ConfigManager::RATE_EXPERIENCE)
	registerEnumIn("configKeys", ConfigManager::RATE_SKILL)
	registerEnumIn("configKeys", ConfigManager::RATE_LOOT)
	registerEnumIn("configKeys", ConfigManager::RATE_MAGIC)
	registerEnumIn("configKeys", ConfigManager::RATE_SPAWN)
	registerEnumIn("configKeys", ConfigManager::HOUSE_PRICE)
	registerEnumIn("configKeys", ConfigManager::KILLS_TO_RED)
	registerEnumIn("configKeys", ConfigManager::KILLS_TO_BLACK)
	registerEnumIn("configKeys", ConfigManager::MAX_MESSAGEBUFFER)
	registerEnumIn("configKeys", ConfigManager::ACTIONS_DELAY_INTERVAL)
	registerEnumIn("configKeys", ConfigManager::EX_ACTIONS_DELAY_INTERVAL)
	registerEnumIn("configKeys", ConfigManager::KICK_AFTER_MINUTES)
	registerEnumIn("configKeys", ConfigManager::PROTECTION_LEVEL)
	registerEnumIn("configKeys", ConfigManager::DEATH_LOSE_PERCENT)
	registerEnumIn("configKeys", ConfigManager::STATUSQUERY_TIMEOUT)
	registerEnumIn("configKeys", ConfigManager::FRAG_TIME)
	registerEnumIn("configKeys", ConfigManager::WHITE_SKULL_TIME)
	registerEnumIn("configKeys", ConfigManager::GAME_PORT)
	registerEnumIn("configKeys", ConfigManager::CREATEACCOUNT_PORT)
	registerEnumIn("configKeys", ConfigManager::CREATECHARACTER_PORT)
	registerEnumIn("configKeys", ConfigManager::LOGIN_PORT)
	registerEnumIn("configKeys", ConfigManager::STATUS_PORT)
	registerEnumIn("configKeys", ConfigManager::STAIRHOP_DELAY)
	registerEnumIn("configKeys", ConfigManager::EXP_FROM_PLAYERS_LEVEL_RANGE)
	registerEnumIn("configKeys", ConfigManager::MAX_PACKETS_PER_SECOND)
	registerEnumIn("configKeys", ConfigManager::MALE_OUTFIT)
	registerEnumIn("configKeys", ConfigManager::FEMALE_OUTFIT)

	// os
	registerMethod("os", "mtime", LuaScriptInterface::luaSystemTime);

	// table
	registerMethod("table", "create", LuaScriptInterface::luaTableCreate);
	registerMethod("table", "pack", LuaScriptInterface::luaTablePack);

	// Game
	registerTable("Game");

	registerMethod("Game", "getSpectators", LuaScriptInterface::luaGameGetSpectators);
	registerMethod("Game", "getPlayers", LuaScriptInterface::luaGameGetPlayers);
	registerMethod("Game", "getItemIdByClientID", LuaScriptInterface::luaGameGetItemIdByClientID);
	registerMethod("Game", "getNpcs", LuaScriptInterface::luaGameGetNpcs);
	registerMethod("Game", "getMonsters", LuaScriptInterface::luaGameGetMonsters);
	registerMethod("Game", "loadMap", LuaScriptInterface::luaGameLoadMap);
	registerMethod("Game", "getMonstersFromPos", LuaScriptInterface::luaGameGetMonstersFromPos);

	registerMethod("Game", "getExperienceStage", LuaScriptInterface::luaGameGetExperienceStage);
	registerMethod("Game", "getMonsterCount", LuaScriptInterface::luaGameGetMonsterCount);
	registerMethod("Game", "getPlayerCount", LuaScriptInterface::luaGameGetPlayerCount);
	registerMethod("Game", "getNpcCount", LuaScriptInterface::luaGameGetNpcCount);
	registerMethod("Game", "getMonsterTypes", LuaScriptInterface::luaGameGetMonsterTypes);

	registerMethod("Game", "getTowns", LuaScriptInterface::luaGameGetTowns);
	registerMethod("Game", "getHouses", LuaScriptInterface::luaGameGetHouses);

	registerMethod("Game", "getGameState", LuaScriptInterface::luaGameGetGameState);
	registerMethod("Game", "setGameState", LuaScriptInterface::luaGameSetGameState);
	
	registerMethod("Game", "isDay", LuaScriptInterface::luaGameIsDay);
	registerMethod("Game", "isSunset", LuaScriptInterface::luaGameIsSunset);
	registerMethod("Game", "isNight", LuaScriptInterface::luaGameIsNight);
	registerMethod("Game", "isSunrise", LuaScriptInterface::luaGameIsSunrise);

	registerMethod("Game", "getWorldType", LuaScriptInterface::luaGameGetWorldType);
	registerMethod("Game", "setWorldType", LuaScriptInterface::luaGameSetWorldType);

	registerMethod("Game", "getReturnMessage", LuaScriptInterface::luaGameGetReturnMessage);

	registerMethod("Game", "createItem", LuaScriptInterface::luaGameCreateItem);
	registerMethod("Game", "createContainer", LuaScriptInterface::luaGameCreateContainer);
	registerMethod("Game", "createMonster", LuaScriptInterface::luaGameCreateMonster);
	registerMethod("Game", "createDuelist", LuaScriptInterface::luaGameCreateDuelist);
	registerMethod("Game", "createNpc", LuaScriptInterface::luaGameCreateNpc);
	registerMethod("Game", "createTile", LuaScriptInterface::luaGameCreateTile);
	registerMethod("Game", "createMonsterType", LuaScriptInterface::luaGameCreateMonsterType);

	registerMethod("Game", "startRaid", LuaScriptInterface::luaGameStartRaid);

	registerMethod("Game", "getClientVersion", LuaScriptInterface::luaGameGetClientVersion);

	registerMethod("Game", "reload", LuaScriptInterface::luaGameReload);
	
	registerMethod("Game", "sendAnimatedText", LuaScriptInterface::luaGameSendAnimatedText);
	registerMethod("Game", "getZoneById", LuaScriptInterface::luaGameGetZoneByID);

	registerMethod("Game", "addGuild", LuaScriptInterface::luaGameAddGuild);
	registerMethod("Game", "removeGuild", LuaScriptInterface::luaGameRemoveGuild);
	registerMethod("Game", "getGuilds", LuaScriptInterface::luaGameGetGuilds);
	registerMethod("Game", "getGuild", LuaScriptInterface::luaGameGetGuild);

	// Variant
	registerClass("Variant", "", LuaScriptInterface::luaVariantCreate);

	registerMethod("Variant", "getNumber", LuaScriptInterface::luaVariantGetNumber);
	registerMethod("Variant", "getString", LuaScriptInterface::luaVariantGetString);
	registerMethod("Variant", "getPosition", LuaScriptInterface::luaVariantGetPosition);

	// Position
	registerClass("Position", "", LuaScriptInterface::luaPositionCreate);
	registerMetaMethod("Position", "__add", LuaScriptInterface::luaPositionAdd);
	registerMetaMethod("Position", "__sub", LuaScriptInterface::luaPositionSub);
	registerMetaMethod("Position", "__eq", LuaScriptInterface::luaPositionCompare);

	registerMethod("Position", "getDistance", LuaScriptInterface::luaPositionGetDistance);
	registerMethod("Position", "isSightClear", LuaScriptInterface::luaPositionIsSightClear);

	registerMethod("Position", "sendMagicEffect", LuaScriptInterface::luaPositionSendMagicEffect);
	registerMethod("Position", "sendDistanceEffect", LuaScriptInterface::luaPositionSendDistanceEffect);

	registerMethod("Position", "shakeScreen", LuaScriptInterface::luaPositionShakeScreen);

	// Zone
	registerClass("Zone", "", LuaScriptInterface::luaGetZone);
	registerMetaMethod("Zone", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Zone", "getName", LuaScriptInterface::luaGetZoneName);
	registerMethod("Zone", "getId", LuaScriptInterface::luaGetZoneId);
	registerMethod("Zone", "getRange", LuaScriptInterface::luaGetZoneRange);
	registerMethod("Zone", "clean", LuaScriptInterface::luaCleanZone);
	

	// Tile
	registerClass("Tile", "", LuaScriptInterface::luaTileCreate);
	registerMetaMethod("Tile", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Tile", "getPosition", LuaScriptInterface::luaTileGetPosition);
	registerMethod("Tile", "getGround", LuaScriptInterface::luaTileGetGround);
	registerMethod("Tile", "getThing", LuaScriptInterface::luaTileGetThing);
	registerMethod("Tile", "getThingCount", LuaScriptInterface::luaTileGetThingCount);
	registerMethod("Tile", "getTopVisibleThing", LuaScriptInterface::luaTileGetTopVisibleThing);

	registerMethod("Tile", "getTopTopItem", LuaScriptInterface::luaTileGetTopTopItem);
	registerMethod("Tile", "getTopDownItem", LuaScriptInterface::luaTileGetTopDownItem);
	registerMethod("Tile", "getFieldItem", LuaScriptInterface::luaTileGetFieldItem);

	registerMethod("Tile", "getItemById", LuaScriptInterface::luaTileGetItemById);
	registerMethod("Tile", "getItemByType", LuaScriptInterface::luaTileGetItemByType);
	registerMethod("Tile", "getItemByTopOrder", LuaScriptInterface::luaTileGetItemByTopOrder);
	registerMethod("Tile", "getItemCountById", LuaScriptInterface::luaTileGetItemCountById);

	registerMethod("Tile", "getBottomCreature", LuaScriptInterface::luaTileGetBottomCreature);
	registerMethod("Tile", "getTopCreature", LuaScriptInterface::luaTileGetTopCreature);
	registerMethod("Tile", "getBottomVisibleCreature", LuaScriptInterface::luaTileGetBottomVisibleCreature);
	registerMethod("Tile", "getTopVisibleCreature", LuaScriptInterface::luaTileGetTopVisibleCreature);

	registerMethod("Tile", "getItems", LuaScriptInterface::luaTileGetItems);
	registerMethod("Tile", "getItemCount", LuaScriptInterface::luaTileGetItemCount);
	registerMethod("Tile", "getDownItemCount", LuaScriptInterface::luaTileGetDownItemCount);
	registerMethod("Tile", "getTopItemCount", LuaScriptInterface::luaTileGetTopItemCount);

	registerMethod("Tile", "getCreatures", LuaScriptInterface::luaTileGetCreatures);
	registerMethod("Tile", "getCreatureCount", LuaScriptInterface::luaTileGetCreatureCount);

	registerMethod("Tile", "getThingIndex", LuaScriptInterface::luaTileGetThingIndex);

	registerMethod("Tile", "hasProperty", LuaScriptInterface::luaTileHasProperty);
	registerMethod("Tile", "hasFlag", LuaScriptInterface::luaTileHasFlag);

	registerMethod("Tile", "queryAdd", LuaScriptInterface::luaTileQueryAdd);
	registerMethod("Tile", "addItem", LuaScriptInterface::luaTileAddItem);
	registerMethod("Tile", "addItemEx", LuaScriptInterface::luaTileAddItemEx);

	registerMethod("Tile", "getHouse", LuaScriptInterface::luaTileGetHouse);
	registerMethod("Tile", "update", LuaScriptInterface::luaTileUpdate);
	// zones
	registerMethod("Tile", "getZoneId", LuaScriptInterface::luaTileGetZoneId);
	registerMethod("Tile", "getZone", LuaScriptInterface::luaTileGetZone);
	registerMethod("Tile", "loadZoneId", LuaScriptInterface::luaTileLoadZoneId);

	// NetworkMessage
	registerClass("NetworkMessage", "", LuaScriptInterface::luaNetworkMessageCreate);
	registerMetaMethod("NetworkMessage", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("NetworkMessage", "__gc", LuaScriptInterface::luaNetworkMessageDelete);
	registerMethod("NetworkMessage", "delete", LuaScriptInterface::luaNetworkMessageDelete);

	registerMethod("NetworkMessage", "getByte", LuaScriptInterface::luaNetworkMessageGetByte);
	registerMethod("NetworkMessage", "getU16", LuaScriptInterface::luaNetworkMessageGetU16);
	registerMethod("NetworkMessage", "getU32", LuaScriptInterface::luaNetworkMessageGetU32);
	registerMethod("NetworkMessage", "getU64", LuaScriptInterface::luaNetworkMessageGetU64);
	registerMethod("NetworkMessage", "getString", LuaScriptInterface::luaNetworkMessageGetString);
	registerMethod("NetworkMessage", "getPosition", LuaScriptInterface::luaNetworkMessageGetPosition);

	registerMethod("NetworkMessage", "addByte", LuaScriptInterface::luaNetworkMessageAddByte);
	registerMethod("NetworkMessage", "addU16", LuaScriptInterface::luaNetworkMessageAddU16);
	registerMethod("NetworkMessage", "addU32", LuaScriptInterface::luaNetworkMessageAddU32);
	registerMethod("NetworkMessage", "addU64", LuaScriptInterface::luaNetworkMessageAddU64);
	registerMethod("NetworkMessage", "addString", LuaScriptInterface::luaNetworkMessageAddString);
	registerMethod("NetworkMessage", "addPosition", LuaScriptInterface::luaNetworkMessageAddPosition);
	registerMethod("NetworkMessage", "addDouble", LuaScriptInterface::luaNetworkMessageAddDouble);
	registerMethod("NetworkMessage", "addItem", LuaScriptInterface::luaNetworkMessageAddItem);
	registerMethod("NetworkMessage", "addItemId", LuaScriptInterface::luaNetworkMessageAddItemId);

	registerMethod("NetworkMessage", "reset", LuaScriptInterface::luaNetworkMessageReset);
	registerMethod("NetworkMessage", "seek", LuaScriptInterface::luaNetworkMessageSeek);
	registerMethod("NetworkMessage", "tell", LuaScriptInterface::luaNetworkMessageTell);
	registerMethod("NetworkMessage", "len", LuaScriptInterface::luaNetworkMessageLength);
	registerMethod("NetworkMessage", "skipBytes", LuaScriptInterface::luaNetworkMessageSkipBytes);
	registerMethod("NetworkMessage", "sendToPlayer", LuaScriptInterface::luaNetworkMessageSendToPlayer);

	// ModalWindow
	registerClass("ModalWindow", "", LuaScriptInterface::luaModalWindowCreate);
	registerMetaMethod("ModalWindow", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("ModalWindow", "__gc", LuaScriptInterface::luaModalWindowDelete);
	registerMethod("ModalWindow", "delete", LuaScriptInterface::luaModalWindowDelete);

	registerMethod("ModalWindow", "getId", LuaScriptInterface::luaModalWindowGetId);
	registerMethod("ModalWindow", "getTitle", LuaScriptInterface::luaModalWindowGetTitle);
	registerMethod("ModalWindow", "getMessage", LuaScriptInterface::luaModalWindowGetMessage);

	registerMethod("ModalWindow", "setTitle", LuaScriptInterface::luaModalWindowSetTitle);
	registerMethod("ModalWindow", "setMessage", LuaScriptInterface::luaModalWindowSetMessage);

	registerMethod("ModalWindow", "getButtonCount", LuaScriptInterface::luaModalWindowGetButtonCount);
	registerMethod("ModalWindow", "getChoiceCount", LuaScriptInterface::luaModalWindowGetChoiceCount);

	registerMethod("ModalWindow", "addButton", LuaScriptInterface::luaModalWindowAddButton);
	registerMethod("ModalWindow", "addChoice", LuaScriptInterface::luaModalWindowAddChoice);

	registerMethod("ModalWindow", "getDefaultEnterButton", LuaScriptInterface::luaModalWindowGetDefaultEnterButton);
	registerMethod("ModalWindow", "setDefaultEnterButton", LuaScriptInterface::luaModalWindowSetDefaultEnterButton);

	registerMethod("ModalWindow", "getDefaultEscapeButton", LuaScriptInterface::luaModalWindowGetDefaultEscapeButton);
	registerMethod("ModalWindow", "setDefaultEscapeButton", LuaScriptInterface::luaModalWindowSetDefaultEscapeButton);

	registerMethod("ModalWindow", "hasPriority", LuaScriptInterface::luaModalWindowHasPriority);
	registerMethod("ModalWindow", "setPriority", LuaScriptInterface::luaModalWindowSetPriority);

	registerMethod("ModalWindow", "sendToPlayer", LuaScriptInterface::luaModalWindowSendToPlayer);

	// Item
	registerClass("Item", "", LuaScriptInterface::luaItemCreate);
	registerMetaMethod("Item", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Item", "isItem", LuaScriptInterface::luaItemIsItem);

	registerMethod("Item", "getParent", LuaScriptInterface::luaItemGetParent);
	registerMethod("Item", "getTopParent", LuaScriptInterface::luaItemGetTopParent);

	registerMethod("Item", "getId", LuaScriptInterface::luaItemGetId);

	registerMethod("Item", "clone", LuaScriptInterface::luaItemClone);
	registerMethod("Item", "split", LuaScriptInterface::luaItemSplit);
	registerMethod("Item", "remove", LuaScriptInterface::luaItemRemove);

	registerMethod("Item", "getUniqueId", LuaScriptInterface::luaItemGetUniqueId);
	registerMethod("Item", "getActionId", LuaScriptInterface::luaItemGetActionId);
	registerMethod("Item", "setActionId", LuaScriptInterface::luaItemSetActionId);

	registerMethod("Item", "getCount", LuaScriptInterface::luaItemGetCount);
	registerMethod("Item", "getCharges", LuaScriptInterface::luaItemGetCharges);
	registerMethod("Item", "getFluidType", LuaScriptInterface::luaItemGetFluidType);
	registerMethod("Item", "getWeight", LuaScriptInterface::luaItemGetWeight);

	registerMethod("Item", "getSubType", LuaScriptInterface::luaItemGetSubType);

	registerMethod("Item", "getName", LuaScriptInterface::luaItemGetName);
	registerMethod("Item", "getPluralName", LuaScriptInterface::luaItemGetPluralName);
	registerMethod("Item", "getArticle", LuaScriptInterface::luaItemGetArticle);

	registerMethod("Item", "getPosition", LuaScriptInterface::luaItemGetPosition);
	registerMethod("Item", "getTile", LuaScriptInterface::luaItemGetTile);

	registerMethod("Item", "hasAttribute", LuaScriptInterface::luaItemHasAttribute);
	registerMethod("Item", "getAttribute", LuaScriptInterface::luaItemGetAttribute);
	registerMethod("Item", "setAttribute", LuaScriptInterface::luaItemSetAttribute);
	registerMethod("Item", "setIntAttribute", LuaScriptInterface::luaItemSetIntAttribute);
	registerMethod("Item", "removeAttribute", LuaScriptInterface::luaItemRemoveAttribute);

	registerMethod("Item", "getCustomAttribute", LuaScriptInterface::luaItemGetCustomAttribute);
	registerMethod("Item", "setCustomAttribute", LuaScriptInterface::luaItemSetCustomAttribute);
	registerMethod("Item", "removeCustomAttribute", LuaScriptInterface::luaItemRemoveCustomAttribute);

	registerMethod("Item", "moveTo", LuaScriptInterface::luaItemMoveTo);
	registerMethod("Item", "transform", LuaScriptInterface::luaItemTransform);
	registerMethod("Item", "decay", LuaScriptInterface::luaItemDecay);

	registerMethod("Item", "getDescription", LuaScriptInterface::luaItemGetDescription);

	registerMethod("Item", "hasProperty", LuaScriptInterface::luaItemHasProperty);
	registerMethod("Item", "isLoadedFromMap", LuaScriptInterface::luaItemIsLoadedFromMap);

	// Container
	registerClass("Container", "Item", LuaScriptInterface::luaContainerCreate);
	registerMetaMethod("Container", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Container", "getSize", LuaScriptInterface::luaContainerGetSize);
	registerMethod("Container", "getCapacity", LuaScriptInterface::luaContainerGetCapacity);
	registerMethod("Container", "getEmptySlots", LuaScriptInterface::luaContainerGetEmptySlots);
	
	registerMethod("Container", "getContentDescription", LuaScriptInterface::luaContainerGetContentDescription);
	
	registerMethod("Container", "getItems", LuaScriptInterface::luaContainerGetItems);

	registerMethod("Container", "getItemHoldingCount", LuaScriptInterface::luaContainerGetItemHoldingCount);
	registerMethod("Container", "getItemCountById", LuaScriptInterface::luaContainerGetItemCountById);

	registerMethod("Container", "getItem", LuaScriptInterface::luaContainerGetItem);
	registerMethod("Container", "hasItem", LuaScriptInterface::luaContainerHasItem);
	registerMethod("Container", "addItem", LuaScriptInterface::luaContainerAddItem);
	registerMethod("Container", "addItemEx", LuaScriptInterface::luaContainerAddItemEx);
	
	registerMethod("Container", "getCorpseOwner", LuaScriptInterface::luaContainerGetCorpseOwner);
	registerMethod("Container", "isHoldingUniqueItem", LuaScriptInterface::luaContainerIsHoldingUniqueItem);

	registerMethod("Container", "getPokeballsCached", LuaScriptInterface::luaContainerGetPokeballsCached);

	// Teleport
	registerClass("Teleport", "Item", LuaScriptInterface::luaTeleportCreate);
	registerMetaMethod("Teleport", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Teleport", "getDestination", LuaScriptInterface::luaTeleportGetDestination);
	registerMethod("Teleport", "setDestination", LuaScriptInterface::luaTeleportSetDestination);

	// Creature
	registerClass("Creature", "", LuaScriptInterface::luaCreatureCreate);
	registerMetaMethod("Creature", "__eq", LuaScriptInterface::luaUserdataCompare);



	registerMethod("Creature", "getEvents", LuaScriptInterface::luaCreatureGetEvents);
	registerMethod("Creature", "registerEvent", LuaScriptInterface::luaCreatureRegisterEvent);
	registerMethod("Creature", "unregisterEvent", LuaScriptInterface::luaCreatureUnregisterEvent);

	registerMethod("Creature", "isRemoved", LuaScriptInterface::luaCreatureIsRemoved);
	registerMethod("Creature", "isCreature", LuaScriptInterface::luaCreatureIsCreature);
	registerMethod("Creature", "isInGhostMode", LuaScriptInterface::luaCreatureIsInGhostMode);
	registerMethod("Creature", "isHealthHidden", LuaScriptInterface::luaCreatureIsHealthHidden);
	registerMethod("Creature", "isImmune", LuaScriptInterface::luaCreatureIsImmune);

	registerMethod("Creature", "canSee", LuaScriptInterface::luaCreatureCanSee);
	registerMethod("Creature", "canSeeCreature", LuaScriptInterface::luaCreatureCanSeeCreature);

	registerMethod("Creature", "getParent", LuaScriptInterface::luaCreatureGetParent);

	registerMethod("Creature", "getId", LuaScriptInterface::luaCreatureGetId);
	registerMethod("Creature", "getName", LuaScriptInterface::luaCreatureGetName);

	registerMethod("Creature", "getTarget", LuaScriptInterface::luaCreatureGetTarget);
	registerMethod("Creature", "setTarget", LuaScriptInterface::luaCreatureSetTarget);

	registerMethod("Creature", "addCustomIcon", LuaScriptInterface::luaCreatureAddCustomIcon);
	registerMethod("Creature", "removeCustomIcon", LuaScriptInterface::luaCreatureRemoveCustomIcon);
	registerMethod("Creature", "cleanCustomIcons", LuaScriptInterface::luaCreatureCleanCustomIcons);

	registerMethod("Creature", "getFollowCreature", LuaScriptInterface::luaCreatureGetFollowCreature);
	registerMethod("Creature", "setFollowCreature", LuaScriptInterface::luaCreatureSetFollowCreature);

	registerMethod("Creature", "getMaster", LuaScriptInterface::luaCreatureGetMaster);
	registerMethod("Creature", "setMaster", LuaScriptInterface::luaCreatureSetMaster);
	registerMethod("Creature", "updateCreatureType", LuaScriptInterface::luaCreatureUpdateCreatureType);

	registerMethod("Creature", "getLight", LuaScriptInterface::luaCreatureGetLight);
	registerMethod("Creature", "setLight", LuaScriptInterface::luaCreatureSetLight);

	registerMethod("Creature", "getSpeed", LuaScriptInterface::luaCreatureGetSpeed);
	registerMethod("Creature", "getBaseSpeed", LuaScriptInterface::luaCreatureGetBaseSpeed);
	registerMethod("Creature", "changeSpeed", LuaScriptInterface::luaCreatureChangeSpeed);

	registerMethod("Creature", "setDropLoot", LuaScriptInterface::luaCreatureSetDropLoot);
	registerMethod("Creature", "setSkillLoss", LuaScriptInterface::luaCreatureSetSkillLoss);

	registerMethod("Creature", "getPosition", LuaScriptInterface::luaCreatureGetPosition);
	registerMethod("Creature", "getTile", LuaScriptInterface::luaCreatureGetTile);
	registerMethod("Creature", "getDirection", LuaScriptInterface::luaCreatureGetDirection);
	registerMethod("Creature", "setDirection", LuaScriptInterface::luaCreatureSetDirection);

	registerMethod("Creature", "getHealth", LuaScriptInterface::luaCreatureGetHealth);
	registerMethod("Creature", "setHealth", LuaScriptInterface::luaCreatureSetHealth);
	registerMethod("Creature", "addHealth", LuaScriptInterface::luaCreatureAddHealth);
	registerMethod("Creature", "getMaxHealth", LuaScriptInterface::luaCreatureGetMaxHealth);

	registerMethod("Creature", "setMaxHealth", LuaScriptInterface::luaCreatureSetMaxHealth);
	registerMethod("Creature", "setOldMaxHealth", LuaScriptInterface::luaCreatureSetOldMaxHealth);
	registerMethod("Creature", "setHiddenHealth", LuaScriptInterface::luaCreatureSetHiddenHealth);

	registerMethod("Creature", "getSkull", LuaScriptInterface::luaCreatureGetSkull);
	registerMethod("Creature", "setSkull", LuaScriptInterface::luaCreatureSetSkull);

	registerMethod("Creature", "setNameColor", LuaScriptInterface::luaCreatureSetNameColor);

	registerMethod("Creature", "getOutfit", LuaScriptInterface::luaCreatureGetOutfit);
	registerMethod("Creature", "setOutfit", LuaScriptInterface::luaCreatureSetOutfit);

	registerMethod("Creature", "getCondition", LuaScriptInterface::luaCreatureGetCondition);
	registerMethod("Creature", "addCondition", LuaScriptInterface::luaCreatureAddCondition);
	registerMethod("Creature", "removeCondition", LuaScriptInterface::luaCreatureRemoveCondition);
	
	registerMethod("Creature", "hasCondition", LuaScriptInterface::luaCreatureHasCondition);

	registerMethod("Creature", "remove", LuaScriptInterface::luaCreatureRemove);
	registerMethod("Creature", "teleportTo", LuaScriptInterface::luaCreatureTeleportTo);
	registerMethod("Creature", "say", LuaScriptInterface::luaCreatureSay);

	registerMethod("Creature", "getDamageMap", LuaScriptInterface::luaCreatureGetDamageMap);
	registerMethod("Creature", "setBossStatus", LuaScriptInterface::luaCreatureSetBossStatus);

	registerMethod("Creature", "getSummons", LuaScriptInterface::luaCreatureGetSummons);

	registerMethod("Creature", "getDescription", LuaScriptInterface::luaCreatureGetDescription);

	registerMethod("Creature", "getPathTo", LuaScriptInterface::luaCreatureGetPathTo);
	
	registerMethod("Creature", "canMove", LuaScriptInterface::luaCreatureCanMove);
	registerMethod("Creature", "setNoMove", LuaScriptInterface::luaCreatureSetNoMove);
	
	registerMethod("Creature", "move", LuaScriptInterface::luaCreatureMove);

	registerMethod("Creature", "moveTo", LuaScriptInterface::luaCreatureMoveTo);

	registerMethod("Creature", "cancelWalk", LuaScriptInterface::luaCreatureCancelWalk);

	registerMethod("Creature", "getWalkDelay", LuaScriptInterface::luaCreatureGetWalkDelay);

	registerMethod("Creature", "getZone", LuaScriptInterface::luaCreatureGetZone);	

	registerMethod("Creature", "sendProgressbar", LuaScriptInterface::luaCreatureSetProgressbar);
	
	registerMethod("Creature", "sendJump", LuaScriptInterface::luaCreatureSendJump);
	
	registerMethod("Creature", "sendFirstTitle", LuaScriptInterface::luaCreatureSendFirstTitle);

	registerMethod("Creature", "setNickname", LuaScriptInterface::luaCreatureSetNickname);
	
	registerMethod("Creature", "setSpeed", LuaScriptInterface::luaCreatureSetSpeed);

	registerMethod("Creature", "setStringStorageValue", LuaScriptInterface::luaSetStringStorageValue);

	registerMethod("Creature", "getStringStorageValue", LuaScriptInterface::luaGetStringStorageValue);

	registerMethod("Creature", "getZoneId", LuaScriptInterface::luaCreatureGetZoneId);
	registerMethod("Creature", "getCurrentZone", LuaScriptInterface::luaCreatureGetCurrentZone);	
	
	registerMethod("Creature", "insertAttachedEffect", LuaScriptInterface::luaCreatureInsertAttachedEffect);	
	registerMethod("Creature", "removeAttachedEffect", LuaScriptInterface::luaCreatureRemoveAttachedEffect);	
	registerMethod("Creature", "cleanAttachedEffects", LuaScriptInterface::luaCreatureCleanAttachedEffects);	
	// Player
	registerClass("Player", "Creature", LuaScriptInterface::luaPlayerCreate);
	registerMetaMethod("Player", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Player", "isPlayer", LuaScriptInterface::luaPlayerIsPlayer);

	registerMethod("Player", "getGuid", LuaScriptInterface::luaPlayerGetGuid);
	registerMethod("Player", "getIp", LuaScriptInterface::luaPlayerGetIp);
	registerMethod("Player", "getAccountId", LuaScriptInterface::luaPlayerGetAccountId);
	registerMethod("Player", "getLastLoginSaved", LuaScriptInterface::luaPlayerGetLastLoginSaved);
	registerMethod("Player", "getLastLogout", LuaScriptInterface::luaPlayerGetLastLogout);

	registerMethod("Player", "getAccountType", LuaScriptInterface::luaPlayerGetAccountType);
	registerMethod("Player", "setAccountType", LuaScriptInterface::luaPlayerSetAccountType);

	registerMethod("Player", "getCapacity", LuaScriptInterface::luaPlayerGetCapacity);
	registerMethod("Player", "setCapacity", LuaScriptInterface::luaPlayerSetCapacity);

	registerMethod("Player", "getFreeCapacity", LuaScriptInterface::luaPlayerGetFreeCapacity);

	registerMethod("Player", "getDepotChest", LuaScriptInterface::luaPlayerGetDepotChest);
	registerMethod("Player", "getInbox", LuaScriptInterface::luaPlayerGetInbox);

	registerMethod("Player", "getSkullTime", LuaScriptInterface::luaPlayerGetSkullTime);
	registerMethod("Player", "setSkullTime", LuaScriptInterface::luaPlayerSetSkullTime);
	registerMethod("Player", "getDeathPenalty", LuaScriptInterface::luaPlayerGetDeathPenalty);

	registerMethod("Player", "getExperience", LuaScriptInterface::luaPlayerGetExperience);
	registerMethod("Player", "addExperience", LuaScriptInterface::luaPlayerAddExperience);
	registerMethod("Player", "removeExperience", LuaScriptInterface::luaPlayerRemoveExperience);
	registerMethod("Player", "getLevel", LuaScriptInterface::luaPlayerGetLevel);

	registerMethod("Player", "getMagicLevel", LuaScriptInterface::luaPlayerGetMagicLevel);
	registerMethod("Player", "getBaseMagicLevel", LuaScriptInterface::luaPlayerGetBaseMagicLevel);
	registerMethod("Player", "getMana", LuaScriptInterface::luaPlayerGetMana);
	registerMethod("Player", "addMana", LuaScriptInterface::luaPlayerAddMana);
	registerMethod("Player", "getMaxMana", LuaScriptInterface::luaPlayerGetMaxMana);
	registerMethod("Player", "setMaxMana", LuaScriptInterface::luaPlayerSetMaxMana);
	registerMethod("Player", "getManaSpent", LuaScriptInterface::luaPlayerGetManaSpent);
	registerMethod("Player", "addManaSpent", LuaScriptInterface::luaPlayerAddManaSpent);

	registerMethod("Player", "getBaseMaxHealth", LuaScriptInterface::luaPlayerGetBaseMaxHealth);
	registerMethod("Player", "getBaseMaxMana", LuaScriptInterface::luaPlayerGetBaseMaxMana);

	registerMethod("Player", "getSkillLevel", LuaScriptInterface::luaPlayerGetSkillLevel);
	registerMethod("Player", "getEffectiveSkillLevel", LuaScriptInterface::luaPlayerGetEffectiveSkillLevel);
	registerMethod("Player", "getSkillPercent", LuaScriptInterface::luaPlayerGetSkillPercent);
	registerMethod("Player", "getSkillTries", LuaScriptInterface::luaPlayerGetSkillTries);
	registerMethod("Player", "addSkillTries", LuaScriptInterface::luaPlayerAddSkillTries);
	registerMethod("Player", "getSpecialSkill", LuaScriptInterface::luaPlayerGetSpecialSkill);
	registerMethod("Player", "addSpecialSkill", LuaScriptInterface::luaPlayerAddSpecialSkill);

	registerMethod("Player", "addOfflineTrainingTime", LuaScriptInterface::luaPlayerAddOfflineTrainingTime);
	registerMethod("Player", "getOfflineTrainingTime", LuaScriptInterface::luaPlayerGetOfflineTrainingTime);
	registerMethod("Player", "removeOfflineTrainingTime", LuaScriptInterface::luaPlayerRemoveOfflineTrainingTime);

	registerMethod("Player", "addOfflineTrainingTries", LuaScriptInterface::luaPlayerAddOfflineTrainingTries);

	registerMethod("Player", "getOfflineTrainingSkill", LuaScriptInterface::luaPlayerGetOfflineTrainingSkill);
	registerMethod("Player", "setOfflineTrainingSkill", LuaScriptInterface::luaPlayerSetOfflineTrainingSkill);

	registerMethod("Player", "getItemCount", LuaScriptInterface::luaPlayerGetItemCount);
	registerMethod("Player", "getItemById", LuaScriptInterface::luaPlayerGetItemById);

	registerMethod("Player", "getVocation", LuaScriptInterface::luaPlayerGetVocation);
	registerMethod("Player", "setVocation", LuaScriptInterface::luaPlayerSetVocation);

	registerMethod("Player", "getSex", LuaScriptInterface::luaPlayerGetSex);
	registerMethod("Player", "setSex", LuaScriptInterface::luaPlayerSetSex);

	registerMethod("Player", "getTown", LuaScriptInterface::luaPlayerGetTown);
	registerMethod("Player", "setTown", LuaScriptInterface::luaPlayerSetTown);

	registerMethod("Player", "getGuild", LuaScriptInterface::luaPlayerGetGuild);
	registerMethod("Player", "setGuild", LuaScriptInterface::luaPlayerSetGuild);

	registerMethod("Player", "setGuildRank", LuaScriptInterface::luaPlayerSetGuildRank);
	registerMethod("Player", "getGuildRank", LuaScriptInterface::luaPlayerGetGuildRank);

	registerMethod("Player", "getGuildPermissions", LuaScriptInterface::luaPlayerGetGuildPermissions);
	registerMethod("Player", "hasGuildPermission", LuaScriptInterface::luaPlayerHasGuildPermission);

	registerMethod("Player", "addInboxMessage", LuaScriptInterface::luaPlayerAddInboxMessage);
	registerMethod("Player", "finishInboxMessage", LuaScriptInterface::luaPlayerFinishInboxMessage);
	registerMethod("Player", "getGuildInbox", LuaScriptInterface::luaPlayerGetGuildInbox);
	registerMethod("Player", "getGuildInboxById", LuaScriptInterface::luaPlayerGetGuildInboxById);

	registerMethod("Player", "getGuildNick", LuaScriptInterface::luaPlayerGetGuildNick);
	registerMethod("Player", "setGuildNick", LuaScriptInterface::luaPlayerSetGuildNick);

	registerMethod("Player", "getGroup", LuaScriptInterface::luaPlayerGetGroup);
	registerMethod("Player", "setGroup", LuaScriptInterface::luaPlayerSetGroup);

	registerMethod("Player", "getStamina", LuaScriptInterface::luaPlayerGetStamina);
	registerMethod("Player", "setStamina", LuaScriptInterface::luaPlayerSetStamina);

	registerMethod("Player", "getSoul", LuaScriptInterface::luaPlayerGetSoul);
	registerMethod("Player", "addSoul", LuaScriptInterface::luaPlayerAddSoul);
	registerMethod("Player", "getMaxSoul", LuaScriptInterface::luaPlayerGetMaxSoul);

	registerMethod("Player", "getBankBalance", LuaScriptInterface::luaPlayerGetBankBalance);
	registerMethod("Player", "setBankBalance", LuaScriptInterface::luaPlayerSetBankBalance);

	registerMethod("Player", "getStorageValue", LuaScriptInterface::luaPlayerGetStorageValue);
	registerMethod("Player", "setStorageValue", LuaScriptInterface::luaPlayerSetStorageValue);

	registerMethod("Player", "addItem", LuaScriptInterface::luaPlayerAddItem);
	registerMethod("Player", "addItemEx", LuaScriptInterface::luaPlayerAddItemEx);
	registerMethod("Player", "removeItem", LuaScriptInterface::luaPlayerRemoveItem);

	registerMethod("Player", "setFly", LuaScriptInterface::luaPlayerSetFly);

	registerMethod("Player", "setMarketSellItem", LuaScriptInterface::luaPlayerSetMarketSellItem);
	registerMethod("Player", "canSellMarketItem", LuaScriptInterface::luaPlayerCanSellMarketItem);

	registerMethod("Player", "setElementalBuff", LuaScriptInterface::luaPlayerSetElementalBuff);
	registerMethod("Player", "getElementalBuff", LuaScriptInterface::luaPlayerGetElementalBuff);
	
	// player:addWing(wingId)
	registerMethod("Player", "addWing", LuaScriptInterface::luaPlayerAddWing);
	
	// player:removeWing(wingId)
	registerMethod("Player", "removeWing", LuaScriptInterface::luaPlayerRemoveWing);
	
	// player:addAura(id)
	registerMethod("Player", "addAura", LuaScriptInterface::luaPlayerAddAura);
	
	// player:removeAura(id)
	registerMethod("Player", "removeAura", LuaScriptInterface::luaPlayerRemoveAura);
	
	// player:addAura(id)
	registerMethod("Player", "addAura", LuaScriptInterface::luaPlayerAddAura);
	
	// player:removeShader(id)
	registerMethod("Player", "removeShader", LuaScriptInterface::luaPlayerRemoveShader);
	
	// player:addShader(id)
	registerMethod("Player", "addShader", LuaScriptInterface::luaPlayerAddShader);

	registerMethod("Player", "getUsingPokeball", LuaScriptInterface::luaPlayerGetUsingPokeball);
	registerMethod("Player", "setUsingPokeball", LuaScriptInterface::luaPlayerSetUsingPokeball);

	registerMethod("Player", "setLastTimePokeballUse", LuaScriptInterface::luaPlayerSetLastTimePokeballUse);
	registerMethod("Player", "getLastTimePokeballUse", LuaScriptInterface::luaPlayerGetLastTimePokeballUse);

	registerMethod("Player", "insertBall", LuaScriptInterface::luaPlayerInsertBall);
	registerMethod("Player", "getPokeballsCached", LuaScriptInterface::luaPlayerGetPokeballsCached);

	registerMethod("Player", "clearPokeballs", LuaScriptInterface::luaPlayerClearPokeballs);

	registerMethod("Player", "getMoney", LuaScriptInterface::luaPlayerGetMoney);
	registerMethod("Player", "addMoney", LuaScriptInterface::luaPlayerAddMoney);
	registerMethod("Player", "removeMoney", LuaScriptInterface::luaPlayerRemoveMoney);

	registerMethod("Player", "showTextDialog", LuaScriptInterface::luaPlayerShowTextDialog);

	registerMethod("Player", "sendTextMessage", LuaScriptInterface::luaPlayerSendTextMessage);
	registerMethod("Player", "sendChannelMessage", LuaScriptInterface::luaPlayerSendChannelMessage);
	registerMethod("Player", "sendPrivateMessage", LuaScriptInterface::luaPlayerSendPrivateMessage);
	registerMethod("Player", "sendClosePrivate", LuaScriptInterface::luaPlayerSendClosePrivate);
	registerMethod("Player", "channelSay", LuaScriptInterface::luaPlayerChannelSay);
	registerMethod("Player", "openChannel", LuaScriptInterface::luaPlayerOpenChannel);

	registerMethod("Player", "getSlotItem", LuaScriptInterface::luaPlayerGetSlotItem);
	registerMethod("Player", "getItemByPos", LuaScriptInterface::luaPlayerGetItemByPos);

	registerMethod("Player", "getParty", LuaScriptInterface::luaPlayerGetParty);

	registerMethod("Player", "addOutfit", LuaScriptInterface::luaPlayerAddOutfit);
	registerMethod("Player", "addOutfitAddon", LuaScriptInterface::luaPlayerAddOutfitAddon);
	registerMethod("Player", "removeOutfit", LuaScriptInterface::luaPlayerRemoveOutfit);
	registerMethod("Player", "removeOutfitAddon", LuaScriptInterface::luaPlayerRemoveOutfitAddon);
	registerMethod("Player", "hasOutfit", LuaScriptInterface::luaPlayerHasOutfit);
	registerMethod("Player", "sendOutfitWindow", LuaScriptInterface::luaPlayerSendOutfitWindow);

	registerMethod("Player", "addMount", LuaScriptInterface::luaPlayerAddMount);
	registerMethod("Player", "removeMount", LuaScriptInterface::luaPlayerRemoveMount);
	registerMethod("Player", "hasMount", LuaScriptInterface::luaPlayerHasMount);

	registerMethod("Player", "getPremiumDays", LuaScriptInterface::luaPlayerGetPremiumDays);
	registerMethod("Player", "addPremiumDays", LuaScriptInterface::luaPlayerAddPremiumDays);
	registerMethod("Player", "removePremiumDays", LuaScriptInterface::luaPlayerRemovePremiumDays);

	registerMethod("Player", "hasBlessing", LuaScriptInterface::luaPlayerHasBlessing);
	registerMethod("Player", "addBlessing", LuaScriptInterface::luaPlayerAddBlessing);
	registerMethod("Player", "removeBlessing", LuaScriptInterface::luaPlayerRemoveBlessing);

	registerMethod("Player", "canLearnSpell", LuaScriptInterface::luaPlayerCanLearnSpell);
	registerMethod("Player", "learnSpell", LuaScriptInterface::luaPlayerLearnSpell);
	registerMethod("Player", "forgetSpell", LuaScriptInterface::luaPlayerForgetSpell);
	registerMethod("Player", "hasLearnedSpell", LuaScriptInterface::luaPlayerHasLearnedSpell);

	registerMethod("Player", "sendTutorial", LuaScriptInterface::luaPlayerSendTutorial);
	registerMethod("Player", "addMapMark", LuaScriptInterface::luaPlayerAddMapMark);

	registerMethod("Player", "save", LuaScriptInterface::luaPlayerSave);
	registerMethod("Player", "popupFYI", LuaScriptInterface::luaPlayerPopupFYI);

	registerMethod("Player", "isPzLocked", LuaScriptInterface::luaPlayerIsPzLocked);

	registerMethod("Player", "getClient", LuaScriptInterface::luaPlayerGetClient);
	registerMethod("Player", "getHouse", LuaScriptInterface::luaPlayerGetHouse);
	registerMethod("Player", "sendHouseWindow", LuaScriptInterface::luaPlayerSendHouseWindow);
	registerMethod("Player", "setEditHouse", LuaScriptInterface::luaPlayerSetEditHouse);

	registerMethod("Player", "setGhostMode", LuaScriptInterface::luaPlayerSetGhostMode);
	
	registerMethod("Player", "getIdleTime", LuaScriptInterface::luaPlayerGetIdleTime);
	registerMethod("Player", "resetIdleTime", LuaScriptInterface::luaPlayerResetIdleTime);

	registerMethod("Player", "getContainerId", LuaScriptInterface::luaPlayerGetContainerId);
	registerMethod("Player", "getContainerById", LuaScriptInterface::luaPlayerGetContainerById);
	registerMethod("Player", "getContainerIndex", LuaScriptInterface::luaPlayerGetContainerIndex);
	// [CATCH-SYSTEM] Brokes
	registerMethod("Player", "addBrokes", LuaScriptInterface::luaPlayerAddBrokes);
	registerMethod("Player", "resetBrokes", LuaScriptInterface::luaPlayerResetBrokes);
	registerMethod("Player", "getBrokes", LuaScriptInterface::luaPlayerGetBrokes);
	registerMethod("Player", "getAllBrokes", LuaScriptInterface::luaPlayerGetAllBrokes);
	registerMethod("Player", "getUsedPokeballs", LuaScriptInterface::luaPlayerGetUsedPokeballs);

	// [CATCH-SYSTEM] Points
	registerMethod("Player", "addCatchPoints", LuaScriptInterface::luaPlayerAddCatchPoints);
	registerMethod("Player", "resetCatchPoints", LuaScriptInterface::luaPlayerResetCatchPoints);
	registerMethod("Player", "getCatchPoints", LuaScriptInterface::luaPlayerGetCatchPoints);

	registerMethod("Player", "addGuardian", LuaScriptInterface::luaPlayerAddGuardian);
	registerMethod("Player", "removeGuardian", LuaScriptInterface::luaPlayerRemoveGuardian);
	registerMethod("Player", "getGuardians", LuaScriptInterface::luaPlayerGetGuardians);

	registerMethod("Player", "getGuildEmblem", LuaScriptInterface::luaPlayerGetGuildEmblem);

	registerMethod("Player", "applyGuildBuffs", LuaScriptInterface::luaPlayerApplyGuildBuffs);
	registerMethod("Player", "removeGuildBuffs", LuaScriptInterface::luaPlayerRemoveGuildBuffs);
	registerMethod("Player", "updateRegeneration", LuaScriptInterface::luaPlayerUpdateRegeneration);
	registerMethod("Player", "addGuildContribution", LuaScriptInterface::luaPlayerAddGuildContribution);
	registerMethod("Player", "getGuildContribution", LuaScriptInterface::luaPlayerGetGuildContribution);

	registerMethod("Player", "setSpectating", LuaScriptInterface::luaPlayerSetSpectating);
  	registerMethod("Player", "addSpectator", LuaScriptInterface::luaPlayerAddSpectator);
  	registerMethod("Player", "removeSpectator", LuaScriptInterface::luaPlayerRemoveSpectator);
  	registerMethod("Player", "getSpectating", LuaScriptInterface::luaPlayerGetSpectating);
  	registerMethod("Player", "getSpectators", LuaScriptInterface::luaPlayerGetSpectators);

	registerMethod("Player", "hasChaseMode", LuaScriptInterface::luaPlayerHasChaseMode);
	registerMethod("Player", "hasSecureMode", LuaScriptInterface::luaPlayerHasSecureMode);
	registerMethod("Player", "getFightMode", LuaScriptInterface::luaPlayerGetFightMode);

	// Monster
	registerClass("Monster", "Creature", LuaScriptInterface::luaMonsterCreate);
	registerMetaMethod("Monster", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Monster", "isMonster", LuaScriptInterface::luaMonsterIsMonster);

	registerMethod("Monster", "getType", LuaScriptInterface::luaMonsterGetType);
	registerMethod("Monster", "getRank", LuaScriptInterface::luaMonsterGetRank);

	registerMethod("Monster", "getSpawnPosition", LuaScriptInterface::luaMonsterGetSpawnPosition);
	registerMethod("Monster", "isInSpawnRange", LuaScriptInterface::luaMonsterIsInSpawnRange);

	registerMethod("Monster", "isIdle", LuaScriptInterface::luaMonsterIsIdle);
	registerMethod("Monster", "setIdle", LuaScriptInterface::luaMonsterSetIdle);

	registerMethod("Monster", "isTarget", LuaScriptInterface::luaMonsterIsTarget);
	registerMethod("Monster", "isOpponent", LuaScriptInterface::luaMonsterIsOpponent);
	registerMethod("Monster", "isFriend", LuaScriptInterface::luaMonsterIsFriend);

	registerMethod("Monster", "addFriend", LuaScriptInterface::luaMonsterAddFriend);
	registerMethod("Monster", "removeFriend", LuaScriptInterface::luaMonsterRemoveFriend);
	registerMethod("Monster", "getFriendList", LuaScriptInterface::luaMonsterGetFriendList);
	registerMethod("Monster", "getFriendCount", LuaScriptInterface::luaMonsterGetFriendCount);

	registerMethod("Monster", "addTarget", LuaScriptInterface::luaMonsterAddTarget);
	registerMethod("Monster", "removeTarget", LuaScriptInterface::luaMonsterRemoveTarget);
	registerMethod("Monster", "getTargetList", LuaScriptInterface::luaMonsterGetTargetList);
	registerMethod("Monster", "getTargetCount", LuaScriptInterface::luaMonsterGetTargetCount);

	registerMethod("Monster", "selectTarget", LuaScriptInterface::luaMonsterSelectTarget);
	registerMethod("Monster", "searchTarget", LuaScriptInterface::luaMonsterSearchTarget);

	registerMethod("Monster", "isGuardian", LuaScriptInterface::luaMonsterIsGuardian);

	// Duelist
	registerClass("Duelist", "Creature", LuaScriptInterface::luaDuelistCreate);
	registerMetaMethod("Duelist", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Duelist", "isDuelist", LuaScriptInterface::luaDuelistIsDuelist);
	registerMethod("Duelist", "setContract", LuaScriptInterface::luaDuelistSetContract);
	registerMethod("Duelist", "setContractId", LuaScriptInterface::luaDuelistSetContractId);
	registerMethod("Duelist", "getContractId", LuaScriptInterface::luaDuelistGetContractId);

	//get exp from monsters
	registerMethod("Monster", "getExperience", LuaScriptInterface::luaMonsterGetExperience);
	registerMethod("Monster", "setExperience", LuaScriptInterface::luaMonsterSetExperience);
	registerMethod("Monster", "getLevel", LuaScriptInterface::luaMonsterGetLevel);
	registerMethod("Monster", "getBoost", LuaScriptInterface::luaMonsterGetBoost);

	registerMethod("Monster", "setOrderPosition", LuaScriptInterface::luaMonsterSetOrderPosition);
	registerMethod("Monster", "getOrderPosition", LuaScriptInterface::luaMonsterGetOrderPosition);

	registerMethod("Monster", "setPokeStopped", LuaScriptInterface::luaMonsterSetPokeStopped);
	registerMethod("Monster", "isPokeStopped", LuaScriptInterface::luaMonsterIsPokeStopped);

	registerMethod("Monster", "isGhost", LuaScriptInterface::luaMonsterIsGhost);

	// Npc
	registerClass("Npc", "Creature", LuaScriptInterface::luaNpcCreate);
	registerMetaMethod("Npc", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Npc", "isNpc", LuaScriptInterface::luaNpcIsNpc);

	registerMethod("Npc", "setMasterPos", LuaScriptInterface::luaNpcSetMasterPos);

	registerMethod("Npc", "getSpeechBubble", LuaScriptInterface::luaNpcGetSpeechBubble);
	registerMethod("Npc", "setSpeechBubble", LuaScriptInterface::luaNpcSetSpeechBubble);

	registerMethod("Npc", "isHolder", LuaScriptInterface::luaNpcIsHolder);

	// 
	registerClass("Guild", "", LuaScriptInterface::luaGuildCreate);
	registerMetaMethod("Guild", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Guild", "save", LuaScriptInterface::luaGuildSave);

	registerMethod("Guild", "getId", LuaScriptInterface::luaGuildGetId);
	registerMethod("Guild", "getName", LuaScriptInterface::luaGuildGetName);
	registerMethod("Guild", "getMembersOnline", LuaScriptInterface::luaGuildGetMembersOnline);

	registerMethod("Guild", "getMembers", LuaScriptInterface::luaGuildGetMembers);
	registerMethod("Guild", "addMember", LuaScriptInterface::luaGuildAddMember);
	registerMethod("Guild", "removeMember", LuaScriptInterface::luaGuildRemoveMember);
	registerMethod("Guild", "removeOnlineMember", LuaScriptInterface::luaGuildRemoveOnlineMember);
	registerMethod("Guild", "setMemberRank", LuaScriptInterface::luaGuildSetMemberRank);
	registerMethod("Guild", "getMemberRank", LuaScriptInterface::luaGuildGetMemberRank);

	registerMethod("Guild", "addRank", LuaScriptInterface::luaGuildAddRank);
	registerMethod("Guild", "editRank", LuaScriptInterface::luaGuildEditRank);
	registerMethod("Guild", "removeRank", LuaScriptInterface::luaGuildRemoveRank);
	registerMethod("Guild", "getDefaultRank", LuaScriptInterface::luaGuildGetDefaultRank);
	registerMethod("Guild", "getRanks", LuaScriptInterface::luaGuildGetRanks);

	registerMethod("Guild", "getRankById", LuaScriptInterface::luaGuildGetRankById);
	registerMethod("Guild", "getRankByName", LuaScriptInterface::luaGuildGetRankByName);

	registerMethod("Guild", "getMotd", LuaScriptInterface::luaGuildGetMotd);
	registerMethod("Guild", "setMotd", LuaScriptInterface::luaGuildSetMotd);

	registerMethod("Guild", "getLevel", LuaScriptInterface::luaGuildGetLevel);
	registerMethod("Guild", "setLevel", LuaScriptInterface::luaGuildSetLevel);

	registerMethod("Guild", "getGold", LuaScriptInterface::luaGuildGetGold);
	registerMethod("Guild", "setGold", LuaScriptInterface::luaGuildSetGold);
	registerMethod("Guild", "addGold", LuaScriptInterface::luaGuildAddGold);
	registerMethod("Guild", "removeGold", LuaScriptInterface::luaGuildRemoveGold);

	registerMethod("Guild", "getRequiredLevel", LuaScriptInterface::luaGuildGetRequiredLevel);
	registerMethod("Guild", "setRequiredLevel", LuaScriptInterface::luaGuildSetRequiredLevel);

	registerMethod("Guild", "getEmblem", LuaScriptInterface::luaGuildGetEmblem);
	registerMethod("Guild", "setEmblem", LuaScriptInterface::luaGuildSetEmblem);

	registerMethod("Guild", "getWarsWon", LuaScriptInterface::luaGuildGetWarsWon);
	registerMethod("Guild", "setWarsWon", LuaScriptInterface::luaGuildSetWarsWon);
	registerMethod("Guild", "addWarsWon", LuaScriptInterface::luaGuildAddWarsWon);

	registerMethod("Guild", "getWarsLost", LuaScriptInterface::luaGuildGetWarsLost);
	registerMethod("Guild", "setWarsLost", LuaScriptInterface::luaGuildSetWarsLost);
	registerMethod("Guild", "addWarsLost", LuaScriptInterface::luaGuildAddWarsLost);

	registerMethod("Guild", "getLanguage", LuaScriptInterface::luaGuildGetLanguage);
	registerMethod("Guild", "setLanguage", LuaScriptInterface::luaGuildSetLanguage);

	registerMethod("Guild", "getJoinStatus", LuaScriptInterface::luaGuildGetJoinStatus);
	registerMethod("Guild", "setJoinStatus", LuaScriptInterface::luaGuildSetJoinStatus);

	registerMethod("Guild", "getBuffs", LuaScriptInterface::luaGuildGetBuffs);
	registerMethod("Guild", "setBuff", LuaScriptInterface::luaGuildSetBuff);
	registerMethod("Guild", "hasBuff", LuaScriptInterface::luaGuildHasBuff);

	registerMethod("Guild", "getPacifism", LuaScriptInterface::luaGuildGetPacifism);
	registerMethod("Guild", "setPacifism", LuaScriptInterface::luaGuildSetPacifism);
	registerMethod("Guild", "isPacifist", LuaScriptInterface::luaGuildIsPacifist);

	registerMethod("Guild", "getPacifismStatus", LuaScriptInterface::luaGuildGetPacifismStatus);
	registerMethod("Guild", "setPacifismStatus", LuaScriptInterface::luaGuildSetPacifismStatus);

	registerMethod("Guild", "getCombinedLevels", LuaScriptInterface::luaGuildGetCombinedLevels);

	registerMethod("Guild", "setLeaderName", LuaScriptInterface::luaGuildSetLeaderName);
	registerMethod("Guild", "getLeaderName", LuaScriptInterface::luaGuildGetLeaderName);

	registerMethod("Guild", "getMemberCount", LuaScriptInterface::luaGuildGetMemberCount);

	registerMethod("Guild", "addWar", LuaScriptInterface::luaGuildAddWar);
	registerMethod("Guild", "removeWar", LuaScriptInterface::luaGuildRemoveWar);
	registerMethod("Guild", "isInWar", LuaScriptInterface::luaGuildIsInWar);
	registerMethod("Guild", "isInAnyWar", LuaScriptInterface::luaGuildIsInAnyWar);
	registerMethod("Guild", "getWarEndDate", LuaScriptInterface::luaGuildGetWarEndDate);
	registerMethod("Guild", "getWar", LuaScriptInterface::luaGuildGetWar);
	registerMethod("Guild", "getWars", LuaScriptInterface::luaGuildGetWars);
	registerMethod("Guild", "addWarKill", LuaScriptInterface::luaGuildAddWarKill);
	registerMethod("Guild", "setWarStatus", LuaScriptInterface::luaGuildSetWarStatus);

	registerMethod("Guild", "setLastBuffSave", LuaScriptInterface::luaGuildSetLastBuffSave);
	registerMethod("Guild", "getLastBuffSave", LuaScriptInterface::luaGuildGetLastBuffSave);

	// Group
	registerClass("Group", "", LuaScriptInterface::luaGroupCreate);
	registerMetaMethod("Group", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Group", "getId", LuaScriptInterface::luaGroupGetId);
	registerMethod("Group", "getName", LuaScriptInterface::luaGroupGetName);
	registerMethod("Group", "getFlags", LuaScriptInterface::luaGroupGetFlags);
	registerMethod("Group", "getAccess", LuaScriptInterface::luaGroupGetAccess);
	registerMethod("Group", "getMaxDepotItems", LuaScriptInterface::luaGroupGetMaxDepotItems);
	registerMethod("Group", "getMaxVipEntries", LuaScriptInterface::luaGroupGetMaxVipEntries);
	registerMethod("Group", "hasFlag", LuaScriptInterface::luaGroupHasFlag);

	// Vocation
	registerClass("Vocation", "", LuaScriptInterface::luaVocationCreate);
	registerMetaMethod("Vocation", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Vocation", "getId", LuaScriptInterface::luaVocationGetId);
	registerMethod("Vocation", "getClientId", LuaScriptInterface::luaVocationGetClientId);
	registerMethod("Vocation", "getName", LuaScriptInterface::luaVocationGetName);
	registerMethod("Vocation", "getDescription", LuaScriptInterface::luaVocationGetDescription);

	registerMethod("Vocation", "getRequiredSkillTries", LuaScriptInterface::luaVocationGetRequiredSkillTries);
	registerMethod("Vocation", "getRequiredManaSpent", LuaScriptInterface::luaVocationGetRequiredManaSpent);

	registerMethod("Vocation", "getCapacityGain", LuaScriptInterface::luaVocationGetCapacityGain);

	registerMethod("Vocation", "getHealthGain", LuaScriptInterface::luaVocationGetHealthGain);
	registerMethod("Vocation", "getHealthGainTicks", LuaScriptInterface::luaVocationGetHealthGainTicks);
	registerMethod("Vocation", "getHealthGainAmount", LuaScriptInterface::luaVocationGetHealthGainAmount);

	registerMethod("Vocation", "getManaGain", LuaScriptInterface::luaVocationGetManaGain);
	registerMethod("Vocation", "getManaGainTicks", LuaScriptInterface::luaVocationGetManaGainTicks);
	registerMethod("Vocation", "getManaGainAmount", LuaScriptInterface::luaVocationGetManaGainAmount);

	registerMethod("Vocation", "getMaxSoul", LuaScriptInterface::luaVocationGetMaxSoul);
	registerMethod("Vocation", "getSoulGainTicks", LuaScriptInterface::luaVocationGetSoulGainTicks);

	registerMethod("Vocation", "getAttackSpeed", LuaScriptInterface::luaVocationGetAttackSpeed);
	registerMethod("Vocation", "getBaseSpeed", LuaScriptInterface::luaVocationGetBaseSpeed);

	registerMethod("Vocation", "getDemotion", LuaScriptInterface::luaVocationGetDemotion);
	registerMethod("Vocation", "getPromotion", LuaScriptInterface::luaVocationGetPromotion);

	// Town
	registerClass("Town", "", LuaScriptInterface::luaTownCreate);
	registerMetaMethod("Town", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Town", "getId", LuaScriptInterface::luaTownGetId);
	registerMethod("Town", "getName", LuaScriptInterface::luaTownGetName);
	registerMethod("Town", "getTemplePosition", LuaScriptInterface::luaTownGetTemplePosition);

	// House
	registerClass("House", "", LuaScriptInterface::luaHouseCreate);
	registerMetaMethod("House", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("House", "getId", LuaScriptInterface::luaHouseGetId);
	registerMethod("House", "getName", LuaScriptInterface::luaHouseGetName);
	registerMethod("House", "getTown", LuaScriptInterface::luaHouseGetTown);
	registerMethod("House", "getExitPosition", LuaScriptInterface::luaHouseGetExitPosition);
	registerMethod("House", "getRent", LuaScriptInterface::luaHouseGetRent);

	registerMethod("House", "getOwnerGuid", LuaScriptInterface::luaHouseGetOwnerGuid);
	registerMethod("House", "setOwnerGuid", LuaScriptInterface::luaHouseSetOwnerGuid);
	registerMethod("House", "startTrade", LuaScriptInterface::luaHouseStartTrade);

	registerMethod("House", "getBeds", LuaScriptInterface::luaHouseGetBeds);
	registerMethod("House", "getBedCount", LuaScriptInterface::luaHouseGetBedCount);

	registerMethod("House", "getDoors", LuaScriptInterface::luaHouseGetDoors);
	registerMethod("House", "getDoorCount", LuaScriptInterface::luaHouseGetDoorCount);
	registerMethod("House", "getDoorIdByPosition", LuaScriptInterface::luaHouseGetDoorIdByPosition);

	registerMethod("House", "getTiles", LuaScriptInterface::luaHouseGetTiles);
	registerMethod("House", "getItems", LuaScriptInterface::luaHouseGetItems);
	registerMethod("House", "getTileCount", LuaScriptInterface::luaHouseGetTileCount);
	registerMethod("House", "canEditAccessList", LuaScriptInterface::luaHouseCanEditAccessList);

	registerMethod("House", "getAccessList", LuaScriptInterface::luaHouseGetAccessList);
	registerMethod("House", "setAccessList", LuaScriptInterface::luaHouseSetAccessList);
	
	registerMethod("House", "kickPlayer", LuaScriptInterface::luaHouseKickPlayer);

	// ItemType
	registerClass("ItemType", "", LuaScriptInterface::luaItemTypeCreate);
	registerMetaMethod("ItemType", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("ItemType", "isCorpse", LuaScriptInterface::luaItemTypeIsCorpse);
	registerMethod("ItemType", "isHolder", LuaScriptInterface::luaItemTypeIsHolder);
	registerMethod("ItemType", "isDoor", LuaScriptInterface::luaItemTypeIsDoor);
	registerMethod("ItemType", "isContainer", LuaScriptInterface::luaItemTypeIsContainer);
	registerMethod("ItemType", "isFluidContainer", LuaScriptInterface::luaItemTypeIsFluidContainer);
	registerMethod("ItemType", "isMovable", LuaScriptInterface::luaItemTypeIsMovable);
	registerMethod("ItemType", "isRune", LuaScriptInterface::luaItemTypeIsRune);
	registerMethod("ItemType", "isStackable", LuaScriptInterface::luaItemTypeIsStackable);
	registerMethod("ItemType", "isReadable", LuaScriptInterface::luaItemTypeIsReadable);
	registerMethod("ItemType", "isWritable", LuaScriptInterface::luaItemTypeIsWritable);
	registerMethod("ItemType", "isBlocking", LuaScriptInterface::luaItemTypeIsBlocking);
	registerMethod("ItemType", "isGroundTile", LuaScriptInterface::luaItemTypeIsGroundTile);
	registerMethod("ItemType", "isMagicField", LuaScriptInterface::luaItemTypeIsMagicField);
	registerMethod("ItemType", "isUseable", LuaScriptInterface::luaItemTypeIsUseable);
	registerMethod("ItemType", "isPickupable", LuaScriptInterface::luaItemTypeIsPickupable);

	registerMethod("ItemType", "getType", LuaScriptInterface::luaItemTypeGetType);
	registerMethod("ItemType", "getId", LuaScriptInterface::luaItemTypeGetId);
	registerMethod("ItemType", "getClientId", LuaScriptInterface::luaItemTypeGetClientId);
	registerMethod("ItemType", "getName", LuaScriptInterface::luaItemTypeGetName);
	registerMethod("ItemType", "getPluralName", LuaScriptInterface::luaItemTypeGetPluralName);
	registerMethod("ItemType", "getArticle", LuaScriptInterface::luaItemTypeGetArticle);
	registerMethod("ItemType", "getDescription", LuaScriptInterface::luaItemTypeGetDescription);
	registerMethod("ItemType", "getSlotPosition", LuaScriptInterface::luaItemTypeGetSlotPosition);

	registerMethod("ItemType", "getCharges", LuaScriptInterface::luaItemTypeGetCharges);
	registerMethod("ItemType", "getFluidSource", LuaScriptInterface::luaItemTypeGetFluidSource);
	registerMethod("ItemType", "getCapacity", LuaScriptInterface::luaItemTypeGetCapacity);
	registerMethod("ItemType", "getWeight", LuaScriptInterface::luaItemTypeGetWeight);

	registerMethod("ItemType", "getHitChance", LuaScriptInterface::luaItemTypeGetHitChance);
	registerMethod("ItemType", "getShootRange", LuaScriptInterface::luaItemTypeGetShootRange);

	registerMethod("ItemType", "getAttack", LuaScriptInterface::luaItemTypeGetAttack);
	registerMethod("ItemType", "getDefense", LuaScriptInterface::luaItemTypeGetDefense);
	registerMethod("ItemType", "getExtraDefense", LuaScriptInterface::luaItemTypeGetExtraDefense);
	registerMethod("ItemType", "getArmor", LuaScriptInterface::luaItemTypeGetArmor);
	registerMethod("ItemType", "getWeaponType", LuaScriptInterface::luaItemTypeGetWeaponType);

	registerMethod("ItemType", "getElementType", LuaScriptInterface::luaItemTypeGetElementType);
	registerMethod("ItemType", "getElementDamage", LuaScriptInterface::luaItemTypeGetElementDamage);

	registerMethod("ItemType", "getTransformEquipId", LuaScriptInterface::luaItemTypeGetTransformEquipId);
	registerMethod("ItemType", "getTransformDeEquipId", LuaScriptInterface::luaItemTypeGetTransformDeEquipId);
	registerMethod("ItemType", "getDestroyId", LuaScriptInterface::luaItemTypeGetDestroyId);
	registerMethod("ItemType", "getDecayId", LuaScriptInterface::luaItemTypeGetDecayId);
	registerMethod("ItemType", "getDecayTime", LuaScriptInterface::luaItemTypeGetDecayTime);
	registerMethod("ItemType", "getRequiredLevel", LuaScriptInterface::luaItemTypeGetRequiredLevel);
	registerMethod("ItemType", "getAmmoType", LuaScriptInterface::luaItemTypeGetAmmoType);
	registerMethod("ItemType", "getCorpseType", LuaScriptInterface::luaItemTypeGetCorpseType);

	registerMethod("ItemType", "hasSubType", LuaScriptInterface::luaItemTypeHasSubType);

	// Combat
	registerClass("Combat", "", LuaScriptInterface::luaCombatCreate);
	registerMetaMethod("Combat", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("Combat", "__gc", LuaScriptInterface::luaCombatDelete);
	registerMethod("Combat", "delete", LuaScriptInterface::luaCombatDelete);
	registerMethod("Combat", "setCondition", LuaScriptInterface::luaCombatAddCondition);
	registerMethod("Combat", "getSize", LuaScriptInterface::luaCombatGetConditionsSize);
	registerMethod("Combat", "clearConditions", LuaScriptInterface::luaCombatClearConditions);

	registerMethod("Combat", "setParameter", LuaScriptInterface::luaCombatSetParameter);
	registerMethod("Combat", "setStringParameter", LuaScriptInterface::luaCombatSetStringParameter);
	registerMethod("Combat", "setFormula", LuaScriptInterface::luaCombatSetFormula);

	registerMethod("Combat", "setArea", LuaScriptInterface::luaCombatSetArea);
	registerMethod("Combat", "addCondition", LuaScriptInterface::luaCombatAddCondition);
	registerMethod("Combat", "setCallback", LuaScriptInterface::luaCombatSetCallback);
	registerMethod("Combat", "setOrigin", LuaScriptInterface::luaCombatSetOrigin);

	registerMethod("Combat", "execute", LuaScriptInterface::luaCombatExecute);

	// Condition
	registerClass("Condition", "", LuaScriptInterface::luaConditionCreate);
	registerMetaMethod("Condition", "__eq", LuaScriptInterface::luaUserdataCompare);
	registerMetaMethod("Condition", "__gc", LuaScriptInterface::luaConditionDelete);
	registerMethod("Condition", "delete", LuaScriptInterface::luaConditionDelete);

	registerMethod("Condition", "getId", LuaScriptInterface::luaConditionGetId);
	registerMethod("Condition", "getSubId", LuaScriptInterface::luaConditionGetSubId);

	registerMethod("Condition", "saveCondition", LuaScriptInterface::luaConditionSaveCondition);
	registerMethod("Condition", "getType", LuaScriptInterface::luaConditionGetType);
	registerMethod("Condition", "getIcons", LuaScriptInterface::luaConditionGetIcons);
	registerMethod("Condition", "getEndTime", LuaScriptInterface::luaConditionGetEndTime);

	registerMethod("Condition", "clone", LuaScriptInterface::luaConditionClone);
	registerMethod("Condition", "getTicks", LuaScriptInterface::luaConditionGetTicks);
	registerMethod("Condition", "setTicks", LuaScriptInterface::luaConditionSetTicks);

	registerMethod("Condition", "setParameter", LuaScriptInterface::luaConditionSetParameter);
	registerMethod("Condition", "setFormula", LuaScriptInterface::luaConditionSetFormula);
	registerMethod("Condition", "setOutfit", LuaScriptInterface::luaConditionSetOutfit);

	registerMethod("Condition", "addDamage", LuaScriptInterface::luaConditionAddDamage);

	registerMethod("Condition", "setBonus", LuaScriptInterface::luaConditionSetBonus);
	registerMethod("Condition", "getBonus", LuaScriptInterface::luaConditionGetBonus);

	// MonsterType
	registerClass("MonsterType", "", LuaScriptInterface::luaMonsterTypeCreate);
	registerMetaMethod("MonsterType", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("MonsterType", "isAttackable", LuaScriptInterface::luaMonsterTypeIsAttackable);
	registerMethod("MonsterType", "isConvinceable", LuaScriptInterface::luaMonsterTypeIsConvinceable);
	registerMethod("MonsterType", "isSummonable", LuaScriptInterface::luaMonsterTypeIsSummonable);
	registerMethod("MonsterType", "isIllusionable", LuaScriptInterface::luaMonsterTypeIsIllusionable);
	registerMethod("MonsterType", "isHostile", LuaScriptInterface::luaMonsterTypeIsHostile);
	registerMethod("MonsterType", "isPassive", LuaScriptInterface::luaMonsterTypeIsPassive);

	registerMethod("MonsterType", "isFlyable", LuaScriptInterface::luaMonsterTypeIsFlyable);
	registerMethod("MonsterType", "isRideable", LuaScriptInterface::luaMonsterTypeIsRideable);
	registerMethod("MonsterType", "isSurfable", LuaScriptInterface::luaMonsterTypeIsSurfable);
	registerMethod("MonsterType", "canTeleport", LuaScriptInterface::luaMonsterTypeCanTeleport);
	registerMethod("MonsterType", "canBlink", LuaScriptInterface::luaMonsterTypeCanBlink);
	registerMethod("MonsterType", "canDig", LuaScriptInterface::luaMonsterTypeCanDig);
	registerMethod("MonsterType", "canSmash", LuaScriptInterface::luaMonsterTypeCanSmash);
	registerMethod("MonsterType", "canCut", LuaScriptInterface::luaMonsterTypeCanCut);
	registerMethod("MonsterType", "canLight", LuaScriptInterface::luaMonsterTypeCanLight);
	registerMethod("MonsterType", "canLevitate", LuaScriptInterface::luaMonsterTypeCanLevitate);
	registerMethod("MonsterType", "canControlMind", LuaScriptInterface::luaMonsterTypeCanControlMind);

	registerMethod("MonsterType", "funcao", LuaScriptInterface::luaMonsterTypeFuncao);
	
	
	registerMethod("MonsterType", "catchChance", LuaScriptInterface::luaMonsterTypeCatchChance);
	registerMethod("MonsterType", "moveMagicAttackBase", LuaScriptInterface::luaMonsterTypeGetMoveMagicAttackBase);
	registerMethod("MonsterType", "moveMagicDefenseBase", LuaScriptInterface::luaMonsterTypeGetMoveMagicDefenseBase);
	
	registerMethod("MonsterType", "getPhysicalDamage", LuaScriptInterface::luaMonsterTypeGetPhysicalDamage);
	registerMethod("MonsterType", "getSpecialDamage", LuaScriptInterface::luaMonsterTypeGetSpecialDamage);
	registerMethod("MonsterType", "getSpecialDefense", LuaScriptInterface::luaMonsterTypeGetSpecialDefense);
	registerMethod("MonsterType", "getPhysicalDefense", LuaScriptInterface::luaMonsterTypeGetPhysicalDefense);
	
	registerMethod("MonsterType", "minimumLevel", LuaScriptInterface::luaMonsterTypeGetMinimumLevel);
	registerMethod("MonsterType", "wildHealth", LuaScriptInterface::luaMonsterTypeWildHealth);
	registerMethod("MonsterType", "wildMaxHealth", LuaScriptInterface::luaMonsterTypeWildMaxHealth);
	registerMethod("MonsterType", "wildBaseSpeed", LuaScriptInterface::luaMonsterTypeWildBaseSpeed);
	registerMethod("MonsterType", "pokemonRank", LuaScriptInterface::luaMonsterTypeGetPokemonRank);
	
	registerMethod("MonsterType", "hasShiny", LuaScriptInterface::luaMonsterTypeHasShiny);
	registerMethod("MonsterType", "hasMega", LuaScriptInterface::luaMonsterTypeHasMega);
	registerMethod("MonsterType", "dexEntry", LuaScriptInterface::luaMonsterTypeDexEntry);
	registerMethod("MonsterType", "portraitId", LuaScriptInterface::luaMonsterTypePortraitId);

	registerMethod("MonsterType", "isPushable", LuaScriptInterface::luaMonsterTypeIsPushable);
	registerMethod("MonsterType", "isHealthHidden", LuaScriptInterface::luaMonsterTypeIsHealthHidden);

	registerMethod("MonsterType", "canPushItems", LuaScriptInterface::luaMonsterTypeCanPushItems);
	registerMethod("MonsterType", "canPushCreatures", LuaScriptInterface::luaMonsterTypeCanPushCreatures);


	registerMethod("MonsterType", "name", LuaScriptInterface::luaMonsterTypeName);
	registerMethod("MonsterType", "nameDescription", LuaScriptInterface::luaMonsterTypeNameDescription);
	registerMethod("MonsterType", "addAttack", LuaScriptInterface::luaMonsterTypeAddAttack);
	registerMethod("MonsterType", "addMove", LuaScriptInterface::luaMonsterTypeAddMove);

	registerMethod("MonsterType", "addDefense", LuaScriptInterface::luaMonsterTypeAddDefense);
	registerMethod("MonsterType", "addElement", LuaScriptInterface::luaMonsterTypeAddElement);

	registerMethod("MonsterType", "addVoice", LuaScriptInterface::luaMonsterTypeAddVoice);
	registerMethod("MonsterType", "health", LuaScriptInterface::luaMonsterTypeHealth);
	registerMethod("MonsterType", "maxHealth", LuaScriptInterface::luaMonsterTypeMaxHealth);
	registerMethod("MonsterType", "runHealth", LuaScriptInterface::luaMonsterTypeRunHealth);
	registerMethod("MonsterType", "experience", LuaScriptInterface::luaMonsterTypeExperience);
	registerMethod("MonsterType", "skull", LuaScriptInterface::luaMonsterTypeSkull);

	registerMethod("MonsterType", "combatImmunities", LuaScriptInterface::luaMonsterTypeCombatImmunities);
	registerMethod("MonsterType", "conditionImmunities", LuaScriptInterface::luaMonsterTypeConditionImmunities);

	registerMethod("MonsterType", "getAttackList", LuaScriptInterface::luaMonsterTypeGetAttackList);
	registerMethod("MonsterType", "getDefenseList", LuaScriptInterface::luaMonsterTypeGetDefenseList);
	registerMethod("MonsterType", "getElementList", LuaScriptInterface::luaMonsterTypeGetElementList);

	registerMethod("MonsterType", "getMoveList", LuaScriptInterface::luaMonsterTypeGetMoveList);

	registerMethod("MonsterType", "getVoices", LuaScriptInterface::luaMonsterTypeGetVoices);
	registerMethod("MonsterType", "getLoot", LuaScriptInterface::luaMonsterTypeGetLoot);
	registerMethod("MonsterType", "addLoot", LuaScriptInterface::luaMonsterTypeAddLoot);

	registerMethod("MonsterType", "getCreatureEvents", LuaScriptInterface::luaMonsterTypeGetCreatureEvents);
	registerMethod("MonsterType", "registerEvent", LuaScriptInterface::luaMonsterTypeRegisterEvent);

	registerMethod("MonsterType", "eventType", LuaScriptInterface::luaMonsterTypeEventType);
	registerMethod("MonsterType", "onThink", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onAppear", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onDisappear", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onMove", LuaScriptInterface::luaMonsterTypeEventOnCallback);
	registerMethod("MonsterType", "onSay", LuaScriptInterface::luaMonsterTypeEventOnCallback);

	registerMethod("MonsterType", "getSummonList", LuaScriptInterface::luaMonsterTypeGetSummonList);
	registerMethod("MonsterType", "getEvolutionList", LuaScriptInterface::luaMonsterTypeGetEvolutionList);
	registerMethod("MonsterType", "addEvolution", LuaScriptInterface::luaMonsterTypeAddEvolution);
	registerMethod("MonsterType", "race2", LuaScriptInterface::luaMonsterTypeRace2);
	registerMethod("MonsterType", "getMinLevel", LuaScriptInterface::luaMonsterTypeGetMinLevel);
	registerMethod("MonsterType", "getMaxLevel", LuaScriptInterface::luaMonsterTypeGetMaxLevel);

	registerMethod("MonsterType", "addSummon", LuaScriptInterface::luaMonsterTypeAddSummon);

	registerMethod("MonsterType", "maxSummons", LuaScriptInterface::luaMonsterTypeMaxSummons);

	registerMethod("MonsterType", "armor", LuaScriptInterface::luaMonsterTypeArmor);
	registerMethod("MonsterType", "defense", LuaScriptInterface::luaMonsterTypeDefense);
	registerMethod("MonsterType", "outfit", LuaScriptInterface::luaMonsterTypeOutfit);
	registerMethod("MonsterType", "race", LuaScriptInterface::luaMonsterTypeRace);
	registerMethod("MonsterType", "corpseId", LuaScriptInterface::luaMonsterTypeCorpseId);
	registerMethod("MonsterType", "manaCost", LuaScriptInterface::luaMonsterTypeManaCost);
	registerMethod("MonsterType", "baseSpeed", LuaScriptInterface::luaMonsterTypeBaseSpeed);
	registerMethod("MonsterType", "light", LuaScriptInterface::luaMonsterTypeLight);

	registerMethod("MonsterType", "staticAttackChance", LuaScriptInterface::luaMonsterTypeStaticAttackChance);
	registerMethod("MonsterType", "targetDistance", LuaScriptInterface::luaMonsterTypeTargetDistance);
	registerMethod("MonsterType", "yellChance", LuaScriptInterface::luaMonsterTypeYellChance);
	registerMethod("MonsterType", "yellSpeedTicks", LuaScriptInterface::luaMonsterTypeYellSpeedTicks);
	registerMethod("MonsterType", "changeTargetChance", LuaScriptInterface::luaMonsterTypeChangeTargetChance);
	registerMethod("MonsterType", "changeTargetSpeed", LuaScriptInterface::luaMonsterTypeChangeTargetSpeed);

	// Loot
	registerClass("Loot", "", LuaScriptInterface::luaCreateLoot);
	registerMetaMethod("Loot", "__gc", LuaScriptInterface::luaDeleteLoot);
	registerMethod("Loot", "delete", LuaScriptInterface::luaDeleteLoot);

	registerMethod("Loot", "setId", LuaScriptInterface::luaLootSetId);
	registerMethod("Loot", "setMaxCount", LuaScriptInterface::luaLootSetMaxCount);
	registerMethod("Loot", "setSubType", LuaScriptInterface::luaLootSetSubType);
	registerMethod("Loot", "setChance", LuaScriptInterface::luaLootSetChance);
	registerMethod("Loot", "setActionId", LuaScriptInterface::luaLootSetActionId);
	registerMethod("Loot", "setDescription", LuaScriptInterface::luaLootSetDescription);
	registerMethod("Loot", "addChildLoot", LuaScriptInterface::luaLootAddChildLoot);

	// MonsterSpell
	registerClass("MonsterSpell", "", LuaScriptInterface::luaCreateMonsterSpell);
	registerMetaMethod("MonsterSpell", "__gc", LuaScriptInterface::luaDeleteMonsterSpell);
	registerMethod("MonsterSpell", "delete", LuaScriptInterface::luaDeleteMonsterSpell);

	registerMethod("MonsterSpell", "setType", LuaScriptInterface::luaMonsterSpellSetType);
	registerMethod("MonsterSpell", "setScriptName", LuaScriptInterface::luaMonsterSpellSetScriptName);
	registerMethod("MonsterSpell", "setChance", LuaScriptInterface::luaMonsterSpellSetChance);
	registerMethod("MonsterSpell", "setInterval", LuaScriptInterface::luaMonsterSpellSetInterval);
	registerMethod("MonsterSpell", "setRange", LuaScriptInterface::luaMonsterSpellSetRange);
	registerMethod("MonsterSpell", "setCombatValue", LuaScriptInterface::luaMonsterSpellSetCombatValue);
	registerMethod("MonsterSpell", "setCombatType", LuaScriptInterface::luaMonsterSpellSetCombatType);
	registerMethod("MonsterSpell", "setAttackValue", LuaScriptInterface::luaMonsterSpellSetAttackValue);
	registerMethod("MonsterSpell", "setPower", LuaScriptInterface::luaMonsterSpellSetPower);
	registerMethod("MonsterSpell", "setLevel", LuaScriptInterface::luaMonsterSpellSetLevel);
	registerMethod("MonsterSpell", "setPassive", LuaScriptInterface::luaMonsterSpellSetPassive);
	registerMethod("MonsterSpell", "setNeedTarget", LuaScriptInterface::luaMonsterSpellSetNeedTarget);
	registerMethod("MonsterSpell", "setCombatLength", LuaScriptInterface::luaMonsterSpellSetCombatLength);
	registerMethod("MonsterSpell", "setCombatSpread", LuaScriptInterface::luaMonsterSpellSetCombatSpread);
	registerMethod("MonsterSpell", "setCombatRadius", LuaScriptInterface::luaMonsterSpellSetCombatRadius);
	registerMethod("MonsterSpell", "setConditionType", LuaScriptInterface::luaMonsterSpellSetConditionType);
	registerMethod("MonsterSpell", "setConditionDamage", LuaScriptInterface::luaMonsterSpellSetConditionDamage);
	registerMethod("MonsterSpell", "setConditionSpeedChange", LuaScriptInterface::luaMonsterSpellSetConditionSpeedChange);
	registerMethod("MonsterSpell", "setConditionDuration", LuaScriptInterface::luaMonsterSpellSetConditionDuration);
	registerMethod("MonsterSpell", "setConditionTickInterval", LuaScriptInterface::luaMonsterSpellSetConditionTickInterval);
	registerMethod("MonsterSpell", "setCombatShootEffect", LuaScriptInterface::luaMonsterSpellSetCombatShootEffect);
	registerMethod("MonsterSpell", "setCombatEffect", LuaScriptInterface::luaMonsterSpellSetCombatEffect);
	// Party
	registerClass("Party", "", LuaScriptInterface::luaPartyCreate);
	registerMetaMethod("Party", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Party", "disband", LuaScriptInterface::luaPartyDisband);

	registerMethod("Party", "getLeader", LuaScriptInterface::luaPartyGetLeader);
	registerMethod("Party", "setLeader", LuaScriptInterface::luaPartySetLeader);

	registerMethod("Party", "getMembers", LuaScriptInterface::luaPartyGetMembers);
	registerMethod("Party", "getMemberCount", LuaScriptInterface::luaPartyGetMemberCount);

	registerMethod("Party", "getInvitees", LuaScriptInterface::luaPartyGetInvitees);
	registerMethod("Party", "getInviteeCount", LuaScriptInterface::luaPartyGetInviteeCount);

	registerMethod("Party", "addInvite", LuaScriptInterface::luaPartyAddInvite);
	registerMethod("Party", "removeInvite", LuaScriptInterface::luaPartyRemoveInvite);

	registerMethod("Party", "addMember", LuaScriptInterface::luaPartyAddMember);
	registerMethod("Party", "removeMember", LuaScriptInterface::luaPartyRemoveMember);

	registerMethod("Party", "isSharedExperienceActive", LuaScriptInterface::luaPartyIsSharedExperienceActive);
	registerMethod("Party", "isSharedExperienceEnabled", LuaScriptInterface::luaPartyIsSharedExperienceEnabled);
	registerMethod("Party", "shareExperience", LuaScriptInterface::luaPartyShareExperience);
	registerMethod("Party", "setSharedExperience", LuaScriptInterface::luaPartySetSharedExperience);

	// Spells
	registerClass("Spell", "", LuaScriptInterface::luaSpellCreate);
	registerMetaMethod("Spell", "__eq", LuaScriptInterface::luaUserdataCompare);

	registerMethod("Spell", "onCastSpell", LuaScriptInterface::luaSpellOnCastSpell);
	registerMethod("Spell", "register", LuaScriptInterface::luaSpellRegister);
	registerMethod("Spell", "name", LuaScriptInterface::luaSpellName);
	registerMethod("Spell", "id", LuaScriptInterface::luaSpellId);
	registerMethod("Spell", "group", LuaScriptInterface::luaSpellGroup);
	registerMethod("Spell", "cooldown", LuaScriptInterface::luaSpellCooldown);
	registerMethod("Spell", "groupCooldown", LuaScriptInterface::luaSpellGroupCooldown);
	registerMethod("Spell", "level", LuaScriptInterface::luaSpellLevel);
	registerMethod("Spell", "magicLevel", LuaScriptInterface::luaSpellMagicLevel);
	registerMethod("Spell", "mana", LuaScriptInterface::luaSpellMana);
	registerMethod("Spell", "manaPercent", LuaScriptInterface::luaSpellManaPercent);
	registerMethod("Spell", "soul", LuaScriptInterface::luaSpellSoul);
	registerMethod("Spell", "range", LuaScriptInterface::luaSpellRange);
	registerMethod("Spell", "isPremium", LuaScriptInterface::luaSpellPremium);
	registerMethod("Spell", "isEnabled", LuaScriptInterface::luaSpellEnabled);
	registerMethod("Spell", "needTarget", LuaScriptInterface::luaSpellNeedTarget);
	registerMethod("Spell", "needWeapon", LuaScriptInterface::luaSpellNeedWeapon);
	registerMethod("Spell", "needLearn", LuaScriptInterface::luaSpellNeedLearn);
	registerMethod("Spell", "isSelfTarget", LuaScriptInterface::luaSpellSelfTarget);
	registerMethod("Spell", "isBlocking", LuaScriptInterface::luaSpellBlocking);
	registerMethod("Spell", "isAggressive", LuaScriptInterface::luaSpellAggressive);
	registerMethod("Spell", "isPzLock", LuaScriptInterface::luaSpellPzLock);
	registerMethod("Spell", "vocation", LuaScriptInterface::luaSpellVocation);

	// only for InstantSpell
	registerMethod("Spell", "words", LuaScriptInterface::luaSpellWords);
	registerMethod("Spell", "needDirection", LuaScriptInterface::luaSpellNeedDirection);
	registerMethod("Spell", "hasParams", LuaScriptInterface::luaSpellHasParams);
	registerMethod("Spell", "hasPlayerNameParam", LuaScriptInterface::luaSpellHasPlayerNameParam);
	registerMethod("Spell", "needCasterTargetOrDirection", LuaScriptInterface::luaSpellNeedCasterTargetOrDirection);
	registerMethod("Spell", "isBlockingWalls", LuaScriptInterface::luaSpellIsBlockingWalls);

	// only for RuneSpells
	registerMethod("Spell", "runeLevel", LuaScriptInterface::luaSpellRuneLevel);
	registerMethod("Spell", "runeMagicLevel", LuaScriptInterface::luaSpellRuneMagicLevel);
	registerMethod("Spell", "runeId", LuaScriptInterface::luaSpellRuneId);
	registerMethod("Spell", "charges", LuaScriptInterface::luaSpellCharges);
	registerMethod("Spell", "allowFarUse", LuaScriptInterface::luaSpellAllowFarUse);
	registerMethod("Spell", "blockWalls", LuaScriptInterface::luaSpellBlockWalls);
	registerMethod("Spell", "checkFloor", LuaScriptInterface::luaSpellCheckFloor);

	// Action
	registerClass("Action", "", LuaScriptInterface::luaCreateAction);
	registerMethod("Action", "onUse", LuaScriptInterface::luaActionOnUse);
	registerMethod("Action", "register", LuaScriptInterface::luaActionRegister);
	registerMethod("Action", "id", LuaScriptInterface::luaActionItemId);
	registerMethod("Action", "aid", LuaScriptInterface::luaActionActionId);
	registerMethod("Action", "uid", LuaScriptInterface::luaActionUniqueId);
	registerMethod("Action", "allowFarUse", LuaScriptInterface::luaActionAllowFarUse);
	registerMethod("Action", "blockWalls", LuaScriptInterface::luaActionBlockWalls);
	registerMethod("Action", "checkFloor", LuaScriptInterface::luaActionCheckFloor);

	// TalkAction
	registerClass("TalkAction", "", LuaScriptInterface::luaCreateTalkaction);
	registerMethod("TalkAction", "onSay", LuaScriptInterface::luaTalkactionOnSay);
	registerMethod("TalkAction", "register", LuaScriptInterface::luaTalkactionRegister);
	registerMethod("TalkAction", "separator", LuaScriptInterface::luaTalkactionSeparator);

	// CreatureEvent
	registerClass("CreatureEvent", "", LuaScriptInterface::luaCreateCreatureEvent);
	registerMethod("CreatureEvent", "type", LuaScriptInterface::luaCreatureEventType);
	registerMethod("CreatureEvent", "register", LuaScriptInterface::luaCreatureEventRegister);
	registerMethod("CreatureEvent", "onLogin", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onLogout", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onThink", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onPrepareDeath", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onDeath", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onKill", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onAdvance", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onModalWindow", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onTextEdit", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onHealthChange", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onManaChange", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onExtendedOpcode", LuaScriptInterface::luaCreatureEventOnCallback);
	registerMethod("CreatureEvent", "onMove", LuaScriptInterface::luaCreatureEventOnCallback);

	// MoveEvent
	registerClass("MoveEvent", "", LuaScriptInterface::luaCreateMoveEvent);
	registerMethod("MoveEvent", "type", LuaScriptInterface::luaMoveEventType);
	registerMethod("MoveEvent", "register", LuaScriptInterface::luaMoveEventRegister);
	registerMethod("MoveEvent", "level", LuaScriptInterface::luaMoveEventLevel);
	registerMethod("MoveEvent", "magicLevel", LuaScriptInterface::luaMoveEventMagLevel);
	registerMethod("MoveEvent", "slot", LuaScriptInterface::luaMoveEventSlot);
	registerMethod("MoveEvent", "id", LuaScriptInterface::luaMoveEventItemId);
	registerMethod("MoveEvent", "aid", LuaScriptInterface::luaMoveEventActionId);
	registerMethod("MoveEvent", "uid", LuaScriptInterface::luaMoveEventUniqueId);
	registerMethod("MoveEvent", "premium", LuaScriptInterface::luaMoveEventPremium);
	registerMethod("MoveEvent", "vocation", LuaScriptInterface::luaMoveEventVocation);
	registerMethod("MoveEvent", "onEquip", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onDeEquip", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onStepIn", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onStepOut", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onAddItem", LuaScriptInterface::luaMoveEventOnCallback);
	registerMethod("MoveEvent", "onRemoveItem", LuaScriptInterface::luaMoveEventOnCallback);

	// GlobalEvent
	registerClass("GlobalEvent", "", LuaScriptInterface::luaCreateGlobalEvent);
	registerMethod("GlobalEvent", "type", LuaScriptInterface::luaGlobalEventType);
	registerMethod("GlobalEvent", "register", LuaScriptInterface::luaGlobalEventRegister);
	registerMethod("GlobalEvent", "time", LuaScriptInterface::luaGlobalEventTime);
	registerMethod("GlobalEvent", "interval", LuaScriptInterface::luaGlobalEventInterval);
	registerMethod("GlobalEvent", "onThink", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onTime", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onStartup", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onShutdown", LuaScriptInterface::luaGlobalEventOnCallback);
	registerMethod("GlobalEvent", "onRecord", LuaScriptInterface::luaGlobalEventOnCallback);

}

#undef registerEnum
#undef registerEnumIn

void LuaScriptInterface::registerClass(const std::string& className, const std::string& baseClass, lua_CFunction newFunction/* = nullptr*/)
{
	// className = {}
	lua_newtable(luaState);
	lua_pushvalue(luaState, -1);
	lua_setglobal(luaState, className.c_str());
	int methods = lua_gettop(luaState);

	// methodsTable = {}
	lua_newtable(luaState);
	int methodsTable = lua_gettop(luaState);

	if (newFunction) {
		// className.__call = newFunction
		lua_pushcfunction(luaState, newFunction);
		lua_setfield(luaState, methodsTable, "__call");
	}

	uint32_t parents = 0;
	if (!baseClass.empty()) {
		lua_getglobal(luaState, baseClass.c_str());
		lua_rawgeti(luaState, -1, 'p');
		parents = getNumber<uint32_t>(luaState, -1) + 1;
		lua_pop(luaState, 1);
		lua_setfield(luaState, methodsTable, "__index");
	}

	// setmetatable(className, methodsTable)
	lua_setmetatable(luaState, methods);

	// className.metatable = {}
	luaL_newmetatable(luaState, className.c_str());
	int metatable = lua_gettop(luaState);

	// className.metatable.__metatable = className
	lua_pushvalue(luaState, methods);
	lua_setfield(luaState, metatable, "__metatable");

	// className.metatable.__index = className
	lua_pushvalue(luaState, methods);
	lua_setfield(luaState, metatable, "__index");

	// className.metatable['h'] = hash
	lua_pushnumber(luaState, std::hash<std::string>()(className));
	lua_rawseti(luaState, metatable, 'h');

	// className.metatable['p'] = parents
	lua_pushnumber(luaState, parents);
	lua_rawseti(luaState, metatable, 'p');

	// className.metatable['t'] = type
	if (className == "Item") {
		lua_pushnumber(luaState, LuaData_Item);
	} else if (className == "Container") {
		lua_pushnumber(luaState, LuaData_Container);
	} else if (className == "Teleport") {
		lua_pushnumber(luaState, LuaData_Teleport);
	} else if (className == "Player") {
		lua_pushnumber(luaState, LuaData_Player);
	} else if (className == "Monster") {
		lua_pushnumber(luaState, LuaData_Monster);
	} else if (className == "Duelist") {
		lua_pushnumber(luaState, LuaData_Duelist);
	} else if (className == "Npc") {
		lua_pushnumber(luaState, LuaData_Npc);
	} else if (className == "Tile") {
		lua_pushnumber(luaState, LuaData_Tile);
	} else {
		lua_pushnumber(luaState, LuaData_Unknown);
	}
	lua_rawseti(luaState, metatable, 't');

	// pop className, className.metatable
	lua_pop(luaState, 2);
}

void LuaScriptInterface::registerTable(const std::string& tableName)
{
	// _G[tableName] = {}
	lua_newtable(luaState);
	lua_setglobal(luaState, tableName.c_str());
}

void LuaScriptInterface::registerMethod(const std::string& globalName, const std::string& methodName, lua_CFunction func)
{
	// globalName.methodName = func
	lua_getglobal(luaState, globalName.c_str());
	lua_pushcfunction(luaState, func);
	lua_setfield(luaState, -2, methodName.c_str());

	// pop globalName
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerMetaMethod(const std::string& className, const std::string& methodName, lua_CFunction func)
{
	// className.metatable.methodName = func
	luaL_getmetatable(luaState, className.c_str());
	lua_pushcfunction(luaState, func);
	lua_setfield(luaState, -2, methodName.c_str());

	// pop className.metatable
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerGlobalMethod(const std::string& functionName, lua_CFunction func)
{
	// _G[functionName] = func
	lua_pushcfunction(luaState, func);
	lua_setglobal(luaState, functionName.c_str());
}

void LuaScriptInterface::registerVariable(const std::string& tableName, const std::string& name, lua_Number value)
{
	// tableName.name = value
	lua_getglobal(luaState, tableName.c_str());
	setField(luaState, name.c_str(), value);

	// pop tableName
	lua_pop(luaState, 1);
}

void LuaScriptInterface::registerGlobalVariable(const std::string& name, lua_Number value)
{
	// _G[name] = value
	lua_pushnumber(luaState, value);
	lua_setglobal(luaState, name.c_str());
}

void LuaScriptInterface::registerGlobalBoolean(const std::string& name, bool value)
{
	// _G[name] = value
	pushBoolean(luaState, value);
	lua_setglobal(luaState, name.c_str());
}

int LuaScriptInterface::luaDoCreatureCastSpell(lua_State* L)
{
	//doCreatureCastSpell(cid, spellname)
	Creature* creature = getCreature(L, 1);
	std::string spellName = getString(L, 2);
	if(creature){
		InstantSpell* spell = g_spells->getInstantSpellByName(spellName);
		if(!spell){
			lua_pushboolean(L, false);
			return 1;
		}
		Creature* target = creature->getAttackedCreature();
		if(target){
			spell->castSpell(creature, target);
		} else {
			spell->castSpell(creature);
		}
		lua_pushboolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaGetPlayerInstantSpellCount(lua_State* L)
{
	// //getPlayerInstantSpellCount(cid)
	// Player* player = getPlayer(L, 1);
	// if (player) {
	// 	lua_pushnumber(L, g_spells->getInstantSpellCount(player));
	// } else {
	// 	reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
	// }
	return 1;
}

int LuaScriptInterface::luaGetPlayerInstantSpellInfo(lua_State* L)
{
	//getPlayerInstantSpellInfo(cid, index)
	// Player* player = getPlayer(L, 1);
	// if (!player) {
	// 	reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
	// 	pushBoolean(L, false);
	// 	return 1;
	// }

	// uint32_t index = getNumber<uint32_t>(L, 2);
	// InstantSpell* spell = g_spells->getInstantSpellByIndex(player, index);
	// if (!spell) {
	// 	reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
	// 	return 1;
	// }

	// lua_createtable(L, 0, 6);
	// setField(L, "name", spell->getName());
	// setField(L, "words", spell->getWords());
	// setField(L, "level", spell->getLevel());
	// setField(L, "mlevel", spell->getMagicLevel());
	// setField(L, "mana", spell->getManaCost(player));
	// setField(L, "manapercent", spell->getManaPercent());
	return 1;
}

int LuaScriptInterface::luaDoPlayerAddItem(lua_State* L)
{
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count/subtype, <optional: default: 1> canDropOnMap)
	//doPlayerAddItem(cid, itemid, <optional: default: 1> count, <optional: default: 1> canDropOnMap, <optional: default: 1>subtype)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	int32_t count = getNumber<int32_t>(L, 3, 1);
	bool canDropOnMap = getBoolean(L, 4, true);
	uint16_t subType = getNumber<uint16_t>(L, 5, 1);

	const ItemType& it = Item::items[itemId];
	int32_t itemCount;

	auto parameters = lua_gettop(L);
	if (parameters > 4) {
		//subtype already supplied, count then is the amount
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / MAX_ITEM_COUNT));
		} else {
			itemCount = 1;
		}
		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		uint16_t stackCount = subType;
		if (it.stackable && stackCount > MAX_ITEM_COUNT) {
			stackCount = MAX_ITEM_COUNT;
		}

		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game.internalPlayerAddItem(player, newItem, canDropOnMap);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				uint32_t uid = getScriptEnv()->addThing(newItem);
				lua_pushnumber(L, uid);
				return 1;
			} else {
				//stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
				return 1;
			}
		}
	}

	pushBoolean(L, false);
	return 1;
}

int LuaScriptInterface::luaDebugPrint(lua_State* L)
{
	//debugPrint(text)
	reportErrorFunc(getString(L, -1));
	return 0;
}

int LuaScriptInterface::luaGetWorldTime(lua_State* L)
{
	//getWorldTime()
	int32_t time = (g_game.getLightHour() * 3600) + (g_game.getLightMinutes() * 60);
	lua_pushnumber(L, time);
	return 1;
}

int LuaScriptInterface::luaGetWorldLight(lua_State* L)
{
	//getWorldLight()
	LightInfo lightInfo = g_game.getWorldLightInfo();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int LuaScriptInterface::luaGetWorldUpTime(lua_State* L)
{
	//getWorldUpTime()
	uint64_t uptime = (OTSYS_TIME() - ProtocolStatus::start) / 1000;
	lua_pushnumber(L, uptime);
	return 1;
}

bool LuaScriptInterface::getArea(lua_State* L, std::list<uint32_t>& list, uint32_t& rows)
{
	lua_pushnil(L);
	for (rows = 0; lua_next(L, -2) != 0; ++rows) {
		if (!isTable(L, -1)) {
			return false;
		}

		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			if (!isNumber(L, -1)) {
				return false;
			}
			list.push_back(getNumber<uint32_t>(L, -1));
			lua_pop(L, 1);
		}

		lua_pop(L, 1);
	}

	lua_pop(L, 1);
	return (rows != 0);
}

int LuaScriptInterface::luaCreateCombatArea(lua_State* L)
{
	//createCombatArea( {area}, <optional> {extArea} )
	ScriptEnvironment* env = getScriptEnv();
	if (env->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc("This function can only be used while loading the script.");
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = g_luaEnvironment.createAreaObject(env->getScriptInterface());
	AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);

	int parameters = lua_gettop(L);
	if (parameters >= 2) {
		uint32_t rowsExtArea;
		std::list<uint32_t> listExtArea;
		if (!isTable(L, 2) || !getArea(L, listExtArea, rowsExtArea)) {
			reportErrorFunc("Invalid extended area table.");
			pushBoolean(L, false);
			return 1;
		}
		area->setupExtArea(listExtArea, rowsExtArea);
	}

	uint32_t rowsArea = 0;
	std::list<uint32_t> listArea;
	if (!isTable(L, 1) || !getArea(L, listArea, rowsArea)) {
		reportErrorFunc("Invalid area table.");
		pushBoolean(L, false);
		return 1;
	}

	area->setupArea(listArea, rowsArea);
	lua_pushnumber(L, areaId);
	return 1;
}

int LuaScriptInterface::luaDoAreaCombat(lua_State* L)
{
	// doAreaCombat(cid, type, pos, area, min, max, effect[, origin = ORIGIN_SPELL[, blockArmor = false[, blockShield =
	// false[, ignoreResistances = false]]]])
	Creature* creature = getCreature(L, 1);
	if (!creature && (!isNumber(L, 1) || getNumber<uint32_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t areaId = getNumber<uint32_t>(L, 4);
	const AreaCombat* area = g_luaEnvironment.getAreaObject(areaId);
	if (area || areaId == 0) {
		CombatType_t combatType = getNumber<CombatType_t>(L, 2);

		CombatParams params;
		params.combatType = combatType;
		params.impactEffect = getNumber<uint8_t>(L, 7);

		params.blockedByArmor = getBoolean(L, 9, false);
		params.blockedByShield = getBoolean(L, 10, false);
		// params.ignoreResistances = getBoolean(L, 11, false);

		CombatDamage damage;
		damage.origin = getNumber<CombatOrigin>(L, 8, ORIGIN_SPELL);
		damage.primary.type = combatType;
		damage.primary.value = normal_random(getNumber<int32_t>(L, 5), getNumber<int32_t>(L, 6));

		Combat::doAreaCombatTemp(creature, getPosition(L, 3), area, damage, params);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaDoTargetCombat(lua_State* L)
{
	//doTargetCombat(cid, target, type, min, max, effect[, origin = ORIGIN_SPELL])
	Creature* creature = getCreature(L, 1);

	if (!creature) {
		return 0;
	}

	if (!creature && (!isNumber(L, 1) || getNumber<uint64_t>(L, 1) != 0)) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		return 0;
	}

	CombatType_t combatType = getNumber<CombatType_t>(L, 3);

	CombatParams params;
	params.combatType = combatType;
	params.impactEffect = getNumber<uint16_t>(L, 6);

	CombatDamage damage;
	damage.origin = getNumber<CombatOrigin>(L, 7, ORIGIN_SPELL);
	damage.primary.type = combatType;
	damage.primary.value = normal_random(getNumber<int64_t>(L, 4), getNumber<int64_t>(L, 5));
	Combat::doTargetCombat(creature, target, damage, params);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaDoChallengeCreature(lua_State* L)
{
	//doChallengeCreature(cid, target)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Creature* target = getCreature(L, 2);
	if (!target) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	target->challengeCreature(creature);
	pushBoolean(L, true);
	return 1;
}


int LuaScriptInterface::luaIsValidUID(lua_State* L)
{
	//isValidUID(uid)
	pushBoolean(L, getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1)) != nullptr);
	return 1;
}


int LuaScriptInterface::luaAddDuelistType(lua_State* L)
{
    // addDuelistType(name, outfit, health, speed, description, minTargetDist, maxTargetDist, {pokemons}, corpse, experience, {startVoices}, {deathVoices}, {fleeingVoices})
    std::string name = getString(L, 1);
    DuelistInfo info;
    info.outfit = getOutfit(L, 2);
    info.health = getNumber<int64_t>(L, 3);
    info.maxHealth = getNumber<int64_t>(L, 4);
    info.speed = getNumber<uint32_t>(L, 5);
    info.description = getString(L, 6);
    info.minTargetDist = getNumber<uint32_t>(L, 7, 3);
    info.maxTargetDist = getNumber<uint32_t>(L, 8, 5);


    if (lua_istable(L, 9)) {
        lua_pushnil(L);
        while (lua_next(L, 9) != 0) {
            std::string pokemonName = getString(L, -1);
            MonsterType* monsterType = g_monsters.getMonsterType(pokemonName);
            if (monsterType) {
                info.pokemons.push_back(monsterType);
            }
            lua_pop(L, 1);
        }
    }
	info.corpse = getNumber<uint32_t>(L, 10, 0);
	info.experience = getNumber<uint32_t>(L, 11, 0);

    if (lua_istable(L, 12)) {
        lua_pushnil(L);
        while (lua_next(L, 12) != 0) {
            std::string voice = getString(L, -1);
            info.startDuelVoices.push_back(voice);
            lua_pop(L, 1);
        }
    }

    if (lua_istable(L, 13)) {
        lua_pushnil(L);
        while (lua_next(L, 13) != 0) {
            std::string voice = getString(L, -1);
            info.deathDuelVoices.push_back(voice);
            lua_pop(L, 1);
        }
    }

    if (lua_istable(L, 14)) {
        lua_pushnil(L);
        while (lua_next(L, 14) != 0) {
            std::string voice = getString(L, -1);
            info.fleeingVoices.push_back(voice);
            lua_pop(L, 1);
        }
    }

    g_game.addDuelistType(name, info);
    return 1;
}

int LuaScriptInterface::luaAddMarketItem(lua_State* L)
{
	//addMarketItem(item, amount, price, currency, playerId, <optional> anonymous)
	MarketItem marketItem;
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	PropWriteStream propWriteStream;
	item->serializeAttr(propWriteStream);

	size_t attributesSize;
	const char* attributes = propWriteStream.getStream(attributesSize);

	std::string pokeName = item->getPokemonName();
	if (!pokeName.empty()) {
	    marketItem.pokeballAttributes.name = pokeName;
	    marketItem.pokeballAttributes.boost = item->getPokemonBoost();
	}
	
	const ItemType& itemType = Item::items[item->getID()];

	marketItem.itemtype = item->getID();
	marketItem.category = itemType.marketCategory;
	marketItem.itemName = itemType.name;
	marketItem.attributes = std::string(attributes, attributesSize);
	marketItem.attributesSize = attributesSize;
	marketItem.amount = getNumber<uint16_t>(L, 2);
	marketItem.price = getNumber<uint64_t>(L, 3);
	marketItem.currency = static_cast<MarketCurrency_t>(getNumber<uint8_t>(L, 4));
	marketItem.playerId = getNumber<uint32_t>(L, 5);
	marketItem.created = OTSYS_TIME();
	marketItem.anonymous = getBoolean(L, 6, false);

	Player* player = g_game.getPlayerByGUID(marketItem.playerId);
	if (!player) {
		marketItem.playerName = "Not Found";
		std::cout << "Player not found, no error" << std::endl;
	} else {
		marketItem.playerName = player->getName();
	}
	

	IOMarket::addMarketItem(marketItem);
	return 1;
}

int LuaScriptInterface::luaRemoveMarketItem(lua_State* L)
{
	//removeMarketItem(id)
	uint32_t id = getNumber<uint32_t>(L, 1);
	IOMarket::removeMarketItem(id);
	return 1;
}

int LuaScriptInterface::luaGetMarketItems(lua_State* L)
{
	//getMarketItems()
	MarketItemMap items = IOMarket::getMarketItems();
	lua_createtable(L, items.size(), 0);
	int i = 1;
	for (const auto& it : items) {
		if (it.second.expired == true) {
			continue;
		} else if (it.second.created + (86400000 * 2) < OTSYS_TIME()) {
			IOMarket::setMarketItemExpired(it.first);
			continue;
		}
			

		const ItemType& itemType = Item::items[it.second.itemtype];

		lua_createtable(L, 0, 11);
		setField(L, "id", it.first);
		setField(L, "itemtype", it.second.itemtype);
		setField(L, "itemClientId", itemType.clientId);
		setField(L, "itemName", itemType.name);
		setField(L, "amount", it.second.amount);
		setField(L, "category", itemType.marketCategory);
		setField(L, "price", it.second.price);
		setField(L, "currency", static_cast<int>(it.second.currency));
		setField(L, "created", it.second.created/1000);
		setField(L, "anonymous", it.second.anonymous);
		if (it.second.anonymous == true) {
			setField(L, "playerName", "Anonymous");
		} else {
			setField(L, "playerName", it.second.playerName);
		}
			
		if (!it.second.pokeballAttributes.name.empty()) {
        	lua_createtable(L, 0, 1);
        	setField(L, "name", it.second.pokeballAttributes.name);
			setField(L, "boost", it.second.pokeballAttributes.boost);
			lua_setfield(L, -2, "pokeballAttributes");
		}
        
		lua_rawseti(L, -2, i++);
	}
	return 1;
}

int LuaScriptInterface::luaGetPlayerMarketItems(lua_State* L)
{
	//getPlayerMarketItems(playerGuid)
	uint32_t playerGuid = getNumber<uint32_t>(L, 1);
	std::vector<uint32_t> items = IOMarket::getPlayerItems(playerGuid);
	lua_createtable(L, items.size(), 0);
	int i = 1;
	for (const auto& MarketItemId : items) {
		const MarketItem& it = IOMarket::getMarketItem(MarketItemId);
		const ItemType& itemType = Item::items[it.itemtype];
		lua_createtable(L, 0, 12);
		setField(L, "id", MarketItemId);
		setField(L, "itemtype", it.itemtype);
		setField(L, "itemClientId", itemType.clientId);
		setField(L, "itemName", itemType.name);
		setField(L, "amount", it.amount);
		setField(L, "category", itemType.marketCategory);
		setField(L, "price", it.price);
		setField(L, "currency", static_cast<int>(it.currency));
		setField(L, "created", it.created/1000);
		setField(L, "expired", it.expired ? 1 : 0);
		setField(L, "anonymous", it.anonymous);
		if (it.anonymous == true) {
			setField(L, "playerName", "Anonymous");
		} else {
			setField(L, "playerName", it.playerName);
		}
		if (!it.pokeballAttributes.name.empty()) {
			lua_createtable(L, 0, 1);
			setField(L, "name", it.pokeballAttributes.name);
			setField(L, "boost", it.pokeballAttributes.boost);
			lua_setfield(L, -2, "pokeballAttributes");
		}
		lua_rawseti(L, -2, i++);
	}
	return 1;
}

int LuaScriptInterface::luaGetMarketItemById(lua_State* L)
{
	//getMarketItemById(itemId)
	uint32_t MarketItemId = getNumber<uint32_t>(L, 1);
	const MarketItem& it = IOMarket::getMarketItem(MarketItemId);
	const ItemType& itemType = Item::items[it.itemtype];
	lua_createtable(L, 0, 13);
	setField(L, "id", MarketItemId);
	setField(L, "itemtype", it.itemtype);
	setField(L, "playerId", it.playerId);
	setField(L, "itemClientId", itemType.clientId);
	setField(L, "itemName", itemType.name);
	setField(L, "amount", it.amount);
	setField(L, "category", itemType.marketCategory);
	setField(L, "price", it.price);
	setField(L, "currency", static_cast<int>(it.currency));
	setField(L, "created", it.created/1000);
	setField(L, "expired", it.expired ? 1 : 0);
	setField(L, "anonymous", it.anonymous);
	if (it.anonymous == true) {
		setField(L, "playerName", "Anonymous");
	} else {
		setField(L, "playerName", it.playerName);
	}
	if (!it.pokeballAttributes.name.empty()) {
		lua_createtable(L, 0, 1);
		setField(L, "name", it.pokeballAttributes.name);
		setField(L, "boost", it.pokeballAttributes.boost);
		lua_setfield(L, -2, "pokeballAttributes");
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMarketItem(lua_State* L)
{
	//playerAddMarketItem(player, itemId, amount)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}
	uint32_t MarketItemId = getNumber<uint32_t>(L, 2);
	uint16_t amount = getNumber<uint16_t>(L, 3);

	const MarketItem& it = IOMarket::getMarketItem(MarketItemId);
	Item* item = Item::CreateItem(it.itemtype, 1);
	const char* attributesData = it.attributes.c_str();

	PropStream propStream;
	propStream.init(attributesData, it.attributesSize);

    if (!item->unserializeAttr(propStream)) {
        std::cout << "Error loading market item from database. unserializeAttr" << std::endl;
        delete item;
		lua_pushnil(L);
        return 1;
    }
	item->setItemCount(amount);
	
	Inbox* inbox = player->getInbox();

	ReturnValue ret = g_game.internalAddItem(inbox, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	if (ret == RETURNVALUE_NOERROR) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		delete item;
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaUpdateMarketItemAmount(lua_State* L)
{
	//updateMarketItemAmount(offerid, newAmount)
	uint32_t MarketItemId = getNumber<uint32_t>(L, 1);
	uint16_t newAmount = getNumber<uint16_t>(L, 2);
	IOMarket::updateMarketItemAmount(MarketItemId, newAmount);
	return 1;
}

int LuaScriptInterface::luaSetMarketItemExpired(lua_State* L)
{
	//setMarketItemExpired(offerId)
	uint32_t MarketItemId = getNumber<uint32_t>(L, 1);
	IOMarket::setMarketItemExpired(MarketItemId);
	return 1;
}

int LuaScriptInterface::luaGetMarketItemsPage(lua_State* L)
{
	//getMarketItemsPage(page, pageSize)
	uint32_t page = getNumber<uint32_t>(L, 1);
	uint32_t pageSize = getNumber<uint32_t>(L, 2);
	MarketItemMap items = IOMarket::getMarketItemsPage(page, pageSize);
	lua_createtable(L, items.size(), 0);
	int i = 1;
	for (const auto& it : items) {
		if (it.second.expired == true) {
			continue;
		} else if (it.second.created + (86400000 * 2) < OTSYS_TIME()) {
			IOMarket::setMarketItemExpired(it.first);
			continue;
		}
		const ItemType& itemType = Item::items[it.second.itemtype];
		lua_createtable(L, 0, 11);
		setField(L, "id", it.first);
		setField(L, "itemtype", it.second.itemtype);
		setField(L, "itemClientId", itemType.clientId);
		setField(L, "itemName", itemType.name);
		setField(L, "amount", it.second.amount);
		setField(L, "category", itemType.marketCategory);
		setField(L, "price", it.second.price);
		setField(L, "currency", static_cast<int>(it.second.currency));
		setField(L, "created", it.second.created/1000);
		setField(L, "anonymous", it.second.anonymous);
		if (it.second.anonymous == true) {
			setField(L, "playerName", "Anonymous");
		} else {
			setField(L, "playerName", it.second.playerName);
		}
		if (!it.second.pokeballAttributes.name.empty()) {
			lua_createtable(L, 0, 1);
			setField(L, "name", it.second.pokeballAttributes.name);
			setField(L, "boost", it.second.pokeballAttributes.boost);
			lua_setfield(L, -2, "pokeballAttributes");
		}
		lua_rawseti(L, -2, i++);
	}
	return 1;
}

int LuaScriptInterface::luaGetPlayerMarketItemsPage(lua_State* L)
{
	//getPlayerMarketItemsPage(guid, page, pageSize)
	uint32_t playerGuid = getNumber<uint32_t>(L, 1);
	uint32_t page = getNumber<uint32_t>(L, 2);
	uint32_t pageSize = getNumber<uint32_t>(L, 3);
	std::vector<uint32_t> items = IOMarket::getPlayerMarketItemsPage(playerGuid, page, pageSize);
	lua_createtable(L, items.size(), 0);
	int i = 1;
	for (const auto& MarketItemId : items) {
		const MarketItem& it = IOMarket::getMarketItem(MarketItemId);
		const ItemType& itemType = Item::items[it.itemtype];
		lua_createtable(L, 0, 12);
		setField(L, "id", MarketItemId);
		setField(L, "itemtype", it.itemtype);
		setField(L, "itemClientId", itemType.clientId);
		setField(L, "itemName", itemType.name);
		setField(L, "amount", it.amount);
		setField(L, "category", itemType.marketCategory);
		setField(L, "price", it.price);
		setField(L, "currency", static_cast<int>(it.currency));
		setField(L, "created", it.created/1000);
		setField(L, "expired", it.expired ? 1 : 0);
		setField(L, "anonymous", it.anonymous);
		if (it.anonymous == true) {
			setField(L, "playerName", "Anonymous");
		} else {
			setField(L, "playerName", it.playerName);
		}
		if (!it.pokeballAttributes.name.empty()) {
			lua_createtable(L, 0, 1);
			setField(L, "name", it.pokeballAttributes.name);
			setField(L, "boost", it.pokeballAttributes.boost);
			lua_setfield(L, -2, "pokeballAttributes");
		}
		lua_rawseti(L, -2, i++);
	}
	return 1;
}

int LuaScriptInterface::luaGetMarketItemsSize(lua_State* L)
{
	//getMarketItemsSize()
	lua_pushnumber(L, IOMarket::getMarketItemsSize());
	return 1;
}

int LuaScriptInterface::luaGetPlayerMarketItemsSize(lua_State* L)
{
	//getPlayerMarketItemsSize(playerGuid)
	uint32_t playerGuid = getNumber<uint32_t>(L, 1);
	lua_pushnumber(L, IOMarket::getPlayerItemsSize(playerGuid));
	return 1;
}

int LuaScriptInterface::luaGetMarketItemsByNameAndCategory(lua_State* L)
{
	//getMarketItemsByNameAndCategory(name, category, page, pageSize)
	std::string name = getString(L, 1);
	uint16_t category = getNumber<uint16_t>(L, 2);
	uint32_t page = getNumber<uint32_t>(L, 3);
	uint32_t pageSize = getNumber<uint32_t>(L, 4);
	MarketItemMap items = IOMarket::getMarketItemsByNameAndCategory(name, category, page, pageSize);
	lua_createtable(L, items.size(), 0);
	int i = 1;
	for (const auto& it : items) {
		if (it.second.expired == true) {
			continue;
		} else if (it.second.created + (86400000 * 2) < OTSYS_TIME()) {
			IOMarket::setMarketItemExpired(it.first);
			continue;
		}
		const ItemType& itemType = Item::items[it.second.itemtype];
		lua_createtable(L, 0, 11);
		setField(L, "id", it.first);
		setField(L, "itemtype", it.second.itemtype);
		setField(L, "itemClientId", itemType.clientId);
		setField(L, "itemName", itemType.name);
		setField(L, "amount", it.second.amount);
		setField(L, "category", itemType.marketCategory);
		setField(L, "price", it.second.price);
		setField(L, "currency", static_cast<int>(it.second.currency));
		setField(L, "created", it.second.created/1000);
		setField(L, "anonymous", it.second.anonymous);
		if (it.second.anonymous == true) {
			setField(L, "playerName", "Anonymous");
		} else {
			setField(L, "playerName", it.second.playerName);
		}
		if (!it.second.pokeballAttributes.name.empty()) {
			lua_createtable(L, 0, 1);
			setField(L, "name", it.second.pokeballAttributes.name);
			setField(L, "boost", it.second.pokeballAttributes.boost);
			lua_setfield(L, -2, "pokeballAttributes");
		}
		lua_rawseti(L, -2, i++);
	}
	return 1;
}

int LuaScriptInterface::luaGetMarketItemsByNameAndCategorySize(lua_State* L)
{
	//getMarketItemsByNameAndCategorySize(name, category)
	std::string name = getString(L, 1);
	uint16_t category = getNumber<uint16_t>(L, 2);
	lua_pushnumber(L, IOMarket::getMarketItemsByNameAndCategorySize(name, category));
	return 1;
}

int LuaScriptInterface::luaIsDepot(lua_State* L)
{
	//isDepot(uid)
	Container* container = getScriptEnv()->getContainerByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, container && container->getDepotLocker());
	return 1;
}

int LuaScriptInterface::luaIsMoveable(lua_State* L)
{
	//isMoveable(uid)
	//isMovable(uid)
	Thing* thing = getScriptEnv()->getThingByUID(getNumber<uint32_t>(L, -1));
	pushBoolean(L, thing && thing->isPushable());
	return 1;
}

int LuaScriptInterface::luaDoAddContainerItem(lua_State* L)
{
	//doAddContainerItem(uid, itemid, <optional> count/subtype)
	uint32_t uid = getNumber<uint32_t>(L, 1);

	ScriptEnvironment* env = getScriptEnv();
	Container* container = env->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId = getNumber<uint16_t>(L, 2);
	const ItemType& it = Item::items[itemId];

	int32_t itemCount = 1;
	int32_t subType = 1;
	uint32_t count = getNumber<uint32_t>(L, 3, 1);

	if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = static_cast<int32_t>(std::ceil(static_cast<float>(count) / MAX_ITEM_COUNT));
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	while (itemCount > 0) {
		int32_t stackCount = std::min<int32_t>(MAX_ITEM_COUNT, subType);
		Item* newItem = Item::CreateItem(itemId, stackCount);
		if (!newItem) {
			reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		if (it.stackable) {
			subType -= stackCount;
		}

		ReturnValue ret = g_game.internalAddItem(container, newItem);
		if (ret != RETURNVALUE_NOERROR) {
			delete newItem;
			pushBoolean(L, false);
			return 1;
		}

		if (--itemCount == 0) {
			if (newItem->getParent()) {
				lua_pushnumber(L, env->addThing(newItem));
			} else {
				//stackable item stacked with existing object, newItem will be released
				pushBoolean(L, false);
			}
			return 1;
		}
	}

	pushBoolean(L, false);
	return 1;
}

int LuaScriptInterface::luaGetDepotId(lua_State* L)
{
	//getDepotId(uid)
	uint32_t uid = getNumber<uint32_t>(L, -1);

	Container* container = getScriptEnv()->getContainerByUID(uid);
	if (!container) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CONTAINER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	DepotLocker* depotLocker = container->getDepotLocker();
	if (!depotLocker) {
		reportErrorFunc("Depot not found");
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, depotLocker->getDepotId());
	return 1;
}



int LuaScriptInterface::luaGetCombatName(lua_State* L)
{
	//getCombatName(COMBAT_TYPE)
	CombatType_t combatType = getNumber<CombatType_t>(L, 1);
	pushString(L, getCombatName(combatType));
	return 1;
}

int LuaScriptInterface::luaDoSetCreatureLight(lua_State* L)
{
	//doSetCreatureLight(cid, lightLevel, lightColor, time)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint16_t level = getNumber<uint16_t>(L, 2);
	uint16_t color = getNumber<uint16_t>(L, 3);
	uint32_t time = getNumber<uint32_t>(L, 4);
	Condition* condition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_LIGHT, time, level | (color << 8));
	creature->addCondition(condition);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaAddEvent(lua_State* L)
{
	//addEvent(callback, delay, ...)
	lua_State* globalState = g_luaEnvironment.getLuaState();
	if (!globalState) {
		reportErrorFunc("No valid script interface!");
		pushBoolean(L, false);
		return 1;
	} else if (globalState != L) {
		lua_xmove(L, globalState, lua_gettop(L));
	}

	int parameters = lua_gettop(globalState);
	if (!isFunction(globalState, -parameters)) { //-parameters means the first parameter from left to right
		reportErrorFunc("callback parameter should be a function.");
		pushBoolean(L, false);
		return 1;
	}

	if (g_config.getBoolean(ConfigManager::WARN_UNSAFE_SCRIPTS) || g_config.getBoolean(ConfigManager::CONVERT_UNSAFE_SCRIPTS)) {
		std::vector<std::pair<int32_t, LuaDataType>> indexes;
		for (int i = 3; i <= parameters; ++i) {
			if (lua_getmetatable(globalState, i) == 0) {
				continue;
			}
			lua_rawgeti(L, -1, 't');

			LuaDataType type = getNumber<LuaDataType>(L, -1);
			if (type != LuaData_Unknown && type != LuaData_Tile) {
				indexes.push_back({i, type});
			}
			lua_pop(globalState, 2);
		}

		if (!indexes.empty()) {
			if (g_config.getBoolean(ConfigManager::WARN_UNSAFE_SCRIPTS)) {
				bool plural = indexes.size() > 1;

				std::string warningString = "Argument";
				if (plural) {
					warningString += 's';
				}

				for (const auto& entry : indexes) {
					if (entry == indexes.front()) {
						warningString += ' ';
					} else if (entry == indexes.back()) {
						warningString += " and ";
					} else {
						warningString += ", ";
					}
					warningString += '#';
					warningString += std::to_string(entry.first);
				}

				if (plural) {
					warningString += " are unsafe";
				} else {
					warningString += " is unsafe";
				}

				reportErrorFunc(warningString);
			}

			if (g_config.getBoolean(ConfigManager::CONVERT_UNSAFE_SCRIPTS)) {
				for (const auto& entry : indexes) {
					switch (entry.second) {
						case LuaData_Item:
						case LuaData_Container:
						case LuaData_Teleport: {
							lua_getglobal(globalState, "Item");
							lua_getfield(globalState, -1, "getUniqueId");
							break;
						}
						case LuaData_Player:
						case LuaData_Monster:
						case LuaData_Npc: {
							lua_getglobal(globalState, "Creature");
							lua_getfield(globalState, -1, "getId");
							break;
						}
						default:
							break;
					}
					lua_replace(globalState, -2);
					lua_pushvalue(globalState, entry.first);
					lua_call(globalState, 1, 1);
					lua_replace(globalState, entry.first);
				}
			}
		}
	}

	LuaTimerEventDesc eventDesc;
	for (int i = 0; i < parameters - 2; ++i) { //-2 because addEvent needs at least two parameters
		eventDesc.parameters.push_back(luaL_ref(globalState, LUA_REGISTRYINDEX));
	}

	uint32_t delay = std::max<uint32_t>(100, getNumber<uint32_t>(globalState, 2));
	lua_pop(globalState, 1);

	eventDesc.function = luaL_ref(globalState, LUA_REGISTRYINDEX);
	eventDesc.scriptId = getScriptEnv()->getScriptId();

	auto& lastTimerEventId = g_luaEnvironment.lastEventTimerId;
	eventDesc.eventId = g_scheduler.addEvent(createSchedulerTask(
		delay, std::bind(&LuaEnvironment::executeTimerEvent, &g_luaEnvironment, lastTimerEventId)
	));

	g_luaEnvironment.timerEvents.emplace(lastTimerEventId, std::move(eventDesc));
	lua_pushnumber(L, lastTimerEventId++);
	return 1;
}

int LuaScriptInterface::luaStopEvent(lua_State* L)
{
	//stopEvent(eventid)
	lua_State* globalState = g_luaEnvironment.getLuaState();
	if (!globalState) {
		reportErrorFunc("No valid script interface!");
		pushBoolean(L, false);
		return 1;
	}

	uint32_t eventId = getNumber<uint32_t>(L, 1);

	auto& timerEvents = g_luaEnvironment.timerEvents;
	auto it = timerEvents.find(eventId);
	if (it == timerEvents.end()) {
		pushBoolean(L, false);
		return 1;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	g_scheduler.stopEvent(timerEventDesc.eventId);
	luaL_unref(globalState, LUA_REGISTRYINDEX, timerEventDesc.function);

	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(globalState, LUA_REGISTRYINDEX, parameter);
	}

	pushBoolean(L, true);
	return 1;
}


int LuaScriptInterface::luaSaveServer(lua_State* L)
{
	g_game.saveGameState();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCleanMap(lua_State* L)
{
	lua_pushnumber(L, g_game.map.clean());
	return 1;
}

int LuaScriptInterface::luaIsInWar(lua_State* L)
{
	//isInWar(cid, target)
	Player* player = getPlayer(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player* targetPlayer = getPlayer(L, 2);
	if (!targetPlayer) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, player->isInWar(targetPlayer));
	return 1;
}

int LuaScriptInterface::luaGetWaypointPositionByName(lua_State* L)
{
	//getWaypointPositionByName(name)
	auto& waypoints = g_game.map.waypoints;

	auto it = waypoints.find(getString(L, -1));
	if (it != waypoints.end()) {
		pushPosition(L, it->second);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaSendChannelMessage(lua_State* L)
{
	//sendChannelMessage(channelId, type, message)
	uint32_t channelId = getNumber<uint32_t>(L, 1);
	ChatChannel* channel = g_chat->getChannelById(channelId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	SpeakClasses type = getNumber<SpeakClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaSendGuildChannelMessage(lua_State* L)
{
	//sendGuildChannelMessage(guildId, type, message)
	uint32_t guildId = getNumber<uint32_t>(L, 1);
	ChatChannel* channel = g_chat->getGuildChannelById(guildId);
	if (!channel) {
		pushBoolean(L, false);
		return 1;
	}

	SpeakClasses type = getNumber<SpeakClasses>(L, 2);
	std::string message = getString(L, 3);
	channel->sendToAll(message, type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaIsScriptsInterface(lua_State* L)
{
	//isScriptsInterface()
	if (getScriptEnv()->getScriptInterface() == &g_scripts->getScriptInterface()) {
		pushBoolean(L, true);
	} else {
		reportErrorFunc("EventCallback: can only be called inside (data/scripts/)");
		pushBoolean(L, false);
	}
	return 1;
}

std::string LuaScriptInterface::escapeString(const std::string& string)
{
	std::string s = string;
	replaceString(s, "\\", "\\\\");
	replaceString(s, "\"", "\\\"");
	replaceString(s, "'", "\\'");
	replaceString(s, "[[", "\\[[");
	return s;
}

#ifndef LUAJIT_VERSION
const luaL_Reg LuaScriptInterface::luaBitReg[] = {
	//{"tobit", LuaScriptInterface::luaBitToBit},
	{"bnot", LuaScriptInterface::luaBitNot},
	{"band", LuaScriptInterface::luaBitAnd},
	{"bor", LuaScriptInterface::luaBitOr},
	{"bxor", LuaScriptInterface::luaBitXor},
	{"lshift", LuaScriptInterface::luaBitLeftShift},
	{"rshift", LuaScriptInterface::luaBitRightShift},
	//{"arshift", LuaScriptInterface::luaBitArithmeticalRightShift},
	//{"rol", LuaScriptInterface::luaBitRotateLeft},
	//{"ror", LuaScriptInterface::luaBitRotateRight},
	//{"bswap", LuaScriptInterface::luaBitSwapEndian},
	//{"tohex", LuaScriptInterface::luaBitToHex},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaBitNot(lua_State* L)
{
	lua_pushnumber(L, static_cast<lua_Number>(~static_cast<int32_t>(getNumber<uint32_t>(L, -1))));
	return 1;
}

#define MULTIOP(name, op) \
int LuaScriptInterface::luaBit##name(lua_State* L) \
{ \
	int n = lua_gettop(L); \
	uint32_t w = getNumber<uint32_t>(L, -1); \
	for (int i = 1; i < n; ++i) \
		w op getNumber<uint32_t>(L, i); \
	lua_pushnumber(L, w); \
	return 1; \
}

MULTIOP(And, &= )
MULTIOP(Or, |= )
MULTIOP(Xor, ^= )

#define SHIFTOP(name, op) \
int LuaScriptInterface::luaBit##name(lua_State* L) \
{ \
	uint32_t n1 = getNumber<uint32_t>(L, 1), n2 = getNumber<uint32_t>(L, 2); \
	lua_pushnumber(L, (n1 op n2)); \
	return 1; \
}

SHIFTOP(LeftShift, << )
SHIFTOP(RightShift, >> )
#endif

const luaL_Reg LuaScriptInterface::luaConfigManagerTable[] = {
	{"getString", LuaScriptInterface::luaConfigManagerGetString},
	{"getNumber", LuaScriptInterface::luaConfigManagerGetNumber},
	{"getBoolean", LuaScriptInterface::luaConfigManagerGetBoolean},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaConfigManagerGetString(lua_State* L)
{
	pushString(L, g_config.getString(getNumber<ConfigManager::string_config_t>(L, -1)));
	return 1;
}

int LuaScriptInterface::luaConfigManagerGetNumber(lua_State* L)
{
	lua_pushnumber(L, g_config.getNumber(getNumber<ConfigManager::integer_config_t>(L, -1)));
	return 1;
}

int LuaScriptInterface::luaConfigManagerGetBoolean(lua_State* L)
{
	pushBoolean(L, g_config.getBoolean(getNumber<ConfigManager::boolean_config_t>(L, -1)));
	return 1;
}

const luaL_Reg LuaScriptInterface::luaDatabaseTable[] = {
	{"query", LuaScriptInterface::luaDatabaseExecute},
	{"asyncQuery", LuaScriptInterface::luaDatabaseAsyncExecute},
	{"storeQuery", LuaScriptInterface::luaDatabaseStoreQuery},
	{"asyncStoreQuery", LuaScriptInterface::luaDatabaseAsyncStoreQuery},
	{"escapeString", LuaScriptInterface::luaDatabaseEscapeString},
	{"escapeBlob", LuaScriptInterface::luaDatabaseEscapeBlob},
	{"lastInsertId", LuaScriptInterface::luaDatabaseLastInsertId},
	{"tableExists", LuaScriptInterface::luaDatabaseTableExists},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaDatabaseExecute(lua_State* L)
{
	pushBoolean(L, Database::getInstance().executeQuery(getString(L, -1)));
	return 1;
}

int LuaScriptInterface::luaDatabaseAsyncExecute(lua_State* L)
{
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = getScriptEnv()->getScriptId();
		callback = [ref, scriptId](DBResult_ptr, bool success) {
			lua_State* luaState = g_luaEnvironment.getLuaState();
			if (!luaState) {
				return;
			}

			if (!LuaScriptInterface::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			pushBoolean(luaState, success);
			auto env = getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment);
			g_luaEnvironment.callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks.addTask(getString(L, -1), callback);
	return 0;
}

int LuaScriptInterface::luaDatabaseStoreQuery(lua_State* L)
{
	if (DBResult_ptr res = Database::getInstance().storeQuery(getString(L, -1))) {
		lua_pushnumber(L, ScriptEnvironment::addResult(res));
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaDatabaseAsyncStoreQuery(lua_State* L)
{
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = getScriptEnv()->getScriptId();
		callback = [ref, scriptId](DBResult_ptr result, bool) {
			lua_State* luaState = g_luaEnvironment.getLuaState();
			if (!luaState) {
				return;
			}

			if (!LuaScriptInterface::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			if (result) {
				lua_pushnumber(luaState, ScriptEnvironment::addResult(result));
			} else {
				pushBoolean(luaState, false);
			}
			auto env = getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment);
			g_luaEnvironment.callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks.addTask(getString(L, -1), callback, true);
	return 0;
}

int LuaScriptInterface::luaDatabaseEscapeString(lua_State* L)
{
	pushString(L, Database::getInstance().escapeString(getString(L, -1)));
	return 1;
}

int LuaScriptInterface::luaDatabaseEscapeBlob(lua_State* L)
{
	uint32_t length = getNumber<uint32_t>(L, 2);
	pushString(L, Database::getInstance().escapeBlob(getString(L, 1).c_str(), length));
	return 1;
}

int LuaScriptInterface::luaDatabaseLastInsertId(lua_State* L)
{
	lua_pushnumber(L, Database::getInstance().getLastInsertId());
	return 1;
}

int LuaScriptInterface::luaDatabaseTableExists(lua_State* L)
{
	pushBoolean(L, DatabaseManager::tableExists(getString(L, -1)));
	return 1;
}

const luaL_Reg LuaScriptInterface::luaResultTable[] = {
	{"getNumber", LuaScriptInterface::luaResultGetNumber},
	{"getString", LuaScriptInterface::luaResultGetString},
	{"getStream", LuaScriptInterface::luaResultGetStream},
	{"next", LuaScriptInterface::luaResultNext},
	{"free", LuaScriptInterface::luaResultFree},
	{nullptr, nullptr}
};

int LuaScriptInterface::luaResultGetNumber(lua_State* L)
{
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	const std::string& s = getString(L, 2);
	lua_pushnumber(L, res->getNumber<int64_t>(s));
	return 1;
}

int LuaScriptInterface::luaResultGetString(lua_State* L)
{
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	const std::string& s = getString(L, 2);
	pushString(L, res->getString(s));
	return 1;
}

int LuaScriptInterface::luaResultGetStream(lua_State* L)
{
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	unsigned long length;
	const char* stream = res->getStream(getString(L, 2), length);
	lua_pushlstring(L, stream, length);
	lua_pushnumber(L, length);
	return 2;
}

int LuaScriptInterface::luaResultNext(lua_State* L)
{
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, -1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, res->next());
	return 1;
}

int LuaScriptInterface::luaResultFree(lua_State* L)
{
	pushBoolean(L, ScriptEnvironment::removeResult(getNumber<uint32_t>(L, -1)));
	return 1;
}

// Userdata
int LuaScriptInterface::luaUserdataCompare(lua_State* L)
{
	// userdataA == userdataB
	pushBoolean(L, getUserdata<void>(L, 1) == getUserdata<void>(L, 2));
	return 1;
}

// _G
int LuaScriptInterface::luaIsType(lua_State* L)
{
	// isType(derived, base)
	lua_getmetatable(L, -2);
	lua_getmetatable(L, -2);

	lua_rawgeti(L, -2, 'p');
	uint_fast8_t parentsB = getNumber<uint_fast8_t>(L, 1);

	lua_rawgeti(L, -3, 'h');
	size_t hashB = getNumber<size_t>(L, 1);

	lua_rawgeti(L, -3, 'p');
	uint_fast8_t parentsA = getNumber<uint_fast8_t>(L, 1);
	for (uint_fast8_t i = parentsA; i < parentsB; ++i) {
		lua_getfield(L, -3, "__index");
		lua_replace(L, -4);
	}

	lua_rawgeti(L, -4, 'h');
	size_t hashA = getNumber<size_t>(L, 1);

	pushBoolean(L, hashA == hashB);
	return 1;
}

int LuaScriptInterface::luaRawGetMetatable(lua_State* L)
{
	// rawgetmetatable(metatableName)
	luaL_getmetatable(L, getString(L, 1).c_str());
	return 1;
}

// os
int LuaScriptInterface::luaSystemTime(lua_State* L)
{
	// os.mtime()
	lua_pushnumber(L, OTSYS_TIME());
	return 1;
}

// table
int LuaScriptInterface::luaTableCreate(lua_State* L)
{
	// table.create(arrayLength, keyLength)
	lua_createtable(L, getNumber<int32_t>(L, 1), getNumber<int32_t>(L, 2));
	return 1;
}


int LuaScriptInterface::luaTablePack(lua_State* L)
{
	// table.pack(...)
	int n = lua_gettop(L);         /* number of elements to pack */
	lua_createtable(L, n, 1);      /* create result table */
	lua_insert(L, 1);              /* put it at index 1 */
	for (int i = n; i >= 1; i--) { /* assign elements */
		lua_rawseti(L, 1, i);
	}
	if (luaL_callmeta(L, -1, "__index") != 0) {
		lua_replace(L, -2);
	}
	lua_pushinteger(L, n);
	lua_setfield(L, 1, "n"); /* t.n = number of elements */
	return 1;                /* return table */
}


// Game
int LuaScriptInterface::luaGameGetSpectators(lua_State* L)
{
	// Game.getSpectators(position[, multifloor = false[, onlyPlayer = false[, minRangeX = 0[, maxRangeX = 0[, minRangeY = 0[, maxRangeY = 0]]]]]])
	const Position& position = getPosition(L, 1);
	bool multifloor = getBoolean(L, 2, false);
	bool onlyPlayers = getBoolean(L, 3, false);
	int32_t minRangeX = getNumber<int32_t>(L, 4, 0);
	int32_t maxRangeX = getNumber<int32_t>(L, 5, 0);
	int32_t minRangeY = getNumber<int32_t>(L, 6, 0);
	int32_t maxRangeY = getNumber<int32_t>(L, 7, 0);

	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, position, multifloor, onlyPlayers, minRangeX, maxRangeX, minRangeY, maxRangeY);

	lua_createtable(L, spectators.size(), 0);

	int index = 0;
	for (Creature* creature : spectators) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetItemIdByClientID(lua_State* L)
{
    // Game.getItemIdByClientID(itemID)
    uint16_t itemID = getNumber<uint16_t>(L, 1);
    const ItemType& it = Item::items.getItemIdByClientId(itemID);
    if (it.id == 0) {
        lua_pushnil(L);
        return 1;
    }
    lua_pushnumber(L, it.id);
    return 1;
}

int LuaScriptInterface::luaGameGetPlayers(lua_State* L)
{
	// Game.getPlayers()
	lua_createtable(L, g_game.getPlayersOnline(), 0);

	int index = 0;
	for (const auto& playerEntry : g_game.getPlayers()) {
		pushUserdata<Player>(L, playerEntry.second);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetNpcs(lua_State* L)
{
	// Game.getNpcs()
	lua_createtable(L, g_game.getNpcsOnline(), 0);

	int index = 0;
	for (const auto& npcEntry : g_game.getNpcs()) {
		pushUserdata<Npc>(L, npcEntry.second);
		setMetatable(L, -1, "Npc");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetMonsters(lua_State* L)
{
	// Game.getMonsters()
	lua_createtable(L, g_game.getMonstersOnline(), 0);

	int index = 0;
	for (const auto& monsterEntry : g_game.getMonsters()) {
		pushUserdata<Monster>(L, monsterEntry.second);
		setMetatable(L, -1, "Monster");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameLoadMap(lua_State* L)
{
	// Game.loadMap(path)
	const std::string& path = getString(L, 1);
		g_dispatcher.addTask(createTask([path]() {
		try {
			g_game.loadMap(path);
		} catch (const std::exception& e) {
			// FIXME: Should only catch some exceptions
			std::cout << "[Error - LuaScriptInterface::luaGameLoadMap] Failed to load map: "
				<< e.what() << std::endl;
		}
	}));
	return 0;
}


int LuaScriptInterface::luaGameGetMonstersFromPos(lua_State* L)
{
	// Game.getMonstersFromPos(pos)
	
	const Position& position = getPosition(L, 1);
	Tile* tile = g_game.map.getTile(position);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	CreatureVector* creatureVector = tile->getCreatures();
	if (!creatureVector) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creatureVector->size(), 0);

	int index = 0;
	for (Creature* creature : *creatureVector) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetExperienceStage(lua_State* L)
{
	// Game.getExperienceStage(level)
	uint32_t level = getNumber<uint32_t>(L, 1);
	lua_pushnumber(L, g_game.getExperienceStage(level));
	return 1;
}

int LuaScriptInterface::luaGameGetMonsterCount(lua_State* L)
{
	// Game.getMonsterCount()
	lua_pushnumber(L, g_game.getMonstersOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetPlayerCount(lua_State* L)
{
	// Game.getPlayerCount()
	lua_pushnumber(L, g_game.getPlayersOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetNpcCount(lua_State* L)
{
	// Game.getNpcCount()
	lua_pushnumber(L, g_game.getNpcsOnline());
	return 1;
}

int LuaScriptInterface::luaGameGetMonsterTypes(lua_State* L)
{
	// Game.getMonsterTypes()
	auto& type = g_monsters.monsters;
	lua_createtable(L, type.size(), 0);

	for (auto& mType : type) {
		pushUserdata<MonsterType>(L, &mType.second);
		setMetatable(L, -1, "MonsterType");
		lua_setfield(L, -2, mType.first.c_str());
	}
	return 1;
}

int LuaScriptInterface::luaGameGetTowns(lua_State* L)
{
	// Game.getTowns()
	const auto& towns = g_game.map.towns.getTowns();
	lua_createtable(L, towns.size(), 0);

	int index = 0;
	for (auto townEntry : towns) {
		pushUserdata<Town>(L, townEntry.second);
		setMetatable(L, -1, "Town");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetHouses(lua_State* L)
{
	// Game.getHouses()
	const auto& houses = g_game.map.houses.getHouses();
	lua_createtable(L, houses.size(), 0);

	int index = 0;
	for (auto houseEntry : houses) {
		pushUserdata<House>(L, houseEntry.second);
		setMetatable(L, -1, "House");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetGameState(lua_State* L)
{
	// Game.getGameState()
	lua_pushnumber(L, g_game.getGameState());
	return 1;
}

int LuaScriptInterface::luaGameSetGameState(lua_State* L)
{
	// Game.setGameState(state)
	GameState_t state = getNumber<GameState_t>(L, 1);
	g_game.setGameState(state);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaGameIsDay(lua_State* L)
{
	// Game.isDay()
	pushBoolean(L, g_game.isDay());
	return 1;
}

int LuaScriptInterface::luaGameIsSunset(lua_State* L)
{
	// Game.isSunset()
	pushBoolean(L, g_game.isSunset());
	return 1;
}

int LuaScriptInterface::luaGameIsNight(lua_State* L)
{
	// Game.isNight()
	pushBoolean(L, g_game.isNight());
	return 1;
}

int LuaScriptInterface::luaGameIsSunrise(lua_State* L)
{
	// Game.isSunrise()
	pushBoolean(L, g_game.isSunrise());
	return 1;
}


int LuaScriptInterface::luaGameGetWorldType(lua_State* L)
{
	// Game.getWorldType()
	lua_pushnumber(L, g_game.getWorldType());
	return 1;
}

int LuaScriptInterface::luaGameSetWorldType(lua_State* L)
{
	// Game.setWorldType(type)
	WorldType_t type = getNumber<WorldType_t>(L, 1);
	g_game.setWorldType(type);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaGameGetReturnMessage(lua_State* L)
{
	// Game.getReturnMessage(value)
	ReturnValue value = getNumber<ReturnValue>(L, 1);
	pushString(L, getReturnMessage(value));
	return 1;
}

int LuaScriptInterface::luaGameCreateItem(lua_State* L)
{
	// Game.createItem(itemId[, count[, position]])
	uint16_t count = getNumber<uint16_t>(L, 2, 1);
	uint16_t id;
	if (isNumber(L, 1)) {
		id = getNumber<uint16_t>(L, 1);
	} else {
		id = Item::items.getItemIdByName(getString(L, 1));
		if (id == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	const ItemType& it = Item::items[id];
	if (it.stackable) {
		count = std::min<uint16_t>(count, MAX_ITEM_COUNT);
	}

	Item* item = Item::CreateItem(id, count);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position& position = getPosition(L, 3);
		Tile* tile = g_game.map.getTile(position);
		if (!tile) {
			delete item;
			lua_pushnil(L);
			return 1;
		}

		g_game.internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	} else {
		getScriptEnv()->addTempItem(item);
		item->setParent(VirtualCylinder::virtualCylinder);
	}

	pushUserdata<Item>(L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int LuaScriptInterface::luaGameCreateContainer(lua_State* L)
{
	// Game.createContainer(itemId, size[, position])
	uint16_t size = getNumber<uint16_t>(L, 2);
	uint16_t id;
	if (isNumber(L, 1)) {
		id = getNumber<uint16_t>(L, 1);
	} else {
		id = Item::items.getItemIdByName(getString(L, 1));
		if (id == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	Container* container = Item::CreateItemAsContainer(id, size);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) >= 3) {
		const Position& position = getPosition(L, 3);
		Tile* tile = g_game.map.getTile(position);
		if (!tile) {
			delete container;
			lua_pushnil(L);
			return 1;
		}

		g_game.internalAddItem(tile, container, INDEX_WHEREEVER, FLAG_NOLIMIT);
	} else {
		getScriptEnv()->addTempItem(container);
		container->setParent(VirtualCylinder::virtualCylinder);
	}

	pushUserdata<Container>(L, container);
	setMetatable(L, -1, "Container");
	return 1;
}

int LuaScriptInterface::luaGameCreateMonster(lua_State* L)
{
	// Game.createMonster(monsterName, position[, extended = false[, force = false, lvl, boost, master]])
	uint32_t lvl = getNumber<uint32_t>(L, 5, 0);
	uint32_t bst = getNumber<uint32_t>(L, 6, 0);

	Player* master = getPlayer(L, 7);
	Monster* monster = Monster::createMonster(getString(L, 1), lvl, bst);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	if (master) {
		monster->convinceCreature(master);
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	bool result = g_events->eventMonsterOnSpawn(monster, position, false, true);
	if (result) {
		if (g_game.placeCreature(monster, position, extended, force)) {
			pushUserdata<Monster>(L, monster);
			setMetatable(L, -1, "Monster");
		} else {
			delete monster;
			lua_pushnil(L);
		}
	} else {
		delete monster;
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameCreateDuelist(lua_State* L)
{
	// Game.createDuelist(name, position[, extended = false[, force = false]])
	std::string name = getString(L, 1);
	const DuelistInfo& info = g_game.getDuelistType(name);
	Duelist* duelist = Duelist::createDuelist(name, info);
	if (!duelist) {
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	// bool result = g_events->eventMonsterOnSpawn(duelist, position, false, true);
	if (g_game.placeCreature(duelist, position, extended, force)) {
		pushUserdata<Duelist>(L, duelist);
		setMetatable(L, -1, "Duelist");
	} else {
		delete duelist;
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaGameCreateNpc(lua_State* L)
{
	// Game.createNpc(npcName, position[, extended = false[, force = false[, spawnName[, wasHolder]]]])
	Npc* npc = Npc::createNpc(getString(L, 1));
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	std::string spawnName = getString(L, 5);
	if (!spawnName.empty()) {
		npc->setNickName(spawnName);
	}

	bool wasHolder = getBoolean(L, 6, false);
	npc->setWasHolder(wasHolder);

	const Position& position = getPosition(L, 2);
	bool extended = getBoolean(L, 3, false);
	bool force = getBoolean(L, 4, false);
	if (g_game.placeCreature(npc, position, extended, force)) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		delete npc;
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameCreateTile(lua_State* L)
{
	// Game.createTile(x, y, z[, isDynamic = false])
	// Game.createTile(position[, isDynamic = false])
	Position position;
	bool isDynamic;
	if (isTable(L, 1)) {
		position = getPosition(L, 1);
		isDynamic = getBoolean(L, 2, false);
	} else {
		position.x = getNumber<uint16_t>(L, 1);
		position.y = getNumber<uint16_t>(L, 2);
		position.z = getNumber<uint16_t>(L, 3);
		isDynamic = getBoolean(L, 4, false);
	}

	Tile* tile = g_game.map.getTile(position);
	if (!tile) {
		if (isDynamic) {
			tile = new DynamicTile(position.x, position.y, position.z);
		} else {
			tile = new StaticTile(position.x, position.y, position.z);
		}

		g_game.map.setTile(position, tile);
	}

	pushUserdata(L, tile);
	setMetatable(L, -1, "Tile");
	return 1;
}

int LuaScriptInterface::luaGameCreateMonsterType(lua_State* L)
{
	// Game.createMonsterType(name)

	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("MonsterTypes can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	MonsterType* monsterType = g_monsters.getMonsterType(getString(L, 1));
	if (monsterType) {

		monsterType->info.lootItems.clear();
		monsterType->info.attackSpells.clear();
		monsterType->info.moves.clear();
		monsterType->info.defenseSpells.clear();
		monsterType->info.scripts.clear();
		monsterType->info.thinkEvent = -1;
		monsterType->info.creatureAppearEvent = -1;
		monsterType->info.creatureDisappearEvent = -1;
		monsterType->info.creatureMoveEvent = -1;
		monsterType->info.creatureSayEvent = -1;

		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else if (isString(L, 1)) {
		monsterType = new MonsterType();
		std::string name = getString(L, 1);
		g_monsters.addMonsterType(name, monsterType);
		monsterType = g_monsters.getMonsterType(getString(L, 1));
		monsterType->name = name;
		monsterType->nameDescription = "a " + name;
		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameStartRaid(lua_State* L)
{
	// Game.startRaid(raidName)
	const std::string& raidName = getString(L, 1);

	Raid* raid = g_game.raids.getRaidByName(raidName);
	if (!raid || !raid->isLoaded()) {
		lua_pushnumber(L, RETURNVALUE_NOSUCHRAIDEXISTS);
		return 1;
	}

	if (g_game.raids.getRunning()) {
		lua_pushnumber(L, RETURNVALUE_ANOTHERRAIDISALREADYEXECUTING);
		return 1;
	}

	g_game.raids.setRunning(raid);
	raid->startRaid();
	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}

int LuaScriptInterface::luaGameGetClientVersion(lua_State* L)
{
	// Game.getClientVersion()
	lua_createtable(L, 0, 3);
	setField(L, "min", CLIENT_VERSION_MIN);
	setField(L, "max", CLIENT_VERSION_MAX);
	setField(L, "string", CLIENT_VERSION_STR);
	return 1;
}

int LuaScriptInterface::luaGameReload(lua_State* L)
{
	// Game.reload(reloadType)
	ReloadTypes_t reloadType = getNumber<ReloadTypes_t>(L, 1);

	if (reloadType == RELOAD_TYPE_GLOBAL) {
		pushBoolean(L, g_luaEnvironment.loadFile("data/global.lua") == 0);
	} else {
		pushBoolean(L, g_game.reload(reloadType));
	}
	lua_gc(g_luaEnvironment.getLuaState(), LUA_GCCOLLECT, 0);
	return 1;
}

int LuaScriptInterface::luaGameSendAnimatedText(lua_State* L)
{
	// Game.sendAnimatedText(position, text, color, isCritical)
	TextMessage message;
	message.position = getPosition(L, 1);
	message.text = getString(L, 2);
	message.primary.color = getNumber<TextColor_t>(L, 3);
	bool isCritical = getBoolean(L, 4, false);
	if (message.position.x && message.position.y && message.position.z) {
		SpectatorVec spectators;
		g_game.map.getSpectators(spectators, message.position, false, true); // san
		for (Creature* spectator : spectators) {
			spectator->getPlayer()->sendAnimatedText(message, isCritical);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetZoneByID(lua_State* L) 
{
	// Game.getZoneById(zoneId)
	uint16_t zoneId = getNumber<uint16_t>(L, 1);
	if(!zoneId) {
		lua_pushnil(L);
	}

	Zone* zone = g_game.getZoneById(zoneId);
	
	if (zone) {
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGameAddGuild(lua_State* L)
{
	// Game.addGuild(guildId, name)
	uint32_t guildId = getNumber<uint32_t>(L, 1);
	const std::string& name = getString(L, 2);

	Guild* guild = g_game.getGuild(guildId);

	if (!guild) {
		guild = new Guild(guildId, name);
		g_game.addGuild(guild);
		pushUserdata<Guild>(L, guild);
		setMetatable(L, -1, "Guild");
	}
	else {
		lua_pushnil(L);
		return 1;
	}

	return 1;
}

int LuaScriptInterface::luaGameRemoveGuild(lua_State* L)
{
	// Game.removeGuild(guildId)
	uint32_t guildId = getNumber<uint32_t>(L, 1);

	Guild* guild = g_game.getGuild(guildId);
	if (guild) {
		g_game.removeGuild(guildId);
	}

	return 1;
}

int LuaScriptInterface::luaGameGetGuilds(lua_State* L)
{
	// Game.getGuilds()
	auto guilds = g_game.getGuilds();
	lua_createtable(L, guilds.size(), 0);

	int index = 0;
	for (const auto& guildEntry : guilds) {
		pushUserdata<Guild>(L, guildEntry.second);
		setMetatable(L, -1, "Guild");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGameGetGuild(lua_State* L)
{
	// Game.getGuild(guildId)
	uint32_t guildId = getNumber<uint32_t>(L, 1);
	const auto& guild = g_game.getGuild(guildId);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Guild>(L, guild);
	setMetatable(L, -1, "Guild");
	return 1;
}

// Variant
int LuaScriptInterface::luaVariantCreate(lua_State* L)
{
	// Variant(number or string or position or thing)
	LuaVariant variant;
	if (isUserdata(L, 2)) {
		if (Thing* thing = getThing(L, 2)) {
			variant.type = VARIANT_TARGETPOSITION;
			variant.pos = thing->getPosition();
		}
	} else if (isTable(L, 2)) {
		variant.type = VARIANT_POSITION;
		variant.pos = getPosition(L, 2);
	} else if (isNumber(L, 2)) {
		variant.type = VARIANT_NUMBER;
		variant.number = getNumber<uint32_t>(L, 2);
	} else if (isString(L, 2)) {
		variant.type = VARIANT_STRING;
		variant.text = getString(L, 2);
	}
	pushVariant(L, variant);
	return 1;
}

int LuaScriptInterface::luaVariantGetNumber(lua_State* L)
{
	// Variant:getNumber()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_NUMBER) {
		lua_pushnumber(L, variant.number);
	} else {
		lua_pushnumber(L, 0);
	}
	return 1;
}

int LuaScriptInterface::luaVariantGetString(lua_State* L)
{
	// Variant:getString()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_STRING) {
		pushString(L, variant.text);
	} else {
		pushString(L, std::string());
	}
	return 1;
}

int LuaScriptInterface::luaVariantGetPosition(lua_State* L)
{
	// Variant:getPosition()
	const LuaVariant& variant = getVariant(L, 1);
	if (variant.type == VARIANT_POSITION || variant.type == VARIANT_TARGETPOSITION) {
		pushPosition(L, variant.pos);
	} else {
		pushPosition(L, Position());
	}
	return 1;
}

// Position
int LuaScriptInterface::luaPositionCreate(lua_State* L)
{
	// Position([x = 0[, y = 0[, z = 0[, stackpos = 0]]]])
	// Position([position])
	if (lua_gettop(L) <= 1) {
		pushPosition(L, Position());
		return 1;
	}

	int32_t stackpos;
	if (isTable(L, 2)) {
		const Position& position = getPosition(L, 2, stackpos);
		pushPosition(L, position, stackpos);
	} else {
		uint16_t x = getNumber<uint16_t>(L, 2, 0);
		uint16_t y = getNumber<uint16_t>(L, 3, 0);
		uint8_t z = getNumber<uint8_t>(L, 4, 0);
		stackpos = getNumber<int32_t>(L, 5, 0);

		pushPosition(L, Position(x, y, z), stackpos);
	}
	return 1;
}

int LuaScriptInterface::luaPositionAdd(lua_State* L)
{
	// positionValue = position + positionEx
	int32_t stackpos;
	const Position& position = getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = getPosition(L, 2, stackpos);
	} else {
		positionEx = getPosition(L, 2);
	}

	pushPosition(L, position + positionEx, stackpos);
	return 1;
}

int LuaScriptInterface::luaPositionSub(lua_State* L)
{
	// positionValue = position - positionEx
	int32_t stackpos;
	const Position& position = getPosition(L, 1, stackpos);

	Position positionEx;
	if (stackpos == 0) {
		positionEx = getPosition(L, 2, stackpos);
	} else {
		positionEx = getPosition(L, 2);
	}

	pushPosition(L, position - positionEx, stackpos);
	return 1;
}

int LuaScriptInterface::luaPositionCompare(lua_State* L)
{
	// position == positionEx
	const Position& positionEx = getPosition(L, 2);
	const Position& position = getPosition(L, 1);
	pushBoolean(L, position == positionEx);
	return 1;
}

int LuaScriptInterface::luaPositionGetDistance(lua_State* L)
{
	// position:getDistance(positionEx)
	const Position& positionEx = getPosition(L, 2);
	const Position& position = getPosition(L, 1);
	lua_pushnumber(L, std::max<int32_t>(
		std::max<int32_t>(
			std::abs(Position::getDistanceX(position, positionEx)),
			std::abs(Position::getDistanceY(position, positionEx))
		),
		std::abs(Position::getDistanceZ(position, positionEx))
	));
	return 1;
}

int LuaScriptInterface::luaPositionIsSightClear(lua_State* L)
{
	// position:isSightClear(positionEx[, sameFloor = true])
	bool sameFloor = getBoolean(L, 3, true);
	const Position& positionEx = getPosition(L, 2);
	const Position& position = getPosition(L, 1);
	pushBoolean(L, g_game.isSightClear(position, positionEx, sameFloor));
	return 1;
}

int LuaScriptInterface::luaPositionSendMagicEffect(lua_State* L)
{
	// position:sendMagicEffect(magicEffect, player = nullptr])
	SpectatorVec spectators;
	if (lua_gettop(L) >= 3) {
		Player* player = getPlayer(L, 3);
		if (player) {
			spectators.emplace_back(player);
		}
	}

	MagicEffectClasses magicEffect = getNumber<MagicEffectClasses>(L, 2);
	
	if (magicEffect == CONST_ME_NONE) {
		pushBoolean(L, false);
		return 1;
	}
	
	const Position& position = getPosition(L, 1);
	if (!spectators.empty()) {
		Game::addMagicEffect(spectators, position, magicEffect);
	} else {
		g_game.addMagicEffect(position, magicEffect);
	}

	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPositionSendDistanceEffect(lua_State* L)
{
	// position:sendDistanceEffect(positionEx, distanceEffect, player = nullptr])
	SpectatorVec spectators;
	if (lua_gettop(L) >= 4) {
		Player* player = getPlayer(L, 4);
		if (player) {
			spectators.emplace_back(player);
		}
	}
	ShootType_t distanceEffect = getNumber<ShootType_t>(L, 3);
	const Position& positionEx = getPosition(L, 2);
	const Position& position = getPosition(L, 1);
	if (!spectators.empty()) {
		Game::addDistanceEffect(spectators, position, positionEx, distanceEffect);
	} else {
		g_game.addDistanceEffect(position, positionEx, distanceEffect);
	}

	pushBoolean(L, true);
	return 1;
}
int LuaScriptInterface::luaPositionShakeScreen(lua_State* L)
{	
	// position:shakeScreen(intensity, time)
	SpectatorVec spectators;
	const Position& position = getPosition(L, 1);
	uint32_t intensity = getNumber<uint32_t>(L, 2, 25);
	uint32_t duration = getNumber<uint32_t>(L, 3, 2500);

	g_game.map.getSpectators(spectators, position, false, true);
	
	if (spectators.empty()) {
		lua_pushboolean(L, false);
		return 1;
	}

	for (Creature* spectator : spectators) {
		if(Player* player = spectator->getPlayer()) {
			player->shakeScreen(intensity, duration);
		}
	}
	lua_pushboolean(L, true);
	return 1;
}


// Tile
int LuaScriptInterface::luaTileCreate(lua_State* L)
{
	// Tile(x, y, z)
	// Tile(position)
	Tile* tile;
	if (isTable(L, 2)) {
		tile = g_game.map.getTile(getPosition(L, 2));
	} else {
		uint8_t z = getNumber<uint8_t>(L, 4);
		uint16_t y = getNumber<uint16_t>(L, 3);
		uint16_t x = getNumber<uint16_t>(L, 2);
		tile = g_game.map.getTile(x, y, z);
	}

	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Zone
int LuaScriptInterface::luaGetZone(lua_State* L)
{ 
	// Zone(id)
	uint16_t zoneId = getNumber<uint16_t>(L, 2);
	if(!zoneId) {
		lua_pushnil(L);
	}

	Zone* zone = g_game.getZoneById(zoneId);
	
	if (zone) {
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGetZoneName(lua_State* L)
{ 
	// zone:getName()
	Zone* zone = getUserdata<Zone>(L, 1);
	
	if (zone) {
		lua_pushstring(L, zone->getName().c_str());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGetZoneId(lua_State* L)
{ 
	// zone:getId()
	Zone* zone = getUserdata<Zone>(L, 1);
	
	if (zone) {
		lua_pushnumber(L, zone->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCleanZone(lua_State* L)
{ 
	// zone:clean()
	Zone* zone = getUserdata<Zone>(L, 1);
	
	if (zone) {
		zone->clean();
		lua_pushboolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGetZoneRange(lua_State* L) { 
    // zone:getRange()
    Zone* zone = getUserdata<Zone>(L, 1);

    if (zone) {
        lua_newtable(L);

        std::vector<zoneInfos> ranges = zone->getZoneRange();
        for (size_t i = 0; i < ranges.size(); ++i) {
            lua_newtable(L);

            const zoneInfos& zones = ranges[i];

            Position topleft = zones.topleft;
            Position bottomright = zones.bottomright;

            pushPosition(L, topleft); 
            lua_rawseti(L, -2, 1);

            pushPosition(L, bottomright);
            lua_rawseti(L, -2, 2);

            lua_rawseti(L, -2, i + 1);
        }
    } else {
        lua_pushnil(L);
    }
    return 1;
}



int LuaScriptInterface::luaTileGetPosition(lua_State* L)
{
	// tile:getPosition()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (tile) {
		pushPosition(L, tile->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetZoneId(lua_State* L)
{
	// tile:getZoneId()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	
	uint16_t id = tile->getZoneId();
	lua_pushnumber(L, id);
	return 1;
}

int LuaScriptInterface::luaTileGetZone(lua_State* L)
{
	// tile:getZone()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Zone* zone = g_game.getZoneById(tile->getZoneId());
	if (!zone) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Zone>(L, zone);
	setMetatable(L, -1, "Zone");
	return 1;
}

int LuaScriptInterface::luaTileLoadZoneId(lua_State* L)
{
	// tile:loadZoneId()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushboolean(L, false);
		return 1;
	}

	uint16_t id = g_game.getZoneIdByPosition(tile->getPosition());
	tile->setZoneId(id, false);
	lua_pushboolean(L, true);
	return 1;
}

int LuaScriptInterface::luaTileUpdate(lua_State* L)
{
	// tile:update()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	const Position& tilePosition = tile->getPosition();
	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, tilePosition, true, true);
	if (spectators.empty()) {
		lua_pushboolean(L, true);
		return 1;
	}
	for (Creature* spectator : spectators) {
		if(spectator->getPlayer()) {
			spectator->getPlayer()->sendUpdateTile(tile, tilePosition);
		}
	}
	lua_pushboolean(L, true);
	return 1;
}

int LuaScriptInterface::luaTileGetGround(lua_State* L)
{
	// tile:getGround()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (tile && tile->getGround()) {
		pushUserdata<Item>(L, tile->getGround());
		setItemMetatable(L, -1, tile->getGround());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetThing(lua_State* L)
{
	// tile:getThing(index)
	int32_t index = getNumber<int32_t>(L, 2);
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Thing* thing = tile->getThing(index);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (Creature* creature = thing->getCreature()) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else if (Item* item = thing->getItem()) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetThingCount(lua_State* L)
{
	// tile:getThingCount()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getThingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetTopVisibleThing(lua_State* L)
{
	// tile:getTopVisibleThing(creature)
	Creature* creature = getCreature(L, 2);
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Thing* thing = tile->getTopVisibleThing(creature);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	if (Creature* visibleCreature = thing->getCreature()) {
		pushUserdata<Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else if (Item* visibleItem = thing->getItem()) {
		pushUserdata<Item>(L, visibleItem);
		setItemMetatable(L, -1, visibleItem);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetTopTopItem(lua_State* L)
{
	// tile:getTopTopItem()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = tile->getTopTopItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetTopDownItem(lua_State* L)
{
	// tile:getTopDownItem()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = tile->getTopDownItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetFieldItem(lua_State* L)
{
	// tile:getFieldItem()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = tile->getFieldItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetItemById(lua_State* L)
{
	// tile:getItemById(itemId[, subType = -1])
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	int32_t subType = getNumber<int32_t>(L, 3, -1);

	Item* item = g_game.findItemOfType(tile, itemId, false, subType);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetItemByType(lua_State* L)
{
	// tile:getItemByType(itemType)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	bool found;

	ItemTypes_t itemType = getNumber<ItemTypes_t>(L, 2);
	switch (itemType) {
		case ITEM_TYPE_TELEPORT:
			found = tile->hasFlag(TILESTATE_TELEPORT);
			break;
		case ITEM_TYPE_MAGICFIELD:
			found = tile->hasFlag(TILESTATE_MAGICFIELD);
			break;
		case ITEM_TYPE_MAILBOX:
			found = tile->hasFlag(TILESTATE_MAILBOX);
			break;
		case ITEM_TYPE_TRASHHOLDER:
			found = tile->hasFlag(TILESTATE_TRASHHOLDER);
			break;
		case ITEM_TYPE_BED:
			found = tile->hasFlag(TILESTATE_BED);
			break;
		case ITEM_TYPE_DEPOT:
			found = tile->hasFlag(TILESTATE_DEPOT);
			break;
		default:
			found = true;
			break;
	}

	if (!found) {
		lua_pushnil(L);
		return 1;
	}

	if (Item* item = tile->getGround()) {
		const ItemType& it = Item::items[item->getID()];
		if (it.type == itemType) {
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
			return 1;
		}
	}

	if (const TileItemVector* items = tile->getItemList()) {
		for (Item* item : *items) {
			const ItemType& it = Item::items[item->getID()];
			if (it.type == itemType) {
				pushUserdata<Item>(L, item);
				setItemMetatable(L, -1, item);
				return 1;
			}
		}
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaTileGetItemByTopOrder(lua_State* L)
{
	// tile:getItemByTopOrder(topOrder)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	int32_t topOrder = getNumber<int32_t>(L, 2);

	Item* item = tile->getItemByTopOrder(topOrder);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Item>(L, item);
	setItemMetatable(L, -1, item);
	return 1;
}

int LuaScriptInterface::luaTileGetItemCountById(lua_State* L)
{
	// tile:getItemCountById(itemId[, subType = -1])
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	lua_pushnumber(L, tile->getItemTypeCount(itemId, subType));
	return 1;
}

int LuaScriptInterface::luaTileGetBottomCreature(lua_State* L)
{
	// tile:getBottomCreature()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	const Creature* creature = tile->getBottomCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<const Creature>(L, creature);
	setCreatureMetatable(L, -1, creature);
	return 1;
}

int LuaScriptInterface::luaTileGetTopCreature(lua_State* L)
{
	// tile:getTopCreature()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = tile->getTopCreature();
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Creature>(L, creature);
	setCreatureMetatable(L, -1, creature);
	return 1;
}

int LuaScriptInterface::luaTileGetBottomVisibleCreature(lua_State* L)
{
	// tile:getBottomVisibleCreature(creature)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const Creature* visibleCreature = tile->getBottomVisibleCreature(creature);
	if (visibleCreature) {
		pushUserdata<const Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetTopVisibleCreature(lua_State* L)
{
	// tile:getTopVisibleCreature(creature)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Creature* visibleCreature = tile->getTopVisibleCreature(creature);
	if (visibleCreature) {
		pushUserdata<Creature>(L, visibleCreature);
		setCreatureMetatable(L, -1, visibleCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetItems(lua_State* L)
{
	// tile:getItems()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	TileItemVector* itemVector = tile->getItemList();
	if (!itemVector) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, itemVector->size(), 0);

	int index = 0;
	for (Item* item : *itemVector) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetItemCount(lua_State* L)
{
	// tile:getItemCount()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getItemCount());
	return 1;
}

int LuaScriptInterface::luaTileGetDownItemCount(lua_State* L)
{
	// tile:getDownItemCount()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (tile) {
		lua_pushnumber(L, tile->getDownItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetTopItemCount(lua_State* L)
{
	// tile:getTopItemCount()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getTopItemCount());
	return 1;
}

int LuaScriptInterface::luaTileGetCreatures(lua_State* L)
{
	// tile:getCreatures()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	CreatureVector* creatureVector = tile->getCreatures();
	if (!creatureVector) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creatureVector->size(), 0);

	int index = 0;
	for (Creature* creature : *creatureVector) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaTileGetCreatureCount(lua_State* L)
{
	// tile:getCreatureCount()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, tile->getCreatureCount());
	return 1;
}

int LuaScriptInterface::luaTileHasProperty(lua_State* L)
{
	// tile:hasProperty(property[, item])
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Item* item;
	if (lua_gettop(L) >= 3) {
		item = getUserdata<Item>(L, 3);
	} else {
		item = nullptr;
	}

	ITEMPROPERTY property = getNumber<ITEMPROPERTY>(L, 2);
	if (item) {
		pushBoolean(L, tile->hasProperty(item, property));
	} else {
		pushBoolean(L, tile->hasProperty(property));
	}
	return 1;
}

int LuaScriptInterface::luaTileGetThingIndex(lua_State* L)
{
	// tile:getThingIndex(thing)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Thing* thing = getThing(L, 2);
	if (thing) {
		lua_pushnumber(L, tile->getThingIndex(thing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileHasFlag(lua_State* L)
{
	// tile:hasFlag(flag)
	Tile* tile = getUserdata<Tile>(L, 1);
	if (tile) {
		tileflags_t flag = getNumber<tileflags_t>(L, 2);
		pushBoolean(L, tile->hasFlag(flag));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileQueryAdd(lua_State* L)
{
	// tile:queryAdd(thing[, flags])
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	Thing* thing = getThing(L, 2);
	if (thing) {
		uint32_t flags = getNumber<uint32_t>(L, 3, 0);
		lua_pushnumber(L, tile->queryAdd(0, *thing, 1, flags));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileAddItem(lua_State* L)
{
	// tile:addItem(itemId[, count/subType = 1[, flags = 0]])
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	uint32_t subType = getNumber<uint32_t>(L, 3, 1);
	Item* item = Item::CreateItem(itemId, std::min<uint32_t>(subType, 100));
	if (!item) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t flags = getNumber<uint32_t>(L, 4, 0);
	ReturnValue ret = g_game.internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		delete item;
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTileAddItemEx(lua_State* L)
{
	// tile:addItemEx(item[, flags = 0])
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}
	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}
	uint32_t flags = getNumber<uint32_t>(L, 3, 0);
	ReturnValue ret = g_game.internalAddItem(tile, item, INDEX_WHEREEVER, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int LuaScriptInterface::luaTileGetHouse(lua_State* L)
{
	// tile:getHouse()
	Tile* tile = getUserdata<Tile>(L, 1);
	if (!tile) {
		lua_pushnil(L);
		return 1;
	}

	if (HouseTile* houseTile = dynamic_cast<HouseTile*>(tile)) {
		pushUserdata<House>(L, houseTile->getHouse());
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// NetworkMessage
int LuaScriptInterface::luaNetworkMessageCreate(lua_State* L)
{
	// NetworkMessage()
	pushUserdata<NetworkMessage>(L, new NetworkMessage);
	setMetatable(L, -1, "NetworkMessage");
	return 1;
}

int LuaScriptInterface::luaNetworkMessageDelete(lua_State* L)
{
	NetworkMessage** messagePtr = getRawUserdata<NetworkMessage>(L, 1);
	if (messagePtr && *messagePtr) {
		delete *messagePtr;
		*messagePtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaNetworkMessageGetByte(lua_State* L)
{
	// networkMessage:getByte()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getByte());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU16(lua_State* L)
{
	// networkMessage:getU16()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint16_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU32(lua_State* L)
{
	// networkMessage:getU32()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint32_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetU64(lua_State* L)
{
	// networkMessage:getU64()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->get<uint64_t>());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetString(lua_State* L)
{
	// networkMessage:getString()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		pushString(L, message->getString());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageGetPosition(lua_State* L)
{
	// networkMessage:getPosition()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		pushPosition(L, message->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddByte(lua_State* L)
{
	// networkMessage:addByte(number)
	uint8_t number = getNumber<uint8_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addByte(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU16(lua_State* L)
{
	// networkMessage:addU16(number)
	uint16_t number = getNumber<uint16_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint16_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU32(lua_State* L)
{
	// networkMessage:addU32(number)
	uint32_t number = getNumber<uint32_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint32_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddU64(lua_State* L)
{
	// networkMessage:addU64(number)
	uint64_t number = getNumber<uint64_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->add<uint64_t>(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddString(lua_State* L)
{
	// networkMessage:addString(string)
	const std::string& string = getString(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addString(string);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddPosition(lua_State* L)
{
	// networkMessage:addPosition(position)
	const Position& position = getPosition(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addPosition(position);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddDouble(lua_State* L)
{
	// networkMessage:addDouble(number)
	double number = getNumber<double>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addDouble(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddItem(lua_State* L)
{
	// networkMessage:addItem(item)
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->addItem(item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageAddItemId(lua_State* L)
{
	// networkMessage:addItemId(itemId)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	message->addItemId(itemId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNetworkMessageReset(lua_State* L)
{
	// networkMessage:reset()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->reset();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageSeek(lua_State* L)
{
	// networkMessage:seek(position)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message && isNumber(L, 2)) {
		pushBoolean(L, message->setBufferPosition(getNumber<uint16_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageTell(lua_State* L)
{
	// networkMessage:tell()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getBufferPosition() - message->INITIAL_BUFFER_POSITION);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageLength(lua_State* L)
{
	// networkMessage:len()
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		lua_pushnumber(L, message->getLength());
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaNetworkMessageSkipBytes(lua_State* L)
{
	// networkMessage:skipBytes(number)
	int16_t number = getNumber<int16_t>(L, 2);
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (message) {
		message->skipBytes(number);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNetworkMessageSendToPlayer(lua_State* L)
{
	// networkMessage:sendToPlayer(player)
	NetworkMessage* message = getUserdata<NetworkMessage>(L, 1);
	if (!message) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getPlayer(L, 2);
	if (player) {
		player->sendNetworkMessage(*message);
		pushBoolean(L, true);
	} else {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
	}
	return 1;
}

// ModalWindow
int LuaScriptInterface::luaModalWindowCreate(lua_State* L)
{
	// ModalWindow(id, title, message)
	const std::string& message = getString(L, 4);
	const std::string& title = getString(L, 3);
	uint32_t id = getNumber<uint32_t>(L, 2);

	pushUserdata<ModalWindow>(L, new ModalWindow(id, title, message));
	setMetatable(L, -1, "ModalWindow");
	return 1;
}

int LuaScriptInterface::luaModalWindowDelete(lua_State* L)
{
	ModalWindow** windowPtr = getRawUserdata<ModalWindow>(L, 1);
	if (windowPtr && *windowPtr) {
		delete *windowPtr;
		*windowPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaModalWindowGetId(lua_State* L)
{
	// modalWindow:getId()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetTitle(lua_State* L)
{
	// modalWindow:getTitle()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->title);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetMessage(lua_State* L)
{
	// modalWindow:getMessage()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushString(L, window->message);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetTitle(lua_State* L)
{
	// modalWindow:setTitle(text)
	const std::string& text = getString(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->title = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetMessage(lua_State* L)
{
	// modalWindow:setMessage(text)
	const std::string& text = getString(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->message = text;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetButtonCount(lua_State* L)
{
	// modalWindow:getButtonCount()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->buttons.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetChoiceCount(lua_State* L)
{
	// modalWindow:getChoiceCount()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->choices.size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowAddButton(lua_State* L)
{
	// modalWindow:addButton(id, text)
	const std::string& text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->buttons.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowAddChoice(lua_State* L)
{
	// modalWindow:addChoice(id, text)
	const std::string& text = getString(L, 3);
	uint8_t id = getNumber<uint8_t>(L, 2);
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->choices.emplace_back(text, id);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetDefaultEnterButton(lua_State* L)
{
	// modalWindow:getDefaultEnterButton()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEnterButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetDefaultEnterButton(lua_State* L)
{
	// modalWindow:setDefaultEnterButton(buttonId)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->defaultEnterButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowGetDefaultEscapeButton(lua_State* L)
{
	// modalWindow:getDefaultEscapeButton()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		lua_pushnumber(L, window->defaultEscapeButton);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetDefaultEscapeButton(lua_State* L)
{
	// modalWindow:setDefaultEscapeButton(buttonId)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->defaultEscapeButton = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowHasPriority(lua_State* L)
{
	// modalWindow:hasPriority()
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		pushBoolean(L, window->priority);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSetPriority(lua_State* L)
{
	// modalWindow:setPriority(priority)
	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		window->priority = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaModalWindowSendToPlayer(lua_State* L)
{
	// modalWindow:sendToPlayer(player)
	Player* player = getPlayer(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	ModalWindow* window = getUserdata<ModalWindow>(L, 1);
	if (window) {
		if (!player->hasModalWindowOpen(window->id)) {
			player->sendModalWindow(*window);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Item
int LuaScriptInterface::luaItemCreate(lua_State* L)
{
	// Item(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemIsItem(lua_State* L)
{
	// item:isItem()
	pushBoolean(L, getUserdata<const Item>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaItemGetParent(lua_State* L)
{
	// item:getParent()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* parent = item->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, parent);
	return 1;
}

int LuaScriptInterface::luaItemGetTopParent(lua_State* L)
{
	// item:getTopParent()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* topParent = item->getTopParent();
	if (!topParent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, topParent);
	return 1;
}

int LuaScriptInterface::luaItemGetId(lua_State* L)
{
	// item:getId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemClone(lua_State* L)
{
	// item:clone()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Item* clone = item->clone();
	if (!clone) {
		lua_pushnil(L);
		return 1;
	}

	getScriptEnv()->addTempItem(clone);
	clone->setParent(VirtualCylinder::virtualCylinder);

	pushUserdata<Item>(L, clone);
	setItemMetatable(L, -1, clone);
	return 1;
}

int LuaScriptInterface::luaItemSplit(lua_State* L)
{
	// item:split([count = 1])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = *itemPtr;
	if (!item || !item->isStackable()) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t count = std::min<uint16_t>(getNumber<uint16_t>(L, 2, 1), item->getItemCount());
	uint16_t diff = item->getItemCount() - count;

	Item* splitItem = item->clone();
	if (!splitItem) {
		lua_pushnil(L);
		return 1;
	}

	splitItem->setItemCount(count);
		
	ScriptEnvironment* env = getScriptEnv();
	uint32_t uid = env->addThing(item);

	Item* newItem = g_game.transformItem(item, item->getID(), diff);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	*itemPtr = newItem;

	splitItem->setParent(VirtualCylinder::virtualCylinder);
	env->addTempItem(splitItem);

	pushUserdata<Item>(L, splitItem);
	setItemMetatable(L, -1, splitItem);
	return 1;
}

int LuaScriptInterface::luaItemRemove(lua_State* L)
{
	// item:remove([count = -1])
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		int32_t count = getNumber<int32_t>(L, 2, -1);
		pushBoolean(L, g_game.internalRemoveItem(item, count) == RETURNVALUE_NOERROR);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetUniqueId(lua_State* L)
{
	// item:getUniqueId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		uint32_t uniqueId = item->getUniqueId();
		if (uniqueId == 0) {
			uniqueId = getScriptEnv()->addThing(item);
		}
		lua_pushnumber(L, uniqueId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetActionId(lua_State* L)
{
	// item:getActionId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getActionId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemSetActionId(lua_State* L)
{
	// item:setActionId(actionId)
	uint16_t actionId = getNumber<uint16_t>(L, 2);
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		item->setActionId(actionId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetCount(lua_State* L)
{
	// item:getCount()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetCharges(lua_State* L)
{
	// item:getCharges()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getCharges());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetFluidType(lua_State* L)
{
	// item:getFluidType()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getFluidType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetWeight(lua_State* L)
{
	// item:getWeight()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getWeight());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetSubType(lua_State* L)
{
	// item:getSubType()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetName(lua_State* L)
{
	// item:getName()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetPluralName(lua_State* L)
{
	// item:getPluralName()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetArticle(lua_State* L)
{
	// item:getArticle()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getArticle());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetPosition(lua_State* L)
{
	// item:getPosition()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushPosition(L, item->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetTile(lua_State* L)
{
	// item:getTile()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Tile* tile = item->getTile();
	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemHasAttribute(lua_State* L)
{
	// item:hasAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	itemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<itemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	pushBoolean(L, item->hasAttribute(attribute));
	return 1;
}

int LuaScriptInterface::luaItemGetAttribute(lua_State* L)
{
	// item:getAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	itemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<itemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	if (ItemAttributes::isIntAttrType(attribute)) {
		lua_pushnumber(L, item->getIntAttr(attribute));
	} else if (ItemAttributes::isStrAttrType(attribute)) {
		pushString(L, item->getStrAttr(attribute));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemSetIntAttribute(lua_State* L)
{
	// item:setIntAttribute(key, value)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	itemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<itemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	if (ItemAttributes::isIntAttrType(attribute)) {
		if (attribute == ITEM_ATTRIBUTE_UNIQUEID) {
			reportErrorFunc("Attempt to set protected key \"uid\"");
			pushBoolean(L, false);
			return 1;
		}

		item->setIntAttr(attribute, getNumber<uint32_t>(L, 3));
		pushBoolean(L, true);
	} else if (ItemAttributes::isStrAttrType(attribute)) {
		item->setStrAttr(attribute, getString(L, 3));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemSetAttribute(lua_State* L)
{
	// item:setAttribute(key, value)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	itemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<itemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	if (ItemAttributes::isIntAttrType(attribute)) {
		if (attribute == ITEM_ATTRIBUTE_UNIQUEID) {
			reportErrorFunc("Attempt to set protected key \"uid\"");
			pushBoolean(L, false);
			return 1;
		}

		//std::cout << "Int Attribute Value: " << getNumber<int32_t>(L, 3) << std::endl;

		item->setIntAttr(attribute, getNumber<int32_t>(L, 3));
		pushBoolean(L, true);
	} else if (ItemAttributes::isStrAttrType(attribute)) {
		item->setStrAttr(attribute, getString(L, 3));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemRemoveAttribute(lua_State* L)
{
	// item:removeAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	itemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<itemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	bool ret = attribute != ITEM_ATTRIBUTE_UNIQUEID;
	if (ret) {
		item->removeAttribute(attribute);
	} else {
		reportErrorFunc("Attempt to erase protected key \"uid\"");
	}
	pushBoolean(L, ret);
	return 1;
}

int LuaScriptInterface::luaItemGetCustomAttribute(lua_State* L) {
	// item:getCustomAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const ItemAttributes::CustomAttribute* attr;
	if (isNumber(L, 2)) {
		attr = item->getCustomAttribute(getNumber<int64_t>(L, 2));
	} else if (isString(L, 2)) {
		attr = item->getCustomAttribute(getString(L, 2));
	} else {
		lua_pushnil(L);
		return 1;
	}

	if (attr) {
		attr->pushToLua(L);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemSetCustomAttribute(lua_State* L) {
	// item:setCustomAttribute(key, value)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	std::string key;
	if (isNumber(L, 2)) {
		key = std::to_string(getNumber<int64_t>(L, 2));
	} else if (isString(L, 2)) {
		key = getString(L, 2);
	} else {
		lua_pushnil(L);
		return 1;
	}

	ItemAttributes::CustomAttribute val;
	if (isNumber(L, 3)) {
		double tmp = getNumber<double>(L, 3);
		if (std::floor(tmp) < tmp) {
			val.set<double>(tmp);
		} else {
			val.set<int64_t>(tmp);
		}
	} else if (isString(L, 3)) {
		val.set<std::string>(getString(L, 3));
	} else if (isBoolean(L, 3)) {
		val.set<bool>(getBoolean(L, 3));
	} else {
		lua_pushnil(L);
		return 1;
	}

	item->setCustomAttribute(key, val);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaItemRemoveCustomAttribute(lua_State* L) {
	// item:removeCustomAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		pushBoolean(L, item->removeCustomAttribute(getNumber<int64_t>(L, 2)));
	} else if (isString(L, 2)) {
		pushBoolean(L, item->removeCustomAttribute(getString(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaItemMoveTo(lua_State* L)
{
	// item:moveTo(position or cylinder[, flags])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = *itemPtr;
	if (!item || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* toCylinder;
	if (isUserdata(L, 2)) {
		const LuaDataType type = getUserdataType(L, 2);
		switch (type) {
			case LuaData_Container:
				toCylinder = getUserdata<Container>(L, 2);
				break;
			case LuaData_Player:
				toCylinder = getUserdata<Player>(L, 2);
				break;
			case LuaData_Tile:
				toCylinder = getUserdata<Tile>(L, 2);
				break;
			default:
				toCylinder = nullptr;
				break;
		}
	} else {
		toCylinder = g_game.map.getTile(getPosition(L, 2));
	}

	if (!toCylinder) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() == toCylinder) {
		pushBoolean(L, true);
		return 1;
	}
	
	uint32_t flags = getNumber<uint32_t>(L, 3, FLAG_NOLIMIT | FLAG_IGNOREBLOCKITEM | FLAG_IGNOREBLOCKCREATURE | FLAG_IGNORENOTMOVEABLE);

	if (item->getParent() == VirtualCylinder::virtualCylinder) {
		pushBoolean(L, g_game.internalAddItem(toCylinder, item, INDEX_WHEREEVER, flags) == RETURNVALUE_NOERROR);
	} else {
		Item* moveItem = nullptr;
		ReturnValue ret = g_game.internalMoveItem(item->getParent(), toCylinder, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem, flags);
		if (moveItem) {
			*itemPtr = moveItem;
		}
		pushBoolean(L, ret == RETURNVALUE_NOERROR);
	}
	return 1;
}

int LuaScriptInterface::luaItemTransform(lua_State* L)
{
	// item:transform(itemId[, count/subType = -1])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item*& item = *itemPtr;
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);
	if (item->getID() == itemId && (subType == -1 || subType == item->getSubType())) {
		pushBoolean(L, true);
		return 1;
	}

	const ItemType& it = Item::items[itemId];
	if (it.stackable) {
		subType = std::min<int32_t>(subType, MAX_ITEM_COUNT);
	}

	ScriptEnvironment* env = getScriptEnv();
	uint32_t uid = env->addThing(item);

	Item* newItem = g_game.transformItem(item, itemId, subType);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	item = newItem;
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaItemDecay(lua_State* L)
{
	// item:decay(decayId)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		if (isNumber(L, 2)) {
			item->setDecayTo(getNumber<int32_t>(L, 2));
		}

		g_game.startDecay(item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemGetDescription(lua_State* L)
{
	// item:getDescription(distance)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		int32_t distance = getNumber<int32_t>(L, 2);
		pushString(L, item->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemHasProperty(lua_State* L)
{
	// item:hasProperty(property)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		ITEMPROPERTY property = getNumber<ITEMPROPERTY>(L, 2);
		pushBoolean(L, item->hasProperty(property));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemIsLoadedFromMap(lua_State* L)
{
	// item:isLoadedFromMap()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushBoolean(L, item->isLoadedFromMap());
	} else {
		lua_pushnil(L);
	}
	return 1;
}


// Container
int LuaScriptInterface::luaContainerCreate(lua_State* L)
{
	// Container(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Container* container = getScriptEnv()->getContainerByUID(id);
	if (container) {
		pushUserdata(L, container);
		setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetSize(lua_State* L)
{
	// container:getSize()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetCapacity(lua_State* L)
{
	// container:getCapacity()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->capacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetEmptySlots(lua_State* L)
{
	// container:getEmptySlots([recursive = false])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t slots = container->capacity() - container->size();
	bool recursive = getBoolean(L, 2, false);
	if (recursive) {
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			if (Container* tmpContainer = (*it)->getContainer()) {
				slots += tmpContainer->capacity() - tmpContainer->size();
			}
		}
	}
	lua_pushnumber(L, slots);
	return 1;
}

int LuaScriptInterface::luaContainerGetItemHoldingCount(lua_State* L)
{
	// container:getItemHoldingCount()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getItemHoldingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetItem(lua_State* L)
{
	// container:getItem(index)
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t index = getNumber<uint32_t>(L, 2);
	Item* item = container->getItemByIndex(index);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerHasItem(lua_State* L)
{
	// container:hasItem(item)
	Item* item = getUserdata<Item>(L, 2);
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		pushBoolean(L, container->isHoldingItem(item));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerAddItem(lua_State* L)
{
	// container:addItem(itemId[, count/subType = 1[, index = INDEX_WHEREEVER[, flags = 0]]])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	uint32_t count = getNumber<uint32_t>(L, 3, 1);
	const ItemType& it = Item::items[itemId];
	if (it.stackable) {
		count = std::min<uint16_t>(count, MAX_ITEM_COUNT);
	}

	Item* item = Item::CreateItem(itemId, count);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	int32_t index = getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
	uint32_t flags = getNumber<uint32_t>(L, 5, 0);

	ReturnValue ret = g_game.internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		delete item;
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerAddItemEx(lua_State* L)
{
	// container:addItemEx(item[, index = INDEX_WHEREEVER[, flags = 0]])
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	int32_t index = getNumber<int32_t>(L, 3, INDEX_WHEREEVER);
	uint32_t flags = getNumber<uint32_t>(L, 4, 0);
	ReturnValue ret = g_game.internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int LuaScriptInterface::luaContainerGetCorpseOwner(lua_State* L)
{
	// container:getCorpseOwner()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getCorpseOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerIsHoldingUniqueItem(lua_State* L)
{
	Container* container = getUserdata<Container>(L, 1);
	if (container->isHoldingUniqueItem()) {
		pushBoolean(L, true);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetPokeballsCached(lua_State* L)
{
	// container:getPokeballsCached()
	Container* container = getUserdata<Container>(L, 1);
	std::vector<Item*> pokeballs = container->getPokeballsCached();
	lua_createtable(L, pokeballs.size(), 0);

	int index = 0;
	for (Item* pokeball : pokeballs) {
		pushUserdata<Item>(L, pokeball);
		setItemMetatable(L, -1, pokeball);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetItemCountById(lua_State* L)
{
	// container:getItemCountById(itemId[, subType = -1])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);
	lua_pushnumber(L, container->getItemTypeCount(itemId, subType));
	return 1;
}

int LuaScriptInterface::luaContainerGetContentDescription(lua_State* L)
{
	// container:getContentDescription()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		pushString(L, container->getContentDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaContainerGetItems(lua_State* L)
{
	// container:getItems([recursive = false])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	bool recursive = getBoolean(L, 2, false);
	std::vector<Item*> items = container->getItems(recursive);

	lua_createtable(L, items.size(), 0);

	int index = 0;
	for (Item* item : items) {
		pushUserdata(L, item);
		setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

// Teleport
int LuaScriptInterface::luaTeleportCreate(lua_State* L)
{
	// Teleport(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item && item->getTeleport()) {
		pushUserdata(L, item);
		setMetatable(L, -1, "Teleport");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTeleportGetDestination(lua_State* L)
{
	// teleport:getDestination()
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		pushPosition(L, teleport->getDestPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTeleportSetDestination(lua_State* L)
{
	// teleport:setDestination(position)
	Teleport* teleport = getUserdata<Teleport>(L, 1);
	if (teleport) {
		teleport->setDestPos(getPosition(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}




// Creature
int LuaScriptInterface::luaCreatureCreate(lua_State* L)
{
	// Creature(id or name or userdata)
	Creature* creature;
	if (isNumber(L, 2)) {
		creature = g_game.getCreatureByID(getNumber<uint64_t>(L, 2));
	} else if (isString(L, 2)) {
		creature = g_game.getCreatureByName(getString(L, 2));
	} else if (isUserdata(L, 2)) {
		LuaDataType type = getUserdataType(L, 2);
		if (type != LuaData_Player && type != LuaData_Monster && type != LuaData_Npc) {
			lua_pushnil(L);
			return 1;
		}
		creature = getUserdata<Creature>(L, 2);
	} else {
		creature = nullptr;
	}

	if (creature) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetEvents(lua_State* L)
{
	// creature:getEvents(type)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	CreatureEventType_t eventType = getNumber<CreatureEventType_t>(L, 2);
	const auto& eventList = creature->getCreatureEvents(eventType);
	lua_createtable(L, eventList.size(), 0);

	int index = 0;
	for (CreatureEvent* event : eventList) {
		pushString(L, event->getName());
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureRegisterEvent(lua_State* L)
{
	// creature:registerEvent(name)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		const std::string& name = getString(L, 2);
		pushBoolean(L, creature->registerCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureUnregisterEvent(lua_State* L)
{
	// creature:unregisterEvent(name)
	const std::string& name = getString(L, 2);
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->unregisterCreatureEvent(name));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureIsRemoved(lua_State* L)
{
	// creature:isRemoved()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isRemoved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureIsCreature(lua_State* L)
{
	// creature:isCreature()
	pushBoolean(L, getUserdata<const Creature>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaCreatureIsInGhostMode(lua_State* L)
{
	// creature:isInGhostMode()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isInGhostMode());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureIsHealthHidden(lua_State* L)
{
	// creature:isHealthHidden()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushBoolean(L, creature->isHealthHidden());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureCanSee(lua_State* L)
{
	// creature:canSee(position)
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		const Position& position = getPosition(L, 2);
		pushBoolean(L, creature->canSee(position));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureCanSeeCreature(lua_State* L)
{
	// creature:canSeeCreature(creature)
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		const Creature* otherCreature = getCreature(L, 2);
		pushBoolean(L, creature->canSeeCreature(otherCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetParent(lua_State* L)
{
	// creature:getParent()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* parent = creature->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, parent);
	return 1;
}

int LuaScriptInterface::luaCreatureGetId(lua_State* L)
{
	// creature:getId()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetName(lua_State* L)
{
	// creature:getName()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushString(L, creature->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetTarget(lua_State* L)
{
	// creature:getTarget()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Creature* target = creature->getAttackedCreature();
	if (target) {
		pushUserdata<Creature>(L, target);
		setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetTarget(lua_State* L)
{
	// creature:setTarget(target)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		Creature* target = getCreature(L, 2);
		pushBoolean(L, creature->setAttackedCreature(target));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureAddCustomIcon(lua_State* L)
{
	// creature:addCustomIcon(target)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		std::string iconName = getString(L, 2);
		int16_t pointX = getNumber<int16_t>(L, 3);
		int16_t pointY = getNumber<int16_t>(L, 4);
		creature->insertIcon(iconName, pointX, pointY);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureRemoveCustomIcon(lua_State* L)
{
	// creature:removeCustomIcon(iconName)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		std::string iconName = getString(L, 2);
		creature->removeIcon(iconName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureCleanCustomIcons(lua_State* L)
{
	// creature:cleanCustomIcons()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->cleanIcons();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetFollowCreature(lua_State* L)
{
	// creature:getFollowCreature()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Creature* followCreature = creature->getFollowCreature();
	if (followCreature) {
		pushUserdata<Creature>(L, followCreature);
		setCreatureMetatable(L, -1, followCreature);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetFollowCreature(lua_State* L)
{
	// creature:setFollowCreature(followedCreature)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		Creature* followCreature = getCreature(L, 2);
		pushBoolean(L, creature->setFollowCreature(followCreature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetMaster(lua_State* L)
{
	// creature:getMaster()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Creature* master = creature->getMaster();
	if (!master) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Creature>(L, master);
	setCreatureMetatable(L, -1, master);
	return 1;
}

int LuaScriptInterface::luaCreatureSetMaster(lua_State* L)
{
	// creature:setMaster(master)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, creature->setMaster(getCreature(L, 2)));
	g_game.updateCreatureType(creature);
	return 1;
}

int LuaScriptInterface::luaCreatureUpdateCreatureType(lua_State* L)
{
	// creature:updateCreatureType()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	g_game.updateCreatureType(creature);
	return 1;
}

int LuaScriptInterface::luaCreatureGetLight(lua_State* L)
{
	// creature:getLight()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	LightInfo lightInfo = creature->getCreatureLight();
	lua_pushnumber(L, lightInfo.level);
	lua_pushnumber(L, lightInfo.color);
	return 2;
}

int LuaScriptInterface::luaCreatureSetLight(lua_State* L)
{
	// creature:setLight(color, level)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	LightInfo light;
	light.color = getNumber<uint8_t>(L, 2);
	light.level = getNumber<uint8_t>(L, 3);
	creature->setCreatureLight(light);
	g_game.changeLight(creature);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureGetSpeed(lua_State* L)
{
	// creature:getSpeed()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetBaseSpeed(lua_State* L)
{
	// creature:getBaseSpeed()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

//get exp from monsters
int LuaScriptInterface::luaMonsterGetExperience(lua_State* L)
{
	// monster:getExperience()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getExperience());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSetExperience(lua_State* L)
{
	// monster:setExperience(experience)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		monster->setExperience(getNumber<uint64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetLevel(lua_State* L)
{
	// monster:getLevel()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetBoost(lua_State* L)
{
	// monster:getBoost()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getBoost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSetOrderPosition(lua_State* L)
{
	// monster:setOrderPosition(Position())
	Monster* monster = getUserdata<Monster>(L, 1);
	const Position position = getPosition(L, 2);
	if (monster) {
		monster->setOrderPosition(position);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetOrderPosition(lua_State* L)
{
	// monster:getOrderPosition()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushPosition(L, monster->getOrderPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaMonsterSetPokeStopped(lua_State* L)
{
	// monster:setPokeStopped(bool)
	Monster* monster = getUserdata<Monster>(L, 1);
	bool stop = getBoolean(L, 2);
	if (monster) {
		monster->setPokeStopped(stop);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsPokeStopped(lua_State* L)
{
	// monster:isPokeStopped()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isPokeStopped());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsGhost(lua_State* L)
{
	// monster:isGhost()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isGhost());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureChangeSpeed(lua_State* L)
{
	// creature:changeSpeed(delta)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t delta = getNumber<int32_t>(L, 2);
	g_game.changeSpeed(creature, delta);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureSetDropLoot(lua_State* L)
{
	// creature:setDropLoot(doDrop)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->setDropLoot(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetSkillLoss(lua_State* L)
{
	// creature:setSkillLoss(skillLoss)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->setSkillLoss(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetPosition(lua_State* L)
{
	// creature:getPosition()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushPosition(L, creature->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetTile(lua_State* L)
{
	// creature:getTile()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Tile* tile = creature->getTile();
	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetDirection(lua_State* L)
{
	// creature:getDirection()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getDirection());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetDirection(lua_State* L)
{
	// creature:setDirection(direction)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		pushBoolean(L, g_game.internalCreatureTurn(creature, getNumber<Direction>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetHealth(lua_State* L)
{
	// creature:getHealth()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetHealth(lua_State* L)
{
 	// creature:setHealth(health)
 	Creature* creature = getUserdata<Creature>(L, 1);
 	if (!creature) {
 		lua_pushnil(L);
 		return 1;
 	}
 
 	creature->health = std::min<int64_t>(getNumber<uint64_t>(L, 2), creature->healthMax);
 	g_game.addCreatureHealth(creature);
 
 	Player* player = creature->getPlayer();
 	if (player) {
 		player->sendStats();
 	}
 	pushBoolean(L, true);
 	return 1;
}

int LuaScriptInterface::luaCreatureAddHealth(lua_State* L)
{
	// creature:addHealth(healthChange)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	CombatDamage damage;
	damage.primary.value = getNumber<int64_t>(L, 2);
	// std::cout << getNumber<int64_t>(L, 2) << std::endl;
	if (damage.primary.value >= 0) {
		damage.primary.type = COMBAT_HEALING;
	} else {
		damage.primary.type = COMBAT_UNDEFINEDDAMAGE;
	}
	pushBoolean(L, g_game.combatChangeHealth(nullptr, creature, damage));
	return 1;
}

int LuaScriptInterface::luaCreatureGetMaxHealth(lua_State* L)
{
	// creature:getMaxHealth()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getMaxHealth());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetMaxHealth(lua_State* L)
{
	// creature:setMaxHealth(maxHealth)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->healthMax = getNumber<uint64_t>(L, 2);
	creature->health = std::min<int64_t>(creature->health, creature->healthMax);
	g_game.addCreatureHealth(creature);

	Player* player = creature->getPlayer();
	if (player) {
		player->sendStats();
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureSetOldMaxHealth(lua_State* L)
{
	// creature:setOldMaxHealth(health)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	creature->oldMaxHealth = getNumber<uint64_t>(L, 2);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureSetHiddenHealth(lua_State* L)
{
	// creature:setHiddenHealth(hide)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->setHiddenHealth(getBoolean(L, 2));
		g_game.addCreatureHealth(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetSkull(lua_State* L)
{
	// creature:getSkull()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getSkull());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetSkull(lua_State* L)
{
	// creature:setSkull(skull)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->setSkull(getNumber<Skulls_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetNameColor(lua_State* L)
{
	// creature:setNameColor(name_color)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->setNameColor(getNumber<NameColor_t>(L, 2));
		creature->nameColor = getNumber<NameColor_t>(L, 2);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetOutfit(lua_State* L)
{
	// creature:getOutfit()
	const Creature* creature = getUserdata<const Creature>(L, 1);
	if (creature) {
		pushOutfit(L, creature->getCurrentOutfit());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetOutfit(lua_State* L)
{
	// creature:setOutfit(outfit)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->defaultOutfit = getOutfit(L, 2);
		g_game.internalCreatureChangeOutfit(creature, creature->defaultOutfit);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetCondition(lua_State* L)
{
	// creature:getCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0]])
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	uint32_t subId = getNumber<uint32_t>(L, 4, 0);

	Condition* condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		pushUserdata<Condition>(L, condition);
		setWeakMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureAddCondition(lua_State* L)
{
	// creature:addCondition(condition[, force = false])
	Creature* creature = getUserdata<Creature>(L, 1);
	Condition* condition = getUserdata<Condition>(L, 2);
	if (creature && condition) {
		bool force = getBoolean(L, 3, false);
		pushBoolean(L, creature->addCondition(condition->clone(), force));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureRemoveCondition(lua_State* L)
{
	// creature:removeCondition(conditionType[, conditionId = CONDITIONID_COMBAT[, subId = 0[, force = false]]])
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);
	uint32_t subId = getNumber<uint32_t>(L, 4, 0);
	Condition* condition = creature->getCondition(conditionType, conditionId, subId);
	if (condition) {
		bool force = getBoolean(L, 5, false);
		creature->removeCondition(condition, force);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureIsImmune(lua_State* L)
{
	// creature:isImmune(condition or conditionType)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	if (isNumber(L, 2)) {
		pushBoolean(L, creature->isImmune(getNumber<ConditionType_t>(L, 2)));
	} else if (Condition* condition = getUserdata<Condition>(L, 2)) {
		pushBoolean(L, creature->isImmune(condition->getType()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
int LuaScriptInterface::luaCreatureHasCondition(lua_State* L)
{
	// creature:hasCondition(conditionType[, subId = 0])
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	uint32_t subId = getNumber<uint32_t>(L, 3, 0);
	pushBoolean(L, creature->hasCondition(conditionType, subId));
	return 1;
}


int LuaScriptInterface::luaCreatureRemove(lua_State* L)
{
	// creature:remove()
	Creature** creaturePtr = getRawUserdata<Creature>(L, 1);
	if (!creaturePtr) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = *creaturePtr;
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = creature->getPlayer();
	if (player) {
		player->kickPlayer(true);
	} else {
		g_game.removeCreature(creature);
	}

	*creaturePtr = nullptr;
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureTeleportTo(lua_State* L)
{
	// creature:teleportTo(position[, pushMovement = false])
	bool pushMovement = getBoolean(L, 3, false);

	const Position& position = getPosition(L, 2);
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const Position oldPosition = creature->getPosition();
	if (g_game.internalTeleport(creature, position, pushMovement) != RETURNVALUE_NOERROR) {
		pushBoolean(L, false);
		return 1;
	}

	if (pushMovement) {
		if (oldPosition.x == position.x) {
			if (oldPosition.y < position.y) {
				g_game.internalCreatureTurn(creature, DIRECTION_SOUTH);
			} else {
				g_game.internalCreatureTurn(creature, DIRECTION_NORTH);
			}
		} else if (oldPosition.x > position.x) {
			g_game.internalCreatureTurn(creature, DIRECTION_WEST);
		} else if (oldPosition.x < position.x) {
			g_game.internalCreatureTurn(creature, DIRECTION_EAST);
		}
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureSay(lua_State* L)
{
	// creature:say(text[, type = TALKTYPE_MONSTER_SAY[, ghost = false[, target = nullptr[, position]]]])
	int parameters = lua_gettop(L);

	Position position;
	if (parameters >= 6) {
		position = getPosition(L, 6);
		if (!position.x || !position.y) {
			reportErrorFunc("Invalid position specified.");
			pushBoolean(L, false);
			return 1;
		}
	}

	Creature* target = nullptr;
	if (parameters >= 5) {
		target = getCreature(L, 5);
	}

	bool ghost = getBoolean(L, 4, false);

	SpeakClasses type = getNumber<SpeakClasses>(L, 3, TALKTYPE_MONSTER_SAY);
	const std::string& text = getString(L, 2);
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	SpectatorVec spectators;
	if (target) {
		spectators.emplace_back(target);
	}

	if (position.x != 0) {
		pushBoolean(L, g_game.internalCreatureSay(creature, type, text, ghost, &spectators, &position));
	} else {
		pushBoolean(L, g_game.internalCreatureSay(creature, type, text, ghost, &spectators));
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetDamageMap(lua_State* L)
{
	// creature:getDamageMap()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->damageMap.size(), 0);
	for (auto damageEntry : creature->damageMap) {
		lua_createtable(L, 0, 2);
		setField(L, "total", damageEntry.second.total);
		setField(L, "ticks", damageEntry.second.ticks);
		lua_rawseti(L, -2, damageEntry.first);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetBossStatus(lua_State* L)
{
	// creature:setBossStatus(bool)
	Creature* creature = getUserdata<Creature>(L, 1);
	bool isBoss = getBoolean(L, 2);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	creature->setBossStatus(isBoss);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCreatureGetSummons(lua_State* L)
{
	// creature:getSummons()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, creature->getSummonCount(), 0);

	int index = 0;
	for (Creature* summon : creature->getSummons()) {
		pushUserdata<Creature>(L, summon);
		setCreatureMetatable(L, -1, summon);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetDescription(lua_State* L)
{
	// creature:getDescription(distance)
	int32_t distance = getNumber<int32_t>(L, 2);
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		pushString(L, creature->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetPathTo(lua_State* L)
{
	// creature:getPathTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	const Position& position = getPosition(L, 2);

	FindPathParams fpp;
	fpp.minTargetDist = getNumber<int32_t>(L, 3, 0);
	fpp.maxTargetDist = getNumber<int32_t>(L, 4, 1);
	fpp.fullPathSearch = getBoolean(L, 5, fpp.fullPathSearch);
	fpp.clearSight = getBoolean(L, 6, fpp.clearSight);
	fpp.maxSearchDist = getNumber<int32_t>(L, 7, fpp.maxSearchDist);

	std::forward_list<Direction> dirList;
	if (creature->getPathTo(position, dirList, fpp)) {
		lua_newtable(L);

		int index = 0;
		for (Direction dir : dirList) {
			lua_pushnumber(L, dir);
			lua_rawseti(L, -2, ++index);
		}
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureMoveTo(lua_State* L)
{
    // creature:moveTo(pos[, minTargetDist = 0[, maxTargetDist = 1[, fullPathSearch = true[, clearSight = true[, maxSearchDist = 0]]]]])
    Creature* creature = getUserdata<Creature>(L, 1);
    if (!creature) {
        lua_pushnil(L);
        return 1;
    }
	
	if (creature->getMaster() && creature->getMaster()->getPlayer()) {
		creature->getMaster()->masterWalked = false;
	}
		

    const Position& position = getPosition(L, 2);

    FindPathParams fpp;
    fpp.minTargetDist = getNumber<int32_t>(L, 3, 0);
    fpp.maxTargetDist = getNumber<int32_t>(L, 4, 0);
    fpp.fullPathSearch = getBoolean(L, 5, fpp.fullPathSearch);
    fpp.clearSight = getBoolean(L, 6, false);
    fpp.maxSearchDist = getNumber<int32_t>(L, 7, 30);

    std::forward_list<Direction> dirList;
    if (creature->getPathTo(position, dirList, fpp)) {
        creature->startAutoWalk(dirList);
        pushBoolean(L, true);
    } else {
        pushBoolean(L, false);
    }
    return 1;
}

int LuaScriptInterface::luaCreatureCancelWalk(lua_State* L)
{
    // creature:cancelWalk()
    Creature* creature = getUserdata<Creature>(L, 1);
    if (!creature) {
        lua_pushnil(L);
        return 1;
    }
	creature->clearListWalkDir();
	pushBoolean(L, true);
    return 1;
}


int LuaScriptInterface::luaCreatureSetNoMove(lua_State* L)
{
   // creature:setNoMove(canMove)
   Player* player = getUserdata<Player>(L, 1);
   if (!player) {
      lua_pushnil(L);
      return 1;
   }

   bool noMove = getBoolean(L, 2);
   if (player->canMove() == noMove) {
	   // std::cout << "Esta setando! " << noMove << std::endl;
      player->setNoMove(noMove);
   }

   pushBoolean(L, true);
   return 1;
}

int LuaScriptInterface::luaCreatureCanMove(lua_State* L)
{
   // creature:canMove()
   Player* player = getUserdata<Player>(L, 1);
    if (player) {
      pushBoolean(L, player->canMove());
   } else {
      lua_pushnil(L);
   }
   return 1;
}

int LuaScriptInterface::luaCreatureMove(lua_State* L)
{
	// creature:move(direction)
	// creature:move(tile[, flags = 0])
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		Direction direction = getNumber<Direction>(L, 2);
		if (direction > DIRECTION_LAST) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game.internalMoveCreature(creature, direction, FLAG_NOLIMIT));
	} else {
		Tile* tile = getUserdata<Tile>(L, 2);
		if (!tile) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, g_game.internalMoveCreature(*creature, *tile, getNumber<uint32_t>(L, 3)));
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetWalkDelay(lua_State* L)
{
	// creature:getWalkDelay(direction)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		Direction direction = getNumber<Direction>(L, 2);
		if (direction > DIRECTION_LAST) {
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, creature->getWalkDelay(direction));
	} 
	return 1;
}

int LuaScriptInterface::luaCreatureGetZone(lua_State* L)
{
	// creature:getZone()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		lua_pushnumber(L, creature->getZone());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureSetProgressbar(lua_State* L)
{
    // creature:sendProgressbar(duration, leftToRight)
    Creature* creature = getUserdata<Creature>(L, 1);
    uint32_t duration = getNumber<uint32_t>(L, 2);
    bool ltr = getBoolean(L, 3);
    if (creature) {
        g_game.startProgressbar(creature, duration, ltr);
        pushBoolean(L, true);
    }
    else {
        lua_pushnil(L);
    }

    return 1;
}

int LuaScriptInterface::luaCreatureSendJump(lua_State* L)
{
    // creature:sendJump(height, duration)
    Creature* creature = getUserdata<Creature>(L, 1);
    uint32_t height = getNumber<uint32_t>(L, 2);
    uint32_t duration = getNumber<uint32_t>(L, 3);
    if (creature) {
        g_game.startJump(creature, height, duration);
        pushBoolean(L, true);
    }
    else {
        lua_pushnil(L);
    }

    return 1;
}

int LuaScriptInterface::luaCreatureSendFirstTitle(lua_State* L)
{
    // creature:sendFirstTitle(title, font, color)
    Creature* creature = getUserdata<Creature>(L, 1);
    const std::string& title = getString(L, 2);
    const std::string& font = getString(L, 3);
    const std::string& color = getString(L, 4);
    if (creature) {
		creature->title = title;
		creature->titleFont = font;
		creature->titleColor = color;
		creature->refreshTile();
        pushBoolean(L, true);
    }
    else {
        lua_pushnil(L);
    }

    return 1;
}

int LuaScriptInterface::luaCreatureSetNickname(lua_State* L)
{
	// creature:setNickname("nickname")
	Creature* creature = getUserdata<Creature>(L, 1);
	const std::string& nickname = getString(L, 2);
	if (creature) {
		creature->nickname = nickname;
		creature->refreshTile();
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaCreatureSetSpeed(lua_State* L)
{
	// creature:setSpeed(speed)
	Creature* creature = getCreature(L, 1);
	if (!creature) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_CREATURE_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	int32_t speed = getNumber<int32_t>(L, 2);
	g_game.setCreatureSpeed(creature, speed);
	pushBoolean(L, true);
	return 1;
}

/*
int LuaScriptInterface::luaCreatureHasIcon(lua_State* L)
{
	// creature:hasIcon(id)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushboolean(L, false);
		return 1;
	}

	const std::string id = getString(L, 2);
	pushBoolean(L, creature->hasIcon(id));
	return 1;
}

int LuaScriptInterface::luaCreatureAddIcon(lua_State* L)
{
	// creature:addIcon(id)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushboolean(L, false);
		return 1;
	}

	const std::string id = getString(L, 2);
	const std::string image = getString(L, 3);
	int32_t offsetX = getNumber<int32_t>(L, 4);
	int32_t offsetY = getNumber<int32_t>(L, 5);

	CustomIcon_t icon{ image, offsetX, offsetY };

	pushBoolean(L, creature->addIcon(id, icon));
	return 1;
}

int LuaScriptInterface::luaCreatureRemoveIcon(lua_State* L)
{
	// creature:removeIcon(id)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushboolean(L, false);
		return 1;
	}

	const std::string id = getString(L, 2);
	pushBoolean(L, creature->removeIcon(id));
	return 1;
}

*/
// Player
int LuaScriptInterface::luaPlayerCreate(lua_State* L)
{
	// Player(id or guid or name or userdata)
	Player* player;
	if (isNumber(L, 2)) {
		uint32_t id = getNumber<uint64_t>(L, 2);
		if (id >= 0x10000000 && id <= Player::playerAutoID) {
			player = g_game.getPlayerByID(id);
		} else {
			player = g_game.getPlayerByGUID(id);
		}
	} else if (isString(L, 2)) {
		ReturnValue ret = g_game.getPlayerByNameWildcard(getString(L, 2), player);
		if (ret != RETURNVALUE_NOERROR) {
			lua_pushnil(L);
			lua_pushnumber(L, ret);
			return 2;
		}
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Player) {
			lua_pushnil(L);
			return 1;
		}
		player = getUserdata<Player>(L, 2);
	} else {
		player = nullptr;
	}

	if (player) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerIsPlayer(lua_State* L)
{
	// player:isPlayer()
	pushBoolean(L, getUserdata<const Player>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuid(lua_State* L)
{
	// player:getGuid()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getGUID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetIp(lua_State* L)
{
	// player:getIp()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getIP());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetAccountId(lua_State* L)
{
	// player:getAccountId()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLastLoginSaved(lua_State* L)
{
	// player:getLastLoginSaved()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLoginSaved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLastLogout(lua_State* L)
{
	// player:getLastLogout()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLastLogout());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetAccountType(lua_State* L)
{
	// player:getAccountType()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getAccountType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetAccountType(lua_State* L)
{
	// player:setAccountType(accountType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->accountType = getNumber<AccountType_t>(L, 2);
		IOLoginData::setAccountType(player->getAccount(), player->accountType);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetCapacity(lua_State* L)
{
	// player:getCapacity()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetCapacity(lua_State* L)
{
	// player:setCapacity(capacity)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->capacity = getNumber<uint32_t>(L, 2);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetFreeCapacity(lua_State* L)
{
	// player:getFreeCapacity()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getFreeCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetDepotChest(lua_State* L)
{
	// player:getDepotChest(depotId[, autoCreate = false])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t depotId = getNumber<uint32_t>(L, 2);
	bool autoCreate = getBoolean(L, 3, false);
	DepotChest* depotChest = player->getDepotChest(depotId, autoCreate);
	if (depotChest) {
		player->setLastDepotId(depotId); // FIXME: workaround for #2251
		pushUserdata<Item>(L, depotChest);
		setItemMetatable(L, -1, depotChest);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetInbox(lua_State* L)
{
	// player:getInbox()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Inbox* inbox = player->getInbox();
	if (inbox) {
		pushUserdata<Item>(L, inbox);
		setItemMetatable(L, -1, inbox);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkullTime(lua_State* L)
{
	// player:getSkullTime()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSkullTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetSkullTime(lua_State* L)
{
	// player:setSkullTime(skullTime)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setSkullTicks(getNumber<int64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetDeathPenalty(lua_State* L)
{
	// player:getDeathPenalty()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLostPercent() * 100);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetExperience(lua_State* L)
{
	// player:getExperience()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getExperience());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddExperience(lua_State* L)
{
	// player:addExperience(experience[, sendText = false])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int64_t experience = getNumber<int64_t>(L, 2);
		bool sendText = getBoolean(L, 3, false);
		player->addExperience(nullptr, experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveExperience(lua_State* L)
{
	// player:removeExperience(experience[, sendText = false])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int64_t experience = getNumber<int64_t>(L, 2);
		bool sendText = getBoolean(L, 3, false);
		player->removeExperience(experience, sendText);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetLevel(lua_State* L)
{
	// player:getLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMagicLevel(lua_State* L)
{
	// player:getMagicLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMagicLevel(lua_State* L)
{
	// player:getBaseMagicLevel()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBaseMagicLevel());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMana(lua_State* L)
{
	// player:getMana()
	const Player* player = getUserdata<const Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMana(lua_State* L)
{
	// player:addMana(manaChange[, animationOnLoss = false])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	int32_t manaChange = getNumber<int32_t>(L, 2);
	bool animationOnLoss = getBoolean(L, 3, false);
	if (!animationOnLoss && manaChange < 0) {
		player->changeMana(manaChange);
	} else {
		CombatDamage damage;
		damage.primary.value = manaChange;
		damage.origin = ORIGIN_NONE;
		g_game.combatChangeMana(nullptr, player, damage);
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetMaxMana(lua_State* L)
{
	// player:getMaxMana()
	const Player* player = getUserdata<const Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMaxMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetMaxMana(lua_State* L)
{
	// player:setMaxMana(maxMana)
	Player* player = getPlayer(L, 1);
	if (player) {
		player->manaMax = getNumber<int32_t>(L, 2);
		player->mana = std::min<int32_t>(player->mana, player->manaMax);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetManaSpent(lua_State* L)
{
	// player:getManaSpent()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSpentMana());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddManaSpent(lua_State* L)
{
	// player:addManaSpent(amount)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->addManaSpent(getNumber<uint64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMaxHealth(lua_State* L)
{
	// player:getBaseMaxHealth()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->healthMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBaseMaxMana(lua_State* L)
{
	// player:getBaseMaxMana()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->manaMax);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillLevel(lua_State* L)
{
	// player:getSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetEffectiveSkillLevel(lua_State* L)
{
	// player:getEffectiveSkillLevel(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->getSkillLevel(skillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillPercent(lua_State* L)
{
	// player:getSkillPercent(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].percent);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSkillTries(lua_State* L)
{
	// player:getSkillTries(skillType)
	skills_t skillType = getNumber<skills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && skillType <= SKILL_LAST) {
		lua_pushnumber(L, player->skills[skillType].tries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSkillTries(lua_State* L)
{
	// player:addSkillTries(skillType, tries)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint64_t tries = getNumber<uint64_t>(L, 3);
		player->addSkillAdvance(skillType, tries);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSpecialSkill(lua_State* L)
{
	// player:getSpecialSkill(specialSkillType)
	SpecialSkills_t specialSkillType = getNumber<SpecialSkills_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player && specialSkillType <= SPECIALSKILL_LAST) {
		lua_pushnumber(L, player->getSpecialSkill(specialSkillType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSpecialSkill(lua_State* L)
{
	// player:addSpecialSkill(specialSkillType, value)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	SpecialSkills_t specialSkillType = getNumber<SpecialSkills_t>(L, 2);
	if (specialSkillType > SPECIALSKILL_LAST) {
		lua_pushnil(L);
		return 1;
	}
	player->setVarSpecialSkill(specialSkillType, getNumber<int32_t>(L, 3));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerAddOfflineTrainingTime(lua_State* L)
{
	// player:addOfflineTrainingTime(time)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int32_t time = getNumber<int32_t>(L, 2);
		player->addOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerGetOfflineTrainingTime(lua_State* L)
{
	// player:getOfflineTrainingTime()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOfflineTrainingTime(lua_State* L)
{
	// player:removeOfflineTrainingTime(time)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		int32_t time = getNumber<int32_t>(L, 2);
		player->removeOfflineTrainingTime(time);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOfflineTrainingTries(lua_State* L)
{
	// player:addOfflineTrainingTries(skillType, tries)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint64_t tries = getNumber<uint64_t>(L, 3);
		pushBoolean(L, player->addOfflineTrainingTries(skillType, tries));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetOfflineTrainingSkill(lua_State* L)
{
	// player:getOfflineTrainingSkill()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getOfflineTrainingSkill());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetOfflineTrainingSkill(lua_State* L)
{
	// player:setOfflineTrainingSkill(skillId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint32_t skillId = getNumber<uint32_t>(L, 2);
		player->setOfflineTrainingSkill(skillId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetItemCount(lua_State* L)
{
	// player:getItemCount(itemId[, subType = -1])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);
	lua_pushnumber(L, player->getItemTypeCount(itemId, subType));
	return 1;
}

int LuaScriptInterface::luaPlayerGetItemById(lua_State* L)
{
	// player:getItemById(itemId, deepSearch[, subType = -1])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}
	bool deepSearch = getBoolean(L, 3);
	int32_t subType = getNumber<int32_t>(L, 4, -1);

	Item* item = g_game.findItemOfType(player, itemId, deepSearch, subType);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetVocation(lua_State* L)
{
	// player:getVocation()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Vocation>(L, player->getVocation());
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetVocation(lua_State* L)
{
	// player:setVocation(id or name or userdata)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* vocation;
	if (isNumber(L, 2)) {
		vocation = g_vocations.getVocation(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		vocation = g_vocations.getVocation(g_vocations.getVocationId(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		vocation = getUserdata<Vocation>(L, 2);
	} else {
		vocation = nullptr;
	}

	if (!vocation) {
		pushBoolean(L, false);
		return 1;
	}

	player->setVocation(vocation->getId());
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetSex(lua_State* L)
{
	// player:getSex()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSex());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetSex(lua_State* L)
{
	// player:setSex(newSex)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		PlayerSex_t newSex = getNumber<PlayerSex_t>(L, 2);
		player->setSex(newSex);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetTown(lua_State* L)
{
	// player:getTown()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Town>(L, player->getTown());
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetTown(lua_State* L)
{
	// player:setTown(town)
	Town* town = getUserdata<Town>(L, 2);
	if (!town) {
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setTown(town);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuild(lua_State* L)
{
	// player:getGuild()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Guild* guild = player->getGuild();
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	pushUserdata<Guild>(L, guild);
	setMetatable(L, -1, "Guild");
	return 1;
}

int LuaScriptInterface::luaPlayerSetGuild(lua_State* L)
{
	// player:setGuild(guild)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->setGuild(getUserdata<Guild>(L, 2));
	pushBoolean(L, true);
	return 1;
}


int LuaScriptInterface::luaPlayerSetGuildRank(lua_State* L)
{
	// player:setGuildRank(rankId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Guild* guild = player->getGuild();
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t rankId = getNumber<uint32_t>(L, 2);
	GuildRank_ptr rank = guild->getRankById(rankId);
	if (rank) {
		player->setGuildRank(rank);
		pushBoolean(L, true);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildRank(lua_State* L)
{
	// player:getGuildRank()
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->getGuild()) {
		GuildRank_ptr rank = player->getGuildRank();
		if (rank) {
			lua_createtable(L, 0, 6);
			setField(L, "id", rank->id);
			setField(L, "name", rank->name);
			setField(L, "permissions", rank->permissions);
			setField(L, "default", rank->isDefault);
			setField(L, "leader", rank->leader);
			setField(L, "removed", rank->removed);
		}
		else {
			lua_pushnil(L);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerGetGuildPermissions(lua_State* L)
{
	// player:getGuildPermissions()
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->getGuild()) {
		lua_pushnumber(L, player->getGuildRank()->permissions);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasGuildPermission(lua_State* L)
{
	// player:hasGuildPermission(value)
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->getGuild()) {
		int32_t value = getNumber<int32_t>(L, 2);
		int32_t permissions = player->getGuildRank()->permissions;
		if (permissions == -1) {
			pushBoolean(L, true);
			return 1;
		}

		pushBoolean(L, (permissions & 1 << value) != 0);
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerAddInboxMessage(lua_State* L)
{
	// player:addInboxMessage(id, type, text[, finished = false[, targetId = 0[, guildId = 0]]])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint32_t id = getNumber<uint32_t>(L, 2);
		time_t date = time(nullptr);
		uint8_t type = getNumber<uint8_t>(L, 3);
		std::string text = getString(L, 4);
		bool finished = getBoolean(L, 5, false);
		uint32_t targetId = getNumber<uint32_t>(L, 6, 0);
		uint32_t guildId = getNumber<uint32_t>(L, 7, 0);
		player->addInboxMessage(id, static_cast<uint32_t>(date), type, text, finished, targetId, guildId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerFinishInboxMessage(lua_State* L)
{
	// player:finishInboxMessage(messageId, updateDb)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint32_t messageId = getNumber<uint32_t>(L, 2);
		bool updateDb = getBoolean(L, 3, false);
		player->finishInboxMessage(messageId, updateDb);
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerGetGuildInbox(lua_State* L)
{
	// player:getGuildInbox()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		auto& guildInbox = player->getGuildInbox();
		lua_createtable(L, guildInbox.size(), 0);

		int index = 0;
		for (const auto& key : guildInbox.keys()) {
			auto& msg = guildInbox.get(key);
			lua_createtable(L, 0, 7);
			setField(L, "id", msg.id);
			setField(L, "date", msg.date);
			setField(L, "type", msg.type);
			setField(L, "text", msg.text);
			setField(L, "finished", msg.finished);
			setField(L, "targetId", msg.targetId);
			setField(L, "guildId", msg.guildId);

			lua_rawseti(L, -2, ++index);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildInboxById(lua_State* L)
{
	// player:getGuildInboxById(msgId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint32_t msgId = getNumber<uint32_t>(L, 2);
		auto &guildInbox = player->getGuildInbox();
		if (!guildInbox.contains(msgId)) {
			lua_pushnil(L);
			return 1;
		}

		auto& msg = guildInbox.get(msgId);
		lua_createtable(L, 0, 7);
		setField(L, "id", msg.id);
		setField(L, "date", msg.date);
		setField(L, "type", msg.type);
		setField(L, "text", msg.text);
		setField(L, "finished", msg.finished);
		setField(L, "targetId", msg.targetId);
		setField(L, "guildId", msg.guildId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerGetGuildNick(lua_State* L)
{
	// player:getGuildNick()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushString(L, player->getGuildNick());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetGuildNick(lua_State* L)
{
	// player:setGuildNick(nick)
	const std::string& nick = getString(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setGuildNick(nick);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGroup(lua_State* L)
{
	// player:getGroup()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushUserdata<Group>(L, player->getGroup());
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetGroup(lua_State* L)
{
	// player:setGroup(group)
	Group* group = getUserdata<Group>(L, 2);
	if (!group) {
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setGroup(group);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetStamina(lua_State* L)
{
	// player:getStamina()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getStaminaMinutes());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetStamina(lua_State* L)
{
	// player:setStamina(stamina)
	uint16_t stamina = getNumber<uint16_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->staminaMinutes = std::min<uint16_t>(2520, stamina);
		player->sendStats();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSoul(lua_State* L)
{
	// player:getSoul()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getSoul());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddSoul(lua_State* L)
{
	// player:addSoul(soulChange)
	int32_t soulChange = getNumber<int32_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->changeSoul(soulChange);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetMaxSoul(lua_State* L)
{
	// player:getMaxSoul()
	Player* player = getUserdata<Player>(L, 1);
	if (player && player->vocation) {
		lua_pushnumber(L, player->vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBankBalance(lua_State* L)
{
	// player:getBankBalance()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getBankBalance());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetBankBalance(lua_State* L)
{
	// player:setBankBalance(bankBalance)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int64_t balance = getNumber<int64_t>(L, 2);
	if (balance < 0) {
		reportErrorFunc("Invalid bank balance value.");
		lua_pushnil(L);
		return 1;
	}

	player->setBankBalance(balance);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetStorageValue(lua_State* L)
{
	// player:getStorageValue(key)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t key = getNumber<uint32_t>(L, 2);
	int32_t value;
	if (player->getStorageValue(key, value)) {
		lua_pushnumber(L, value);
	} else {
		lua_pushnumber(L, -1);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetStorageValue(lua_State* L)
{
	// player:setStorageValue(key, value)
	int32_t value = getNumber<int32_t>(L, 3);
	uint32_t key = getNumber<uint32_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		std::ostringstream ss;
		ss << "Accessing reserved range: " << key;
		reportErrorFunc(ss.str());
		pushBoolean(L, false);
		return 1;
	}

	if (player) {
		player->addStorageValue(key, value);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSetStringStorageValue(lua_State* L)
{
	// creature:setStringStorageValue(key, value)
	std::string value = getString(L, 3);
	uint32_t key = getNumber<uint32_t>(L, 2);
	Creature* creature = getUserdata<Creature>(L, 1);
	if (creature) {
		creature->addStringStorageValue(key, value);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGetStringStorageValue(lua_State* L)
{
	// creature:getStringStorageValue(key)
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t key = getNumber<uint32_t>(L, 2);
	std::string value;
	if (creature->getStringStorageValue(key, value)) {
		lua_pushstring(L, value.c_str());
	} else {
		lua_pushnumber(L, -1);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetZoneId(lua_State* L)
{
	// creature:getZoneId()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	Tile* tile = creature->getTile();

	if (!tile) {
		lua_pushnil(L);
	} else {
		uint16_t zoneId = tile->getZoneId();
		lua_pushnumber(L, zoneId);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureGetCurrentZone(lua_State* L)
{
	// creature:getCurrentZone()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	Tile* tile = creature->getTile();

	if (!tile) {
		lua_pushnil(L);
	} else {
		Zone* zone = g_game.getZoneById(tile->getZoneId());
		pushUserdata<Zone>(L, zone);
		setMetatable(L, -1, "Zone");
	}
	return 1;
}

int LuaScriptInterface::luaCreatureInsertAttachedEffect(lua_State* L)
{
	// creature:insertAttachedEffect(effectId(uint16_t), front(uint8_t))
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	uint16_t effectId = getNumber<uint16_t>(L, 2);
	uint8_t front = getNumber<uint8_t>(L, 3);
	creature->insertAttachedEffect(effectId, front);
	return 1;
}

int LuaScriptInterface::luaCreatureRemoveAttachedEffect(lua_State* L)
{
	// creature:removeAttachedEffect(effectId(uint16_t))
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	uint16_t effectId = getNumber<uint16_t>(L, 2);
	creature->removeAttachedEffect(effectId);
	return 1;
}

int LuaScriptInterface::luaCreatureCleanAttachedEffects(lua_State* L)
{
	// creature:cleanAttachedEffects()
	Creature* creature = getUserdata<Creature>(L, 1);
	if (!creature) {
		lua_pushnil(L);
		return 1;
	}
	creature->cleanAttachedEffects();
	return 1;
}

int LuaScriptInterface::luaPlayerGetItemByPos(lua_State* L)
{
    // player:getItemByPos(fromPos, fromStackPos, spriteID)
    Player* player = getUserdata<Player>(L, 1);
    if (!player) {
        lua_pushnil(L);
        return 1;
    }
    Position fromPos = getPosition(L, 2);
    int32_t fromStackPos = getNumber<int32_t>(L, 3);
    uint32_t fromSpriteId = getNumber<uint32_t>(L, 4);
    Thing* thing = g_game.internalGetThing(player, fromPos, fromStackPos, fromSpriteId, STACKPOS_USEITEM);
    if (!thing) {
        lua_pushnil(L);
        return 1;
    }
    Item* item = thing->getItem();

    if (!item) {
        lua_pushnil(L);
        return 1;
    }

    pushUserdata<Item>(L, item);
    setItemMetatable(L, -1, item);
    return 1;
}

int LuaScriptInterface::luaPlayerAddItem(lua_State* L)
{
	// player:addItem(itemId[, count = 1[, canDropOnMap = true[, subType = 1[, slot = CONST_SLOT_WHEREEVER]]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		pushBoolean(L, false);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t count = getNumber<int32_t>(L, 3, 1);
	int32_t subType = getNumber<int32_t>(L, 5, 1);

	const ItemType& it = Item::items[itemId];

	int32_t itemCount = 1;
	int parameters = lua_gettop(L);
	if (parameters >= 4) {
		itemCount = std::max<int32_t>(1, count);
	} else if (it.hasSubType()) {
		if (it.stackable) {
			itemCount = std::ceil(count / (float)MAX_ITEM_COUNT);
		}

		subType = count;
	} else {
		itemCount = std::max<int32_t>(1, count);
	}

	bool hasTable = itemCount > 1;
	if (hasTable) {
		lua_newtable(L);
	} else if (itemCount == 0) {
		lua_pushnil(L);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 4, true);
	slots_t slot = getNumber<slots_t>(L, 6, CONST_SLOT_WHEREEVER);
	for (int32_t i = 1; i <= itemCount; ++i) {
		int32_t stackCount = subType;
		if (it.stackable) {
			stackCount = std::min<int32_t>(stackCount, MAX_ITEM_COUNT);
			subType -= stackCount;
		}

		Item* item = Item::CreateItem(itemId, stackCount);
		if (!item) {
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		ReturnValue ret = g_game.internalPlayerAddItem(player, item, canDropOnMap, slot);
		if (ret != RETURNVALUE_NOERROR) {
			delete item;
			if (!hasTable) {
				lua_pushnil(L);
			}
			return 1;
		}

		if (hasTable) {
			lua_pushnumber(L, i);
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
			lua_settable(L, -3);
		} else {
			pushUserdata<Item>(L, item);
			setItemMetatable(L, -1, item);
		}
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddItemEx(lua_State* L)
{
	// player:addItemEx(item[, canDropOnMap = false[, index = INDEX_WHEREEVER[, flags = 0]]])
	// player:addItemEx(item[, canDropOnMap = true[, slot = CONST_SLOT_WHEREEVER]])
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		pushBoolean(L, false);
		return 1;
	}

	bool canDropOnMap = getBoolean(L, 3, false);
	ReturnValue returnValue;
	if (canDropOnMap) {
		slots_t slot = getNumber<slots_t>(L, 4, CONST_SLOT_WHEREEVER);
		returnValue = g_game.internalPlayerAddItem(player, item, true, slot);
	} else {
		int32_t index = getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
		uint32_t flags = getNumber<uint32_t>(L, 5, 0);
		returnValue = g_game.internalAddItem(player, item, index, flags);
	}

	if (returnValue == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, returnValue);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveItem(lua_State* L)
{
	// player:removeItem(itemId, count[, subType = -1[, ignoreEquipped = false]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	uint32_t count = getNumber<uint32_t>(L, 3);
	int32_t subType = getNumber<int32_t>(L, 4, -1);
	bool ignoreEquipped = getBoolean(L, 5, false);
	pushBoolean(L, player->removeItemOfType(itemId, count, subType, ignoreEquipped));
	return 1;
}

int LuaScriptInterface::luaPlayerGetMoney(lua_State* L)
{
	// player:getMoney()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getMoney());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetFly(lua_State* L)
{
	// player:setFly(bool fly)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->setFly(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetMarketSellItem(lua_State* L)
{
	// player:setMarketSellItem(item)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		Item* item = getUserdata<Item>(L, 2);
		if (!item) {
			item = nullptr;
		}
		player->setMarketSellItem(item);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerCanSellMarketItem(lua_State* L)
{
	// player:canSellMarketItem()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		Item* item = player->getMarketSellItem();
		if (!item || item->isRemoved() || item->getTopParent() != player) {
			lua_pushnil(L);
			return 1;
		}

		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetElementalBuff(lua_State* L)
{
	// player:setElementalBuff(elemento, buff)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}
	CombatType_t element = getNumber<CombatType_t>(L, 2);
	uint16_t buff = getNumber<uint16_t>(L, 3);
	player->setElementalBuff(element, buff);
	return 1;
}

int LuaScriptInterface::luaPlayerGetElementalBuff(lua_State* L)
{
	// player:getElementalBuff(elemento)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}
	CombatType_t element = getNumber<CombatType_t>(L, 2);
	lua_pushnumber(L, player->getElementalBuff(element));
	return 1;
}

int LuaScriptInterface::luaPlayerAddMoney(lua_State* L)
{
	// player:addMoney(money)
	uint64_t money = getNumber<uint64_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		g_game.addMoney(player, money);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveMoney(lua_State* L)
{
	// player:removeMoney(money)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint64_t money = getNumber<uint64_t>(L, 2);
		pushBoolean(L, g_game.removeMoney(player, money));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerShowTextDialog(lua_State* L)
{
	// player:showTextDialog(id or name or userdata[, text[, canWrite[, length]]])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	int32_t length = getNumber<int32_t>(L, 5, -1);
	bool canWrite = getBoolean(L, 4, false);
	std::string text;

	int parameters = lua_gettop(L);
	if (parameters >= 3) {
		text = getString(L, 3);
	}

	Item* item;
	if (isNumber(L, 2)) {
		item = Item::CreateItem(getNumber<uint16_t>(L, 2));
	} else if (isString(L, 2)) {
		item = Item::CreateItem(Item::items.getItemIdByName(getString(L, 2)));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Item) {
			pushBoolean(L, false);
			return 1;
		}
		item = getUserdata<Item>(L, 2);
	} else {
		item = nullptr;
	}

	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (length < 0) {
		length = Item::items[item->getID()].maxTextLen;
	}

	if (!text.empty()) {
		item->setText(text);
		length = std::max<int32_t>(text.size(), length);
	}

	item->setParent(player);
	player->setWriteItem(item, length);
	player->sendTextWindow(item, length, canWrite);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendTextMessage(lua_State* L)
{
	// player:sendTextMessage(type, text[, position, primaryValue = 0, primaryColor = TEXTCOLOR_NONE[, secondaryValue = 0, secondaryColor = TEXTCOLOR_NONE]])
	// player:sendTextMessage(type, text, channelId)

	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

int parameters = lua_gettop(L);

	TextMessage message(getNumber<MessageClasses>(L, 2), getString(L, 3));
	if (parameters == 4) {
		uint16_t channelId = getNumber<uint16_t>(L, 4);
		ChatChannel* channel = g_chat->getChannel(*player, channelId);
		if (!channel || !channel->hasUser(*player)) {
			pushBoolean(L, false);
			return 1;
		}
		message.channelId = channelId;
	} else {
		if (parameters >= 6) {
			message.position = getPosition(L, 4);
			message.primary.value = getNumber<int32_t>(L, 5);
			message.primary.color = getNumber<TextColor_t>(L, 6);
		}

		if (parameters >= 8) {
			message.secondary.value = getNumber<int32_t>(L, 7);
			message.secondary.color = getNumber<TextColor_t>(L, 8);
		}
	}
	
	player->sendTextMessage(message);
	pushBoolean(L, true);
	
	return 1;
}

int LuaScriptInterface::luaPlayerSendChannelMessage(lua_State* L)
{
	// player:sendChannelMessage(author, text, type, channelId)
	uint16_t channelId = getNumber<uint16_t>(L, 5);
	SpeakClasses type = getNumber<SpeakClasses>(L, 4);
	const std::string& text = getString(L, 3);
	const std::string& author = getString(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->sendChannelMessage(author, text, type, channelId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendPrivateMessage(lua_State* L)
{
	// player:sendPrivateMessage(speaker, text[, type])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const Player* speaker = getUserdata<const Player>(L, 2);
	const std::string& text = getString(L, 3);
	SpeakClasses type = getNumber<SpeakClasses>(L, 4, TALKTYPE_PRIVATE_FROM);
	player->sendPrivateMessage(speaker, type, text);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSendClosePrivate(lua_State* L)
{
	// player:sendClosePrivate(channelId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t channelId = getNumber<uint16_t>(L, 2);
	player->sendClosePrivate(channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerChannelSay(lua_State* L)
{
	// player:channelSay(speaker, type, text, channelId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Creature* speaker = getCreature(L, 2);
	SpeakClasses type = getNumber<SpeakClasses>(L, 3);
	const std::string& text = getString(L, 4);
	uint16_t channelId = getNumber<uint16_t>(L, 5);
	player->sendToChannel(speaker, type, text, channelId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerOpenChannel(lua_State* L)
{
	// player:openChannel(channelId)
	uint16_t channelId = getNumber<uint16_t>(L, 2);
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		g_game.playerOpenChannel(player->getID(), channelId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSlotItem(lua_State* L)
{
	// player:getSlotItem(slot)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t slot = getNumber<uint32_t>(L, 2);
	Thing* thing = player->getThing(slot);
	if (!thing) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = thing->getItem();
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetParty(lua_State* L)
{
	// player:getParty()
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Party* party = player->getParty();
	if (party) {
		pushUserdata<Party>(L, party);
		setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOutfit(lua_State* L)
{
	// player:addOutfit(lookType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->addOutfit(getNumber<uint16_t>(L, 2), 0);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddOutfitAddon(lua_State* L)
{
	// player:addOutfitAddon(lookType, addon)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3);
		player->addOutfit(lookType, addon);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOutfit(lua_State* L)
{
	// player:removeOutfit(lookType)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, player->removeOutfit(lookType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveOutfitAddon(lua_State* L)
{
	// player:removeOutfitAddon(lookType, addon)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3);
		pushBoolean(L, player->removeOutfitAddon(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasOutfit(lua_State* L)
{
	// player:hasOutfit(lookType[, addon = 0])
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint16_t lookType = getNumber<uint16_t>(L, 2);
		uint8_t addon = getNumber<uint8_t>(L, 3, 0);
		pushBoolean(L, player->canWear(lookType, addon));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendOutfitWindow(lua_State* L)
{
	// player:sendOutfitWindow()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->sendOutfitWindow();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMount(lua_State* L) {
	// player:addMount(mountId or mountName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		Mount* mount = g_game.mounts.getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->tameMount(mountId));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveMount(lua_State* L) {
	// player:removeMount(mountId or mountName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t mountId;
	if (isNumber(L, 2)) {
		mountId = getNumber<uint8_t>(L, 2);
	} else {
		Mount* mount = g_game.mounts.getMountByName(getString(L, 2));
		if (!mount) {
			lua_pushnil(L);
			return 1;
		}
		mountId = mount->id;
	}
	pushBoolean(L, player->untameMount(mountId));
	return 1;
}

int LuaScriptInterface::luaPlayerHasMount(lua_State* L) {
	// player:hasMount(mountId or mountName)
	const Player* player = getUserdata<const Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Mount* mount = nullptr;
	if (isNumber(L, 2)) {
		mount = g_game.mounts.getMountByID(getNumber<uint8_t>(L, 2));
	} else {
		mount = g_game.mounts.getMountByName(getString(L, 2));
	}

	if (mount) {
		pushBoolean(L, player->hasMount(mount));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetPremiumDays(lua_State* L)
{
	// player:getPremiumDays()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->premiumDays);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddPremiumDays(lua_State* L)
{
	// player:addPremiumDays(days)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (player->premiumDays != std::numeric_limits<uint16_t>::max()) {
		uint16_t days = getNumber<uint16_t>(L, 2);
		int32_t addDays = std::min<int32_t>(0xFFFE - player->premiumDays, days);
		if (addDays > 0) {
			player->setPremiumDays(player->premiumDays + addDays);
			IOLoginData::addPremiumDays(player->getAccount(), addDays);
		}
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemovePremiumDays(lua_State* L)
{
	// player:removePremiumDays(days)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	if (player->premiumDays != std::numeric_limits<uint16_t>::max()) {
		uint16_t days = getNumber<uint16_t>(L, 2);
		int32_t removeDays = std::min<int32_t>(player->premiumDays, days);
		if (removeDays > 0) {
			player->setPremiumDays(player->premiumDays - removeDays);
			IOLoginData::removePremiumDays(player->getAccount(), removeDays);
		}
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerHasBlessing(lua_State* L)
{
	// player:hasBlessing(blessing)
	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->hasBlessing(blessing));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddBlessing(lua_State* L)
{
	// player:addBlessing(blessing)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	if (player->hasBlessing(blessing)) {
		pushBoolean(L, false);
		return 1;
	}

	player->addBlessing(1 << blessing);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveBlessing(lua_State* L)
{
	// player:removeBlessing(blessing)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t blessing = getNumber<uint8_t>(L, 2) - 1;
	if (!player->hasBlessing(blessing)) {
		pushBoolean(L, false);
		return 1;
	}

	player->removeBlessing(1 << blessing);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerCanLearnSpell(lua_State* L)
{
	// player:canLearnSpell(spellName)
	// const Player* player = getUserdata<const Player>(L, 1);
	// if (!player) {
	// 	lua_pushnil(L);
	// 	return 1;
	// }

	// const std::string& spellName = getString(L, 2);
	// InstantSpell* spell = g_spells->getInstantSpellByName(spellName);
	// if (!spell) {
	// 	reportErrorFunc("Spell \"" + spellName + "\" not found");
	// 	pushBoolean(L, false);
	// 	return 1;
	// }

	// if (player->hasFlag(PlayerFlag_IgnoreSpellCheck)) {
	// 	pushBoolean(L, true);
	// 	return 1;
	// }

	// const auto& vocMap = spell->getVocMap();
	// if (vocMap.count(player->getVocationId()) == 0) {
	// 	pushBoolean(L, false);
	// } else if (player->getLevel() < spell->getLevel()) {
	// 	pushBoolean(L, false);
	// } else if (player->getMagicLevel() < spell->getMagicLevel()) {
		pushBoolean(L, false);
	// } else {
	// 	pushBoolean(L, true);
	// }
	return 1;
}

int LuaScriptInterface::luaPlayerLearnSpell(lua_State* L)
{
	// player:learnSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		player->learnInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerForgetSpell(lua_State* L)
{
	// player:forgetSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		player->forgetInstantSpell(spellName);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasLearnedSpell(lua_State* L)
{
	// player:hasLearnedSpell(spellName)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& spellName = getString(L, 2);
		pushBoolean(L, player->hasLearnedInstantSpell(spellName));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendTutorial(lua_State* L)
{
	// player:sendTutorial(tutorialId)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		uint8_t tutorialId = getNumber<uint8_t>(L, 2);
		player->sendTutorial(tutorialId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddMapMark(lua_State* L)
{
	// player:addMapMark(position, type, description)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const Position& position = getPosition(L, 2);
		uint8_t type = getNumber<uint8_t>(L, 3);
		const std::string& description = getString(L, 4);
		player->sendAddMarker(position, type, description);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSave(lua_State* L)
{
	// player:save()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		player->loginPosition = player->getPosition();
		pushBoolean(L, IOLoginData::savePlayer(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerPopupFYI(lua_State* L)
{
	// player:popupFYI(message)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		const std::string& message = getString(L, 2);
		player->sendFYIBox(message);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerIsPzLocked(lua_State* L)
{
	// player:isPzLocked()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->isPzLocked());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetClient(lua_State* L)
{
	// player:getClient()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_createtable(L, 0, 2);
		setField(L, "version", player->getProtocolVersion());
		setField(L, "os", player->getOperatingSystem());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetHouse(lua_State* L)
{
	// player:getHouse()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = g_game.map.houses.getHouseByPlayerId(player->getGUID());
	if (house) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSendHouseWindow(lua_State* L)
{
	// player:sendHouseWindow(house, listId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = getUserdata<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 3);
	player->sendHouseWindow(house, listId);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSetEditHouse(lua_State* L)
{
	// player:setEditHouse(house, listId)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	House* house = getUserdata<House>(L, 2);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 3);
	player->setEditHouse(house, listId);
	pushBoolean(L, true);
	return 1;
}


int LuaScriptInterface::luaPlayerSetGhostMode(lua_State* L)
{
	// player:setGhostMode(enabled[, showEffect=true])
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	bool enabled = getBoolean(L, 2);
	if (player->isInGhostMode() == enabled) {
		pushBoolean(L, true);
		return 1;
	}

	bool showEffect = getBoolean(L, 3, true);

	player->switchGhostMode();

	Tile* tile = player->getTile();
	const Position& position = player->getPosition();

	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, position, true, true);
	for (Creature* spectator : spectators) {
		Player* tmpPlayer = spectator->getPlayer();
		if (tmpPlayer != player && !tmpPlayer->isAccessPlayer()) {
			if (enabled) {
				tmpPlayer->sendRemoveTileThing(position, tile->getStackposOfCreature(tmpPlayer, player));
			} else {
				tmpPlayer->sendCreatureAppear(player, position, showEffect);
			}
		} else {
			tmpPlayer->sendCreatureChangeVisible(player, !enabled);
		}
	}

	if (player->isInGhostMode()) {
		for (const auto& it : g_game.getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->notifyStatusChange(player, VIPSTATUS_OFFLINE);
			}
		}
		IOLoginData::updateOnlineStatus(player->getGUID(), false);
	} else {
		for (const auto& it : g_game.getPlayers()) {
			if (!it.second->isAccessPlayer()) {
				it.second->notifyStatusChange(player, VIPSTATUS_ONLINE);
			}
		}
		IOLoginData::updateOnlineStatus(player->getGUID(), true);
	}
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetIdleTime(lua_State* L)
{
	// player:getIdleTime()
	const Player* const player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	lua_pushnumber(L, player->getIdleTime());
	return 1;
}

int LuaScriptInterface::luaPlayerResetIdleTime(lua_State* L)
{
	// player:resetIdleTime()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->resetIdleTime();
	pushBoolean(L, true);
	return 1;
}


int LuaScriptInterface::luaPlayerGetContainerId(lua_State* L)
{
	// player:getContainerId(container)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = getUserdata<Container>(L, 2);
	if (container) {
		lua_pushnumber(L, player->getContainerID(container));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetContainerById(lua_State* L)
{
	// player:getContainerById(id)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = player->getContainerByID(getNumber<uint8_t>(L, 2));
	if (container) {
		pushUserdata<Container>(L, container);
		setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetContainerIndex(lua_State* L)
{
	// player:getContainerIndex(id)
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->getContainerIndex(getNumber<uint8_t>(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaPlayerAddBrokes(lua_State* L)
{
	// player:addBrokes(pokename, pokeball)
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);
	std::string pokeball = getString(L, 3);

	if (player) {
		player->addBrokesToPokemon(pokeName, pokeball);
		lua_pushboolean(L, true);
	} else {
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerResetBrokes(lua_State* L)
{
	// player:resetBrokes(pokename)
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);

	if (player) {
		player->resetBrokes(pokeName);
		lua_pushboolean(L, true);
	} else {
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetBrokes(lua_State* L)
{
	// player:getBrokes(pokename) <return table>
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);

	if (player) {
		pokeballsInfo brokes = player->getBrokes(pokeName);
		lua_createtable(L, 0, 26);

		setField(L, "poke", brokes.poke); //1
		setField(L, "great", brokes.great); // 2
		setField(L, "ultra", brokes.ultra); //3
		setField(L, "saffari", brokes.saffari);//4
		setField(L, "master", brokes.master);//5
		setField(L, "moon", brokes.moon);//6
		setField(L, "tinker", brokes.tinker);//7
		setField(L, "sora", brokes.sora);//8
		setField(L, "dusk", brokes.dusk);//9
		setField(L, "yume", brokes.yume);//10
		setField(L, "tale", brokes.tale);//11
		setField(L, "net", brokes.net);//12
		setField(L, "janguru", brokes.janguru);//13
		setField(L, "magu", brokes.magu);//14
		setField(L, "fast", brokes.fast);//15
		setField(L, "heavy", brokes.heavy);//16
		setField(L, "premier", brokes.premier);//17
		setField(L, "delta", brokes.delta);//18
		setField(L, "especial", brokes.especial);//19
		setField(L, "esferadepal", brokes.esferadepal);//20
		setField(L, "esferamega", brokes.esferamega);//21
		setField(L, "esferagiga", brokes.esferagiga);//22
		setField(L, "esferatera", brokes.esferatera);//23
		setField(L, "esferaultra", brokes.esferaultra);//24
		setField(L, "esferalendaria", brokes.esferalendaria);//25
		setField(L, "super", brokes.super);//26
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetAllBrokes(lua_State* L)
{
	// player:getAllBrokes() <return table>
	Player* player = getUserdata<Player>(L, 1);
	if(!player) {
		lua_pushnil(L);
		return 1;
	}

	const std::map<std::string, pokeballsInfo> brokesMap = player->getPlayerBrokes();
	lua_createtable(L, brokesMap.size(), 0);

    for (auto it = brokesMap.begin(); it != brokesMap.end(); ++it) {
        const std::string pokemonName = it->first;
        const pokeballsInfo brokes = it->second;

		lua_createtable(L, 0, 26);

		setField(L, "poke", brokes.poke); //1
		setField(L, "great", brokes.great); // 2
		setField(L, "ultra", brokes.ultra); //3
		setField(L, "saffari", brokes.saffari);//4
		setField(L, "master", brokes.master);//5
		setField(L, "moon", brokes.moon);//6
		setField(L, "tinker", brokes.tinker);//7
		setField(L, "sora", brokes.sora);//8
		setField(L, "dusk", brokes.dusk);//9
		setField(L, "yume", brokes.yume);//10
		setField(L, "tale", brokes.tale);//11
		setField(L, "net", brokes.net);//12
		setField(L, "janguru", brokes.janguru);//13
		setField(L, "magu", brokes.magu);//14
		setField(L, "fast", brokes.fast);//15
		setField(L, "heavy", brokes.heavy);//16
		setField(L, "premier", brokes.premier);//17
		setField(L, "delta", brokes.delta);//18
		setField(L, "especial", brokes.especial);//19
		setField(L, "esferadepal", brokes.esferadepal);//20
		setField(L, "esferamega", brokes.esferamega);//21
		setField(L, "esferagiga", brokes.esferagiga);//22
		setField(L, "esferatera", brokes.esferatera);//23
		setField(L, "esferaultra", brokes.esferaultra);//24
		setField(L, "esferalendaria", brokes.esferalendaria);//25
		setField(L, "super", brokes.super);//26

 		lua_setfield(L, -2, pokemonName.c_str()); 
    }
	return 1;
}

int LuaScriptInterface::luaPlayerGetUsedPokeballs(lua_State* L)
{
	// player:getUsedPokeballs(pokeName) <return table>
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);
	if(!player) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t brokes = player->usedPokeballs(pokeName);
	lua_pushnumber(L, brokes);
	return 1;
}


int LuaScriptInterface::luaPlayerAddCatchPoints(lua_State* L)
{
	// player:addCatchPoints(pokename, points)
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);
	uint16_t points = getNumber<uint16_t>(L, 3);

	if (player) {
		player->addCatchPoints(pokeName, points);
		lua_pushboolean(L, true);
	} else {
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerResetCatchPoints(lua_State* L)
{
	// player:resetCatchPoints(pokename)
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);

	if (player) {
		player->resetCatchPoints(pokeName);
		lua_pushboolean(L, true);
	} else {
		lua_pushboolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetCatchPoints(lua_State* L)
{
	// player:getCatchPoints(pokename)
	Player* player = getUserdata<Player>(L, 1);
	std::string pokeName = getString(L, 2);

	if (player) {
		lua_pushnumber(L, player->getCatchPoints(pokeName));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerSetSpectating(lua_State* L) {
	// player:setSpectating(target)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	Player* target = getUserdata<Player>(L, 2);
	player->setSpectating(target);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerAddSpectator(lua_State* L) {
	// player:addSpectator(spectator)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	Player* spectator = getUserdata<Player>(L, 2);
	if (!spectator) {
		lua_pushnil(L);
		return 1;
	}
	player->addSpectator(spectator);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveSpectator(lua_State* L) {
	// player:removeSpectator(spectator)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	Player* spectator = getUserdata<Player>(L, 2);
	if (!spectator) {
		lua_pushnil(L);
		return 1;
	}
	player->removeSpectator(spectator);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetSpectating(lua_State* L) {
	// player:getSpectating()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	Player* spectating = player->getSpectating();
	if (spectating) {
		pushUserdata<Player>(L, spectating);
		setMetatable(L, -1, "Player");
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetSpectators(lua_State* L) {
	// player:getSpectators()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	const auto& spectators = player->getSpectators();
	lua_createtable(L, spectators.size(), 0);
	int index = 0;
	for (Player* spectator : spectators) {
		pushUserdata<Player>(L, spectator);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasChaseMode(lua_State* L)
{
	// player:hasChaseMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->chaseMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerHasSecureMode(lua_State* L)
{
	// player:hasSecureMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		pushBoolean(L, player->secureMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetFightMode(lua_State* L)
{
	// player:getFightMode()
	Player* player = getUserdata<Player>(L, 1);
	if (player) {
		lua_pushnumber(L, player->fightMode);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Monster
int LuaScriptInterface::luaMonsterCreate(lua_State* L)
{
	// Monster(id or userdata)
	Monster* monster;
	if (isNumber(L, 2)) {
		monster = g_game.getMonsterByID(getNumber<uint64_t>(L, 2));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Monster) {
			lua_pushnil(L);
			return 1;
		}
		monster = getUserdata<Monster>(L, 2);
	} else {
		monster = nullptr;
	}

	if (monster) {
		pushUserdata<Monster>(L, monster);
		setMetatable(L, -1, "Monster");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsMonster(lua_State* L)
{
	// monster:isMonster()
	pushBoolean(L, getUserdata<const Monster>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaMonsterGetType(lua_State* L)
{
	// monster:getType()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		pushUserdata<MonsterType>(L, monster->mType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetRank(lua_State* L)
{
	// monster:getRank()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		MonsterType* mType = monster->mType;
		if (mType) {
			lua_pushstring(L, mType->rank.c_str());
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetSpawnPosition(lua_State* L)
{
	// monster:getSpawnPosition()
	const Monster* monster = getUserdata<const Monster>(L, 1);
	if (monster) {
		pushPosition(L, monster->getMasterPos());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsInSpawnRange(lua_State* L)
{
	// monster:isInSpawnRange([position])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isInSpawnRange(lua_gettop(L) >= 2 ? getPosition(L, 2) : monster->getPosition()));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsIdle(lua_State* L)
{
	// monster:isIdle()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->getIdleStatus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSetIdle(lua_State* L)
{
	// monster:setIdle(idle)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->setIdle(getBoolean(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterIsTarget(lua_State* L)
{
	// monster:isTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsOpponent(lua_State* L)
{
	// monster:isOpponent(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isOpponent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsFriend(lua_State* L)
{
	// monster:isFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		const Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->isFriend(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterAddFriend(lua_State* L)
{
	// monster:addFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		monster->addFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterRemoveFriend(lua_State* L)
{
	// monster:removeFriend(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		monster->removeFriend(creature);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetFriendList(lua_State* L)
{
	// monster:getFriendList()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& friendList = monster->getFriendList();
	lua_createtable(L, friendList.size(), 0);

	int index = 0;
	for (Creature* creature : friendList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetFriendCount(lua_State* L)
{
	// monster:getFriendCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getFriendList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterAddTarget(lua_State* L)
{
	// monster:addTarget(creature[, pushFront = false])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	Creature* creature = getCreature(L, 2);
	bool pushFront = getBoolean(L, 3, false);
	monster->addTarget(creature, pushFront);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterRemoveTarget(lua_State* L)
{
	// monster:removeTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	monster->removeTarget(getCreature(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaMonsterGetTargetList(lua_State* L)
{
	// monster:getTargetList()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (!monster) {
		lua_pushnil(L);
		return 1;
	}

	const auto& targetList = monster->getTargetList();
	lua_createtable(L, targetList.size(), 0);

	int index = 0;
	for (Creature* creature : targetList) {
		pushUserdata<Creature>(L, creature);
		setCreatureMetatable(L, -1, creature);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterGetTargetCount(lua_State* L)
{
	// monster:getTargetCount()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		lua_pushnumber(L, monster->getTargetList().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSelectTarget(lua_State* L)
{
	// monster:selectTarget(creature)
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		Creature* creature = getCreature(L, 2);
		pushBoolean(L, monster->selectTarget(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSearchTarget(lua_State* L)
{
	// monster:searchTarget([searchType = TARGETSEARCH_DEFAULT])
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		TargetSearchType_t searchType = getNumber<TargetSearchType_t>(L, 2, TARGETSEARCH_DEFAULT);
		pushBoolean(L, monster->searchTarget(searchType));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterIsGuardian(lua_State* L)
{
	// monster:isGuardian()
	Monster* monster = getUserdata<Monster>(L, 1);
	if (monster) {
		pushBoolean(L, monster->isMonsterGuardian());
		return 1;
	} 
	lua_pushnil(L);
	return 1;
}

// Duelist
int LuaScriptInterface::luaDuelistCreate(lua_State* L)
{
	// Duelist(id or userdata)
	Duelist* duelist;
	if (isNumber(L, 2)) {
		duelist = g_game.getDuelistByID(getNumber<uint64_t>(L, 2));
	} else if (isUserdata(L, 2)) {
		if (getUserdataType(L, 2) != LuaData_Monster) {
			lua_pushnil(L);
			return 1;
		}
		duelist = getUserdata<Duelist>(L, 2);
	} else {
		duelist = nullptr;
	}

	if (duelist) {
		pushUserdata<Duelist>(L, duelist);
		setMetatable(L, -1, "Duelist");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaDuelistIsDuelist(lua_State* L)
{
	// duelist:isDuelist()
	pushBoolean(L, getUserdata<const Duelist>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaDuelistSetContract(lua_State* L)
{
	// duelist:setContract(playerGuid)
	Duelist* duelist = getUserdata<Duelist>(L, 1);
	if (!duelist) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t playerGuid = getNumber<uint32_t>(L, 2);
	duelist->setContractPlayer(playerGuid);
	return 1;
}

int LuaScriptInterface::luaDuelistSetContractId(lua_State* L)
{
	// duelist:setContractId(contractId)
	Duelist* duelist = getUserdata<Duelist>(L, 1);
	if (!duelist) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t contractId = getNumber<uint32_t>(L, 2);
	duelist->setContractId(contractId);
	return 1;
}

int LuaScriptInterface::luaDuelistGetContractId(lua_State* L)
{
	// duelist:getContractId()
	Duelist* duelist = getUserdata<Duelist>(L, 1);
	if (!duelist) {
		lua_pushnil(L);
		return 1;
	}
	lua_pushnumber(L, duelist->getContractId());
	return 1;
}

// Npc
int LuaScriptInterface::luaNpcCreate(lua_State* L)
{
	// Npc([id or name or userdata])
	Npc* npc;
	if (lua_gettop(L) >= 2) {
		if (isNumber(L, 2)) {
			npc = g_game.getNpcByID(getNumber<uint64_t>(L, 2));
		} else if (isString(L, 2)) {
			npc = g_game.getNpcByName(getString(L, 2));
		} else if (isUserdata(L, 2)) {
			if (getUserdataType(L, 2) != LuaData_Npc) {
				lua_pushnil(L);
				return 1;
			}
			npc = getUserdata<Npc>(L, 2);
		} else {
			npc = nullptr;
		}
	} else {
		npc = getScriptEnv()->getNpc();
	}

	if (npc) {
		pushUserdata<Npc>(L, npc);
		setMetatable(L, -1, "Npc");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNpcIsNpc(lua_State* L)
{
	// npc:isNpc()
	pushBoolean(L, getUserdata<const Npc>(L, 1) != nullptr);
	return 1;
}

int LuaScriptInterface::luaNpcSetMasterPos(lua_State* L)
{
	// npc:setMasterPos(pos[, radius])
	Npc* npc = getUserdata<Npc>(L, 1);
	if (!npc) {
		lua_pushnil(L);
		return 1;
	}

	const Position& pos = getPosition(L, 2);
	int32_t radius = getNumber<int32_t>(L, 3, 1);
	npc->setMasterPos(pos, radius);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaNpcGetSpeechBubble(lua_State* L)
{
	// npc:getSpeechBubble()
	Npc* npc = getUserdata<Npc>(L, 1);
	if (npc) {
		lua_pushnumber(L, npc->getSpeechBubble());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaNpcSetSpeechBubble(lua_State* L)
{
	// npc:setSpeechBubble(speechBubble)
	Npc* npc = getUserdata<Npc>(L, 1);
	if (npc) {
		npc->setSpeechBubble(getNumber<uint8_t>(L, 2));
	}
	return 0;
}

int LuaScriptInterface::luaNpcIsHolder(lua_State* L)
{
	// npc:isHolder()
	Npc* npc = getUserdata<Npc>(L, 1);
	if (npc) {
		if (npc->getWasHolder()) {
			lua_pushboolean(L, true);
			return 1;
		}
	}
	lua_pushboolean(L, false);
	return 1;
}

// Guild
int LuaScriptInterface::luaGuildCreate(lua_State* L)
{
	// Guild(id, name)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Guild* guild = g_game.getGuild(id);
	if (guild) {
		pushUserdata<Guild>(L, guild);
		setMetatable(L, -1, "Guild");
	} else {
		std::string name = getString(L, 3);

		Guild* newGuild = new Guild(id, name);
		g_game.addGuild(newGuild);

		if (newGuild) {
			pushUserdata<Guild>(L, newGuild);
			setMetatable(L, -1, "Guild");
			return 1;
		}

		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSave(lua_State* L)
{
	// guild:save()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushBoolean(L, IOGuild::saveGuild(guild));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetId(lua_State* L)
{
	// guild:getId()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetName(lua_State* L)
{
	// guild:getName()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushString(L, guild->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetMembersOnline(lua_State* L)
{
	// guild:getMembersOnline()
	const Guild* guild = getUserdata<const Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const auto& members = guild->getMembersOnline();
	lua_createtable(L, members.size(), 0);

	int index = 0;
	for (Player* player : members) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetMembers(lua_State* L)
{
	// guild:getMembers()
	const Guild* guild = getUserdata<const Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const auto& members = guild->getMembers();
	lua_createtable(L, members.size(), 0);

	int index = 0;
	for (auto member : members) {
		lua_createtable(L, 0, 6);
		setField(L, "guid", member.guid);
		setField(L, "vocationId", member.vocationId);
		setField(L, "name", member.name);
		setField(L, "rank", member.rank);
		setField(L, "level", member.level);
		setField(L, "lastLogin", member.lastLogin);
		setField(L, "contribution", member.contribution);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddMember(lua_State* L)
{
	// guild:addMember(guid, vocationId, name, rank, level, lastLogin)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t guid = getNumber<uint32_t>(L, 2);
	uint32_t vocationId = getNumber<uint32_t>(L, 3);
	std::string name = getString(L, 4);
	std::string rank = getString(L, 5);
	uint32_t level = getNumber<uint32_t>(L, 6);
	uint64_t lastLogin = getNumber<uint64_t>(L, 7);
	guild->addMember(guid, vocationId, name, rank, level, lastLogin);
	pushBoolean(L, true);

	return 1;
}

int LuaScriptInterface::luaGuildRemoveMember(lua_State* L)
{
	// guild:removeMember(guid)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t guid = getNumber<uint32_t>(L, 2);
	guild->removeMember(guid);
	pushBoolean(L, true);

	return 1;
}

int LuaScriptInterface::luaGuildRemoveOnlineMember(lua_State* L)
{
	// guild:removeOnlineMember(player)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	guild->removeMember(player);
	pushBoolean(L, true);

	return 1;
}

int LuaScriptInterface::luaGuildSetMemberRank(lua_State* L)
{
	// guild:setMemberRank(guid, rankId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t guid = getNumber<uint32_t>(L, 2);
	uint32_t rankId = getNumber<uint32_t>(L, 3);

	guild->setMemberRank(guid, rankId);
	pushBoolean(L, true);

	return 1;
}

int LuaScriptInterface::luaGuildGetMemberRank(lua_State* L)
{
	// guild:getMemberRank(guid)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t guid = getNumber<uint32_t>(L, 2);
	GuildRank_ptr rank = guild->getMemberRank(guid);
	if (rank) {
		lua_createtable(L, 0, 6);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "permissions", rank->permissions);
		setField(L, "default", rank->isDefault);
		setField(L, "leader", rank->leader);
		setField(L, "removed", rank->removed);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaGuildAddRank(lua_State* L)
{
	// guild:addRank(id, name, permissions, default[, leader = false])
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t id = getNumber<uint32_t>(L, 2);
		const std::string& name = getString(L, 3);
		int32_t permissions = getNumber<int32_t>(L, 4);
		bool isDefault = getBoolean(L, 5);
		bool leader = getBoolean(L, 6, false);
		guild->addRank(id, name, permissions, isDefault, leader);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildEditRank(lua_State* L)
{
	// guild:editRank(rankId, name, permissions, default)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t rankId = getNumber<uint32_t>(L, 2);
		const std::string& name = getString(L, 3);
		int32_t permissions = getNumber<int32_t>(L, 4, 0);
		bool isDefault = getBoolean(L, 5, false);
		guild->editRank(rankId, name, permissions, isDefault);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildRemoveRank(lua_State* L)
{
	// guild:removeRank(rankId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t rankId = getNumber<uint32_t>(L, 2);
		guild->removeRank(rankId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetDefaultRank(lua_State* L)
{
	// guild:getDefaultRank()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	GuildRank_ptr rank = guild->getDefaultRank();
	if (rank) {
		lua_createtable(L, 0, 6);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "permissions", rank->permissions);
		setField(L, "default", rank->isDefault);
		setField(L, "leader", rank->leader);
		setField(L, "removed", rank->removed);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetRanks(lua_State* L)
{
	// guild:getRanks()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const auto &ranks = guild->getRanks();
	lua_createtable(L, ranks.size(), 0);

	int index = 0;
	for (auto rank : ranks) {
		lua_createtable(L, 0, 6);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "permissions", rank->permissions);
		setField(L, "default", rank->isDefault);
		setField(L, "leader", rank->leader);
		setField(L, "removed", rank->removed);

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetRankById(lua_State* L)
{
	// guild:getRankById(id)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t id = getNumber<uint32_t>(L, 2);
	GuildRank_ptr rank = guild->getRankById(id);
	if (rank) {
		lua_createtable(L, 0, 6);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "permissions", rank->permissions);
		setField(L, "default", rank->isDefault);
		setField(L, "leader", rank->leader);
		setField(L, "removed", rank->removed);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetRankByName(lua_State* L)
{
	// guild:getRankByName(name)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& name = getString(L, 2);
	GuildRank_ptr rank = guild->getRankByName(name);
	if (rank) {
		lua_createtable(L, 0, 6);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "permissions", rank->permissions);
		setField(L, "default", rank->isDefault);
		setField(L, "leader", rank->leader);
		setField(L, "removed", rank->removed);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetMotd(lua_State* L)
{
	// guild:getMotd()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushString(L, guild->getMotd());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetMotd(lua_State* L)
{
	// guild:setMotd(motd)
	const std::string& motd = getString(L, 2);
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		guild->setMotd(motd);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildEmblem(lua_State* L)
{
	// player:getGuildEmblem(target)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Player* target = getUserdata<Player>(L, 2);
	if (!target) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getGuildEmblem(target));
	return 1;
}

int LuaScriptInterface::luaPlayerApplyGuildBuffs(lua_State* L)
{
	// player:applyGuildBuffs()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->applyGuildBuffs();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveGuildBuffs(lua_State* L)
{
	// player:removeGuildBuffs()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->removeGuildBuffs();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerUpdateRegeneration(lua_State* L)
{
	// player:updateRegeneration()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	// player->updateRegeneration();
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerAddGuildContribution(lua_State* L)
{
	// player:addGuildContribution()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	player->addGuildContribution(getNumber<uint64_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuildContribution(lua_State* L)
{
	// player:getGuildContribution()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->getGuildContribution());
	return 1;
}

int LuaScriptInterface::luaPlayerAddGuardian(lua_State* L)
{
	// player:addGuardian(guardian)
	Player* player = getUserdata<Player>(L, 1);
	Monster* guardian = getUserdata<Monster>(L, 2);

	if (!player || !guardian) {
		lua_pushnil(L);
		return 1;
	}
	player->addGuardian(guardian);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveGuardian(lua_State* L)
{
	// player:removeGuardian(guardian)
	Player* player = getUserdata<Player>(L, 1);
	Monster* guardian = getUserdata<Monster>(L, 2);

	if (!player || !guardian) {
		lua_pushnil(L);
		return 1;
	}
	player->removeGuardian(guardian);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetGuardians(lua_State* L)
{
	// player:getGuardians()
	Player* player = getUserdata<Player>(L, 1);
	lua_createtable(L, player->getGuardianCount(), 0);

	int index = 0;
	for (Creature* guardian : player->getGuardians()) {
		pushUserdata<Creature>(L, guardian);
		setCreatureMetatable(L, -1, guardian);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetLevel(lua_State* L)
{
	// guild:getLevel()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getLevel());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetLevel(lua_State* L)
{
	// guild:setLevel(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint16_t value = getNumber<uint16_t>(L, 2);
	if (guild) {
		guild->setLevel(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetGold(lua_State* L)
{
	// guild:getGold()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getGold());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetGold(lua_State* L)
{
	// guild:setGold(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint64_t value = getNumber<uint64_t>(L, 2);
	if (guild) {
		guild->setGold(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddGold(lua_State* L)
{
	// guild:addGold(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint64_t value = getNumber<uint64_t>(L, 2);
	if (guild) {
		guild->addGold(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildRemoveGold(lua_State* L)
{
	// guild:removeGold(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint64_t value = getNumber<uint64_t>(L, 2);
	if (guild) {
		guild->removeGold(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetRequiredLevel(lua_State* L)
{
	// guild:getRequiredLevel()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getRequiredLevel());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetRequiredLevel(lua_State* L)
{
	// guild:setRequiredLevel(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint32_t value = getNumber<uint32_t>(L, 2);
	if (guild) {
		guild->setRequiredLevel(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetEmblem(lua_State* L)
{
	// guild:getEmblem()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getEmblem());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetEmblem(lua_State* L)
{
	// guild:setEmblem(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t value = getNumber<uint8_t>(L, 2);
	if (guild) {
		guild->setEmblem(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetWarsWon(lua_State* L)
{
	// guild:getWarsWon()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getWarsWon());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetWarsWon(lua_State* L)
{
	// guild:setWarsWon()
	Guild* guild = getUserdata<Guild>(L, 1);
	uint16_t value = getNumber<uint16_t>(L, 2);
	if (guild) {
		guild->setWarsWon(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddWarsWon(lua_State* L)
{
	// guild:addWarsWon()
	Guild* guild = getUserdata<Guild>(L, 1);
	uint16_t value = getNumber<uint16_t>(L, 2);
	if (guild) {
		guild->addWarsWon(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetWarsLost(lua_State* L)
{
	// guild:getWarsLost()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getWarsLost());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetWarsLost(lua_State* L)
{
	// guild:setWarsLost()
	Guild* guild = getUserdata<Guild>(L, 1);
	uint16_t value = getNumber<uint16_t>(L, 2);
	if (guild) {
		guild->setWarsLost(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddWarsLost(lua_State* L)
{
	// guild:addWarsLost()
	Guild* guild = getUserdata<Guild>(L, 1);
	uint16_t value = getNumber<uint16_t>(L, 2);
	if (guild) {
		guild->addWarsLost(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetLanguage(lua_State* L)
{
	// guild:getLanguage()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getLanguage());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetLanguage(lua_State* L)
{
	// guild:setLanguage()
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t value = getNumber<uint8_t>(L, 2);
	if (guild) {
		guild->setLanguage(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetJoinStatus(lua_State* L)
{
	// guild:getJoinStatus()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getJoinStatus());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetJoinStatus(lua_State* L)
{
	// guild:setJoinStatus(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t value = getNumber<uint8_t>(L, 2);
	if (guild) {
		guild->setJoinStatus(value);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetBuffs(lua_State* L)
{
	// guild:getBuffs()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		int index = 0;
		lua_createtable(L, guild->getBuffs().size(), 0);
		for (uint8_t type : guild->getBuffs()) {
			lua_pushnumber(L, type);
			lua_rawseti(L, -2, ++index);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetBuff(lua_State* L)
{
	// guild:setBuff(row, type)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t row = getNumber<uint8_t>(L, 2);
	uint8_t type = getNumber<uint8_t>(L, 3);
	if (guild) {
		guild->setBuff(row, type);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildHasBuff(lua_State* L)
{
	// guild:hasBuff(row, type)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t row = getNumber<uint8_t>(L, 2);
	uint8_t type = getNumber<uint8_t>(L, 3);
	if (guild) {
		pushBoolean(L, guild->hasBuff(row, type));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetPacifism(lua_State* L)
{
	// guild:getPacifism()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getPacifism());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetPacifism(lua_State* L)
{
	// guild:setPacifism(pacifism)
	Guild* guild = getUserdata<Guild>(L, 1);
	int64_t pacifism = getNumber<int64_t>(L, 2);
	if (guild) {
		guild->setPacifism(pacifism);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildIsPacifist(lua_State* L)
{
	// guild:isPacifist()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushBoolean(L, guild->isPacifist());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetPacifismStatus(lua_State* L)
{
	// guild:getPacifismStatus()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getPacifismStatus());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetPacifismStatus(lua_State* L)
{
	// guild:setPacifismStatus(status)
	Guild* guild = getUserdata<Guild>(L, 1);
	uint8_t status = getNumber<uint8_t>(L, 2);
	if (guild) {
		guild->setPacifismStatus(status);
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetCombinedLevels(lua_State* L)
{
	// guild:getCombinedLevels()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getCombinedLevels());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetLeaderName(lua_State* L)
{
	// guild:setLeaderName(name)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		guild->setLeaderName(getString(L, 2));
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetLeaderName(lua_State* L)
{
	// guild:getLeaderName()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushString(L, guild->getLeaderName());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetMemberCount(lua_State* L)
{
	// guild:getMemberCount()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getMemberCount());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddWar(lua_State* L)
{
	// guild:addWar(guildId, warId, status, killsMax, goldBet, duration, started, ended, forced, init)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		GuildWar war;
		war.id = getNumber<uint32_t>(L, 3, 0);
		war.status = getNumber<uint8_t>(L, 4, 0);
		war.kills = 0;
		war.killsMax = getNumber<uint16_t>(L, 5, 0);
		war.goldBet = getNumber<uint64_t>(L, 6, 0);
		war.duration = getNumber<time_t>(L, 7, 0);
		war.started = getNumber<time_t>(L, 8, 0);
		war.ended = getNumber<time_t>(L, 9, 0);
		war.forced = getBoolean(L, 10, false);
		war.init = getBoolean(L, 11, false);
		pushBoolean(L, guild->addWar(guildId, war));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildRemoveWar(lua_State* L)
{
	// guild:removeWar(guildId, remove = false)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		pushBoolean(L, guild->removeWar(guildId, getBoolean(L, 3, false)));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildIsInWar(lua_State* L)
{
	// guild:isInWar(guildId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushBoolean(L, guild->isInWar(getNumber<uint32_t>(L, 2)));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildIsInAnyWar(lua_State* L)
{
	// guild:isInAnyWar(guildId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		pushBoolean(L, guild->isInAnyWar(getNumber<uint32_t>(L, 2)));
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetWar(lua_State* L)
{
	// guild:getWar(guildId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		if (!guild->isInAnyWar(guildId)) {
			lua_pushnil(L);
			return 1;
		}
		auto& war = guild->getWar(guildId);
		lua_createtable(L, 0, 11);

		setField(L, "guildId", guildId);
		setField(L, "warId", war.id);
		setField(L, "status", war.status);
		setField(L, "kills", war.kills);
		setField(L, "killsMax", war.killsMax);
		setField(L, "goldBet", war.goldBet);
		setField(L, "duration", war.duration);
		setField(L, "started", war.started);
		setField(L, "ended", war.ended);
		setField(L, "forced", war.forced);
		setField(L, "init", war.init);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetWarEndDate(lua_State* L)
{
	// guild:getWarEndDate(guildId)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		if (!guild->isInAnyWar(guildId)) {
			lua_pushnil(L);
			return 1;
		}
		auto& war = guild->getWar(guildId);
		lua_pushnumber(L, war.started + war.duration);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetWars(lua_State* L)
{
	// guild:getWars()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		int index = 0;
		lua_createtable(L, guild->getWars().size(), 0);
		for (auto& war : guild->getWars()) {
			lua_createtable(L, 0, 11);

			setField(L, "guildId", war.first);
			setField(L, "warId", war.second.id);
			setField(L, "status", war.second.status);
			setField(L, "kills", war.second.kills);
			setField(L, "killsMax", war.second.killsMax);
			setField(L, "goldBet", war.second.goldBet);
			setField(L, "duration", war.second.duration);
			setField(L, "started", war.second.started);
			setField(L, "ended", war.second.ended);
			setField(L, "forced", war.second.forced);
			setField(L, "init", war.second.init);

			lua_rawseti(L, -2, ++index);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildAddWarKill(lua_State* L)
{
	// guild:addWarKill(guildId, kills)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		if (!guild->isInWar(guildId)) {
			lua_pushnil(L);
			return 1;
		}
		auto& war = guild->getWar(guildId);
		war.kills += getNumber<uint16_t>(L, 3);

		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetWarStatus(lua_State* L)
{
	// guild:setWarStatus(guildId, status)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		uint32_t guildId = getNumber<uint32_t>(L, 2);
		if (!guild->isInAnyWar(guildId)) {
			lua_pushnil(L);
			return 1;
		}
		auto& war = guild->getWar(guildId);
		war.status = getNumber<uint8_t>(L, 3);

		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildSetLastBuffSave(lua_State* L)
{
	// guild:setLastBuffSave(value)
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		guild->setLastBuffSave(getNumber<uint64_t>(L, 2));
		pushBoolean(L, true);
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGuildGetLastBuffSave(lua_State* L)
{
	// guild:getLastBuffSave()
	Guild* guild = getUserdata<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getLastBuffSave());
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

// Group
int LuaScriptInterface::luaGroupCreate(lua_State* L)
{
	// Group(id)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Group* group = g_game.groups.getGroup(id);
	if (group) {
		pushUserdata<Group>(L, group);
		setMetatable(L, -1, "Group");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetId(lua_State* L)
{
	// group:getId()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetName(lua_State* L)
{
	// group:getName()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushString(L, group->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetFlags(lua_State* L)
{
	// group:getFlags()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->flags);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetAccess(lua_State* L)
{
	// group:getAccess()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		pushBoolean(L, group->access);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetMaxDepotItems(lua_State* L)
{
	// group:getMaxDepotItems()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxDepotItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupGetMaxVipEntries(lua_State* L)
{
	// group:getMaxVipEntries()
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		lua_pushnumber(L, group->maxVipEntries);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGroupHasFlag(lua_State* L)
{
	// group:hasFlag(flag)
	Group* group = getUserdata<Group>(L, 1);
	if (group) {
		PlayerFlags flag = getNumber<PlayerFlags>(L, 2);
		pushBoolean(L, (group->flags & flag) != 0);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Vocation
int LuaScriptInterface::luaVocationCreate(lua_State* L)
{
	// Vocation(id or name)
	uint32_t id;
	if (isNumber(L, 2)) {
		id = getNumber<uint32_t>(L, 2);
	} else {
		id = g_vocations.getVocationId(getString(L, 2));
	}

	Vocation* vocation = g_vocations.getVocation(id);
	if (vocation) {
		pushUserdata<Vocation>(L, vocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetId(lua_State* L)
{
	// vocation:getId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetClientId(lua_State* L)
{
	// vocation:getClientId()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getClientId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetName(lua_State* L)
{
	// vocation:getName()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetDescription(lua_State* L)
{
	// vocation:getDescription()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		pushString(L, vocation->getVocDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetRequiredSkillTries(lua_State* L)
{
	// vocation:getRequiredSkillTries(skillType, skillLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		skills_t skillType = getNumber<skills_t>(L, 2);
		uint16_t skillLevel = getNumber<uint16_t>(L, 3);
		lua_pushnumber(L, vocation->getReqSkillTries(skillType, skillLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetRequiredManaSpent(lua_State* L)
{
	// vocation:getRequiredManaSpent(magicLevel)
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		uint32_t magicLevel = getNumber<uint32_t>(L, 2);
		lua_pushnumber(L, vocation->getReqMana(magicLevel));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetCapacityGain(lua_State* L)
{
	// vocation:getCapacityGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getCapGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGain(lua_State* L)
{
	// vocation:getHealthGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHPGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGainTicks(lua_State* L)
{
	// vocation:getHealthGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetHealthGainAmount(lua_State* L)
{
	// vocation:getHealthGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getHealthGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGain(lua_State* L)
{
	// vocation:getManaGain()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGain());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGainTicks(lua_State* L)
{
	// vocation:getManaGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetManaGainAmount(lua_State* L)
{
	// vocation:getManaGainAmount()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getManaGainAmount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetMaxSoul(lua_State* L)
{
	// vocation:getMaxSoul()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulMax());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetSoulGainTicks(lua_State* L)
{
	// vocation:getSoulGainTicks()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getSoulGainTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetAttackSpeed(lua_State* L)
{
	// vocation:getAttackSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getAttackSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetBaseSpeed(lua_State* L)
{
	// vocation:getBaseSpeed()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (vocation) {
		lua_pushnumber(L, vocation->getBaseSpeed());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetDemotion(lua_State* L)
{
	// vocation:getDemotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t fromId = vocation->getFromVocation();
	if (fromId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* demotedVocation = g_vocations.getVocation(fromId);
	if (demotedVocation && demotedVocation != vocation) {
		pushUserdata<Vocation>(L, demotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaVocationGetPromotion(lua_State* L)
{
	// vocation:getPromotion()
	Vocation* vocation = getUserdata<Vocation>(L, 1);
	if (!vocation) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t promotedId = g_vocations.getPromotedVocation(vocation->getId());
	if (promotedId == VOCATION_NONE) {
		lua_pushnil(L);
		return 1;
	}

	Vocation* promotedVocation = g_vocations.getVocation(promotedId);
	if (promotedVocation && promotedVocation != vocation) {
		pushUserdata<Vocation>(L, promotedVocation);
		setMetatable(L, -1, "Vocation");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Town
int LuaScriptInterface::luaTownCreate(lua_State* L)
{
	// Town(id or name)
	Town* town;
	if (isNumber(L, 2)) {
		town = g_game.map.towns.getTown(getNumber<uint32_t>(L, 2));
	} else if (isString(L, 2)) {
		town = g_game.map.towns.getTown(getString(L, 2));
	} else {
		town = nullptr;
	}

	if (town) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTownGetId(lua_State* L)
{
	// town:getId()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		lua_pushnumber(L, town->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerAddWing(lua_State* L)
{
	// player:addWing(wingId or wingName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Wing* wing = nullptr;
	if (isNumber(L, 2)) {
		wing = g_game.wings.getWingByClientID(getNumber<uint8_t>(L, 2));
	} else {
		wing = g_game.wings.getWingByName(getString(L, 2));
	}

	if (!wing) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->addWing(wing->id));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveWing(lua_State* L)
{
	// player:removeWing(wingId or wingName)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t wingId;
	if (isNumber(L, 2)) {
		wingId = getNumber<uint8_t>(L, 2);
	} else {
		Wing* wing = g_game.wings.getWingByName(getString(L, 2));
		if (!wing) {
			lua_pushnil(L);
			return 1;
		}
		wingId = wing->id;
	}

	pushBoolean(L, player->removeWing(wingId));
	return 1;
}

int LuaScriptInterface::luaPlayerAddAura(lua_State* L)
{
	// player:addAura(id or name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Aura* aura = nullptr;
	if (isNumber(L, 2)) {
		aura = g_game.auras.getAuraByClientID(getNumber<uint8_t>(L, 2));
	} else {
		aura = g_game.auras.getAuraByName(getString(L, 2));
	}

	if (!aura) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->addAura(aura->id));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveAura(lua_State* L)
{
	// player:removeAura(id or name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t auraId;
	if (isNumber(L, 2)) {
		auraId = getNumber<uint8_t>(L, 2);
	} else {
		Aura* aura = g_game.auras.getAuraByName(getString(L, 2));
		if (!aura) {
			lua_pushnil(L);
			return 1;
		}
		auraId = aura->id;
	}

	pushBoolean(L, player->removeAura(auraId));
	return 1;
}

int LuaScriptInterface::luaPlayerAddShader(lua_State* L)
{
	// player:addShader(name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	Shader* shader = nullptr;
	if (isNumber(L, 2)) {
		shader = g_game.shaders.getShaderByID(getNumber<uint8_t>(L, 2));
	} else {
		shader = g_game.shaders.getShaderByName(getString(L, 2));
	}

	if (!shader) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, player->addShader(shader->id));
	return 1;
}

int LuaScriptInterface::luaPlayerRemoveShader(lua_State* L)
{
	// player:removeShader(id or name)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t shaderId;
	if (isNumber(L, 2)) {
		shaderId = getNumber<uint8_t>(L, 2);
	} else {
		Shader* shader = g_game.shaders.getShaderByName(getString(L, 2));
		if (!shader) {
			lua_pushnil(L);
			return 1;
		}
		shaderId = shader->id;
	}

	pushBoolean(L, player->removeShader(shaderId));
	return 1;
}


int LuaScriptInterface::luaPlayerGetUsingPokeball(lua_State* L)
{
	// player:getUsingPokeball()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = player->getUsingPokeball();
	if(item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	return 1;
}

int LuaScriptInterface::luaPlayerSetUsingPokeball(lua_State* L)
{
	// player:setUsingPokeball(pokeball)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		item = nullptr;
	}

	player->setUsingPokeball(item);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerSetLastTimePokeballUse(lua_State* L)
{
	// player:setLastTimePokeballUse(time)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	
	int64_t time = getNumber<int64_t>(L, 2);
	player->lastPokeballInteraction = time;
	pushBoolean(L, true);
	return 1;
}
int LuaScriptInterface::luaPlayerGetLastTimePokeballUse(lua_State* L)
{
	// player:getLastTimePokeballUse(time)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, player->lastPokeballInteraction);
	return 1;
}

int LuaScriptInterface::luaPlayerInsertBall(lua_State* L)
{
	// player:insertBall(pokeball)
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		pushBoolean(L, false);
		return 1;
	}

	player->insertPokeball(item);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaPlayerGetPokeballsCached(lua_State* L)
{
	// player:getPokeballsCached()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	std::vector<Item*> pokeballs = player->getPokeballsCached();
	lua_createtable(L, pokeballs.size(), 0);

	int index = 0;
	for (Item* pokeball : pokeballs) {
		pushUserdata<Item>(L, pokeball);
		setItemMetatable(L, -1, pokeball);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaPlayerClearPokeballs(lua_State* L)
{
	// player:clearPokeballs()
	Player* player = getUserdata<Player>(L, 1);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}
	player->clearPokeballs();
	return 1;
}

int LuaScriptInterface::luaTownGetName(lua_State* L)
{
	// town:getName()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		pushString(L, town->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTownGetTemplePosition(lua_State* L)
{
	// town:getTemplePosition()
	Town* town = getUserdata<Town>(L, 1);
	if (town) {
		pushPosition(L, town->getTemplePosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// House
int LuaScriptInterface::luaHouseCreate(lua_State* L)
{
	// House(id)
	House* house = g_game.map.houses.getHouse(getNumber<uint32_t>(L, 2));
	if (house) {
		pushUserdata<House>(L, house);
		setMetatable(L, -1, "House");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetId(lua_State* L)
{
	// house:getId()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetName(lua_State* L)
{
	// house:getName()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		pushString(L, house->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetTown(lua_State* L)
{
	// house:getTown()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Town* town = g_game.map.towns.getTown(house->getTownId());
	if (town) {
		pushUserdata<Town>(L, town);
		setMetatable(L, -1, "Town");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetExitPosition(lua_State* L)
{
	// house:getExitPosition()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		pushPosition(L, house->getEntryPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetRent(lua_State* L)
{
	// house:getRent()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getRent());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetOwnerGuid(lua_State* L)
{
	// house:getOwnerGuid()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetOwnerGuid(lua_State* L)
{
	// house:setOwnerGuid(guid[, updateDatabase = true])
	House* house = getUserdata<House>(L, 1);
	if (house) {
		uint32_t guid = getNumber<uint32_t>(L, 2);
		bool updateDatabase = getBoolean(L, 3, true);
		house->setOwner(guid, updateDatabase);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseStartTrade(lua_State* L)
{
	// house:startTrade(player, tradePartner)
	House* house = getUserdata<House>(L, 1);
	Player* player = getUserdata<Player>(L, 2);
	Player* tradePartner = getUserdata<Player>(L, 3);

	if (!player || !tradePartner || !house) {
		lua_pushnil(L);
		return 1;
	}

	if (!Position::areInRange<2, 2, 0>(tradePartner->getPosition(), player->getPosition())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERFARAWAY);
		return 1;
	}

	if (house->getOwner() != player->getGUID()) {
		lua_pushnumber(L, RETURNVALUE_YOUDONTOWNTHISHOUSE);
		return 1;
	}

	if (g_game.map.houses.getHouseByPlayerId(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERALREADYOWNSAHOUSE);
		return 1;
	}

	if (IOLoginData::hasBiddedOnHouse(tradePartner->getGUID())) {
		lua_pushnumber(L, RETURNVALUE_TRADEPLAYERHIGHESTBIDDER);
		return 1;
	}

	Item* transferItem = house->getTransferItem();
	if (!transferItem) {
		lua_pushnumber(L, RETURNVALUE_YOUCANNOTTRADETHISHOUSE);
		return 1;
	}

	transferItem->getParent()->setParent(player);
	if (!g_game.internalStartTrade(player, tradePartner, transferItem)) {
		house->resetTransferItem();
	}

	lua_pushnumber(L, RETURNVALUE_NOERROR);
	return 1;
}


int LuaScriptInterface::luaHouseGetBeds(lua_State* L)
{
	// house:getBeds()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& beds = house->getBeds();
	lua_createtable(L, beds.size(), 0);

	int index = 0;
	for (BedItem* bedItem : beds) {
		pushUserdata<Item>(L, bedItem);
		setItemMetatable(L, -1, bedItem);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetBedCount(lua_State* L)
{
	// house:getBedCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getBedCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoors(lua_State* L)
{
	// house:getDoors()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& doors = house->getDoors();
	lua_createtable(L, doors.size(), 0);

	int index = 0;
	for (Door* door : doors) {
		pushUserdata<Item>(L, door);
		setItemMetatable(L, -1, door);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoorCount(lua_State* L)
{
	// house:getDoorCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getDoors().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetDoorIdByPosition(lua_State* L)
{
	// house:getDoorIdByPosition(position)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	Door* door = house->getDoorByPosition(getPosition(L, 2));
	if (door) {
		lua_pushnumber(L, door->getDoorId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaHouseGetTiles(lua_State* L)
{
	// house:getTiles()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& tiles = house->getTiles();
	lua_createtable(L, tiles.size(), 0);

	int index = 0;
	for (Tile* tile : tiles) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetItems(lua_State* L)
{
	// house:getItems()
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	const auto& tiles = house->getTiles();
	lua_newtable(L);

	int index = 0;
	for (Tile* tile : tiles) {
		TileItemVector* itemVector = tile->getItemList();
		if(itemVector) {
			for(Item* item : *itemVector) {
				pushUserdata<Item>(L, item);
				setItemMetatable(L, -1, item);
				lua_rawseti(L, -2, ++index);
			}
		}
	}
	return 1;
}

int LuaScriptInterface::luaHouseGetTileCount(lua_State* L)
{
	// house:getTileCount()
	House* house = getUserdata<House>(L, 1);
	if (house) {
		lua_pushnumber(L, house->getTiles().size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaHouseCanEditAccessList(lua_State* L)
{
	// house:canEditAccessList(listId, player)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 2);
	Player* player = getPlayer(L, 3);

	pushBoolean(L, house->canEditAccessList(listId, player));
	return 1;
}


int LuaScriptInterface::luaHouseGetAccessList(lua_State* L)
{
	// house:getAccessList(listId)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	std::string list;
	uint32_t listId = getNumber<uint32_t>(L, 2);
	if (house->getAccessList(listId, list)) {
		pushString(L, list);
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int LuaScriptInterface::luaHouseSetAccessList(lua_State* L)
{
	// house:setAccessList(listId, list)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t listId = getNumber<uint32_t>(L, 2);
	const std::string& list = getString(L, 3);
	house->setAccessList(listId, list);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaHouseKickPlayer(lua_State* L)
{
	// house:kickPlayer(player, targetPlayer)
	House* house = getUserdata<House>(L, 1);
	if (!house) {
		lua_pushnil(L);
		return 1;
	}

	pushBoolean(L, house->kickPlayer(getPlayer(L, 2), getPlayer(L, 3)));
	return 1;
}


// ItemType
int LuaScriptInterface::luaItemTypeCreate(lua_State* L)
{
	// ItemType(id or name)
	uint32_t id;
	if (isNumber(L, 2)) {
		id = getNumber<uint32_t>(L, 2);
	} else if (isString(L, 2)) {
		id = Item::items.getItemIdByName(getString(L, 2));
	} else {
		lua_pushnil(L);
		return 1;
	}

	const ItemType& itemType = Item::items[id];
	pushUserdata<const ItemType>(L, &itemType);
	setMetatable(L, -1, "ItemType");
	return 1;
}

int LuaScriptInterface::luaItemTypeIsCorpse(lua_State* L)
{
	// itemType:isCorpse()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->corpseType != RACE_NONE);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsHolder(lua_State* L)
{
	// itemType:isHolder()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isHolder);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsDoor(lua_State* L)
{
	// itemType:isDoor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isDoor());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsContainer(lua_State* L)
{
	// itemType:isContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsFluidContainer(lua_State* L)
{
	// itemType:isFluidContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isFluidContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsMovable(lua_State* L)
{
	// itemType:isMovable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->moveable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsRune(lua_State* L)
{
	// itemType:isRune()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isRune());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsStackable(lua_State* L)
{
	// itemType:isStackable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->stackable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsReadable(lua_State* L)
{
	// itemType:isReadable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canReadText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsWritable(lua_State* L)
{
	// itemType:isWritable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canWriteText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsBlocking(lua_State* L)
{
	// itemType:isBlocking()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->blockProjectile || itemType->blockSolid);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsGroundTile(lua_State* L)
{
	// itemType:isGroundTile()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isGroundTile());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsMagicField(lua_State* L)
{
	// itemType:isMagicField()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isMagicField());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsUseable(lua_State* L)
{
	// itemType:isUseable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isUseable());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeIsPickupable(lua_State* L)
{
	// itemType:isPickupable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isPickupable());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetType(lua_State* L)
{
	// itemType:getType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->type);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetId(lua_State* L)
{
	// itemType:getId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetClientId(lua_State* L)
{
	// itemType:getClientId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->clientId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetName(lua_State* L)
{
	// itemType:getName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetPluralName(lua_State* L)
{
	// itemType:getPluralName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetArticle(lua_State* L)
{
	// itemType:getArticle()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->article);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDescription(lua_State* L)
{
	// itemType:getDescription()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->description);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetSlotPosition(lua_State *L)
{
	// itemType:getSlotPosition()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->slotPosition);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCharges(lua_State* L)
{
	// itemType:getCharges()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->charges);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetFluidSource(lua_State* L)
{
	// itemType:getFluidSource()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->fluidSource);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCapacity(lua_State* L)
{
	// itemType:getCapacity()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->maxItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWeight(lua_State* L)
{
	// itemType:getWeight([count = 1])
	uint16_t count = getNumber<uint16_t>(L, 2, 1);

	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	uint64_t weight = static_cast<uint64_t>(itemType->weight) * std::max<int32_t>(1, count);
	lua_pushnumber(L, weight);
	return 1;
}

int LuaScriptInterface::luaItemTypeGetHitChance(lua_State* L)
{
	// itemType:getHitChance()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->hitChance);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetShootRange(lua_State* L)
{
	// itemType:getShootRange()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->shootRange);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAttack(lua_State* L)
{
	// itemType:getAttack()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->attack);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDefense(lua_State* L)
{
	// itemType:getDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->defense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetExtraDefense(lua_State* L)
{
	// itemType:getExtraDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->extraDefense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetArmor(lua_State* L)
{
	// itemType:getArmor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->armor);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetWeaponType(lua_State* L)
{
	// itemType:getWeaponType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->weaponType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetAmmoType(lua_State* L)
{
	// itemType:getAmmoType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->ammoType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetCorpseType(lua_State* L)
{
	// itemType:getCorpseType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->corpseType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetElementType(lua_State* L)
{
	// itemType:getElementType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetElementDamage(lua_State* L)
{
	// itemType:getElementDamage()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetTransformEquipId(lua_State* L)
{
	// itemType:getTransformEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetTransformDeEquipId(lua_State* L)
{
	// itemType:getTransformDeEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformDeEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDestroyId(lua_State* L)
{
	// itemType:getDestroyId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->destroyTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDecayId(lua_State* L)
{
	// itemType:getDecayId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->decayTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetDecayTime(lua_State* L)
{
	// itemType:getDecayTime()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		uint32_t decayTime = itemType->decayTime;
		if (decayTime == 0 && itemType->showDuration) {
			const ItemType& equipItemType = Item::items[itemType->transformEquipTo];
		decayTime = equipItemType.decayTime;
		}

		lua_pushnumber(L, decayTime);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeGetRequiredLevel(lua_State* L)
{
	// itemType:getRequiredLevel()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->minReqLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaItemTypeHasSubType(lua_State* L)
{
	// itemType:hasSubType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->hasSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Combat
int LuaScriptInterface::luaCombatCreate(lua_State* L)
{
	// Combat()
	pushSharedPtr(L, g_luaEnvironment.createCombatObject(getScriptEnv()->getScriptInterface()));
	setMetatable(L, -1, "Combat");
	return 1;
}

int LuaScriptInterface::luaCombatDelete(lua_State* L)
{
	Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (combat) {
		combat.reset();
	}
	return 0;
}


int LuaScriptInterface::luaCombatGetConditionsSize(lua_State* L)
{
	// combat:getSize()
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	lua_pushnumber(L, combat->getConditionsSize());
	return 1;
}

int LuaScriptInterface::luaCombatClearConditions(lua_State* L)
{
	// combat:clearConditions()
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	combat->clearConditions();
	return 1;
}

int LuaScriptInterface::luaCombatSetParameter(lua_State* L)
{
	// combat:setParameter(key, value)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	CombatParam_t key = getNumber<CombatParam_t>(L, 2);
	uint32_t value;
	if (isBoolean(L, 3)) {
		value = getBoolean(L, 3) ? 1 : 0;
	} else {
		value = getNumber<uint32_t>(L, 3);
	}
	combat->setParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatSetStringParameter(lua_State* L)
{
	// combat:setStringParameter(key, value)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	CombatParam_t key = getNumber<CombatParam_t>(L, 2);
	std::string value = getString(L, 3);

	combat->setStringParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatSetFormula(lua_State* L)
{
	// combat:setFormula(type, mina, minb, maxa, maxb)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	formulaType_t type = getNumber<formulaType_t>(L, 2);
	double mina = getNumber<double>(L, 3);
	double minb = getNumber<double>(L, 4);
	double maxa = getNumber<double>(L, 5);
	double maxb = getNumber<double>(L, 6);
	combat->setPlayerCombatValues(type, mina, minb, maxa, maxb);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatSetArea(lua_State* L)
{
	// combat:setArea(area)
	if (getScriptEnv()->getScriptId() != EVENT_ID_LOADING) {
		reportErrorFunc("This function can only be used while loading the script.");
		lua_pushnil(L);
		return 1;
	}

	const AreaCombat* area = g_luaEnvironment.getAreaObject(getNumber<uint32_t>(L, 2));
	if (!area) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_AREA_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}
	
	combat->setArea(new AreaCombat(*area));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatAddCondition(lua_State* L)
{
	// combat:addCondition(condition)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	Condition* condition = getUserdata<Condition>(L, 2);
	if (condition) {
		combat->addCondition(condition->clone());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCombatSetCallback(lua_State* L)
{
	// combat:setCallback(key, function)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	CallBackParam_t key = getNumber<CallBackParam_t>(L, 2);
	if (!combat->setCallback(key)) {
		lua_pushnil(L);
		return 1;
	}

	CallBack* callback = combat->getCallback(key);
	if (!callback) {
		lua_pushnil(L);
		return 1;
	}

	const std::string& function = getString(L, 3);
	pushBoolean(L, callback->loadCallBack(getScriptEnv()->getScriptInterface(), function));
	return 1;
}

int LuaScriptInterface::luaCombatSetOrigin(lua_State* L)
{
	// combat:setOrigin(origin)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}
	
	combat->setOrigin(getNumber<CombatOrigin>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaCombatExecute(lua_State* L)
{
	// combat:execute(creature, variant)
	const Combat_ptr& combat = getSharedPtr<Combat>(L, 1);
	if (!combat) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_COMBAT_NOT_FOUND));
		lua_pushnil(L);
		return 1;
	}

	if (isUserdata(L, 2)) {
		LuaDataType type = getUserdataType(L, 2);
		if (type != LuaData_Player && type != LuaData_Monster && type != LuaData_Npc) {
			pushBoolean(L, false);
			return 1;
		}
	}

	Creature* creature = getCreature(L, 2);

	const LuaVariant& variant = getVariant(L, 3);
	switch (variant.type) {
		case VARIANT_NUMBER: {
			Creature* target = g_game.getCreatureByID(variant.number);
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			if (combat->hasArea()) {
				combat->doCombat(creature, target->getPosition());
			} else {
				combat->doCombat(creature, target);
			}
			break;
		}

		case VARIANT_POSITION: {
			combat->doCombat(creature, variant.pos);
			break;
		}

		case VARIANT_TARGETPOSITION: {
			if (combat->hasArea()) {
				combat->doCombat(creature, variant.pos);
			} else {
				combat->postCombatEffects(creature, variant.pos);
				g_game.addMagicEffect(variant.pos, CONST_ME_POFF);
			}
			break;
		}

		case VARIANT_STRING: {
			Player* target = g_game.getPlayerByName(variant.text);
			if (!target) {
				pushBoolean(L, false);
				return 1;
			}

			combat->doCombat(creature, target);
			break;
		}

		case VARIANT_NONE: {
			reportErrorFunc(getErrorDesc(LUA_ERROR_VARIANT_NOT_FOUND));
			pushBoolean(L, false);
			return 1;
		}

		default: {
			break;
		}
	}

	pushBoolean(L, true);
	return 1;
}

// Condition
int LuaScriptInterface::luaConditionCreate(lua_State* L)
{
	// Condition(conditionType[, conditionId = CONDITIONID_COMBAT])
	ConditionType_t conditionType = getNumber<ConditionType_t>(L, 2);
	ConditionId_t conditionId = getNumber<ConditionId_t>(L, 3, CONDITIONID_COMBAT);

	Condition* condition = Condition::createCondition(conditionId, conditionType, 0, 0);
	if (condition) {
		pushUserdata<Condition>(L, condition);
		setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionDelete(lua_State* L)
{
	// condition:delete()
	Condition** conditionPtr = getRawUserdata<Condition>(L, 1);
	if (conditionPtr && *conditionPtr) {
		delete *conditionPtr;
		*conditionPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaConditionGetId(lua_State* L)
{
	// condition:getId()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetSubId(lua_State* L)
{
	// condition:getSubId()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getSubId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionSaveCondition(lua_State* L)
{
	// condition:saveCondition()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushboolean(L, condition->needSaveCondition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetType(lua_State* L)
{
	// condition:getType()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetIcons(lua_State* L)
{
	// condition:getIcons()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getIcons());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetEndTime(lua_State* L)
{
	// condition:getEndTime()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getEndTime());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionClone(lua_State* L)
{
	// condition:clone()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		pushUserdata<Condition>(L, condition->clone());
		setMetatable(L, -1, "Condition");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetTicks(lua_State* L)
{
	// condition:getTicks()
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		lua_pushnumber(L, condition->getTicks());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionSetTicks(lua_State* L)
{
	// condition:setTicks(ticks)
	int32_t ticks = getNumber<int32_t>(L, 2);
	Condition* condition = getUserdata<Condition>(L, 1);
	if (condition) {
		condition->setTicks(ticks);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionSetParameter(lua_State* L)
{
	// condition:setParameter(key, value)
	Condition* condition = getUserdata<Condition>(L, 1);
	if (!condition) {
		lua_pushnil(L);
		return 1;
	}

	ConditionParam_t key = getNumber<ConditionParam_t>(L, 2);
	int32_t value;
	if (isBoolean(L, 3)) {
		value = getBoolean(L, 3) ? 1 : 0;
	} else {
		value = getNumber<int32_t>(L, 3);
	}
	condition->setParam(key, value);
	pushBoolean(L, true);
	return 1;
}

int LuaScriptInterface::luaConditionSetFormula(lua_State* L)
{
	// condition:setFormula(mina, minb, maxa, maxb)
	double maxb = getNumber<double>(L, 5);
	double maxa = getNumber<double>(L, 4);
	double minb = getNumber<double>(L, 3);
	double mina = getNumber<double>(L, 2);
	ConditionSpeed* condition = dynamic_cast<ConditionSpeed*>(getUserdata<Condition>(L, 1));
	if (condition) {
		condition->setFormulaVars(mina, minb, maxa, maxb);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionSetOutfit(lua_State* L)
{
	// condition:setOutfit(outfit)
	// condition:setOutfit(lookTypeEx, lookType, lookHead, lookBody, lookLegs, lookFeet[, lookAddons[, lookMount, lookWings, lookAura, lookShader]])
	Outfit_t outfit;
	if (isTable(L, 2)) {
		outfit = getOutfit(L, 2);
	} else {
		outfit.lookShader = getNumber<uint16_t>(L, 12, outfit.lookShader);
		outfit.lookAura = getNumber<uint16_t>(L, 11, outfit.lookAura);
		outfit.lookWings = getNumber<uint16_t>(L, 10, outfit.lookWings);
		outfit.lookMount = getNumber<uint16_t>(L, 9, outfit.lookMount);
		outfit.lookAddons = getNumber<uint8_t>(L, 8, outfit.lookAddons);
		outfit.lookFeet = getNumber<uint8_t>(L, 7);
		outfit.lookLegs = getNumber<uint8_t>(L, 6);
		outfit.lookBody = getNumber<uint8_t>(L, 5);
		outfit.lookHead = getNumber<uint8_t>(L, 4);
		outfit.lookType = getNumber<uint16_t>(L, 3);
		outfit.lookTypeEx = getNumber<uint16_t>(L, 2);
	}

	ConditionOutfit* condition = dynamic_cast<ConditionOutfit*>(getUserdata<Condition>(L, 1));
	if (condition) {
		condition->setOutfit(outfit);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionAddDamage(lua_State* L)
{
	// condition:addDamage(rounds, time, value)
	int32_t value = getNumber<int32_t>(L, 4);
	int32_t time = getNumber<int32_t>(L, 3);
	int32_t rounds = getNumber<int32_t>(L, 2);
	ConditionDamage* condition = dynamic_cast<ConditionDamage*>(getUserdata<Condition>(L, 1));
	if (condition) {
		pushBoolean(L, condition->addDamage(rounds, time, value));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionSetBonus(lua_State* L)
{
	// condition:setBonus(bonus)
	ConditionBonus* condition = getUserdata<ConditionBonus>(L, 1);
	uint16_t bonus = getNumber<uint16_t>(L, 2);
	if (condition) {
		ConditionType_t type = condition->getType();
		if (type != CONDITION_DEFENSEBONUS && type != CONDITION_ATTACKBONUS) {
			std::cout << "Condition is not a bonus condition." << std::endl;
			lua_pushnil(L);
			return 1;
		}
		condition->setBonus(bonus);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaConditionGetBonus(lua_State* L)
{
	// condition:getBonus()
	ConditionBonus* condition = getUserdata<ConditionBonus>(L, 1);
	if (condition) {
		ConditionType_t type = condition->getType();
		if (type != CONDITION_DEFENSEBONUS && type != CONDITION_ATTACKBONUS) {
			std::cout << "Condition is not a bonus condition." << std::endl;
			lua_pushnil(L);
			return 1;
		}
		lua_pushnumber(L, condition->getBonus());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// MonsterType
int LuaScriptInterface::luaMonsterTypeCreate(lua_State* L)
{
	// MonsterType(name)
	MonsterType* monsterType = g_monsters.getMonsterType(getString(L, 2));
	if (monsterType) {
		pushUserdata<MonsterType>(L, monsterType);
		setMetatable(L, -1, "MonsterType");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsAttackable(lua_State* L)
{
	// get: monsterType:isAttackable() set: monsterType:isAttackable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isAttackable);
		} else {
			monsterType->info.isAttackable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsConvinceable(lua_State* L)
{
	// get: monsterType:isConvinceable() set: monsterType:isConvinceable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isConvinceable);
		} else {
			monsterType->info.isConvinceable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsSummonable(lua_State* L)
{
	// get: monsterType:isSummonable() set: monsterType:isSummonable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isSummonable);
		} else {
			monsterType->info.isSummonable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsIllusionable(lua_State* L)
{
	// get: monsterType:isIllusionable() set: monsterType:isIllusionable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isIllusionable);
		} else {
			monsterType->info.isIllusionable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsHostile(lua_State* L)
{
	// get: monsterType:isHostile() set: monsterType:isHostile(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isHostile);
		} else {
			monsterType->info.isHostile = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsPassive(lua_State* L)
{
	// monsterType:isPassive()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.isPassive);
		} else {
			monsterType->info.isPassive = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsFlyable(lua_State* L)
{
	// monsterType:isFlyable()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.isFlyable);
		} else {
			monsterType->info.isFlyable = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsRideable(lua_State* L)
{
	// monsterType:isRideable()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.isRideable);
		} else {
			monsterType->info.isRideable = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsSurfable(lua_State* L)
{
	// monsterType:isSurfable()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.isSurfable);
		} else {
			monsterType->info.isSurfable = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanBlink(lua_State* L)
{
	// monsterType:canBlink()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canBlink);
		} else {
			monsterType->info.canBlink = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	}
	else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanTeleport(lua_State* L)
{
	// monsterType:canTeleport()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canTeleport);
		} else {
			monsterType->info.canTeleport = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanDig(lua_State* L)
{
	// monsterType:canDig()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canDig);
		} else {
			monsterType->info.canDig = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanSmash(lua_State* L)
{
	// monsterType:canSmash()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canSmash);
		} else {
			monsterType->info.canSmash = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanCut(lua_State* L)
{
	// monsterType:canCut()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canCut);
		} else {
			monsterType->info.canCut = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanLight(lua_State* L)
{
	// monsterType:canLight()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canLight);
		} else {
			monsterType->info.canLight = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanLevitate(lua_State* L)
{
	// monsterType:canLevitate() || monsterType:canLevitate(number)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canLevitate);
		} else {
			monsterType->info.canLevitate = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanControlMind(lua_State* L)
{
	// monsterType:canControlMind() || monsterType:canControlMind(number)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.canControlMind);
		} else {
			monsterType->info.canControlMind = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeFuncao(lua_State* L)
{
	// monsterType:funcao() || monsterType:funcao(funcao)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushstring(L, monsterType->info.funcao.c_str());
		} else {
			monsterType->info.funcao = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}



int LuaScriptInterface::luaMonsterTypeCatchChance(lua_State* L)
{
	// monsterType:catchChance() || monsterType:catchChance(number)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.catchChance);
		} else {
			monsterType->info.catchChance = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetMoveMagicAttackBase(lua_State* L)
{
	// get monsterType:moveMagicAttackBase() || set monsterType:moveMagicAttackBase(valor) 
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.moveMagicAttackBase);
		} else {
			monsterType->info.moveMagicAttackBase = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetMoveMagicDefenseBase(lua_State* L)
{
	// monsterType:moveMagicDefenseBase() || setmonsterType:moveMagicDefenseBase(number)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.moveMagicDefenseBase);
		} else {
			monsterType->info.moveMagicDefenseBase = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetPhysicalDamage(lua_State* L)
{
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.movePhysicalDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetSpecialDamage(lua_State* L)
{
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.moveSpecialDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetSpecialDefense(lua_State* L)
{
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.specialDefense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetPhysicalDefense(lua_State* L)
{
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.physicalDefense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetMinimumLevel(lua_State* L)
{
	// monsterType:minimumLevel() | set monsterType:minimumLevel(level)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.minimumLevel);
		} else {
			monsterType->info.minimumLevel = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeWildHealth(lua_State* L)
{
	// monsterType:wildHealth() | set monsterType:wildHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.wildHealth);
		} else {
			monsterType->info.wildHealth = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeWildMaxHealth(lua_State* L)
{
	// monsterType:wildMaxHealth() | set monsterType:wildMaxHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.wildMaxHealth);
		} else {
			monsterType->info.wildMaxHealth = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeWildBaseSpeed(lua_State* L)
{
	// monsterType:wildBaseSpeed() | set monsterType:wildBaseSpeed(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.wildBaseSpeed);
		} else {
			monsterType->info.wildBaseSpeed = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetPokemonRank(lua_State* L)
{
	// monsterType:pokemonRank() || set monsterType:pokemonRank(rank)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushstring(L, monsterType->rank.c_str());
		} else {
			monsterType->rank = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeHasShiny(lua_State* L)
{
	// monsterType:hasShiny()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.hasShiny);
		} else {
			monsterType->info.hasShiny = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeHasMega(lua_State* L)
{
	// monsterType:hasMega()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.hasMega);
		} else {
			monsterType->info.hasMega = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeDexEntry(lua_State* L)
{
	// monsterType:dexEntry()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.dexEntry);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypePortraitId(lua_State* L)
{
	// monsterType:portraitId()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.portraitId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsPushable(lua_State* L)
{
	// get: monsterType:isPushable() set: monsterType:isPushable(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.pushable);
		} else {
			monsterType->info.pushable = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeIsHealthHidden(lua_State* L)
{
	// get: monsterType:isHealthHidden() set: monsterType:isHealthHidden(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.hiddenHealth);
		} else {
			monsterType->info.hiddenHealth = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanPushItems(lua_State* L)
{
	// get: monsterType:canPushItems() set: monsterType:canPushItems(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canPushItems);
		} else {
			monsterType->info.canPushItems = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCanPushCreatures(lua_State* L)
{
	// get: monsterType:canPushCreatures() set: monsterType:canPushCreatures(bool)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, monsterType->info.canPushCreatures);
		} else {
			monsterType->info.canPushCreatures = getBoolean(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeName(lua_State* L)
{
	// get: monsterType:name() set: monsterType:name(name)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->name);
		} else {
			monsterType->name = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeNameDescription(lua_State* L)
{
	// get: monsterType:nameDescription() set: monsterType:nameDescription(desc)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushString(L, monsterType->nameDescription);
		} else {
			monsterType->nameDescription = getString(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeHealth(lua_State* L)
{
	// get: monsterType:health() set: monsterType:health(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.health);
		} else {
			monsterType->info.health = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeMaxHealth(lua_State* L)
{
	// get: monsterType:maxHealth() set: monsterType:maxHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.healthMax);
		} else {
			monsterType->info.healthMax = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeRunHealth(lua_State* L)
{
	// get: monsterType:runHealth() set: monsterType:runHealth(health)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.runAwayHealth);
		} else {
			monsterType->info.runAwayHealth = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeExperience(lua_State* L)
{
	// get: monsterType:experience() set: monsterType:experience(exp)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.experience);
		} else {
			monsterType->info.experience = getNumber<uint64_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeSkull(lua_State* L)
{
	// get: monsterType:skull() set: monsterType:skull(str/constant)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.skull);
		} else {
			if (isNumber(L, 2)) {
				monsterType->info.skull = getNumber<Skulls_t>(L, 2);
			} else {
				monsterType->info.skull = getSkullType(getString(L, 2));
			}
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCombatImmunities(lua_State* L)
{
	// get: monsterType:combatImmunities() set: monsterType:combatImmunities(immunity)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.damageImmunities);
		} else {
			std::string immunity = getString(L, 2);
			if (immunity == "physical") {
				monsterType->info.damageImmunities |= COMBAT_PHYSICALDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "energy") {
				monsterType->info.damageImmunities |= COMBAT_ENERGYDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "fire") {
				monsterType->info.damageImmunities |= COMBAT_FIREDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "poison" || immunity == "earth") {
				monsterType->info.damageImmunities |= COMBAT_EARTHDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "drown") {
				monsterType->info.damageImmunities |= COMBAT_DROWNDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "ice") {
				monsterType->info.damageImmunities |= COMBAT_ICEDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "holy") {
				monsterType->info.damageImmunities |= COMBAT_HOLYDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "death") {
				monsterType->info.damageImmunities |= COMBAT_DEATHDAMAGE;
				pushBoolean(L, true);
			} else if (immunity == "lifedrain") {
				monsterType->info.damageImmunities |= COMBAT_LIFEDRAIN;
				pushBoolean(L, true);
			} else if (immunity == "manadrain") {
				monsterType->info.damageImmunities |= COMBAT_MANADRAIN;
				pushBoolean(L, true);
			} else {
				std::cout << "[Warning - Monsters::loadMonster] Unknown immunity name " << immunity << " for monster: " << monsterType->name << std::endl;
				lua_pushnil(L);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeConditionImmunities(lua_State* L)
{
	// get: monsterType:conditionImmunities() set: monsterType:conditionImmunities(immunity)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.conditionImmunities);
		} else {
			std::string immunity = getString(L, 2);
			if (immunity == "physical") {
				monsterType->info.conditionImmunities |= CONDITION_BLEEDING;
				pushBoolean(L, true);
			} else if (immunity == "energy") {
				monsterType->info.conditionImmunities |= CONDITION_ENERGY;
				pushBoolean(L, true);
			} else if (immunity == "fire") {
				monsterType->info.conditionImmunities |= CONDITION_FIRE;
				pushBoolean(L, true);
			} else if (immunity == "poison" || immunity == "earth") {
				monsterType->info.conditionImmunities |= CONDITION_POISON;
				pushBoolean(L, true);
			} else if (immunity == "drown") {
				monsterType->info.conditionImmunities |= CONDITION_DROWN;
				pushBoolean(L, true);
			} else if (immunity == "ice") {
				monsterType->info.conditionImmunities |= CONDITION_FREEZING;
				pushBoolean(L, true);
			} else if (immunity == "holy") {
				monsterType->info.conditionImmunities |= CONDITION_DAZZLED;
				pushBoolean(L, true);
			} else if (immunity == "death") {
				monsterType->info.conditionImmunities |= CONDITION_CURSED;
				pushBoolean(L, true);
			} else if (immunity == "paralyze") {
				monsterType->info.conditionImmunities |= CONDITION_PARALYZE;
				pushBoolean(L, true);
			} else if (immunity == "outfit") {
				monsterType->info.conditionImmunities |= CONDITION_OUTFIT;
				pushBoolean(L, true);
			} else if (immunity == "drunk") {
				monsterType->info.conditionImmunities |= CONDITION_DRUNK;
				pushBoolean(L, true);
			} else if (immunity == "invisible" || immunity == "invisibility") {
				monsterType->info.conditionImmunities |= CONDITION_INVISIBLE;
				pushBoolean(L, true);
			} else if (immunity == "bleed") {
				monsterType->info.conditionImmunities |= CONDITION_BLEEDING;
				pushBoolean(L, true);
			} else {
				std::cout << "[Warning - Monsters::loadMonster] Unknown immunity name " << immunity << " for monster: " << monsterType->name << std::endl;
				lua_pushnil(L);
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddAttack(lua_State* L)
{
	// monsterType:addAttack(monsterspell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		MonsterSpell* spell = getUserdata<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters.deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.attackSpells.emplace_back(std::move(sb));
			} else {
				std::cout << monsterType->name << std::endl;
				std::cout << "[Warning - Monsters::loadMonster] Cant load spell. " << spell->name << std::endl;
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddMove(lua_State* L)
{
	// monsterType:addMove(monsterspell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		MonsterSpell* spell = getUserdata<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters.deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.moves.emplace_back(std::move(sb));
			} else {
				std::cout << monsterType->name << std::endl;
				std::cout << "[Warning - Monsters::loadMonster] Cant load spell. " << spell->name << std::endl;
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetAttackList(lua_State* L)
{
	// monsterType:getAttackList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.attackSpells.size(), 0);

	int index = 0;
	for (const auto& spellBlock : monsterType->info.attackSpells) {
		lua_createtable(L, 0, 7);

		// setField(L, "chance", spellBlock.chance);
		// setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		// setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		setField(L, "isTarget", spellBlock.isTarget ? 1 : 0);
		// setField(L, "minCombatValue", spellBlock.minCombatValue);
		// setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		setField(L, "level", spellBlock.level); // san
		// setField(L, "type", spellBlock.type); // san
		setField(L, "name", spellBlock.name);
		setField(L, "range", spellBlock.range);
		setField(L, "speed", spellBlock.speed);
		setField(L, "passive", spellBlock.isPassive);
		pushUserdata<CombatSpell>(L, static_cast<CombatSpell*>(spellBlock.spell));
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetMoveList(lua_State* L)
{
	// monsterType:getMoveList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.moves.size(), 0);

	int index = 0;
	for (const auto& spellBlock : monsterType->info.moves) {
		if (spellBlock.name == "melee") {
			continue;
		}
		lua_createtable(L, 0, 6);

		setField(L, "isTarget", spellBlock.isTarget ? 1 : 0);
		setField(L, "level", spellBlock.level); 
		setField(L, "name", spellBlock.name);
		setField(L, "range", spellBlock.range);
		setField(L, "speed", spellBlock.speed);
		setField(L, "passive", spellBlock.isPassive);

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddDefense(lua_State* L)
{
	// monsterType:addDefense(monsterspell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		MonsterSpell* spell = getUserdata<MonsterSpell>(L, 2);
		if (spell) {
			spellBlock_t sb;
			if (g_monsters.deserializeSpell(spell, sb, monsterType->name)) {
				monsterType->info.defenseSpells.push_back(std::move(sb));
			} else {
				std::cout << monsterType->name << std::endl;
				std::cout << "[Warning - Monsters::loadMonster] Cant load spell. " << spell->name << std::endl;
			}
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddElement(lua_State* L)
{
	// monsterType:addElement(type, percent)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		CombatType_t element = getNumber<CombatType_t>(L, 2);
		monsterType->info.elementMap[element] = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddLoot(lua_State* L)
{
	// monsterType:addLoot(loot)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		Loot* loot = getUserdata<Loot>(L, 2);
		if (loot) {
			monsterType->loadLoot(monsterType, loot->lootBlock);
			pushBoolean(L, true);
		} else {
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddVoice(lua_State* L)
{
	// monsterType:addVoice(sentence, interval, chance, yell)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		voiceBlock_t voice;
		voice.text = getString(L, 2);
		monsterType->info.yellSpeedTicks = getNumber<uint32_t>(L, 3);
		monsterType->info.yellChance = getNumber<uint32_t>(L, 4);
		voice.yellText = getBoolean(L, 5);
		monsterType->info.voiceVector.push_back(voice);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetDefenseList(lua_State* L)
{
	// monsterType:getDefenseList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.defenseSpells.size(), 0);


	int index = 0;
	for (const auto& spellBlock : monsterType->info.defenseSpells) {
		lua_createtable(L, 0, 8);

		setField(L, "chance", spellBlock.chance);
		setField(L, "isCombatSpell", spellBlock.combatSpell ? 1 : 0);
		setField(L, "isMelee", spellBlock.isMelee ? 1 : 0);
		setField(L, "minCombatValue", spellBlock.minCombatValue);
		setField(L, "maxCombatValue", spellBlock.maxCombatValue);
		setField(L, "range", spellBlock.range);
		setField(L, "speed", spellBlock.speed);
		pushUserdata<CombatSpell>(L, static_cast<CombatSpell*>(spellBlock.spell));
		lua_setfield(L, -2, "spell");

		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetElementList(lua_State* L)
{
	// monsterType:getElementList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	lua_createtable(L, monsterType->info.elementMap.size(), 0);
	for (const auto& elementEntry : monsterType->info.elementMap) {
		lua_pushnumber(L, elementEntry.second);
		lua_rawseti(L, -2, elementEntry.first);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetVoices(lua_State* L)
{
	// monsterType:getVoices()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.voiceVector.size(), 0);
	for (const auto& voiceBlock : monsterType->info.voiceVector) {
		lua_createtable(L, 0, 2);
		setField(L, "text", voiceBlock.text);
		setField(L, "yellText", voiceBlock.yellText);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaGetMonstersName(lua_State* L)
{
	// getMonstersName()
	const auto& monstersTable = g_monsters.getMonstersName();
	lua_createtable(L, monstersTable.size(), 0);

	int index = 0;
	for (std::string monster : monstersTable) {
		pushString(L, monster);
		lua_rawseti(L, -2, ++index);
	}

	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetLoot(lua_State* L)
{
	// monsterType:getLoot()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	pushLoot(L, monsterType->info.lootItems);
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetCreatureEvents(lua_State* L)
{
	// monsterType:getCreatureEvents()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.scripts.size(), 0);
	for (const std::string& creatureEvent : monsterType->info.scripts) {
		pushString(L, creatureEvent);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeRegisterEvent(lua_State* L)
{
	// monsterType:registerEvent(name)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		monsterType->info.scripts.push_back(getString(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeEventOnCallback(lua_State* L)
{
	// monsterType:onThink(callback)
	// monsterType:onAppear(callback)
	// monsterType:onDisappear(callback)
	// monsterType:onMove(callback)
	// monsterType:onSay(callback)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (monsterType->loadCallback(&g_scripts->getScriptInterface())) {
			pushBoolean(L, true);
			return 1;
		}
		pushBoolean(L, false);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeEventType(lua_State* L)
{
	// monstertype:eventType(event)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		monsterType->info.eventType = getNumber<MonstersEvent_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetSummonList(lua_State* L)
{
	// monsterType:getSummonList()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, monsterType->info.summons.size(), 0);
	for (const auto& summonBlock : monsterType->info.summons) {
		lua_createtable(L, 0, 3);
		setField(L, "name", summonBlock.name);
		setField(L, "speed", summonBlock.speed);
		setField(L, "chance", summonBlock.chance);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeAddEvolution(lua_State* L)
{
    // monsterType:addEvolution(name, level, chance, {{stoneId, stoneCount}, {...}})
    MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
    if (!monsterType) {
        lua_pushnil(L);
        return 1;
    }

    evolutionBlock_t evolution;
    evolution.name = getString(L, 2);
    evolution.level = getNumber<uint32_t>(L, 3);
    evolution.chance = getNumber<uint32_t>(L, 4); 

    luaL_checktype(L, 5, LUA_TTABLE);

    lua_pushnil(L); 
    while (lua_next(L, 5) != 0) { 
        if (lua_istable(L, -1)) {
            stonesBlock_t stoneBlock;

            lua_getfield(L, -1, "stoneId");
            stoneBlock.stoneId = getNumber<uint32_t>(L, -1);
            lua_pop(L, 1);

            lua_getfield(L, -1, "stoneCount"); // Pega o campo stoneCount
            stoneBlock.stoneCount = getNumber<uint32_t>(L, -1);
            lua_pop(L, 1);

            evolution.stones.push_back(stoneBlock);
        }
        lua_pop(L, 1); 
    }

    monsterType->addEvolution(evolution);

    lua_pushboolean(L, true);
    return 1;
}

int LuaScriptInterface::luaMonsterTypeGetEvolutionList(lua_State* L)
{
    // monsterType:getEvolutionList()
    MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
    if (!monsterType) {
        lua_pushnil(L);
        return 1;
    }

    int index = 0;
    lua_createtable(L, monsterType->info.evolutions.size(), 0);

    for (const auto& evolutionBlock : monsterType->info.evolutions) {
        lua_createtable(L, 0, 4);

        setField(L, "name", evolutionBlock.name);
        setField(L, "level", evolutionBlock.level);
        setField(L, "chance", evolutionBlock.chance);

        lua_createtable(L, evolutionBlock.stones.size(), 0);
        int stoneIndex = 0;
        for (const auto& stoneBlock : evolutionBlock.stones) {
            lua_createtable(L, 0, 2);

            setField(L, "stoneId", stoneBlock.stoneId);
            setField(L, "stoneCount", stoneBlock.stoneCount);

            lua_rawseti(L, -2, ++stoneIndex);
        }
        
        lua_setfield(L, -2, "stones");

        lua_rawseti(L, -2, ++index);
    }

    return 1;
}

int LuaScriptInterface::luaMonsterTypeAddSummon(lua_State* L)
{
	// monsterType:addSummon(name, interval, chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		summonBlock_t summon;
		summon.name = getString(L, 2);
		summon.chance = getNumber<int32_t>(L, 3);
		summon.speed = getNumber<int32_t>(L, 4);
		monsterType->info.summons.push_back(summon);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeMaxSummons(lua_State* L)
{
	// get: monsterType:maxSummons() set: monsterType:maxSummons(ammount)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.maxSummons);
		} else {
			monsterType->info.maxSummons = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeArmor(lua_State* L)
{
	// get: monsterType:armor() set: monsterType:armor(armor)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.armor);
		} else {
			monsterType->info.armor = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeDefense(lua_State* L)
{
	// get: monsterType:defense() set: monsterType:defense(defense)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.defense);
		} else {
			monsterType->info.defense = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeOutfit(lua_State* L)
{
	// get: monsterType:outfit() set: monsterType:outfit(outfit)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			pushOutfit(L, monsterType->info.outfit);
		} else {
			monsterType->info.outfit = getOutfit(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeRace(lua_State* L)
{
	// get: monsterType:race() set: monsterType:race(race)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	std::string race = getString(L, 2);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.race);
		} else {
			if (race == "grass") {
				monsterType->info.race = RACE_GRASS;
			} else if (race == "normal") {
				monsterType->info.race = RACE_NORMAL;
			} else if (race == "water") {
				monsterType->info.race = RACE_WATER;
			} else if (race == "fire") {
				monsterType->info.race = RACE_FIRE;
			} else if (race == "flying") {
				monsterType->info.race = RACE_FLYING;
			} else if (race == "poison") {
				monsterType->info.race = RACE_POISON;
			} else if (race == "electric") {
				monsterType->info.race = RACE_ELECTRIC;
			} else if (race == "ground") {
				monsterType->info.race = RACE_GROUND;
			} else if (race == "psychic") {
				monsterType->info.race = RACE_PSYCHIC;
			} else if (race == "rock") {
				monsterType->info.race = RACE_ROCK;
			} else if (race == "ice") {
				monsterType->info.race = RACE_ICE;
			} else if (race == "bug") {
				monsterType->info.race = RACE_BUG;
			} else if (race == "dragon") {
				monsterType->info.race = RACE_DRAGON;
			} else if (race == "ghost") {
				monsterType->info.race = RACE_GHOST;
			} else if (race == "dark") {
				monsterType->info.race = RACE_DARK;
			} else if (race == "steel") {
				monsterType->info.race = RACE_STEEL;
			} else if (race == "fairy") {
				monsterType->info.race = RACE_FAIRY;
			} else if (race == "fighting") {
				monsterType->info.race = RACE_FIGHTING;
			} else if (race == "none") {
				monsterType->info.race = RACE_NONE;
			} else {
				std::cout << "[Warning - Monsters::loadMonster] Unknown race type " << race << "." << std::endl;
				lua_pushnil(L);
				return 1;
			}
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeRace2(lua_State* L)
{
	// get: monsterType:race2() set: monsterType:race2(race)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	std::string race = getString(L, 2);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.race2);
		} else {
			if (race == "grass") {
				monsterType->info.race2 = RACE_GRASS;
			} else if (race == "normal") {
				monsterType->info.race2 = RACE_NORMAL;
			} else if (race == "water") {
				monsterType->info.race2 = RACE_WATER;
			} else if (race == "fire") {
				monsterType->info.race2 = RACE_FIRE;
			} else if (race == "flying") {
				monsterType->info.race2 = RACE_FLYING;
			} else if (race == "poison") {
				monsterType->info.race2 = RACE_POISON;
			} else if (race == "electric") {
				monsterType->info.race2 = RACE_ELECTRIC;
			} else if (race == "ground") {
				monsterType->info.race2 = RACE_GROUND;
			} else if (race == "psychic") {
				monsterType->info.race2 = RACE_PSYCHIC;
			} else if (race == "rock") {
				monsterType->info.race2 = RACE_ROCK;
			} else if (race == "ice") {
				monsterType->info.race2 = RACE_ICE;
			} else if (race == "bug") {
				monsterType->info.race2 = RACE_BUG;
			} else if (race == "dragon") {
				monsterType->info.race2 = RACE_DRAGON;
			} else if (race == "ghost") {
				monsterType->info.race2 = RACE_GHOST;
			} else if (race == "dark") {
				monsterType->info.race2 = RACE_DARK;
			} else if (race == "steel") {
				monsterType->info.race2 = RACE_STEEL;
			} else if (race == "fairy") {
				monsterType->info.race2 = RACE_FAIRY;
			} else if (race == "fighting") {
				monsterType->info.race2 = RACE_FIGHTING;
			} else if (race == "none") {
				monsterType->info.race2 = RACE_NONE;
			} else {
				std::cout << "[Warning - Monsters::loadMonster] Unknown race type " << race << "." << std::endl;
				lua_pushnil(L);
				return 1;
			}
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaMonsterTypeGetMinLevel(lua_State* L)
{
	// monsterType:getMinLevel()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.minLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeGetMaxLevel(lua_State* L)
{
	// monsterType:getMaxLevel()
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		lua_pushnumber(L, monsterType->info.maxLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeCorpseId(lua_State* L)
{
	// get: monsterType:corpseId() set: monsterType:corpseId(id)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.lookcorpse);
		} else {
			monsterType->info.lookcorpse = getNumber<uint16_t>(L, 2);
			lua_pushboolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeManaCost(lua_State* L)
{
	// get: monsterType:manaCost() set: monsterType:manaCost(mana)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.manaCost);
		} else {
			monsterType->info.manaCost = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeBaseSpeed(lua_State* L)
{
	// get: monsterType:baseSpeed() set: monsterType:baseSpeed(speed)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.baseSpeed);
		} else {
			monsterType->info.baseSpeed = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeLight(lua_State* L)
{
	// get: monsterType:light() set: monsterType:light(color, level)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (!monsterType) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, monsterType->info.light.level);
		lua_pushnumber(L, monsterType->info.light.color);
		return 2;
	} else {
		monsterType->info.light.color = getNumber<uint8_t>(L, 2);
		monsterType->info.light.level = getNumber<uint8_t>(L, 3);
		pushBoolean(L, true);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeStaticAttackChance(lua_State* L)
{
	// get: monsterType:staticAttackChance() set: monsterType:staticAttackChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.staticAttackChance);
		} else {
			monsterType->info.staticAttackChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeTargetDistance(lua_State* L)
{
	// get: monsterType:targetDistance() set: monsterType:targetDistance(distance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.targetDistance);
		} else {
			monsterType->info.targetDistance = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeYellChance(lua_State* L)
{
	// get: monsterType:yellChance() set: monsterType:yellChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.yellChance);
		} else {
			monsterType->info.yellChance = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeYellSpeedTicks(lua_State* L)
{
	// get: monsterType:yellSpeedTicks() set: monsterType:yellSpeedTicks(rate)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.yellSpeedTicks);
		} else {
			monsterType->info.yellSpeedTicks = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeChangeTargetChance(lua_State* L)
{
	// get: monsterType:changeTargetChance() set: monsterType:changeTargetChance(chance)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetChance);
		} else {
			monsterType->info.changeTargetChance = getNumber<int32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterTypeChangeTargetSpeed(lua_State* L)
{
	// get: monsterType:changeTargetSpeed() set: monsterType:changeTargetSpeed(speed)
	MonsterType* monsterType = getUserdata<MonsterType>(L, 1);
	if (monsterType) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, monsterType->info.changeTargetSpeed);
		} else {
			monsterType->info.changeTargetSpeed = getNumber<uint32_t>(L, 2);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Loot
int LuaScriptInterface::luaCreateLoot(lua_State* L) 
{
	// Loot() will create a new loot item
	Loot* loot = new Loot();
	if (loot) {
		pushUserdata<Loot>(L, loot);
		setMetatable(L, -1, "Loot");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaDeleteLoot(lua_State* L){
	// loot:delete() loot:__gc()
	Loot** lootPtr = getRawUserdata<Loot>(L, 1);
	if (lootPtr && *lootPtr) {
		delete *lootPtr;
		*lootPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaLootSetId(lua_State* L)
{
	// loot:setId(id or name)
	Loot* loot = getUserdata<Loot>(L, 1);
	uint16_t item;
	if (loot) {
		if (isNumber(L, 2)) {
			loot->lootBlock.id = getNumber<uint16_t>(L, 2);
		} else {
			item = Item::items.getItemIdByName(getString(L, 2));
			loot->lootBlock.id = item;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootSetSubType(lua_State* L)
{
	// loot:setSubType(type)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.subType = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootSetChance(lua_State* L)
{
	// loot:setChance(chance)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.chance = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootSetMaxCount(lua_State* L)
{
	// loot:setMaxCount(max)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.countmax = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootSetActionId(lua_State* L)
{
	// loot:setActionId(actionid)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.actionId = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootSetDescription(lua_State* L)
{
	// loot:setDescription(desc)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.text = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaLootAddChildLoot(lua_State* L)
{
	// loot:addChildLoot(loot)
	Loot* loot = getUserdata<Loot>(L, 1);
	if (loot) {
		loot->lootBlock.childLoot.push_back(getUserdata<Loot>(L, 2)->lootBlock);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// MonsterSpell
int LuaScriptInterface::luaCreateMonsterSpell(lua_State* L)
{
	// MonsterSpell() will create a new Monster Spell
	MonsterSpell* spell = new MonsterSpell();
	if (spell) {
		pushUserdata<MonsterSpell>(L, spell);
		setMetatable(L, -1, "MonsterSpell");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaDeleteMonsterSpell(lua_State* L)
{
	// monsterSpell:delete() monsterSpell:__gc()
	MonsterSpell** monsterSpellPtr = getRawUserdata<MonsterSpell>(L, 1);
	if (monsterSpellPtr && *monsterSpellPtr) {
		delete *monsterSpellPtr;
		*monsterSpellPtr = nullptr;
	}
	return 0;
}

int LuaScriptInterface::luaMonsterSpellSetType(lua_State* L)
{
	// monsterSpell:setType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->name = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}



int LuaScriptInterface::luaMonsterSpellSetScriptName(lua_State* L)
{
	// monsterSpell:setScriptName(name)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->scriptName = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetChance(lua_State* L)
{
	// monsterSpell:setChance(chance)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->chance = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetInterval(lua_State* L)
{
	// monsterSpell:setInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->interval = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetRange(lua_State* L)
{
	// monsterSpell:setRange(range)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->range = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatValue(lua_State* L)
{
	// monsterSpell:setCombatValue(min, max)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->minCombatValue = getNumber<int32_t>(L, 2);
		spell->maxCombatValue = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatType(lua_State* L)
{
	// monsterSpell:setCombatType(combatType_t)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->combatType = getNumber<CombatType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetAttackValue(lua_State* L)
{
	// monsterSpell:setAttackValue(attack, skill)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->attack = getNumber<int32_t>(L, 2);
		spell->skill = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetPower(lua_State* L)
{
	// monsterSpell:setPower(power)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->power = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetLevel(lua_State* L)
{
	// monsterSpell:setLevel(level)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->level = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetPassive(lua_State* L)
{
	// monsterSpell:setPassive(bool)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->isPassive = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetNeedTarget(lua_State* L)
{
	// monsterSpell:setNeedTarget(bool)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->needTarget = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatLength(lua_State* L)
{
	// monsterSpell:setCombatLength(length)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->length = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatSpread(lua_State* L)
{
	// monsterSpell:setCombatSpread(spread)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->spread = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatRadius(lua_State* L)
{
	// monsterSpell:setCombatRadius(radius)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->radius = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionType(lua_State* L)
{
	// monsterSpell:setConditionType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionType = getNumber<ConditionType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionDamage(lua_State* L)
{
	// monsterSpell:setConditionDamage(min, max, start)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionMinDamage = getNumber<int32_t>(L, 2);
		spell->conditionMaxDamage = getNumber<int32_t>(L, 3);
		spell->conditionStartDamage = getNumber<int32_t>(L, 4);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionSpeedChange(lua_State* L)
{
	// monsterSpell:setConditionSpeedChange(speed)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->speedChange = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionDuration(lua_State* L)
{
	// monsterSpell:setConditionDuration(duration)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->duration = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetConditionTickInterval(lua_State* L)
{
	// monsterSpell:setConditionTickInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->tickInterval = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatShootEffect(lua_State* L)
{
	// monsterSpell:setCombatShootEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->shoot = getNumber<ShootType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMonsterSpellSetCombatEffect(lua_State* L)
{
	// monsterSpell:setCombatEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->effect = getNumber<MagicEffectClasses>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Spells
int LuaScriptInterface::luaSpellCreate(lua_State* L)
{
	// Spell(words, name or id) to get an existing spell
	// Spell(type) ex: Spell(SPELL_INSTANT) or Spell(SPELL_RUNE) to create a new spell
	if (lua_gettop(L) == 1) {
		std::cout << "[Error - Spell::luaSpellCreate] There is no parameter set!\n";
		lua_pushnil(L);
		return 1;
	}

	SpellType_t spellType = SPELL_UNDEFINED;

	if (isNumber(L, 2)) {
		int32_t id = getNumber<int32_t>(L, 2);
		RuneSpell* rune = g_spells->getRuneSpell(id);

		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		spellType = static_cast<SpellType_t>(id);
	} else if (lua_isstring(L, 2)) {
		std::string arg = getString(L, 2);
		InstantSpell* instant = g_spells->getInstantSpellByName(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		instant = g_spells->getInstantSpell(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		RuneSpell* rune = g_spells->getRuneSpellByName(arg);
		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		std::string tmp = asLowerCaseString(arg);
		if (tmp == "instant") {
			spellType = SPELL_INSTANT;
		} else if (tmp == "rune") {
			spellType = SPELL_RUNE;
		}
	}

	if (spellType == SPELL_INSTANT) {
		InstantSpell* spell = new InstantSpell(getScriptEnv()->getScriptInterface());
		spell->fromLua = true;
		pushUserdata<Spell>(L, spell);
		setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_INSTANT;
		return 1;
	} else if (spellType == SPELL_RUNE) {
		RuneSpell* spell = new RuneSpell(getScriptEnv()->getScriptInterface());
		spell->fromLua = true;
		pushUserdata<Spell>(L, spell);
		setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_RUNE;
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int LuaScriptInterface::luaSpellOnCastSpell(lua_State* L)
{
	// spell:onCastSpell(callback)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			InstantSpell* instant = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
			if (!instant->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			instant->scripted = true;
			pushBoolean(L, true);
		} else if (spell->spellType == SPELL_RUNE) {
			RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
			if (!rune->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			rune->scripted = true;
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellRegister(lua_State* L)
{
	// spell:register()
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			InstantSpell* instant = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
			if (!instant->isScripted()) {
				pushBoolean(L, false);
				return 1;
			}
			pushBoolean(L, g_spells->registerInstantLuaEvent(instant));
		} else if (spell->spellType == SPELL_RUNE) {
			RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
			if (rune->getMagicLevel() != 0 || rune->getLevel() != 0) {
				// Change information in the ItemType to get accurate description
				ItemType& iType = Item::items.getItemType(rune->getRuneItemId());
				iType.name = rune->getName();
				iType.runeMagLevel = rune->getMagicLevel();
				iType.runeLevel = rune->getLevel();
				iType.charges = rune->getCharges();
			}
			if (!rune->isScripted()) {
				pushBoolean(L, false);
				return 1;
			}
			pushBoolean(L, g_spells->registerRuneLuaEvent(rune));
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellName(lua_State* L)
{
	// spell:name(name)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushString(L, spell->getName());
		} else {
			spell->setName(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellId(lua_State* L)
{
	// spell:id(id)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getId());
		} else {
			spell->setId(getNumber<uint8_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellGroup(lua_State* L)
{
	// spell:group(primaryGroup[, secondaryGroup])
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroup());
			lua_pushnumber(L, spell->getSecondaryGroup());
			return 2;
		} else if (lua_gettop(L) == 2) {
			SpellGroup_t group = getNumber<SpellGroup_t>(L, 2);
			if (group) {
				spell->setGroup(group);
				pushBoolean(L, true);
			} else if (lua_isstring(L, 2)) {
				group = stringToSpellGroup(getString(L, 2));
				if (group != SPELLGROUP_NONE) {
					spell->setGroup(group);
				} else {
					std::cout << "[Warning - Spell::group] Unknown group: " << getString(L, 2) << '\n';
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				std::cout << "[Warning - Spell::group] Unknown group: " << getString(L, 2) << '\n';
				pushBoolean(L, false);
				return 1;
			}
		} else {
			SpellGroup_t primaryGroup = getNumber<SpellGroup_t>(L, 2);
			SpellGroup_t secondaryGroup = getNumber<SpellGroup_t>(L, 3);
			if (primaryGroup && secondaryGroup) {
				spell->setGroup(primaryGroup);
				spell->setSecondaryGroup(secondaryGroup);
				pushBoolean(L, true);
			} else if (lua_isstring(L, 2) && lua_isstring(L, 3)) {
				primaryGroup = stringToSpellGroup(getString(L, 2));
				if (primaryGroup != SPELLGROUP_NONE) {
					spell->setGroup(primaryGroup);
				} else {
					std::cout << "[Warning - Spell::group] Unknown primaryGroup: " << getString(L, 2) << '\n';
					pushBoolean(L, false);
					return 1;
				}
				secondaryGroup = stringToSpellGroup(getString(L, 3));
				if (secondaryGroup != SPELLGROUP_NONE) {
					spell->setSecondaryGroup(secondaryGroup);
				} else {
					std::cout << "[Warning - Spell::group] Unknown secondaryGroup: " << getString(L, 3)
					          << '\n';
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				std::cout << "[Warning - Spell::group] Unknown primaryGroup: " << getString(L, 2)
				          << " or secondaryGroup: " << getString(L, 3) << '\n';
				pushBoolean(L, false);
				return 1;
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellCooldown(lua_State* L)
{
	// spell:cooldown(cooldown)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCooldown());
		} else {
			spell->setCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellGroupCooldown(lua_State* L)
{
	// spell:groupCooldown(primaryGroupCd[, secondaryGroupCd])
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroupCooldown());
			lua_pushnumber(L, spell->getSecondaryCooldown());
			return 2;
		} else if (lua_gettop(L) == 2) {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		} else {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			spell->setSecondaryCooldown(getNumber<uint32_t>(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellLevel(lua_State* L)
{
	// spell:level(lvl)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellMagicLevel(lua_State* L)
{
	// spell:magicLevel(lvl)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellMana(lua_State* L)
{
	// spell:mana(mana)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMana());
		} else {
			spell->setMana(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellManaPercent(lua_State* L)
{
	// spell:manaPercent(percent)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getManaPercent());
		} else {
			spell->setManaPercent(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellSoul(lua_State* L)
{
	// spell:soul(soul)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getSoulCost());
		} else {
			spell->setSoulCost(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellRange(lua_State* L)
{
	// spell:range(range)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRange());
		} else {
			spell->setRange(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellPremium(lua_State* L)
{
	// spell:isPremium(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isPremium());
		} else {
			spell->setPremium(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellEnabled(lua_State* L)
{
	// spell:isEnabled(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isEnabled());
		} else {
			spell->setEnabled(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedTarget(lua_State* L)
{
	// spell:needTarget(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedTarget());
		} else {
			spell->setNeedTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedWeapon(lua_State* L)
{
	// spell:needWeapon(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedWeapon());
		} else {
			spell->setNeedWeapon(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellNeedLearn(lua_State* L)
{
	// spell:needLearn(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedLearn());
		} else {
			spell->setNeedLearn(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellSelfTarget(lua_State* L)
{
	// spell:isSelfTarget(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getSelfTarget());
		} else {
			spell->setSelfTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellBlocking(lua_State* L)
{
	// spell:isBlocking(blockingSolid, blockingCreature)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockingSolid());
			pushBoolean(L, spell->getBlockingCreature());
			return 2;
		} else {
			spell->setBlockingSolid(getBoolean(L, 2));
			spell->setBlockingCreature(getBoolean(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellAggressive(lua_State* L)
{
	// spell:isAggressive(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAggressive());
		} else {
			spell->setAggressive(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellPzLock(lua_State* L)
{
	// spell:isPzLock(bool)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getPzLock());
		} else {
			spell->setPzLock(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaSpellVocation(lua_State* L)
{
	// spell:vocation(vocation)
	Spell* spell = getUserdata<Spell>(L, 1);
	if (!spell) {
		lua_pushnil(L);
		return 1;
	}

	if (lua_gettop(L) == 1) {
		lua_createtable(L, 0, 0);
		int i = 0;
		for (auto& voc : spell->getVocationSpellMap()) {
			std::string name = g_vocations.getVocation(voc.first)->getVocName();
			setField(L, std::to_string(++i).c_str(), name);
		}
		setMetatable(L, -1, "Spell");
	} else {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		for (int i = 0; i < parameters; ++i) {
			std::vector<std::string> vocList = explodeString(getString(L, 2 + i), ";");
			spell->addVocationSpellMap(vocList[0], vocList.size() > 1 ? booleanString(vocList[1]) : false);
		}
		pushBoolean(L, true);
	}
	return 1;
}


// only for InstantSpells
int LuaScriptInterface::luaSpellWords(lua_State* L)
{
	// spell:words(words[, separator = ""])
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushString(L, spell->getWords());
			pushString(L, spell->getSeparator());
			return 2;
		} else {
			std::string sep = "";
			if (lua_gettop(L) == 3) {
				sep = getString(L, 3);
			}
			spell->setWords(getString(L, 2));
			spell->setSeparator(sep);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellNeedDirection(lua_State* L)
{
	// spell:needDirection(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedDirection());
		} else {
			spell->setNeedDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellHasParams(lua_State* L)
{
	// spell:hasParams(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasParam());
		} else {
			spell->setHasParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellHasPlayerNameParam(lua_State* L)
{
	// spell:hasPlayerNameParam(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasPlayerNameParam());
		} else {
			spell->setHasPlayerNameParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellNeedCasterTargetOrDirection(lua_State* L)
{
	// spell:needCasterTargetOrDirection(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedCasterTargetOrDirection());
		} else {
			spell->setNeedCasterTargetOrDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int LuaScriptInterface::luaSpellIsBlockingWalls(lua_State* L)
{
	// spell:blockWalls(bool)
	InstantSpell* spell = dynamic_cast<InstantSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockWalls());
		} else {
			spell->setBlockWalls(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneLevel(lua_State* L)
{
	// spell:runeLevel(level)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	int32_t level = getNumber<int32_t>(L, 2);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(level);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneMagicLevel(lua_State* L)
{
	// spell:runeMagicLevel(magLevel)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	int32_t magLevel = getNumber<int32_t>(L, 2);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(magLevel);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellRuneId(lua_State* L)
{
	// spell:runeId(id)
	RuneSpell* rune = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (rune) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (rune->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, rune->getRuneItemId());
		} else {
			rune->setRuneItemId(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellCharges(lua_State* L)
{
	// spell:charges(charges)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCharges());
		} else {
			spell->setCharges(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellAllowFarUse(lua_State* L)
{
	// spell:allowFarUse(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAllowFarUse());
		} else {
			spell->setAllowFarUse(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellBlockWalls(lua_State* L)
{
	// spell:blockWalls(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckLineOfSight());
		} else {
			spell->setCheckLineOfSight(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int LuaScriptInterface::luaSpellCheckFloor(lua_State* L)
{
	// spell:checkFloor(bool)
	RuneSpell* spell = dynamic_cast<RuneSpell*>(getUserdata<Spell>(L, 1));
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckFloor());
		} else {
			spell->setCheckFloor(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

	
int LuaScriptInterface::luaCreateAction(lua_State* L)
{
	// Action()

	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("Actions can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	Action* action = new Action(getScriptEnv()->getScriptInterface());
	if (action) {
		action->fromLua = true;
		pushUserdata<Action>(L, action);
		setMetatable(L, -1, "Action");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// int LuaScriptInterface::luaDeleteAction(lua_State* L)
// {
// 	// action:delete() action:__gc()
// 	Action** actionsPtr = getRawUserdata<Action>(L, 1);
// 	if (actionsPtr && *actionsPtr) {
// 		delete *actionsPtr;
// 		*actionsPtr = nullptr;
// 	}
// 	return 0;
// }

int LuaScriptInterface::luaActionOnUse(lua_State* L)
{
	// action:onUse(callback)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		if (!action->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		action->scripted = true;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionRegister(lua_State* L)
{
	// action:register()
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		if (!action->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}

		pushBoolean(L, g_actions->registerLuaEvent(action));
		g_actions->clearItemIdRange(action);
		g_actions->clearUniqueIdRange(action);
		g_actions->clearActionIdRange(action);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionItemId(lua_State* L)
{
	// action:id(ids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_actions->addItemId(action, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_actions->addItemId(action, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionActionId(lua_State* L)
{
	// action:aid(aids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_actions->addActionId(action, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_actions->addActionId(action, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionUniqueId(lua_State* L)
{
	// action:uid(uids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_actions->addUniqueId(action, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_actions->addUniqueId(action, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionAllowFarUse(lua_State* L)
{
	// action:allowFarUse(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setAllowFarUse(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionBlockWalls(lua_State* L)
{
	// action:blockWalls(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setCheckLineOfSight(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaActionCheckFloor(lua_State* L)
{
	// action:checkFloor(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setCheckFloor(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreateTalkaction(lua_State* L)
{
	// TalkAction(words)
	
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("TalkActions can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	TalkAction* talk = new TalkAction(getScriptEnv()->getScriptInterface());
	if (talk) {
		talk->fromLua = true;
		talk->setWords(getString(L, 2));
		pushUserdata<TalkAction>(L, talk);
		setMetatable(L, -1, "TalkAction");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionOnSay(lua_State* L)
{
	// talkAction:onSay(callback)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionRegister(lua_State* L)
{
	// talkAction:register()
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_talkActions->registerLuaEvent(talk));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaTalkactionSeparator(lua_State* L)
{
	// talkAction:separator(sep)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		talk->setSeparator(getString(L, 2).c_str());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreateCreatureEvent(lua_State* L)
{
	// CreatureEvent(eventName)
	CreatureEvent* creature = new CreatureEvent(getScriptEnv()->getScriptInterface());

	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("CreatureEvents can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	if (creature) {
		creature->fromLua = true;
		creature->setName(getString(L, 2));
		pushUserdata<CreatureEvent>(L, creature);
		setMetatable(L, -1, "CreatureEvent");
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaCreatureEventType(lua_State* L)
{
	// creatureevent:type(callback)
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "login") {
			creature->setEventType(CREATURE_EVENT_LOGIN);
		} else if (tmpStr == "logout") {
			creature->setEventType(CREATURE_EVENT_LOGOUT);
		} else if (tmpStr == "think") {
			creature->setEventType(CREATURE_EVENT_THINK);
		} else if (tmpStr == "preparedeath") {
			creature->setEventType(CREATURE_EVENT_PREPAREDEATH);
		} else if (tmpStr == "death") {
			creature->setEventType(CREATURE_EVENT_DEATH);
		} else if (tmpStr == "kill") {
			creature->setEventType(CREATURE_EVENT_KILL);
		} else if (tmpStr == "advance") {
			creature->setEventType(CREATURE_EVENT_ADVANCE);
		} else if (tmpStr == "modalwindow") {
			creature->setEventType(CREATURE_EVENT_MODALWINDOW);
		} else if (tmpStr == "textedit") {
			creature->setEventType(CREATURE_EVENT_TEXTEDIT);
		} else if (tmpStr == "healthchange") {
			creature->setEventType(CREATURE_EVENT_HEALTHCHANGE);
		} else if (tmpStr == "manachange") {
			creature->setEventType(CREATURE_EVENT_MANACHANGE);
		} else if (tmpStr == "extendedopcode") {
			creature->setEventType(CREATURE_EVENT_EXTENDED_OPCODE);
		} else if (tmpStr == "move") {
			creature->setEventType(CREATURE_EVENT_MOVE);
		} else {
			std::cout << "[Error - CreatureEvent::configureLuaEvent] Invalid type for creature event: " << typeName << std::endl;
			pushBoolean(L, false);
		}
		creature->setLoaded(true);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureEventRegister(lua_State* L)
{
	// creatureevent:register()
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		if (!creature->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_creatureEvents->registerLuaEvent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreatureEventOnCallback(lua_State* L)
{
	// creatureevent:onLogin / logout / etc. (callback)
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		if (!creature->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreateMoveEvent(lua_State* L)
{
	// MoveEvent()
	MoveEvent* moveevent = new MoveEvent(getScriptEnv()->getScriptInterface());
	
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("MoveEvents can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	if (moveevent) {
		moveevent->fromLua = true;
		pushUserdata<MoveEvent>(L, moveevent);
		setMetatable(L, -1, "MoveEvent");
	} else {
		lua_pushnil(L);
	}
	return 1;
}


int LuaScriptInterface::luaMoveEventType(lua_State* L)
{
	// moveevent:type(callback)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "stepin") {
			moveevent->setEventType(MOVE_EVENT_STEP_IN);
			moveevent->stepFunction = moveevent->StepInField;
		} else if (tmpStr == "stepout") {
			moveevent->setEventType(MOVE_EVENT_STEP_OUT);
			moveevent->stepFunction = moveevent->StepOutField;
		} else if (tmpStr == "equip") {
			moveevent->setEventType(MOVE_EVENT_EQUIP);
			moveevent->equipFunction = moveevent->EquipItem;
		} else if (tmpStr == "deequip") {
			moveevent->setEventType(MOVE_EVENT_DEEQUIP);
			moveevent->equipFunction = moveevent->DeEquipItem;
		} else if (tmpStr == "additem") {
			moveevent->setEventType(MOVE_EVENT_ADD_ITEM_ITEMTILE);
			moveevent->moveFunction = moveevent->AddItemField;
		} else if (tmpStr == "removeitem") {
			moveevent->setEventType(MOVE_EVENT_REMOVE_ITEM_ITEMTILE);
			moveevent->moveFunction = moveevent->RemoveItemField;
		} else {
			std::cout << "Error: [MoveEvent::configureMoveEvent] No valid event name " << typeName << std::endl;
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventRegister(lua_State* L)
{
	// moveevent:register()
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		if (!moveevent->isScripted()) {
			pushBoolean(L, g_moveEvents->registerLuaFunction(moveevent));
			return 1;
		}
		pushBoolean(L, g_moveEvents->registerLuaEvent(moveevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventOnCallback(lua_State* L)
{
	// moveevent:onEquip / deEquip / etc. (callback)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		if (!moveevent->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventSlot(lua_State* L)
{
	// moveevent:slot(slot)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		if (moveevent->getEventType() == MOVE_EVENT_EQUIP || moveevent->getEventType() == MOVE_EVENT_DEEQUIP) {
			if (!moveevent->getSlotName().empty()) {
				std::string slotName = getString(L, 2);
				std::string tmpStr = asLowerCaseString(slotName);
				tmpStr = asLowerCaseString(moveevent->getSlotName());
				if (tmpStr == "head") {
					moveevent->setSlot(SLOTP_HEAD);
				} else if (tmpStr == "necklace") {
					moveevent->setSlot(SLOTP_NECKLACE);
				} else if (tmpStr == "backpack") {
					moveevent->setSlot(SLOTP_BACKPACK);
				} else if (tmpStr == "armor" || tmpStr == "body") {
					moveevent->setSlot(SLOTP_ARMOR);
				} else if (tmpStr == "right-hand") {
					moveevent->setSlot(SLOTP_RIGHT);
				} else if (tmpStr == "left-hand") {
					moveevent->setSlot(SLOTP_LEFT);
				} else if (tmpStr == "hand" || tmpStr == "shield") {
					moveevent->setSlot(SLOTP_RIGHT | SLOTP_LEFT);
				} else if (tmpStr == "legs") {
					moveevent->setSlot(SLOTP_LEGS);
				} else if (tmpStr == "feet") {
					moveevent->setSlot(SLOTP_FEET);
				} else if (tmpStr == "ring") {
					moveevent->setSlot(SLOTP_RING);
				} else if (tmpStr == "ammo") {
					moveevent->setSlot(SLOTP_AMMO);
				} else {
					std::cout << "[Warning - MoveEvent::configureMoveEvent] Unknown slot type: " << moveevent->getSlotName() << std::endl;
				}
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventLevel(lua_State* L)
{
	// moveevent:level(lvl)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredLevel(getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_LEVEL);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventMagLevel(lua_State* L)
{
	// moveevent:magicLevel(lvl)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setRequiredMagLevel(getNumber<uint32_t>(L, 2));
		moveevent->setWieldInfo(WIELDINFO_MAGLV);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventPremium(lua_State* L)
{
	// moveevent:premium(bool)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->setNeedPremium(getBoolean(L, 2));
		moveevent->setWieldInfo(WIELDINFO_PREMIUM);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventVocation(lua_State* L)
 {
	// moveevent:vocation(vocName[, showInDescription = false, lastVoc = false])
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		moveevent->addVocEquipMap(getString(L, 2));
		moveevent->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = getBoolean(L, 3, false);
		bool lastVoc = getBoolean(L, 4, false);
		if (showInDescription) {
			if (moveevent->getVocationString().empty()) {
				tmp = asLowerCaseString(getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			} else {
				tmp = moveevent->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(getString(L, 2));
				tmp += "s";
				moveevent->setVocationString(tmp);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventItemId(lua_State* L)
{
	// moveevent:id(ids)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_moveEvents->addItemId(moveevent, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_moveEvents->addItemId(moveevent, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventActionId(lua_State* L)
{
	// moveevent:aid(ids)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_moveEvents->addActionId(moveevent, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_moveEvents->addActionId(moveevent, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaMoveEventUniqueId(lua_State* L)
{
	// moveevent:uid(ids)
	MoveEvent* moveevent = getUserdata<MoveEvent>(L, 1);
	if (moveevent) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				g_moveEvents->addUniqueId(moveevent, getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			g_moveEvents->addUniqueId(moveevent, getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaCreateGlobalEvent(lua_State* L)
{
	// GlobalEvent(eventName)
	GlobalEvent* global = new GlobalEvent(getScriptEnv()->getScriptInterface());
	
	if (getScriptEnv()->getScriptInterface() != &g_scripts->getScriptInterface()) {
		reportErrorFunc("GlobalEvents can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	if (global) {
		global->fromLua = true;
		global->setName(getString(L, 2));
		global->setEventType(GLOBALEVENT_NONE);
		pushUserdata<GlobalEvent>(L, global);
		setMetatable(L, -1, "GlobalEvent");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventType(lua_State* L)
{
	// globalevent:type(callback)
	GlobalEvent* global = getUserdata<GlobalEvent>(L, 1);
	if (global) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "startup") {
			global->setEventType(GLOBALEVENT_STARTUP);
		} else if (tmpStr == "shutdown") {
			global->setEventType(GLOBALEVENT_SHUTDOWN);
		} else if (tmpStr == "record") {
			global->setEventType(GLOBALEVENT_RECORD);
		} else {
			std::cout << "[Error - CreatureEvent::configureLuaEvent] Invalid type for global event: " << typeName << std::endl;
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventRegister(lua_State* L)
{
	// globalevent:register()
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}

		if (globalevent->getEventType() == GLOBALEVENT_NONE && globalevent->getInterval() == 0) {
			std::cout << "[Error - LuaScriptInterface::luaGlobalEventRegister] No interval for globalevent with name " << globalevent->getName() << std::endl;
			pushBoolean(L, false);
			return 1;
		}
		
		pushBoolean(L, g_globalEvents->registerLuaEvent(globalevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventOnCallback(lua_State* L)
{
	// globalevent:onThink / record / etc. (callback)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventTime(lua_State* L)
{
	// globalevent:time(time)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		std::string timer = getString(L, 2);
		std::vector<int32_t> params = vectorAtoi(explodeString(timer, ":"));

		int32_t hour = params.front();
		if (hour < 0 || hour > 23) {
			std::cout << "[Error - GlobalEvent::configureEvent] Invalid hour \"" << timer << "\" for globalevent with name: " << globalevent->getName() << std::endl;
			pushBoolean(L, false);
			return 1;
		}

		globalevent->setInterval(hour << 16);

		int32_t min = 0;
		int32_t sec = 0;
		if (params.size() > 1) {
			min = params[1];
			if (min < 0 || min > 59) {
				std::cout << "[Error - GlobalEvent::configureEvent] Invalid minute \"" << timer << "\" for globalevent with name: " << globalevent->getName() << std::endl;
				pushBoolean(L, false);
				return 1;
			}

			if (params.size() > 2) {
				sec = params[2];
				if (sec < 0 || sec > 59) {
					std::cout << "[Error - GlobalEvent::configureEvent] Invalid second \"" << timer << "\" for globalevent with name: " << globalevent->getName() << std::endl;
					pushBoolean(L, false);
					return 1;
				}
			}
		}

		time_t current_time = time(nullptr);
		tm* timeinfo = localtime(&current_time);
		timeinfo->tm_hour = hour;
		timeinfo->tm_min = min;
		timeinfo->tm_sec = sec;

		time_t difference = static_cast<time_t>(difftime(mktime(timeinfo), current_time));
		if (difference < 0) {
			difference += 86400;
		}

		globalevent->setNextExecution(current_time + difference);
		globalevent->setEventType(GLOBALEVENT_TIMER);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaGlobalEventInterval(lua_State* L)
{
	// globalevent:interval(interval)
	GlobalEvent* globalevent = getUserdata<GlobalEvent>(L, 1);
	if (globalevent) {
		globalevent->setInterval(getNumber<uint32_t>(L, 2));
		globalevent->setNextExecution(OTSYS_TIME() + getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
// Party

int32_t LuaScriptInterface::luaPartyCreate(lua_State* L)
{
	// Party(userdata)
	Player* player = getUserdata<Player>(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Party* party = player->getParty();
	if (!party) {
		party = new Party(player);
		g_game.updatePlayerShield(player);
		player->sendCreatureSkull(player);
		pushUserdata<Party>(L, party);
		setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyDisband(lua_State* L)
{
	// party:disband()
	Party** partyPtr = getRawUserdata<Party>(L, 1);
	if (partyPtr && *partyPtr) {
		Party*& party = *partyPtr;
		party->disband();
		party = nullptr;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyGetLeader(lua_State* L)
{
	// party:getLeader()
	Party* party = getUserdata<Party>(L, 1);
	if (!party) {
		lua_pushnil(L);
		return 1;
	}

	Player* leader = party->getLeader();
	if (leader) {
		pushUserdata<Player>(L, leader);
		setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartySetLeader(lua_State* L)
{
	// party:setLeader(player)
	Player* player = getPlayer(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party && player) {
		pushBoolean(L, party->passPartyLeadership(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyGetMembers(lua_State* L)
{
	// party:getMembers()
	Party* party = getUserdata<Party>(L, 1);
	if (!party) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, party->getMemberCount(), 0);
	for (Player* player : party->getMembers()) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int LuaScriptInterface::luaPartyGetMemberCount(lua_State* L)
{
	// party:getMemberCount()
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		lua_pushnumber(L, party->getMemberCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyGetInvitees(lua_State* L)
{
	// party:getInvitees()
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		lua_createtable(L, party->getInvitationCount(), 0);

		int index = 0;
		for (Player* player : party->getInvitees()) {
			pushUserdata<Player>(L, player);
			setMetatable(L, -1, "Player");
			lua_rawseti(L, -2, ++index);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyGetInviteeCount(lua_State* L)
{
	// party:getInviteeCount()
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		lua_pushnumber(L, party->getInvitationCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyAddInvite(lua_State* L)
{
	// party:addInvite(player)
	Player* player = getPlayer(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party && player) {
		pushBoolean(L, party->invitePlayer(*player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyRemoveInvite(lua_State* L)
{
	// party:removeInvite(player)
	Player* player = getPlayer(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party && player) {
		pushBoolean(L, party->removeInvite(*player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyAddMember(lua_State* L)
{
	// party:addMember(player)
	Player* player = getPlayer(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party && player) {
		pushBoolean(L, party->joinParty(*player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyRemoveMember(lua_State* L)
{
	// party:removeMember(player)
	Player* player = getPlayer(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party && player) {
		pushBoolean(L, party->leaveParty(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyIsSharedExperienceActive(lua_State* L)
{
	// party:isSharedExperienceActive()
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		pushBoolean(L, party->isSharedExperienceActive());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyIsSharedExperienceEnabled(lua_State* L)
{
	// party:isSharedExperienceEnabled()
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		pushBoolean(L, party->isSharedExperienceEnabled());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartyShareExperience(lua_State* L)
{
	// party:shareExperience(experience)
	uint64_t experience = getNumber<uint64_t>(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		party->shareExperience(experience);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LuaScriptInterface::luaPartySetSharedExperience(lua_State* L)
{
	// party:setSharedExperience(active)
	bool active = getBoolean(L, 2);
	Party* party = getUserdata<Party>(L, 1);
	if (party) {
		pushBoolean(L, party->setSharedExperience(party->getLeader(), active));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

//
LuaEnvironment::LuaEnvironment() : LuaScriptInterface("Main Interface") {}

LuaEnvironment::~LuaEnvironment()
{
	delete testInterface;
	closeState();
}

bool LuaEnvironment::initState()
{
	luaState = luaL_newstate();
	if (!luaState) {
		return false;
	}

	luaL_openlibs(luaState);
	registerFunctions();

	runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaEnvironment::reInitState()
{
	// TODO: get children, reload children
	closeState();
	return initState();
}

bool LuaEnvironment::closeState()
{
	if (!luaState) {
		return false;
	}

	for (const auto& combatEntry : combatIdMap) {
		clearCombatObjects(combatEntry.first);
	}

	for (const auto& areaEntry : areaIdMap) {
		clearAreaObjects(areaEntry.first);
	}

	for (auto& timerEntry : timerEvents) {
		LuaTimerEventDesc timerEventDesc = std::move(timerEntry.second);
		for (int32_t parameter : timerEventDesc.parameters) {
			luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
		}
		luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	}

	combatIdMap.clear();
	areaIdMap.clear();
	timerEvents.clear();
	cacheFiles.clear();

	lua_close(luaState);
	luaState = nullptr;
	return true;
}

LuaScriptInterface* LuaEnvironment::getTestInterface()
{
	if (!testInterface) {
		testInterface = new LuaScriptInterface("Test Interface");
		testInterface->initState();
	}
	return testInterface;
}

Combat_ptr LuaEnvironment::getCombatObject(uint32_t id) const
{
	auto it = combatMap.find(id);
	if (it == combatMap.end()) {
		return nullptr;
	}
	return it->second;
}

Combat_ptr LuaEnvironment::createCombatObject(LuaScriptInterface* interface)
{
	Combat_ptr combat = std::make_shared<Combat>();
	combatMap[++lastCombatId] = combat;
	combatIdMap[interface].push_back(lastCombatId);
	return combat;
}

void LuaEnvironment::clearCombatObjects(LuaScriptInterface* interface)
{
	auto it = combatIdMap.find(interface);
	if (it == combatIdMap.end()) {
		return;
	}

	for (uint32_t id : it->second) {
		auto itt = combatMap.find(id);
		if (itt != combatMap.end()) {
			// delete itt->second;
			combatMap.erase(itt);
		}
	}
	it->second.clear();
}

AreaCombat* LuaEnvironment::getAreaObject(uint32_t id) const
{
	auto it = areaMap.find(id);
	if (it == areaMap.end()) {
		return nullptr;
	}
	return it->second;
}

uint32_t LuaEnvironment::createAreaObject(LuaScriptInterface* interface)
{
	areaMap[++lastAreaId] = new AreaCombat;
	areaIdMap[interface].push_back(lastAreaId);
	return lastAreaId;
}

void LuaEnvironment::clearAreaObjects(LuaScriptInterface* interface)
{
	auto it = areaIdMap.find(interface);
	if (it == areaIdMap.end()) {
		return;
	}

	for (uint32_t id : it->second) {
		auto itt = areaMap.find(id);
		if (itt != areaMap.end()) {
			delete itt->second;
			areaMap.erase(itt);
		}
	}
	it->second.clear();
}

void LuaEnvironment::executeTimerEvent(uint32_t eventIndex)
{
	auto it = timerEvents.find(eventIndex);
	if (it == timerEvents.end()) {
		return;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	//push function
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);

	//push parameters
	for (auto parameter : boost::adaptors::reverse(timerEventDesc.parameters)) {
		lua_rawgeti(luaState, LUA_REGISTRYINDEX, parameter);
	}

	//call the function
	if (reserveScriptEnv()) {
		ScriptEnvironment* env = getScriptEnv();
		env->setTimerEvent();
		env->setScriptId(timerEventDesc.scriptId, this);
		callFunction(timerEventDesc.parameters.size());
	} else {
		std::cout << "[Error - LuaScriptInterface::executeTimerEvent] Call stack overflow" << std::endl;
	}

	//free resources
	luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
	}
}


