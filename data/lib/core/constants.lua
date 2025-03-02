CONTAINER_POSITION = 0xFFFF
CONST_BLINK_CDR = 30
CONST_FLY_FLOOR = 460
CONST_MAX_MAESTRIA = 4
CONST_MAX_STAR = 5
CONST_CHANCE_SKIP_CONDITION = 50
CONST_BOOST_IMMUNITY = 50
CONST_ME_SKIP_CONDITION = 15

CONSTANT_ITEM_DIAMOND = 27635

CONST_ME_CONFUSION = 32
CONST_ME_SILENCE = nil -- corrigir
CONST_ME_FEAR = nil -- corrigir
CONST_ME_BLIND = nil -- ok
CONST_ME_STUN = 32
CONST_ME_SLEEP = 33
CONST_ME_SNARE = nil -- corrigir
CONST_ME_POISON = nil -- ok
CONST_ME_FIRE = nil -- ok
CONST_ME_PARALYZE = 14
CONST_ME_DROWN = nil -- corrigir
CONST_ME_FREEZING = nil -- corrigir
CONST_ME_SEED = nil -- ok

CONST_NEGATIVE_CONDITIONS = {
    CONDITION_SLEEP,
    CONDITION_CONFUSION,
    CONDITION_STUN,
    CONDITION_SILENCE,
    CONDITION_BLIND,
    CONDITION_FEAR,
    CONDITION_SNARE,
    CONDITION_POISON,
    CONDITION_SEED,
    CONDITION_FREEZING,
    CONDITION_DROWN,
    CONDITION_PARALYZE,
    CONDITION_FIRE
}

CONDITION_EFFECTS = {
    [CONDITION_SLEEP] = CONST_ME_SLEEP,
    [CONDITION_CONFUSION] = CONST_ME_CONFUSION,
    [CONDITION_STUN] = CONST_ME_STUN,
    [CONDITION_SILENCE] = CONST_ME_SILENCE,
    [CONDITION_BLIND] = CONST_ME_BLIND,
    [CONDITION_FEAR] = CONST_ME_FEAR,
    [CONDITION_SNARE] = CONST_ME_SNARE,
    [CONDITION_POISON] = CONST_ME_POISON,
    [CONDITION_SEED] = CONST_ME_SEED,
    [CONDITION_FREEZING] = CONST_ME_FREEZING,
    [CONDITION_DROWN] = CONST_ME_DROWN,
    [CONDITION_PARALYZE] = CONST_ME_PARALYZE,
    [CONDITION_FIRE] = CONST_ME_FIRE
}

CONST_CONVERT_CONDITIONS_TO_TEXT = {
    [CONDITION_SLEEP] = "Sleep",
    [CONDITION_CONFUSION] = "Confusion",
    [CONDITION_STUN] = "Stun",
    [CONDITION_SILENCE] = "Silence",
    [CONDITION_BLIND] = "Blind",
    [CONDITION_FEAR] = "Fear",
    [CONDITION_SNARE] = "Snare",
    [CONDITION_POISON] = "Poison",
    [CONDITION_SEED] = "Seed",
    [CONDITION_FREEZING] = "Freezing",
    [CONDITION_DROWN] = "Drown",
    [CONDITION_PARALYZE] = "Paralyze",
    [CONDITION_FIRE] = "Fire"
}

CONST_CONVERT_TEXT_TO_CONDITIONS = {
    ["Sleep"] = CONDITION_SLEEP,
    ["Confusion"] = CONDITION_CONFUSION,
    ["Stun"] = CONDITION_STUN,
    ["Silence"] = CONDITION_SILENCE,
    ["Blind"] = CONDITION_BLIND,
    ["Fear"] = CONDITION_FEAR,
    ["Snare"] = CONDITION_SNARE,
    ["Poison"] = CONDITION_POISON,
    ["Seed"] = CONDITION_SEED,
    ["Freezing"] = CONDITION_FREEZING,
    ["Drown"] = CONDITION_DROWN,
    ["Paralyze"] = CONDITION_PARALYZE,
    ["Fire"] = CONDITION_FIRE
}

CONST_IMMUNITIES_RACE = {
	[RACE_NORMAL] = RACE_GHOST,
	[RACE_GHOST] = RACE_NORMAL,
	[RACE_FIGHTING] = RACE_GHOST,
	[RACE_ELECTRIC] = RACE_GROUND,
	[RACE_POISON] = RACE_STEEL,
	[RACE_GROUND] = RACE_FLYING,
	[RACE_PSYCHIC] = RACE_DARK,
	[RACE_DRAGON] = RACE_FAIRY,
}

CONST_EFFECTIVENESS = {
    [RACE_NORMAL] = {
        noeffect = {RACE_GHOST},
        ineffective = {RACE_ROCK, RACE_STEEL},
        effective = {}
    },
    [RACE_FIRE] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_WATER, RACE_ROCK, RACE_DRAGON},
        effective = {RACE_GRASS, RACE_ICE, RACE_BUG, RACE_STEEL}
    },
    [RACE_WATER] = {
        noeffect = {},
        ineffective = {RACE_WATER, RACE_GRASS, RACE_DRAGON},
        effective = {RACE_FIRE, RACE_GROUND, RACE_ROCK}
    },
    [RACE_ELECTRIC] = {
        noeffect = {RACE_GROUND},
        ineffective = {RACE_ELECTRIC, RACE_GRASS, RACE_DRAGON},
        effective = {RACE_WATER, RACE_FLYING}
    },
    [RACE_GRASS] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_GRASS, RACE_POISON, RACE_FLYING, RACE_BUG, RACE_DRAGON, RACE_STEEL},
        effective = {RACE_WATER, RACE_GROUND, RACE_ROCK}
    },
    [RACE_ICE] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_WATER, RACE_ICE, RACE_STEEL},
        effective = {RACE_GRASS, RACE_GROUND, RACE_FLYING, RACE_DRAGON}
    },
    [RACE_FIGHTING] = {
        noeffect = {RACE_GHOST},
        ineffective = {RACE_POISON, RACE_FLYING, RACE_PSYCHIC, RACE_BUG, RACE_FAIRY},
        effective = {RACE_NORMAL, RACE_ICE, RACE_ROCK, RACE_DARK, RACE_STEEL}
    },
    [RACE_POISON] = {
        noeffect = {RACE_STEEL},
        ineffective = {RACE_POISON, RACE_GROUND, RACE_ROCK, RACE_GHOST},
        effective = {RACE_GRASS, RACE_FAIRY}
    },
    [RACE_GROUND] = {
        noeffect = {RACE_FLYING},
        ineffective = {RACE_GRASS, RACE_BUG},
        effective = {RACE_FIRE, RACE_ELECTRIC, RACE_POISON, RACE_ROCK, RACE_STEEL}
    },
    [RACE_FLYING] = {
        noeffect = {},
        ineffective = {RACE_ELECTRIC, RACE_ROCK, RACE_STEEL},
        effective = {RACE_GRASS, RACE_FIGHTING, RACE_BUG}
    },
    [RACE_PSYCHIC] = {
        noeffect = {RACE_DARK},
        ineffective = {RACE_PSYCHIC, RACE_STEEL},
        effective = {RACE_FIGHTING, RACE_POISON}
    },
    [RACE_BUG] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_FIGHTING, RACE_POISON, RACE_FLYING, RACE_GHOST, RACE_STEEL, RACE_FAIRY},
        effective = {RACE_GRASS, RACE_PSYCHIC, RACE_DARK}
    },
    [RACE_ROCK] = {
        noeffect = {},
        ineffective = {RACE_FIGHTING, RACE_GROUND, RACE_STEEL},
        effective = {RACE_FIRE, RACE_ICE, RACE_FLYING, RACE_BUG}
    },
    [RACE_GHOST] = {
        noeffect = {RACE_NORMAL},
        ineffective = {RACE_DARK},
        effective = {RACE_PSYCHIC, RACE_GHOST}
    },
    [RACE_DRAGON] = {
        noeffect = {RACE_FAIRY},
        ineffective = {RACE_STEEL},
        effective = {RACE_DRAGON}
    },
    [RACE_DARK] = {
        noeffect = {},
        ineffective = {RACE_FIGHTING, RACE_DARK, RACE_FAIRY},
        effective = {RACE_PSYCHIC, RACE_GHOST}
    },
    [RACE_STEEL] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_WATER, RACE_ELECTRIC, RACE_STEEL},
        effective = {RACE_ICE, RACE_ROCK, RACE_FAIRY}
    },
    [RACE_FAIRY] = {
        noeffect = {},
        ineffective = {RACE_FIRE, RACE_POISON, RACE_STEEL},
        effective = {RACE_FIGHTING, RACE_DRAGON, RACE_DARK}
    }
}

conversor_id = {
    [1] = "first",
    [2] = "second",
    [3] = "third",
    [4] = "fourth",
    [5] = "fifth",
    [6] = "sixth",
    [7] = "seventh",
    [8] = "eighth",
    [9] = "ninth",
    [10] = "tenth",
    [11] = "eleventh",
    [12] = "twelfth",
    [13] = "thirteenth",
    [14] = "fourteenth",
    [15] = "fifteenth",
    [16] = "sixteenth",
    [17] = "seventeenth",
    [18] = "eighteenth",
    [19] = "nineteenth",
    [20] = "twentieth",
}

reverse_conversor = {
    ["first"] = 1,
    ["second"] = 2,
    ["third"] = 3,
    ["fourth"] = 4,
    ["fifth"] = 5,
    ["sixth"] = 6,
    ["seventh"] = 7,
    ["eighth"] = 8,
    ["ninth"] = 9,
    ["tenth"] = 10,
    ["eleventh"] = 11,
    ["twelfth"] = 12,
    ["thirteenth"] = 13,
    ["fourteenth"] = 14,
    ["fifteenth"] = 15,
    ["sixteenth"] = 16,
    ["seventeenth"] = 17,
    ["eighteenth"] = 18,
    ["nineteenth"] = 19,
    ["twentieth"] = 20,
}

CONSTANT_RACE_NAME = {
	[RACE_NONE] = "none",
	[RACE_VENOM] = "venom",
	[RACE_FIRE] = "fire",
	[RACE_ENERGY] = "energy",
	[RACE_GRASS] = "grass",
	[RACE_NORMAL] = "normal",
	[RACE_WATER] = "water",
	[RACE_FLYING] = "flying",
	[RACE_POISON] = "poison",
	[RACE_ELECTRIC] = "electric",
	[RACE_GROUND] = "ground",
	[RACE_PSYCHIC] = "psychic",
	[RACE_ROCK] = "rock",
	[RACE_ICE] = "ice",
	[RACE_BUG] = "bug",
	[RACE_DRAGON] = "dragon",
	[RACE_GHOST] = "ghost",
	[RACE_DARK] = "dark",
	[RACE_STEEL] = "steel",
	[RACE_FAIRY] = "fairy",
	[RACE_FIGHTING] = "fighting",
}

RARIDADE_COMUM = 1
RARIDADE_RARO = 2
RARIDADE_EPICO = 3
RARIDADE_LENDARIO = 4
RARIDADE_SHARD = 5
RARIDADE_QUEST = 6

CONST_RARITIES = {
    [26731] = RARIDADE_LENDARIO,
    [26736] = RARIDADE_RARO,
    [26735] = RARIDADE_SHARD,
    [26734] = RARIDADE_COMUM,
    [26733] = RARIDADE_EPICO,
    [26732] = RARIDADE_EPICO,
    [26728] = RARIDADE_QUEST,
    [26730] = RARIDADE_RARO,
    [26724] = RARIDADE_COMUM,
    [26749] = RARIDADE_LENDARIO,
    [26725] = RARIDADE_COMUM,
    [26726] = RARIDADE_RARO,
    [26727] = RARIDADE_EPICO,
    [26748] = RARIDADE_QUEST,
    [26743] = RARIDADE_COMUM,
    [26744] = RARIDADE_SHARD,
}

CONST_RARITIES_EFFECT = {
    [RARIDADE_COMUM] = 2513,
    [RARIDADE_RARO] = 2518,
    [RARIDADE_EPICO] = 2522,
    [RARIDADE_LENDARIO] = 2519,
    [RARIDADE_SHARD] = 2521,
    [RARIDADE_QUEST] = 2520,
}