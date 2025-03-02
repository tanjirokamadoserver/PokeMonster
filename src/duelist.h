#ifndef FS_DUELIST_H
#define FS_DUELIST_H


#include "otpch.h"
#include "tile.h"
#include "creature.h"

class Creature;
class Game;
class Spawn;

using CreatureHashSet = std::unordered_set<Creature*>;
using CreatureList = std::list<Creature*>;

struct DuelistInfo {
    Outfit_t outfit;
    int64_t health;
    int64_t maxHealth;
    uint32_t speed;
	int32_t minTargetDist;
	int32_t maxTargetDist;
	int32_t corpse;
	int32_t experience;
    std::string description;
	std::vector<std::string> startDuelVoices;
	std::vector<std::string> deathDuelVoices;
	std::vector<std::string> fleeingVoices;
	std::list<MonsterType*> pokemons;
};

class Duelist final : public Creature
{
    public:
        static Duelist* createDuelist(const std::string& name, const DuelistInfo& info);
        explicit Duelist(std::string const& name, const DuelistInfo& info);
        ~Duelist();
        // non-copyable
	    Duelist(const Duelist&) = delete;
	    Duelist& operator=(const Duelist&) = delete;

	    Duelist* getDuelist() override {
	    	return this;
	    }
	    const Duelist* getDuelist() const override {
	    	return this;
	    }

		void setID() override {
			if (id == 0) {
				id = duelistAutoID++;
			}
		}

        bool canUseAttack(const Position& pos, const Creature* target) const;

		std::string getDescription(int32_t) const override {
			return strDescription + '.';
		}

		const std::string& getName() const override {
            return name;
        }
		
		const std::string& getNameDescription() const override {
			return nameDescription;
		}

        CreatureType_t getType() const override {
			return CREATURETYPE_MONSTER;
		}

        void removeList() override;
		void addList() override;

        bool canSee(const Position& pos) const override;
		bool canSeeInvisibility() const override {
			return isImmune(CONDITION_INVISIBLE);
		}
        void onWalk() override;
        bool getNextStep(Direction& direction, uint32_t& flags) override;
		void onFollowCreatureComplete(const Creature* creature) override;
		bool getRandomStep(const Position& creaturePos, Direction& direction) const;
		bool getDanceStep(const Position& creaturePos, Direction& direction,
		                  bool keepAttack = true, bool keepDistance = true);

		bool getDistanceStep(const Position& targetPos, Direction& direction, bool flee = false);
		bool isTargetNearby() const {
			return stepDuration >= 1;
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
			if (hasCondition(CONDITION_FEAR) || (pokemons.empty() && summons.empty())) {
				return true;
			}
			return false;
		}

		bool challengeCreature(Creature* creature) override;
        	
        void drainHealth(Creature* attacker, int64_t damage) override;
		void changeHealth(int64_t healthChange, bool sendHealthChange = true) override;

        void onThink(uint32_t interval) override;
		void doAttacking(uint32_t interval) override;

		void onCreatureAppear(Creature* creature, bool isLogin) override;
		void onRemoveCreature(Creature* creature, bool isLogout) override;

        bool canWalkTo(Position pos, Direction direction) const;

		bool isAttackable() const override {
			if (pokemons.empty()) {
				return true;
			}
			return false;
		}
        static uint32_t duelistAutoID;

		std::string getRandomStartDuelVoice() {
			if (startDuelVoices.empty()) {
				return "";
			}
			return startDuelVoices[rand() % startDuelVoices.size()];
		}

		std::string getRandomDeathDuelVoice() {
			if (deathDuelVoices.empty()) {
				return "";
			}
			return deathDuelVoices[rand() % deathDuelVoices.size()];
		}

		std::string getRandomFleeingVoice() {
			if (fleeingVoices.empty()) {
				return "";
			}
			return fleeingVoices[rand() % fleeingVoices.size()];
		}

		void setContractPlayer(uint32_t guid) {
			contractPlayer = guid;
		}

		void setContractId(uint32_t id) {
			contractId = id;
		}

		uint32_t getContractPlayer() {
			return contractPlayer;
		}

		uint32_t getContractId() {
			return contractId;
		}
		
    private:
    	CreatureHashSet friendList;
		CreatureList targetList;
        bool isIdle = true;
        int32_t stepDuration = 0;
        int32_t minTargetDist = 3;
        int32_t maxTargetDist = 5;
		int32_t corpse = 0;
		int32_t experience = 0;
		std::string name;
		std::string nameDescription;
		std::string strDescription;
		std::list<MonsterType*> pokemons;
		std::vector<std::string> startDuelVoices;
		std::vector<std::string> deathDuelVoices;
		std::vector<std::string> fleeingVoices;

		uint32_t contractPlayer = 0;
		uint32_t contractId = 0;

		void onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos, const Tile* oldTile, const Position& oldPos, bool teleport) override;
		void onCreatureEnter(Creature* creature);
		void onCreatureLeave(Creature* creature);
		void onCreatureFound(Creature* creature, bool pushFront = false);

		void addFriend(Creature* creature);
		void removeFriend(Creature* creature);
		void addTarget(Creature* creature, bool pushFront = false);
		void removeTarget(Creature* creature);

        void updateLookDirection();
		void updateTargetList();

		void clearTargetList();
		void clearFriendList();

        void setIdle(bool idle);
		void updateIdleStatus();
		bool getIdleStatus() const {
			return isIdle;
		}

		uint64_t getLostExperience() const override {
			return experience;
		}
		uint16_t getLookCorpse() const override {
			return corpse;
		}

		void death(Creature* lastHitCreature) override;
		Item* getCorpse(Creature* lastHitCreature, Creature* mostDamageCreature) override;

		void onAddCondition(ConditionType_t type) override;
		void onEndCondition(ConditionType_t type) override;

        void onThinkTarget(uint32_t interval);
        bool isFriend(const Creature* creature) const;
		bool isOpponent(const Creature* creature) const;

		void summonRandomPokemon();

		void getPathSearchParams(const Creature* creature, FindPathParams& fpp) const override;
		bool useCacheMap() const override {
			return true;
		}

        friend class LuaScriptInterface;
};
#endif