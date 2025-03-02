#include "otpch.h"

#include "duelist.h"
#include "monster.h"
#include "game.h"
#include "events.h"
#include "configmanager.h"

extern Game g_game;
extern ConfigManager g_config;
extern Events* g_events;

uint32_t Duelist::duelistAutoID = 0x80000000;

Duelist* Duelist::createDuelist(const std::string& name, const DuelistInfo& info)
{
	return new Duelist(name, info);
}

Duelist::Duelist(const std::string& name, const DuelistInfo& info) : name(name)
{
	nameDescription = name;
    defaultOutfit = info.outfit;
    currentOutfit = info.outfit;
    strDescription = info.description;
    health = info.health;
    healthMax = info.maxHealth;
    baseSpeed = info.speed;
	
	minTargetDist = info.minTargetDist;
	maxTargetDist = info.maxTargetDist;
	pokemons = info.pokemons;
	corpse = info.corpse;
	experience = info.experience;

	startDuelVoices = info.startDuelVoices;
	deathDuelVoices = info.deathDuelVoices;
	fleeingVoices = info.fleeingVoices;
}

Duelist::~Duelist()
{
	clearTargetList();
	clearFriendList();
}

bool Duelist::canUseAttack(const Position& pos, const Creature* target) const
{   
    const Position& targetPos = target->getPosition();
	return g_game.isSightClear(pos, targetPos, true);;
}

void Duelist::addList()
{
	g_game.addDuelist(this);
}

void Duelist::removeList()
{
	g_game.removeDuelist(this);
}

bool Duelist::canSee(const Position& pos) const
{
	return Creature::canSee(getPosition(), pos);
}

void Duelist::onThinkTarget([[maybe_unused]] uint32_t interval)
{
	if (!attackedCreature) {
		searchTarget(TARGETSEARCH_NEAREST);
	}
}

void Duelist::onWalk()
{
	Creature::onWalk();
}

bool Duelist::isFriend(const Creature* creature) const
{
	if (creature->getMonster() && !creature->isSummon()) {
		return true;
	}

	return false;
}

bool Duelist::isOpponent(const Creature* creature) const
{	
	if (creature->getMonster() && !creature->isSummon()) {
		return false;
	}
	
	if (creature->getSummonCount() > 0) {
		return false;
	}

	if (contractPlayer > 0) {
	    if (const Player* master = creature->getMaster() ? creature->getMaster()->getPlayer() : nullptr) {  
	        if (master->getGUID() == contractPlayer) {
	            return true;
	        } else {
	            return false;
	        }
	    } else if (const Player* player = creature->getPlayer()) {
	        if (player->getGUID() == contractPlayer) {
	            return true;
	        } else {
	            return false;
	        }
	    }
	}

	if (creature->getMonster() && creature->isSummon() && creature->getMaster()->getPlayer() && !creature->getMonster()->isMonsterGuardian()) {
		return true;
	}

	return false;
}

bool Duelist::isTarget(const Creature* creature) const
{
	if (creature->isRemoved()) {
	    return false;
	}

	if (!creature->isAttackable()) {
	    return false;
	}

	if (creature->getZone() == ZONE_PROTECTION) {
	    return false;
	}

	if (!canSeeCreature(creature)) {
	    return false;
	}

	const Monster* monster = creature->getMonster();
	if ((monster && !monster->isSummon())) {
		return false;
	}

	if (creature->getPosition().z != getPosition().z) {
		return false;
	}

	return true;
}

bool Duelist::selectTarget(Creature* creature)
{

	if (!isTarget(creature)) {
		return false;
	}

	auto it = std::find(targetList.begin(), targetList.end(), creature);
	if (it == targetList.end()) {
		return false;
	}

	if (creature->getPlayer() && creature->getPlayer()->getSummonCount() > 0) {
		return false;
	}

	if (setAttackedCreature(creature)) {
		g_dispatcher.addTask(createTask(std::bind(&Game::checkCreatureAttack, &g_game, getID())));
	}

	g_game.internalCreatureSay(this, TALKTYPE_MONSTER_SAY, getRandomStartDuelVoice(), false);
	
	return setFollowCreature(creature->isSummon() ? creature->getMaster() : creature);
}

bool Duelist::searchTarget(TargetSearchType_t searchType /*= TARGETSEARCH_DEFAULT*/)
{
	std::list<Creature*> resultList;
	const Position& myPos = getPosition();

	for (Creature* creature : targetList) {
		if (followCreature != creature && isTarget(creature)) {
			if (searchType == TARGETSEARCH_RANDOM || canUseAttack(myPos, creature)) {
				resultList.push_back(creature);
			}
		}
	}

	switch (searchType) {
		case TARGETSEARCH_NEAREST: {
			Creature* target = nullptr;
			if (!resultList.empty()) {
				auto it = resultList.begin();
				target = *it;

				if (++it != resultList.end()) {
					const Position& targetPosition = target->getPosition();
					int32_t minRange = Position::getDistanceX(myPos, targetPosition) + Position::getDistanceY(myPos, targetPosition);
					do {
						const Position& pos = (*it)->getPosition();

						int32_t distance = Position::getDistanceX(myPos, pos) + Position::getDistanceY(myPos, pos);
						if (distance < minRange) {
							target = *it;
							minRange = distance;
						}
					} while (++it != resultList.end());
				}
			} else {
				int32_t minRange = std::numeric_limits<int32_t>::max();
				for (Creature* creature : targetList) {
					if (!isTarget(creature)) {
						continue;
					}

					const Position& pos = creature->getPosition();
					int32_t distance = Position::getDistanceX(myPos, pos) + Position::getDistanceY(myPos, pos);
					if (distance < minRange) {
						target = creature;
						minRange = distance;
					}
				}
			}

			if (target && selectTarget(target)) {
				return true;
			}
			break;
		}

		case TARGETSEARCH_DEFAULT:
		case TARGETSEARCH_ATTACKRANGE:
		case TARGETSEARCH_RANDOM:
		default: {
			if (!resultList.empty()) {
				auto it = resultList.begin();
				std::advance(it, uniform_random(0, resultList.size() - 1));
				return selectTarget(*it);
			}

			if (searchType == TARGETSEARCH_ATTACKRANGE) {
				return false;
			}

			break;
		}
	}

	//lets just pick the first target in the list
	for (Creature* target : targetList) {
		if (followCreature != target && selectTarget(target)) {
			return true;
		}
	}
	return false;
}

void Duelist::setIdle(bool idle)
{
	if (isRemoved() || getHealth() <= 0) {
		return;
	}

	isIdle = idle;

	if (!isIdle) {
		g_game.addCreatureCheck(this);
	} else {
		clearTargetList();
		clearFriendList();
		Game::removeCreatureCheck(this);
	}
}

void Duelist::updateIdleStatus()
{
	bool idle = false;

	if (!isSummon() && targetList.empty()) {
		// check if there are aggressive conditions
		idle = std::find_if(conditions.begin(), conditions.end(),
		                    [](Condition* condition) { return condition->isAggressive(); }) == conditions.end();
	}

	if (contractPlayer > 0) {
		idle = false;
	}

	setIdle(idle);
}

void Duelist::onAddCondition(ConditionType_t type)
{
	if (type == CONDITION_FIRE || type == CONDITION_ENERGY || type == CONDITION_POISON) {
		updateMapCache();
	}

	updateIdleStatus();
}

void Duelist::onEndCondition(ConditionType_t type)
{
	if (type == CONDITION_FIRE || type == CONDITION_ENERGY || type == CONDITION_POISON) {
		updateMapCache();
	}

	updateIdleStatus();
}

void Duelist::onThink(uint32_t interval)
{
    
	Creature::onThink(interval);

	updateIdleStatus();

	if (!isIdle) {

		addEventWalk();

		if (!targetList.empty()) {
			if (!followCreature || !hasFollowPath) {
				searchTarget();
			} else if (isFleeing()) {
				if (attackedCreature && !canUseAttack(getPosition(), attackedCreature)) {
					searchTarget(TARGETSEARCH_ATTACKRANGE);
				}
			}
		}

		onThinkTarget(interval);

		if (isFleeing()) {
			if (uniform_random(1, 100) <= 40) {
				g_game.internalCreatureSay(this, TALKTYPE_MONSTER_SAY, getRandomFleeingVoice(), false);
			}
		}

		if (summons.size() < 1) {
			summonRandomPokemon();
		}
	}
	
}

bool Duelist::canWalkTo(Position pos, Direction direction) const
{
	pos = getNextPosition(direction, pos);

	if (getWalkCache(pos) == 0) {
		return false;
	}

	Tile* tile = g_game.map.getTile(pos);
	if (tile && tile->getTopVisibleCreature(this) == nullptr && tile->queryAdd(0, *this, 1, FLAG_PATHFINDING) == RETURNVALUE_NOERROR) {
		return true;
	}

    return false;
}

bool Duelist::getNextStep(Direction& direction, uint32_t& flags)
{
	if (isIdle || getHealth() <= 0) {
		//we dont have anyone watching might aswell stop walking
		eventWalk = 0;
		return false;
	}

	bool result = false;
	if ((!followCreature || !hasFollowPath) && !isSummon()) {
		if (getTimeSinceLastMove() > 1000) {
			//choose a random direction
			result = getRandomStep(getPosition(), direction);
		}
	} else if (followCreature) {
		result = Creature::getNextStep(direction, flags);
		if (result) {
			flags |= FLAG_PATHFINDING;
		} else {
			//target dancing
			if (attackedCreature && attackedCreature == followCreature) {
				if (isFleeing()) {
					result = getDanceStep(getPosition(), direction, false, false);
				} else if (35 < static_cast<uint32_t>(uniform_random(1, 100))) {
					result = getDanceStep(getPosition(), direction);
				}
			}
		}
	}

	return result;
}

bool Duelist::getRandomStep(const Position& creaturePos, Direction& direction) const
{
	static std::vector<Direction> dirList{
			DIRECTION_NORTH,
		DIRECTION_WEST, DIRECTION_EAST,
			DIRECTION_SOUTH
	};
	std::shuffle(dirList.begin(), dirList.end(), getRandomGenerator());

	for (Direction dir : dirList) {
		if (canWalkTo(creaturePos, dir)) {
			direction = dir;
			return true;
		}
	}
	return false;
}

bool Duelist::getDanceStep(const Position& creaturePos, Direction& direction,
                           bool keepAttack /*= true*/, bool keepDistance /*= true*/)
{
	bool canDoAttackNow = canUseAttack(creaturePos, attackedCreature);

	assert(attackedCreature != nullptr);
	const Position& centerPos = attackedCreature->getPosition();

	int_fast32_t offset_x = Position::getOffsetX(creaturePos, centerPos);
	int_fast32_t offset_y = Position::getOffsetY(creaturePos, centerPos);

	int_fast32_t distance_x = std::abs(offset_x);
	int_fast32_t distance_y = std::abs(offset_y);

	uint32_t centerToDist = std::max<uint32_t>(distance_x, distance_y);

	std::vector<Direction> dirList;

	if (!keepDistance || offset_y >= 0) {
		uint32_t tmpDist = std::max<uint32_t>(distance_x, std::abs((creaturePos.getY() - 1) - centerPos.getY()));
		if (tmpDist == centerToDist && canWalkTo(creaturePos, DIRECTION_NORTH)) {
			bool result = true;

			if (keepAttack) {
				result = (!canDoAttackNow || canUseAttack(Position(creaturePos.x, creaturePos.y - 1, creaturePos.z), attackedCreature));
			}

			if (result) {
				dirList.push_back(DIRECTION_NORTH);
			}
		}
	}

	if (!keepDistance || offset_y <= 0) {
		uint32_t tmpDist = std::max<uint32_t>(distance_x, std::abs((creaturePos.getY() + 1) - centerPos.getY()));
		if (tmpDist == centerToDist && canWalkTo(creaturePos, DIRECTION_SOUTH)) {
			bool result = true;

			if (keepAttack) {
				result = (!canDoAttackNow || canUseAttack(Position(creaturePos.x, creaturePos.y + 1, creaturePos.z), attackedCreature));
			}

			if (result) {
				dirList.push_back(DIRECTION_SOUTH);
			}
		}
	}

	if (!keepDistance || offset_x <= 0) {
		uint32_t tmpDist = std::max<uint32_t>(std::abs((creaturePos.getX() + 1) - centerPos.getX()), distance_y);
		if (tmpDist == centerToDist && canWalkTo(creaturePos, DIRECTION_EAST)) {
			bool result = true;

			if (keepAttack) {
				result = (!canDoAttackNow || canUseAttack(Position(creaturePos.x + 1, creaturePos.y, creaturePos.z), attackedCreature));
			}

			if (result) {
				dirList.push_back(DIRECTION_EAST);
			}
		}
	}

	if (!keepDistance || offset_x >= 0) {
		uint32_t tmpDist = std::max<uint32_t>(std::abs((creaturePos.getX() - 1) - centerPos.getX()), distance_y);
		if (tmpDist == centerToDist && canWalkTo(creaturePos, DIRECTION_WEST)) {
			bool result = true;

			if (keepAttack) {
				result = (!canDoAttackNow || canUseAttack(Position(creaturePos.x - 1, creaturePos.y, creaturePos.z), attackedCreature));
			}

			if (result) {
				dirList.push_back(DIRECTION_WEST);
			}
		}
	}

	if (!dirList.empty()) {
		std::shuffle(dirList.begin(), dirList.end(), getRandomGenerator());
		direction = dirList[uniform_random(0, dirList.size() - 1)];
		return true;
	}
	return false;
}

bool Duelist::getDistanceStep(const Position& targetPos, Direction& direction, bool flee /* = false */)
{
	const Position& creaturePos = getPosition();

	int_fast32_t dx = Position::getDistanceX(creaturePos, targetPos);
	int_fast32_t dy = Position::getDistanceY(creaturePos, targetPos);

	int32_t distance = std::max<int32_t>(dx, dy);

	if (!flee && (distance > minTargetDist || !g_game.isSightClear(creaturePos, targetPos, true))) {
		return false; // let the A* calculate it
	} else if (!flee && distance == minTargetDist) {
		return true; // we don't really care here, since it's what we wanted to reach (a dancestep will take of dancing in that position)
	}

	int_fast32_t offsetx = Position::getOffsetX(creaturePos, targetPos);
	int_fast32_t offsety = Position::getOffsetY(creaturePos, targetPos);

	if (dx <= 1 && dy <= 1) {
		//seems like a target is near, it this case we need to slow down our movements (as a monster)
		if (stepDuration < 2) {
			stepDuration++;
		}
	} else if (stepDuration > 0) {
		stepDuration--;
	}

	if (offsetx == 0 && offsety == 0) {
		return getRandomStep(creaturePos, direction); // player is "on" the monster so let's get some random step and rest will be taken care later.
	}

	if (dx == dy) {
		//player is diagonal to the monster
		if (offsetx >= 1 && offsety >= 1) {
			// player is NW
			//escape to SE, S or E [and some extra]
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (s && e) {
				direction = boolean_random() ? DIRECTION_SOUTH : DIRECTION_EAST;
				return true;
			} else if (s) {
				direction = DIRECTION_SOUTH;
				return true;
			} else if (e) {
				direction = DIRECTION_EAST;
				return true;
			} else if (canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				direction = DIRECTION_SOUTHEAST;
				return true;
			}

			/* fleeing */
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);

			if (flee) {
				if (n && w) {
					direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_WEST;
					return true;
				} else if (n) {
					direction = DIRECTION_NORTH;
					return true;
				} else if (w) {
					direction = DIRECTION_WEST;
					return true;
				}
			}

			/* end of fleeing */

			if (w && canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				direction = DIRECTION_WEST;
			} else if (n && canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				direction = DIRECTION_NORTH;
			}

			return true;
		} else if (offsetx <= -1 && offsety <= -1) {
			//player is SE
			//escape to NW , W or N [and some extra]
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);

			if (w && n) {
				direction = boolean_random() ? DIRECTION_WEST : DIRECTION_NORTH;
				return true;
			} else if (w) {
				direction = DIRECTION_WEST;
				return true;
			} else if (n) {
				direction = DIRECTION_NORTH;
				return true;
			}

			if (canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				direction = DIRECTION_NORTHWEST;
				return true;
			}

			/* fleeing */
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (flee) {
				if (s && e) {
					direction = boolean_random() ? DIRECTION_SOUTH : DIRECTION_EAST;
					return true;
				} else if (s) {
					direction = DIRECTION_SOUTH;
					return true;
				} else if (e) {
					direction = DIRECTION_EAST;
					return true;
				}
			}

			/* end of fleeing */

			if (s && canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				direction = DIRECTION_SOUTH;
			} else if (e && canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				direction = DIRECTION_EAST;
			}

			return true;
		} else if (offsetx >= 1 && offsety <= -1) {
			//player is SW
			//escape to NE, N, E [and some extra]
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);
			if (n && e) {
				direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_EAST;
				return true;
			} else if (n) {
				direction = DIRECTION_NORTH;
				return true;
			} else if (e) {
				direction = DIRECTION_EAST;
				return true;
			}

			if (canWalkTo(creaturePos, DIRECTION_NORTHEAST)) {
				direction = DIRECTION_NORTHEAST;
				return true;
			}

			/* fleeing */
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);

			if (flee) {
				if (s && w) {
					direction = boolean_random() ? DIRECTION_SOUTH : DIRECTION_WEST;
					return true;
				} else if (s) {
					direction = DIRECTION_SOUTH;
					return true;
				} else if (w) {
					direction = DIRECTION_WEST;
					return true;
				}
			}

			/* end of fleeing */

			if (w && canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				direction = DIRECTION_WEST;
			} else if (s && canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				direction = DIRECTION_SOUTH;
			}

			return true;
		} else if (offsetx <= -1 && offsety >= 1) {
			// player is NE
			//escape to SW, S, W [and some extra]
			bool w = canWalkTo(creaturePos, DIRECTION_WEST);
			bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
			if (w && s) {
				direction = boolean_random() ? DIRECTION_WEST : DIRECTION_SOUTH;
				return true;
			} else if (w) {
				direction = DIRECTION_WEST;
				return true;
			} else if (s) {
				direction = DIRECTION_SOUTH;
				return true;
			} else if (canWalkTo(creaturePos, DIRECTION_SOUTHWEST)) {
				direction = DIRECTION_SOUTHWEST;
				return true;
			}

			/* fleeing */
			bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
			bool e = canWalkTo(creaturePos, DIRECTION_EAST);

			if (flee) {
				if (n && e) {
					direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_EAST;
					return true;
				} else if (n) {
					direction = DIRECTION_NORTH;
					return true;
				} else if (e) {
					direction = DIRECTION_EAST;
					return true;
				}
			}

			/* end of fleeing */

			if (e && canWalkTo(creaturePos, DIRECTION_SOUTHEAST)) {
				direction = DIRECTION_EAST;
			} else if (n && canWalkTo(creaturePos, DIRECTION_NORTHWEST)) {
				direction = DIRECTION_NORTH;
			}

			return true;
		}
	}

	//Now let's decide where the player is located to the monster (what direction) so we can decide where to escape.
	if (dy > dx) {
		Direction playerDir = offsety < 0 ? DIRECTION_SOUTH : DIRECTION_NORTH;
		switch (playerDir) {
			case DIRECTION_NORTH: {
				// Player is to the NORTH, so obviously we need to check if we can go SOUTH, if not then let's choose WEST or EAST and again if we can't we need to decide about some diagonal movements.
				if (canWalkTo(creaturePos, DIRECTION_SOUTH)) {
					direction = DIRECTION_SOUTH;
					return true;
				}

				bool w = canWalkTo(creaturePos, DIRECTION_WEST);
				bool e = canWalkTo(creaturePos, DIRECTION_EAST);
				if (w && e && offsetx == 0) {
					direction = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
					return true;
				} else if (w && offsetx <= 0) {
					direction = DIRECTION_WEST;
					return true;
				} else if (e && offsetx >= 0) {
					direction = DIRECTION_EAST;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (w && e) {
						direction = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
						return true;
					} else if (w) {
						direction = DIRECTION_WEST;
						return true;
					} else if (e) {
						direction = DIRECTION_EAST;
						return true;
					}
				}

				/* end of fleeing */

				bool sw = canWalkTo(creaturePos, DIRECTION_SOUTHWEST);
				bool se = canWalkTo(creaturePos, DIRECTION_SOUTHEAST);
				if (sw || se) {
					// we can move both dirs
					if (sw && se) {
						direction = boolean_random() ? DIRECTION_SOUTHWEST : DIRECTION_SOUTHEAST;
					} else if (w) {
						direction = DIRECTION_WEST;
					} else if (sw) {
						direction = DIRECTION_SOUTHWEST;
					} else if (e) {
						direction = DIRECTION_EAST;
					} else if (se) {
						direction = DIRECTION_SOUTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_NORTH)) {
					// towards player, yea
					direction = DIRECTION_NORTH;
					return true;
				}

				/* end of fleeing */
				break;
			}

			case DIRECTION_SOUTH: {
				if (canWalkTo(creaturePos, DIRECTION_NORTH)) {
					direction = DIRECTION_NORTH;
					return true;
				}

				bool w = canWalkTo(creaturePos, DIRECTION_WEST);
				bool e = canWalkTo(creaturePos, DIRECTION_EAST);
				if (w && e && offsetx == 0) {
					direction = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
					return true;
				} else if (w && offsetx <= 0) {
					direction = DIRECTION_WEST;
					return true;
				} else if (e && offsetx >= 0) {
					direction = DIRECTION_EAST;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (w && e) {
						direction = boolean_random() ? DIRECTION_WEST : DIRECTION_EAST;
						return true;
					} else if (w) {
						direction = DIRECTION_WEST;
						return true;
					} else if (e) {
						direction = DIRECTION_EAST;
						return true;
					}
				}

				/* end of fleeing */

				bool nw = canWalkTo(creaturePos, DIRECTION_NORTHWEST);
				bool ne = canWalkTo(creaturePos, DIRECTION_NORTHEAST);
				if (nw || ne) {
					// we can move both dirs
					if (nw && ne) {
						direction = boolean_random() ? DIRECTION_NORTHWEST : DIRECTION_NORTHEAST;
					} else if (w) {
						direction = DIRECTION_WEST;
					} else if (nw) {
						direction = DIRECTION_NORTHWEST;
					} else if (e) {
						direction = DIRECTION_EAST;
					} else if (ne) {
						direction = DIRECTION_NORTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_SOUTH)) {
					// towards player, yea
					direction = DIRECTION_SOUTH;
					return true;
				}

				/* end of fleeing */
				break;
			}

			default:
				break;
		}
	} else {
		Direction playerDir = offsetx < 0 ? DIRECTION_EAST : DIRECTION_WEST;
		switch (playerDir) {
			case DIRECTION_WEST: {
				if (canWalkTo(creaturePos, DIRECTION_EAST)) {
					direction = DIRECTION_EAST;
					return true;
				}

				bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
				bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
				if (n && s && offsety == 0) {
					direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
					return true;
				} else if (n && offsety <= 0) {
					direction = DIRECTION_NORTH;
					return true;
				} else if (s && offsety >= 0) {
					direction = DIRECTION_SOUTH;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (n && s) {
						direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
						return true;
					} else if (n) {
						direction = DIRECTION_NORTH;
						return true;
					} else if (s) {
						direction = DIRECTION_SOUTH;
						return true;
					}
				}

				/* end of fleeing */

				bool se = canWalkTo(creaturePos, DIRECTION_SOUTHEAST);
				bool ne = canWalkTo(creaturePos, DIRECTION_NORTHEAST);
				if (se || ne) {
					if (se && ne) {
						direction = boolean_random() ? DIRECTION_SOUTHEAST : DIRECTION_NORTHEAST;
					} else if (s) {
						direction = DIRECTION_SOUTH;
					} else if (se) {
						direction = DIRECTION_SOUTHEAST;
					} else if (n) {
						direction = DIRECTION_NORTH;
					} else if (ne) {
						direction = DIRECTION_NORTHEAST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_WEST)) {
					// towards player, yea
					direction = DIRECTION_WEST;
					return true;
				}

				/* end of fleeing */
				break;
			}

			case DIRECTION_EAST: {
				if (canWalkTo(creaturePos, DIRECTION_WEST)) {
					direction = DIRECTION_WEST;
					return true;
				}

				bool n = canWalkTo(creaturePos, DIRECTION_NORTH);
				bool s = canWalkTo(creaturePos, DIRECTION_SOUTH);
				if (n && s && offsety == 0) {
					direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
					return true;
				} else if (n && offsety <= 0) {
					direction = DIRECTION_NORTH;
					return true;
				} else if (s && offsety >= 0) {
					direction = DIRECTION_SOUTH;
					return true;
				}

				/* fleeing */
				if (flee) {
					if (n && s) {
						direction = boolean_random() ? DIRECTION_NORTH : DIRECTION_SOUTH;
						return true;
					} else if (n) {
						direction = DIRECTION_NORTH;
						return true;
					} else if (s) {
						direction = DIRECTION_SOUTH;
						return true;
					}
				}

				/* end of fleeing */

				bool nw = canWalkTo(creaturePos, DIRECTION_NORTHWEST);
				bool sw = canWalkTo(creaturePos, DIRECTION_SOUTHWEST);
				if (nw || sw) {
					if (nw && sw) {
						direction = boolean_random() ? DIRECTION_NORTHWEST : DIRECTION_SOUTHWEST;
					} else if (n) {
						direction = DIRECTION_NORTH;
					} else if (nw) {
						direction = DIRECTION_NORTHWEST;
					} else if (s) {
						direction = DIRECTION_SOUTH;
					} else if (sw) {
						direction = DIRECTION_SOUTHWEST;
					}
					return true;
				}

				/* fleeing */
				if (flee && canWalkTo(creaturePos, DIRECTION_EAST)) {
					// towards player, yea
					direction = DIRECTION_EAST;
					return true;
				}

				/* end of fleeing */
				break;
			}

			default:
				break;
		}
	}

	return true;
}

void Duelist::death(Creature*)
{
	g_game.internalCreatureSay(this, TALKTYPE_MONSTER_SAY, getRandomDeathDuelVoice(), false);
	setAttackedCreature(nullptr);

	for (Creature* summon : summons) {
		summon->changeHealth(-summon->getHealth());
		summon->setMaster(nullptr);
		summon->decrementReferenceCounter();
	}
	summons.clear();

	clearTargetList();
	clearFriendList();
	onIdleStatus();
}

void Duelist::addFriend(Creature* creature)
{
	assert(creature != this);
	auto result = friendList.insert(creature);
	if (result.second) {
		creature->incrementReferenceCounter();
	}
}

void Duelist::removeFriend(Creature* creature)
{
	auto it = friendList.find(creature);
	if (it != friendList.end()) {
		creature->decrementReferenceCounter();
		friendList.erase(it);
	}
}

void Duelist::addTarget(Creature* creature, bool pushFront/* = false*/)
{
	assert(creature != this);
	if (std::find(targetList.begin(), targetList.end(), creature) == targetList.end()) {
		creature->incrementReferenceCounter();
		if (pushFront) {
			targetList.push_front(creature);
		} else {
			targetList.push_back(creature);
		}
	}
}

void Duelist::removeTarget(Creature* creature)
{
	auto it = std::find(targetList.begin(), targetList.end(), creature);
	if (it != targetList.end()) {
		creature->decrementReferenceCounter();
		targetList.erase(it);
	}
}

void Duelist::updateTargetList()
{
	
	auto friendIterator = friendList.begin();
	while (friendIterator != friendList.end()) {
		Creature* creature = *friendIterator;
		if (creature->getHealth() <= 0 || !canSee(creature->getPosition())) {
			creature->decrementReferenceCounter();
			friendIterator = friendList.erase(friendIterator);
		} else {
			++friendIterator;
		}
	}

	auto targetIterator = targetList.begin();
	while (targetIterator != targetList.end()) {
		Creature* creature = *targetIterator;
		if (creature->getHealth() <= 0 || !canSee(creature->getPosition())) {
			creature->decrementReferenceCounter();
			targetIterator = targetList.erase(targetIterator);
		} else {
			++targetIterator;
		}
	}

	SpectatorVec spectators;
	g_game.map.getSpectators(spectators, position, true);
	spectators.erase(this);
	for (Creature* spectator : spectators) {
		onCreatureFound(spectator);
	}
}

void Duelist::clearTargetList()
{
	for (Creature* creature : targetList) {
		creature->decrementReferenceCounter();
	}
	targetList.clear();
}

void Duelist::clearFriendList()
{
	for (Creature* creature : friendList) {
		creature->decrementReferenceCounter();
	}
	friendList.clear();
}

void Duelist::onCreatureFound(Creature* creature, bool pushFront/* = false*/)
{

    if (!creature) {
		return;
	}

	if (creature == this) {
		return;
	}

	if (!canSee(creature->getPosition())) {
		return;
	}

	if (isFriend(creature)) {
		addFriend(creature);
	}
	
	if (isOpponent(creature)) {
		addTarget(creature, pushFront);
	}

	updateIdleStatus();
}

void Duelist::onCreatureEnter(Creature* creature)
{
	onCreatureFound(creature, true);
}

void Duelist::onCreatureLeave(Creature* creature)
{
	//update friendList
	if (isFriend(creature)) {
		removeFriend(creature);
	}

	//update targetList
	if (isOpponent(creature)) {
		removeTarget(creature);
		if (targetList.empty()) {
			updateIdleStatus();
		}
	}
}

void Duelist::updateLookDirection()
{
	Direction newDir = getDirection();

	if (hasCondition(CONDITION_STUN)) 
		return;

	if (attackedCreature) {
		const Position& pos = getPosition();
		const Position& attackedCreaturePos = attackedCreature->getPosition();
		int_fast32_t offsetx = Position::getOffsetX(attackedCreaturePos, pos);
		int_fast32_t offsety = Position::getOffsetY(attackedCreaturePos, pos);

		int32_t dx = std::abs(offsetx);
		int32_t dy = std::abs(offsety);
		if (dx > dy) {
			//look EAST/WEST
			if (offsetx < 0) {
				newDir = DIRECTION_WEST;
			} else {
				newDir = DIRECTION_EAST;
			}
		} else if (dx < dy) {
			//look NORTH/SOUTH
			if (offsety < 0) {
				newDir = DIRECTION_NORTH;
			} else {
				newDir = DIRECTION_SOUTH;
			}
		} else {
			Direction dir = getDirection();
			if (offsetx < 0 && offsety < 0) {
				if (dir == DIRECTION_SOUTH) {
					newDir = DIRECTION_WEST;
				} else if (dir == DIRECTION_NORTH) {
					newDir = DIRECTION_WEST;
				} else if (dir == DIRECTION_EAST) {
					newDir = DIRECTION_NORTH;
				}
			} else if (offsetx < 0 && offsety > 0) {
				if (dir == DIRECTION_NORTH) {
					newDir = DIRECTION_WEST;
				} else if (dir == DIRECTION_SOUTH) {
					newDir = DIRECTION_WEST;
				} else if (dir == DIRECTION_EAST) {
					newDir = DIRECTION_SOUTH;
				}
			} else if (offsetx > 0 && offsety < 0) {
				if (dir == DIRECTION_SOUTH) {
					newDir = DIRECTION_EAST;
				} else if (dir == DIRECTION_NORTH) {
					newDir = DIRECTION_EAST;
				} else if (dir == DIRECTION_WEST) {
					newDir = DIRECTION_NORTH;
				}
			} else {
				if (dir == DIRECTION_NORTH) {
					newDir = DIRECTION_EAST;
				} else if (dir == DIRECTION_SOUTH) {
					newDir = DIRECTION_EAST;
				} else if (dir == DIRECTION_WEST) {
					newDir = DIRECTION_SOUTH;
				}
			}
		}
	}

	g_game.internalCreatureTurn(this, newDir);
}

void Duelist::drainHealth(Creature* attacker, int64_t damage)
{
	Creature::drainHealth(attacker, damage);
	if (isInvisible()) {
		removeCondition(CONDITION_INVISIBLE);
	}
}

void Duelist::changeHealth(int64_t healthChange, bool sendHealthChange/* = true*/)
{
	//In case a player with ignore flag set attacks the monster
	setIdle(false);
	Creature::changeHealth(healthChange, sendHealthChange);
}

bool Duelist::challengeCreature(Creature* creature)
{
	if (isSummon()) {
		return false;
	}

	bool result = selectTarget(creature);
	return result;
}

void Duelist::onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos,
                             const Tile* oldTile, const Position& oldPos, bool teleport)
{
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	if (creature == this) {

		updateTargetList();
		updateIdleStatus();

	} else {
		// g_game.internalCreatureSay(this, TALKTYPE_MONSTER_SAY, "Moving creature!", false);
		bool canSeeNewPos = canSee(newPos);
		bool canSeeOldPos = canSee(oldPos);

		if (canSeeNewPos && !canSeeOldPos) {
			onCreatureEnter(creature);
		} else if (!canSeeNewPos && canSeeOldPos) {
			onCreatureLeave(creature);
		}

		updateIdleStatus();

        if (!attackedCreature && isOpponent(creature)) {
			//we have no target lets try pick this ones
			selectTarget(creature);
		}
	}
}

void Duelist::onCreatureAppear(Creature* creature, bool isLogin)
{
	Creature::onCreatureAppear(creature, isLogin);

	if (creature == this) {
		//We just spawned lets look around to see who is there.

		updateTargetList();
		updateIdleStatus();
		summonRandomPokemon();
	} else {
		onCreatureEnter(creature);
	}
}

void Duelist::onRemoveCreature(Creature* creature, bool isLogout)
{
	Creature::onRemoveCreature(creature, isLogout);

	if (creature == this) {
		setIdle(true);
	} else {
		onCreatureLeave(creature);
	}
}

void Duelist::getPathSearchParams(const Creature* creature, FindPathParams& fpp) const
{
    Creature::getPathSearchParams(creature, fpp);

    fpp.minTargetDist = minTargetDist;
    fpp.maxTargetDist = maxTargetDist;

    if (isFleeing()) {
        // Distance should be higher than the client view range (Map::maxClientViewportX/Map::maxClientViewportY)
        fpp.maxTargetDist = Map::maxViewportX;
        fpp.clearSight = false;
        fpp.keepDistance = true;
        fpp.fullPathSearch = false;
    } else {
        fpp.fullPathSearch = true;
    }
}

void Duelist::onFollowCreatureComplete(const Creature* creature)
{
	if (creature) {
		auto it = std::find(targetList.begin(), targetList.end(), creature);
		if (it != targetList.end()) {
			Creature* target = (*it);
			targetList.erase(it);

			if (hasFollowPath) {
				targetList.push_front(target);
			} else if (!isSummon() || isMonsterGuardian()) {
				targetList.push_back(target);
			} else {
				target->decrementReferenceCounter();
			}
		}
	}
}

void Duelist::summonRandomPokemon()
{
    auto& pokemons = this->pokemons;

    if (!pokemons.empty()) {
        // get random pokemon

		uint32_t randomIndex = rand() % pokemons.size();
        auto it = std::next(pokemons.begin(), randomIndex);
        MonsterType* summonDuelist = *it;

        // create & place moster
        Monster* monster = new Monster(summonDuelist, 0, 0);
       	if (!g_game.placeCreature(monster, getPosition(), false, true)) {
			std::cout << "Failed to place monster 1" << std::endl;
			if(!g_game.placeCreature(monster, getPosition(), true, true)){
				std::cout << "Failed to place monster 2" << std::endl;
				delete monster;
				return;
			}
		}

        // clean list
        pokemons.erase(it);

        // summon
        monster->convinceCreature(this);
        g_game.updateCreatureType(monster);

		uint16_t effectId = pokeballEffects[rand() % pokeballEffects.size()];

        g_game.addMagicEffect(monster->getPosition(), effectId);
		monster->setEffectId(effectId);

		if (attackedCreature)
			monster->selectTarget(attackedCreature);
    }
}

void Duelist::doAttacking([[maybe_unused]] uint32_t interval)
{
	if (!attackedCreature) {
		return;
	}

	bool updateLook = true;

	// const Position& myPos = getPosition();
	// const Position& targetPos = attackedCreature->getPosition();

	if (updateLook) {
		updateLookDirection();
	}
}

Item* Duelist::getCorpse(Creature* lastHitCreature, Creature* mostDamageCreature)
{
	Item* corpse = Creature::getCorpse(lastHitCreature, mostDamageCreature);
	if (corpse) {
		if (mostDamageCreature) {
			if (mostDamageCreature->getPlayer()) {
				corpse->setCorpseOwner(mostDamageCreature->getID());
			} else {
				const Creature* mostDamageCreatureMaster = mostDamageCreature->getMaster();
				if (mostDamageCreatureMaster && mostDamageCreatureMaster->getPlayer()) {
					corpse->setCorpseOwner(mostDamageCreatureMaster->getID());
				}
			}
		}
	}
	return corpse;
}
