// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_MONSTER_H_9F5EEFE64314418CA7DA41D1B9409DD0
#define FS_MONSTER_H_9F5EEFE64314418CA7DA41D1B9409DD0

#include "tile.h"
#include "monsters.h"

class Creature;
class Game;
class Spawn;

using CreatureHashSet = std::unordered_set<Creature*>;
using CreatureList = std::list<Creature*>;

class Monster final : public Creature
{
	public:
		static Monster* createMonster(const std::string& name, uint32_t lvl, uint32_t bst);
		static int32_t despawnRange;
		static int32_t despawnRadius;

		explicit Monster(MonsterType* mType, uint32_t lvl, uint32_t bst);
		~Monster();

		// non-copyable
		Monster(const Monster&) = delete;
		Monster& operator=(const Monster&) = delete;

		Monster* getMonster() override {
			return this;
		}
		const Monster* getMonster() const override {
			return this;
		}

		void setID() override {
			if (id == 0) {
				id = monsterAutoID++;
			}
		}

		void removeList() override;
		void addList() override;

		const std::string& getName() const override {
            return mType->name;
        }
		
		const std::string& getNameDescription() const override {
			return mType->nameDescription;
		}
		std::string getDescription(int32_t) const override {
			return strDescription + '.';
		}

		CreatureType_t getType() const override {
			return CREATURETYPE_MONSTER;
		}
		
		const NameColor_t getNameColor() const override {
			return mType->nameColor;
		}

		const Position& getMasterPos() const {
			return masterPos;
		}
		void setMasterPos(Position pos) {
			masterPos = pos;
		}

		RaceType_t getRace() const override {
			return mType->info.race;
		}

		RaceType_t getRace2() const final {
			return mType->info.race2;
		}
		int32_t getArmor() const override {
			return mType->info.armor;
		}
		int32_t getDefense() const override {
			return mType->info.defense;
		}
		bool isPushable() const override {
			return canMove() && mType->info.pushable && baseSpeed != 0;
		}
		bool isAttackable() const override {
			return mType->info.isAttackable;
		}

		uint32_t getSummonLevel() const {
			return lvl;
		}

		void setSummonLevel(uint32_t newLevel) {
			lvl = newLevel;
		}

		uint32_t getLevel() const {
			return level;
		} 

		uint32_t getBoost() const {
			return boost;
		}

		//get exp from monsters
		uint64_t getExperience() const {
			return monsterExperience;
		}

		void setExperience(uint64_t value) {
			monsterExperience = value;
		}

		bool canPushItems() const {
			return mType->info.canPushItems;
		}
		bool canPushCreatures() const {
			return mType->info.canPushCreatures;
		}
		bool isHostile() const {
			return mType->info.isHostile;
		}
		
		bool isGhost() const;

		bool isPassive() const {
			return mType->info.isPassive;
		}

		int32_t isFlyable() const {
			return mType->info.isFlyable;
		}

		int32_t isRideable() const {
			return mType->info.isRideable;
		}

		int32_t isSurfable() const {
			return mType->info.isSurfable;
		}

		bool canTeleport() const {
			return mType->info.canTeleport;
		}

		bool canBlink() const {
			return mType->info.canBlink;
		}

		int32_t catchChance() const {
			return mType->info.catchChance;
		}

		int32_t getMoveMagicAttackBase() const {
			return mType->info.moveMagicAttackBase;
		}
		
		int32_t getPhysicalDamage() const {
			return mType->info.movePhysicalDamage;
		}
		
		int32_t getSpecialDamage() const {
			return mType->info.moveSpecialDamage;
		}
		
		int32_t getSpecialDefense() const {
			return mType->info.specialDefense;
		}
		
		int32_t getPhysicalDefense() const {
			return mType->info.physicalDefense;
		}
		
		int32_t getMinimumLevel() const {
			return mType->info.minimumLevel;
		}

		int32_t getMoveMagicDefenseBase() const {
			return mType->info.moveMagicDefenseBase;
		}

		int32_t hasShiny() const {
			return mType->info.hasShiny;
		}

		int32_t hasMega() const {
			return mType->info.hasMega;
		}

		int32_t dexEntry() const {
			return mType->info.dexEntry;
		}

		int32_t portraitId() const {
			return mType->info.portraitId;
		}

		bool canSee(const Position& pos) const override;
		bool canSeeInvisibility() const override {
			return isImmune(CONDITION_INVISIBLE);
		}
		uint32_t getManaCost() const {
			return mType->info.manaCost;
		}
		void setSpawn(Spawn* spawn) {
			this->spawn = spawn;
		}

		void onAttackedCreatureDisappear(bool isLogout) override;

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;
		void onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos, const Tile* oldTile, const Position& oldPos, bool teleport) override;
		void onCreatureSay(Creature* creature, SpeakClasses type, const std::string& text) override;

		void drainHealth(Creature* attacker, int64_t damage) override;
		void changeHealth(int64_t healthChange, bool sendHealthChange = true) override;
		void onWalk() override;
		bool getNextStep(Direction& direction, uint32_t& flags) override;
		void onFollowCreatureComplete(const Creature* creature) override;

		void onThink(uint32_t interval) override;

		bool challengeCreature(Creature* creature) override;
		bool convinceCreature(Creature* creature) override;

		void setNormalCreatureLight() override;
		bool getCombatValues(int64_t& min, int64_t& max) override;
	
		void doAttacking(uint32_t interval) override;
		bool hasExtraSwing() override {
			return extraMeleeAttack;
		}

		bool searchTarget(TargetSearchType_t searchType = TARGETSEARCH_DEFAULT);
		bool selectTarget(Creature* creature);

		const CreatureList& getTargetList() const {
			return targetList;
		}
		const CreatureHashSet& getFriendList() const {
			return friendList;
		}

		bool isTarget(const Creature* creature) const;
		bool isFleeing() const {
			if (hasCondition(CONDITION_FEAR)) {
				return true;
			}
			return !isSummon() && getHealth() <= mType->info.runAwayHealth && challengeFocusDuration <= 0;
		}

		bool getDistanceStep(const Position& targetPos, Direction& direction, bool flee = false);
		bool isTargetNearby() const {
			return stepDuration >= 1;
		}

		BlockType_t blockHit(Creature* attacker, CombatType_t combatType, int64_t& damage,
		                     bool checkDefense = false, bool checkArmor = false, bool field = false) override;

		static uint32_t monsterAutoID;

		void setOrderPosition(const Position orderPosition) {
			this->orderPosition = orderPosition;
		}

		Position getOrderPosition() {
			return orderPosition;
		}
		
		void setPokeStopped(bool pokeStop) {
			this->pokeStop = pokeStop;
		}

		bool isPokeStopped() {
			return pokeStop;
		}
		void setEffectId(uint16_t effectId) {
			this->effectId = effectId;
		}

	private:
		CreatureHashSet friendList;
		CreatureList targetList;

		std::string strDescription;

		MonsterType* mType;
		Spawn* spawn = nullptr;

		int64_t lastMeleeAttack = 0;

		uint32_t attackTicks = 0;
		uint32_t targetTicks = 0;
		uint32_t targetChangeTicks = 0;
		uint32_t defenseTicks = 0;
		uint32_t yellTicks = 0;
		int32_t minCombatValue = 0;
		int32_t maxCombatValue = 0;
		std::string name;
		NameColor_t nameColor = NAMECOLOR_GREEN;
		int32_t targetChangeCooldown = 0;
		int32_t challengeFocusDuration = 0;
		int32_t stepDuration = 0;
		uint32_t level;
		uint32_t lvl;
		uint32_t boost;
		uint32_t bst;
		bool pokeStop = false;
		uint16_t effectId = 0;

		Position masterPos;
		Position orderPosition;

		bool isIdle = true;
		bool extraMeleeAttack = false;
		bool isMasterInRange = false;

		void onCreatureEnter(Creature* creature);
		void onCreatureLeave(Creature* creature);
		void onCreatureFound(Creature* creature, bool pushFront = false);

		void updateLookDirection();

		void addFriend(Creature* creature);
		void removeFriend(Creature* creature);
		void addTarget(Creature* creature, bool pushFront = false);
		void removeTarget(Creature* creature);

		void updateTargetList();
		void clearTargetList();
		void clearFriendList();

		void death(Creature* lastHitCreature) override;
		Item* getCorpse(Creature* lastHitCreature, Creature* mostDamageCreature) override;
		
		void setIdle(bool idle);
		void updateIdleStatus();
		bool getIdleStatus() const {
			return isIdle;
		}

		void onAddCondition(ConditionType_t type) override;
		void onEndCondition(ConditionType_t type) override;
		void onCreatureConvinced(const Creature* convincer, const Creature* creature) override;

		bool canUseAttack(const Position& pos, const Creature* target) const;
		bool canUseSpell(const Position& pos, const Position& targetPos,
		                 const spellBlock_t& sb, uint32_t interval, bool& inRange, bool& resetTicks);
		bool getRandomStep(const Position& creaturePos, Direction& direction) const;
		bool getDanceStep(const Position& creaturePos, Direction& direction,
		                  bool keepAttack = true, bool keepDistance = true);
		bool isInSpawnRange(const Position& pos) const;
		bool canWalkTo(Position pos, Direction direction) const;

		static bool pushItem(Item* item);
		static void pushItems(Tile* tile);
		static bool pushCreature(Creature* creature);
		static void pushCreatures(Tile* tile);

		void onThinkTarget(uint32_t interval);
		void onThinkYell(uint32_t interval);
		void onThinkDefense(uint32_t interval);

		bool isFriend(const Creature* creature) const;
		bool isOpponent(const Creature* creature) const;

		uint64_t getLostExperience() const override {
			return skillLoss ? mType->info.experience : 0;
		}
		uint16_t getLookCorpse() const override {
			return mType->info.lookcorpse;
		}
		
		void dropLoot(Container* corpse, Creature* lastHitCreature) override;
		uint32_t getDamageImmunities() const override {
			return mType->info.damageImmunities;
		}
		uint32_t getConditionImmunities() const override {
			return mType->info.conditionImmunities;
		}
		void getPathSearchParams(const Creature* creature, FindPathParams& fpp) const override;
		bool useCacheMap() const override {
			return true;
		}

		friend class LuaScriptInterface;
};

#endif
