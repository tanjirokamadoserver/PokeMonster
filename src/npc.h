// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_NPC_H_B090D0CB549D4435AFA03647195D156F
#define FS_NPC_H_B090D0CB549D4435AFA03647195D156F

#include "creature.h"
#include "luascript.h"

#include <set>

class Npc;
class Player;

class Npcs
{
	public:
		static void reload();
};

class NpcScriptInterface final : public LuaScriptInterface
{
	public:
		NpcScriptInterface();

		bool loadNpcLib(const std::string& file);

	private:
		void registerFunctions();

		static int luaActionSay(lua_State* L);
		static int luaActionMove(lua_State* L);
		static int luaActionMoveTo(lua_State* L);
		static int luaActionTurn(lua_State* L);
		static int luaActionFollow(lua_State* L);
		static int luagetDistanceTo(lua_State* L);
		static int luaSetNpcFocus(lua_State* L);
		static int luaGetNpcCid(lua_State* L);
		static int luaGetNpcParameter(lua_State* L);
		static int luaOpenShopWindow(lua_State* L);
		static int luaCloseShopWindow(lua_State* L);
		static int luaDoSellItem(lua_State* L);

		// metatable
		static int luaNpcGetParameter(lua_State* L);
		static int luaNpcSetFocus(lua_State* L);

		static int luaNpcOpenShopWindow(lua_State* L);
		static int luaNpcCloseShopWindow(lua_State* L);

	private:
		bool initState() override;
		bool closeState() override;

		bool libLoaded;
};

class NpcEventsHandler
{
	public:
		NpcEventsHandler(const std::string& file, Npc* npc);
		~NpcEventsHandler();

		void onCreatureAppear(Creature* creature);
		void onCreatureDisappear(Creature* creature);
		void onCreatureMove(Creature* creature, const Position& oldPos, const Position& newPos);
		void onCreatureSay(Creature* creature, SpeakClasses, const std::string& text);
		void onPlayerTrade(Player* player, int32_t callback, uint16_t itemId, uint16_t count, uint16_t amount, bool ignore = false, bool inBackpacks = false);
		void onPlayerCloseChannel(Player* player);
		void onPlayerEndTrade(Player* player);
		void onThink();

		bool isLoaded() const;
		
		std::unique_ptr<NpcScriptInterface> scriptInterface;

	private:
		Npc* npc;

		int32_t creatureAppearEvent = -1;
		int32_t creatureDisappearEvent = -1;
		int32_t creatureMoveEvent = -1;
		int32_t creatureSayEvent = -1;
		int32_t playerCloseChannelEvent = -1;
		int32_t playerEndTradeEvent = -1;
		int32_t thinkEvent = -1;
		bool loaded = false;
};

class Npc final : public Creature
{
	public:
		~Npc();

		// non-copyable
		Npc(const Npc&) = delete;
		Npc& operator=(const Npc&) = delete;

		Npc* getNpc() override {
			return this;
		}
		const Npc* getNpc() const override {
			return this;
		}

		bool isPushable() const override {
			return pushable && walkTicks != 0;
		}

		void setID() override {
			if (id == 0) {
				id = npcAutoID++;
			}
		}
		
		void removeList() override;
		void addList() override;

		static Npc* createNpc(const std::string& name);

		bool canSee(const Position& pos) const override;

		bool load();
		void reload();

		void setWasHolder(bool value) {
			wasHolder = value;
		}
		
		bool getWasHolder() const {
			return wasHolder != false;
		}

		void setNickName(std::string newName) {
			nickname = newName;
		}

		const std::string& getName() const override {
			if (!nickname.empty()) {
				return nickname;
			}
			return name;
		}
		const std::string& getNameDescription() const override {
			return name;
		}
		const NameColor_t getNameColor() const override {
			return nameColor;
		}
		CreatureType_t getType() const override {
			return CREATURETYPE_NPC;
		}

		uint8_t getSpeechBubble() const override {
			return speechBubble;
		}
		void setSpeechBubble(const uint8_t bubble) {
			speechBubble = bubble;
		}

		void doSay(const std::string& text);
		void doSayToPlayer(Player* player, const std::string& text);

		void doMoveTo(const Position& pos);

		int32_t getMasterRadius() const {
			return masterRadius;
		}
		const Position& getMasterPos() const {
			return masterPos;
		}
		void setMasterPos(Position pos, int32_t radius = 1) {
			masterPos = pos;
			if (masterRadius == -1) {
				masterRadius = radius;
			}
		}

		void onPlayerCloseChannel(Player* player);
		void onPlayerTrade(Player* player, int32_t callback, uint16_t itemId, uint16_t count,
		                   uint16_t amount, bool ignore = false, bool inBackpacks = false);
		void onPlayerEndTrade(Player* player, int32_t buyCallback, int32_t sellCallback);

		void turnToCreature(Creature* creature);
		void setCreatureFocus(Creature* creature);

		auto& getScriptInterface() { return npcEventHandler->scriptInterface; }

		static uint32_t npcAutoID;
		NameColor_t nameColor = NAMECOLOR_GREEN;
	private:
		explicit Npc(const std::string& name);

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;
		
		void onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos,
		                            const Tile* oldTile, const Position& oldPos, bool teleport) override;

		void onCreatureSay(Creature* creature, SpeakClasses type, const std::string& text) override;
		void onThink(uint32_t interval) override;
		std::string getDescription(int32_t lookDistance) const override;

		bool isImmune(CombatType_t) const override {
			return !attackable;
		}
		bool isImmune(ConditionType_t) const override {
			return !attackable;
		}
		bool isAttackable() const override {
			return attackable;
		}
		bool getNextStep(Direction& dir, uint32_t& flags) override;

		void setIdle(bool idle);
		void updateIdleStatus();

		bool canWalkTo(const Position& fromPos, Direction dir) const;
		bool getRandomStep(Direction& dir) const;

		void reset();
		bool loadFromXml();

		void addShopPlayer(Player* player);
		void removeShopPlayer(Player* player);
		void closeAllShopWindows();

		std::map<std::string, std::string> parameters;

		std::set<Player*> shopPlayerSet;
		std::set<Player*> spectators;

		std::string name;
		std::string filename;
		std::string nickname;
		
		std::unique_ptr<NpcEventsHandler> npcEventHandler;

		Position masterPos;

		uint32_t walkTicks;
		int32_t focusCreature;
		int32_t masterRadius;

		uint8_t speechBubble;

		bool floorChange;
		bool attackable;
		bool ignoreHeight;
		bool loaded;
		bool isIdle;
		bool pushable;
		bool wasHolder = false;

		friend class Npcs;
		friend class NpcScriptInterface;
};

#endif
