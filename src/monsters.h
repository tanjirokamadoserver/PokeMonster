// Icaro for upgrade, updates in code. based on tfs 1.4 
// Special Credits: Pota, Ruby
// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_MONSTERS_H_776E8327BCE2450EB7C4A260785E6C0D
#define FS_MONSTERS_H_776E8327BCE2450EB7C4A260785E6C0D

#include "creature.h"


const uint32_t MAX_LOOTCHANCE = 100000;
const uint32_t MAX_STATICWALK = 100;

struct LootBlock {
	uint16_t id;
	uint32_t countmax;
	uint32_t chance;

	//optional
	int32_t subType;
	int32_t actionId;
	std::string text;

	std::vector<LootBlock> childLoot;
	LootBlock() {
		id = 0;
		countmax = 1;
		chance = 0;

		subType = -1;
		actionId = -1;
	}
};

class Loot {
	public:
		Loot() = default;

		// non-copyable
		Loot(const Loot&) = delete;
		Loot& operator=(const Loot&) = delete;

		LootBlock lootBlock;
};

struct summonBlock_t {
	std::string name;
	uint32_t chance;
	uint32_t speed;
	uint32_t max;
	bool force = false;
};

struct stonesBlock_t {
    uint32_t stoneId;
    uint32_t stoneCount;
};

struct evolutionBlock_t {
	std::string name;
	uint32_t level;
	uint32_t chance;
	std::vector<stonesBlock_t> stones;
};

class BaseSpell;
struct spellBlock_t {
	constexpr spellBlock_t() = default;
	~spellBlock_t();
	spellBlock_t(const spellBlock_t& other) = delete;
	spellBlock_t& operator=(const spellBlock_t& other) = delete;
	spellBlock_t(spellBlock_t&& other) :
		spell(other.spell),
		chance(other.chance),
		speed(other.speed),
		power(other.power),
		range(other.range),
		minCombatValue(other.minCombatValue),
		maxCombatValue(other.maxCombatValue),
		name(other.name),
		type(other.type),
		level(other.level),
		isTarget(other.isTarget),
		combatSpell(other.combatSpell),
		isMelee(other.isMelee),
		isPassive(other.isPassive) { other.spell = nullptr; }


	BaseSpell* spell = nullptr;
	uint32_t chance = 100;
	uint32_t speed = 2000;
	int64_t power = 0;
	uint32_t range = 0;
	int32_t minCombatValue = 0;
	int32_t maxCombatValue = 0;
	std::string name = "none";
	std::string type = "none";
	uint32_t level = 1;
	bool isTarget = false;
	bool combatSpell = false;
	bool isMelee = false;
	bool isPassive = false;

};

struct voiceBlock_t {
	std::string text;
	bool yellText;
};

class MonsterType
{
	struct MonsterInfo {
		LuaScriptInterface* scriptInterface;

		std::map<CombatType_t, int32_t> elementMap;

		std::vector<voiceBlock_t> voiceVector;

		std::vector<LootBlock> lootItems;
		std::vector<std::string> scripts;
		std::vector<spellBlock_t> attackSpells;
		std::vector<spellBlock_t> defenseSpells;
		std::vector<summonBlock_t> summons;

		std::vector<spellBlock_t> moves;
		std::vector<evolutionBlock_t> evolutions;

		Skulls_t skull = SKULL_NONE;
		Outfit_t outfit = {};
		RaceType_t race = RACE_NONE;

		RaceType_t race2 = RACE_NONE;

		LightInfo light = {};
		uint16_t lookcorpse = 0;

		uint64_t experience = 0;
		uint64_t monsterExperience = 0;

		uint32_t manaCost = 0;
		uint32_t yellChance = 0;
		uint32_t yellSpeedTicks = 0;
		uint32_t staticAttackChance = 95;
		uint32_t maxSummons = 0;
		uint32_t changeTargetSpeed = 0;
		uint32_t conditionImmunities = 0;
		uint32_t damageImmunities = 0;
		uint32_t baseSpeed = 200;

		int32_t creatureAppearEvent = -1;
		int32_t creatureDisappearEvent = -1;
		int32_t creatureMoveEvent = -1;
		int32_t creatureSayEvent = -1;
		int32_t thinkEvent = -1;
		int32_t targetDistance = 1;
		int32_t runAwayHealth = 0;
		int32_t health = 100;
		int32_t healthMax = 100;

		int32_t wildHealth = 100;
		int32_t wildMaxHealth = 100;
		int32_t wildBaseSpeed = 100;

		int32_t changeTargetChance = 0;
		int32_t defense = 0;
		int32_t armor = 0;
		uint16_t minLevel = 0;
		uint16_t maxLevel = 0;

		bool canPushItems = false;
		bool canPushCreatures = false;
		bool pushable = true;
		bool isSummonable = false;
		bool isIllusionable = false;
		bool isConvinceable = false;
		bool isAttackable = true;
		bool isGhost = false;
		bool isHostile = true;
		bool isPassive = false;

		int32_t isFlyable = 0;
		int32_t isRideable = 0;
		int32_t isSurfable = 0;
		bool canTeleport = false;
		bool canBlink = false;
		
		bool canDig = false;
		bool canSmash = false;
		bool canCut = false;
		bool canLight = false;
		bool canLevitate = false;
		bool canControlMind = false;
		
		int32_t catchChance = 0;
		int32_t moveMagicAttackBase = 0;
		int32_t moveMagicDefenseBase = 0;
		
		int32_t movePhysicalDamage = 0;
		int32_t moveSpecialDamage = 0;
		int32_t specialDefense = 0;
		int32_t physicalDefense = 0;
		
		int32_t minimumLevel = 0;
		
		int32_t hasShiny = 0;
		int32_t hasMega = 0;
		int32_t dexEntry = 0;
		int32_t portraitId = 0;

		std::string funcao = "";

		bool hiddenHealth = false;
		bool noMove = false;
		MonstersEvent_t eventType = MONSTERS_EVENT_NONE;
	};

	public:
		MonsterType() = default;

		// non-copyable
		MonsterType(const MonsterType&) = delete;
		MonsterType& operator=(const MonsterType&) = delete;

		bool loadCallback(LuaScriptInterface* scriptInterface);

		std::string name;
		std::string rank;
		std::string nameDescription;
		NameColor_t nameColor = NAMECOLOR_GREEN;

		MonsterInfo info;

		void addEvolution(evolutionBlock_t evolution) {
			info.evolutions.push_back(evolution);
		}

		int64_t getSpellPower(std::string spellName, bool wild) {
			if (wild) {

				for (auto &it : info.attackSpells) {
					if (it.name == spellName) {
						return it.power;
					}
				}

			} else {

				for (auto &it : info.moves) {
					if (it.name == spellName) {
						return it.power;
					}
				}

			}

			return 0;
		}

		void loadLoot(MonsterType* monsterType, LootBlock lootblock);
};

class MonsterSpell
{
	public:
		MonsterSpell() = default;

		MonsterSpell(const MonsterSpell&) = delete;
		MonsterSpell& operator=(const MonsterSpell&) = delete;

		std::string name = "";
		std::string scriptName = "";

		uint8_t chance = 100;
		uint8_t range = 0;

		uint32_t interval = 2000;

		int32_t minCombatValue = 0;
		int32_t maxCombatValue = 0;
		int32_t attack = 0;
		int32_t skill = 0;
		int32_t length = 0;
		int32_t level = 0;
		int32_t spread = 0;
		int32_t radius = 0;
		int32_t conditionMinDamage = 0;
		int32_t conditionMaxDamage = 0;
		int32_t conditionStartDamage = 0;
		int32_t tickInterval = 0;
		int32_t speedChange = 0;
		int32_t duration = 0;
		uint16_t power = 0;


		bool isScripted = false;
		bool needTarget = false;
		bool needDirection = false;
		bool combatSpell = false;
		bool isMelee = false;
		bool isPassive = false;

		Outfit_t outfit = {};
		ShootType_t shoot = CONST_ANI_NONE;
		MagicEffectClasses effect = CONST_ME_NONE;
		ConditionType_t conditionType = CONDITION_NONE;
		CombatType_t combatType = COMBAT_UNDEFINEDDAMAGE;
};

class Monsters
{
	public:
		Monsters() = default;
		// non-copyable
		Monsters(const Monsters&) = delete;
		Monsters& operator=(const Monsters&) = delete;

		// bool loadFromXml(bool reloading = false);
		bool isLoaded() const {
			return loaded;
		}
		bool reload();

		std::vector<std::string> getMonstersName() { //pota
			return allMonsters;
		}

		MonsterType* getMonsterType(const std::string& name);
		void addMonsterType(const std::string& name, MonsterType* mType);
		bool deserializeSpell(MonsterSpell* spell, spellBlock_t& sb, const std::string& description = "");

		std::unique_ptr<LuaScriptInterface> scriptInterface;
		std::map<std::string, MonsterType> monsters;
		std::vector<std::string> allMonsters;
	private:
		ConditionDamage* getDamageCondition(ConditionType_t conditionType,
		                                    int32_t maxDamage, int32_t minDamage, int32_t startDamage, uint32_t tickInterval);

		void loadLootContainer(const pugi::xml_node& node, LootBlock&);
		bool loadLootItem(const pugi::xml_node& node, LootBlock&);



		bool loaded = false;
};

#endif
