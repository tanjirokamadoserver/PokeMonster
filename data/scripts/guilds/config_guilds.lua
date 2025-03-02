GUILDS_CFG = {
  EXTOPCODE = 99, -- extended opcode id
  OPCODE = 98, -- normal opcode id (used in sending all wars kills), also check modules/gamelib/protocol.lua in client
  --
  CREATION_REQUIRED_LEVEL = 1, -- required level to create new guild
  NAME_MIN_LENGTH = 4, -- minimum characters for guild name
  NAME_MAX_LENGTH = 16, -- maximum characters for guild name
  NAME_BLACKLIST = {"fuck", "cunt", "shit", "dick", "bitch"}, -- guild name can not contain these words
  --
  GOLD_FOR_LEVEL_VALUE = 4, -- used to calculate required gold for next guild level
  --
  MEMBERS_START = 10, -- maximum members in level 1 guild
  MEMBERS_PER_LEVEL = 5, -- maximum members per new level
  --
  -- guild will have to wait this amount of time before they can change buffs again
  BUFFS_SAVE_DELAY = {
    WEEKS = 0,
    DAYS = 0,
    HOURS = 0,
    MINUTES = 0,
    SECONDS = 15
  },
  --
  TOP_GUILDS_CACHE = 2 * 60, -- in seconds, how often Top Guilds should update
  -- score points used to determine which guild is "the best"
  SCORE_GUILD_LEVEL = 6, -- points per guild level
  SCORE_MEMBERS_COUNT = 1, -- points per guild member
  SCORE_COMBINED_LEVELS = 0.1, -- points per combined level of all members
  SCORE_WON_WARS = 10, -- points per won war
  SCORE_LOST_WARS = 5, -- points per lost war (THIS IS USED TO DECREASE THE POINTS)
  GOLD_STORAGE = 5847342, -- !DEPRACATED! used only to merge old storing into new
  WARS = {
    -- minimum and maximum gold that can be bet
    GOLD_BET = {
      MIN = 1000,
      MAX = 10000000
    },
    -- minimum and maximum duration of the war (in days)
    DURATION = {
      MIN = 3,
      MAX = 30
    },
    -- minimum and maximum kills before war ends
    KILLS = {
      MIN = 10,
      MAX = 100
    },
    -- time before war starts after declaration is accepted (or if forced)
    PREP_TIME = {
      WEEKS = 0,
      DAYS = 1,
      HOURS = 0,
      MINUTES = 0,
      SECONDS = 0
    },
    -- cost of declaring forced war
    FORCED_COST = {
      CRYSTAL = 20,
      PLATINUM = 0,
      GOLD = 0
    },
    CAN_LEAVE = false, -- can members leave the guild when at war
    -- Don't edit
    END_TYPE = {
      SURRENDER = 0,
      KILLS = 1,
      EXPIRED = 2
    },
    -- Don't edit
    STATUS = {
      DECLARATION = 0,
      PREPARING = 1,
      STARTED = 2,
      ENDED = 3
    }
  },
  -- Pacifism config
  PACIFISM = {
    NEW_GUILD = {
      ENABLED = true, -- should newly created guilds start with Pacfisit Mode enabled?
      -- duration of free Pacifist Mode for new guilds
      DURATION = {
        WEEKS = 0,
        DAYS = 3,
        HOURS = 0,
        MINUTES = 0,
        SECONDS = 0
      }
    },
    -- Time between last Pacifist Mode and when can it be reactivated
    -- Cooldown applies when Pacifist Mode ends, not starts
    -- If pacifism lasts 5 days and guild ends it after 3 days (by declaring war)
    -- Then cooldown is applied from that time
    -- If cooldown is set to 3 days and duration to 1 week (7 days)
    -- Then total wait time between starting pacifism and reactiavting
    -- Is gonna be 10 days if pacifism doesn't end earlier due to war declaration
    COOLDOWN = {
      WEEKS = 0,
      DAYS = 3,
      HOURS = 0,
      MINUTES = 0,
      SECONDS = 0
    },
    -- Cost of purchasing pacifism
    COST = {
      CRYSTAL = 500,
      PLATINUM = 0,
      GOLD = 0
    },
    -- Duration of pacifism
    DURATION = {
      WEEKS = 1,
      DAYS = 0,
      HOURS = 0,
      MINUTES = 0,
      SECONDS = 0
    },
    -- Don't edit
    INACTIVE = 0,
    ACTIVE = 1,
    EXHAUSTED = 2
  },
  ----------------------------
  --      DO NOT EDIT       --
  --    UNLESS YOU KNOW     --
  --   WHAT YOU ARE DOING   --
  ----------------------------
  MESSAGE_TYPES = {
    JOIN_INVITATION = 1,
    KICKED_OUT = 2,
    JOIN_REQUEST = 3,
    MEMBER_JOINED = 4,
    MEMBER_LEFT = 5,
    GOLD_DEPOSIT = 6,
    WAR_DECLARATION = 7
  },
  PERMISSIONS = {
    ALL = -1,
    INVITE_MEMBERS = 1,
    EDIT_MEMBERS = 2,
    EDIT_ROLES = 3,
    EDIT_SETTINGS = 4,
    MANAGE_GOLD = 5,
    MANAGE_WARS = 6,
    MANAGE_BUFFS = 7,
    LAST = 8
  }
}

function getForcedWarCost()
  local gold = 0

  gold = gold + GUILDS_CFG.WARS.FORCED_COST.CRYSTAL * 10000
  gold = gold + GUILDS_CFG.WARS.FORCED_COST.PLATINUM * 100
  gold = gold + GUILDS_CFG.WARS.FORCED_COST.GOLD

  return gold
end

function getWarPrepTime()
  return parseTimeTable(GUILDS_CFG.WARS.PREP_TIME)
end

function getPacifismCost()
  local gold = 0

  gold = gold + GUILDS_CFG.PACIFISM.COST.CRYSTAL * 10000
  gold = gold + GUILDS_CFG.PACIFISM.COST.PLATINUM * 100
  gold = gold + GUILDS_CFG.PACIFISM.COST.GOLD

  return gold
end

function getPacifismDuration()
  return parseTimeTable(GUILDS_CFG.PACIFISM.DURATION) * 1000
end

function getPacifismCooldown()
  return parseTimeTable(GUILDS_CFG.PACIFISM.COOLDOWN) * 1000
end

function getNewPacifismDuration()
  return parseTimeTable(GUILDS_CFG.PACIFISM.NEW_GUILD.DURATION) * 1000
end

function getBuffsDelayDuration()
  return parseTimeTable(GUILDS_CFG.BUFFS_SAVE_DELAY) * 1000
end

function parseTimeTable(time)
  local duration = 0

  duration = duration + time.WEEKS * 7 * 24 * 60 * 60
  duration = duration + time.DAYS * 24 * 60 * 60
  duration = duration + time.HOURS * 60 * 60
  duration = duration + time.MINUTES * 60
  duration = duration + time.SECONDS

  return duration
end
