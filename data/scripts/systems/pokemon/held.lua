local heldTable = {    
    -- [26886] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 1}, --  Accuracy 1
    -- [26887] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 2}, --  Accuracy 2
    -- [26888] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 3}, --  Accuracy 3
    -- [26889] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 4}, --  Accuracy 4
    -- [26890] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 5}, --  Accuracy 5
    -- [26891] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 6}, --  Accuracy 6
    -- [26892] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 7}, --  Accuracy 7
    -- [26893] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 8}, --  Accuracy 8
    -- [26894] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 9}, --  Accuracy 9
    -- [26895] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 10}, -- Accuracy 10
    -- [26896] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 11}, -- Accuracy 11
    -- [26897] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 12}, -- Accuracy 12
    -- [26898] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 13}, -- Accuracy 13

    -- Agility

    -- [26899] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 14}, -- Agility 1
    -- [26900] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 15}, -- Agility 2
    -- [26901] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 16}, -- Agility 3
    -- [26902] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 17}, -- Agility 4
    -- [26903] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 18}, -- Agility 5
    -- [26904] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 19}, -- Agility 6
    -- [26905] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 20}, -- Agility 7
    -- [26906] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 21}, -- Agility 8
    -- [26907] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 22}, -- Agility 9
    -- [26908] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 23}, -- Agility 10
    -- [26909] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 24}, -- Agility 11
    -- [26910] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 25}, -- Agility 12
    -- [26911] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 26}, -- Agility 13
    
    -- Attack
    
    -- [26912] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 27}, -- Attack 1
    -- [26913] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 28}, -- Attack 2
    -- [26914] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 29}, -- Attack 3
    -- [26915] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 30}, -- Attack 4
    -- [26916] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 31}, -- Attack 5
    -- [26917] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 32}, -- Attack 6
    -- [26918] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 33}, -- Attack 7
    -- [26919] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 34}, -- Attack 8
    -- [26920] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 35}, -- Attack 9
    -- [26921] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 36}, -- Attack 10
    -- [26922] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 37}, -- Attack 11
    -- [26923] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 38}, -- Attack 12
    -- [26924] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 39}, -- Attack 13
    
    -- -- Boost
    
    -- [26926] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 40}, -- Boost 1
    -- [26927] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 41}, -- Boost 2
    -- [26928] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 42}, -- Boost 3
    -- [26929] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 43}, -- Boost 4
    -- [26930] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 44}, -- Boost 5
    -- [26931] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 45}, -- Boost 6
    -- [26932] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 46}, -- Boost 7
    -- [26933] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 47}, -- Boost 8
    -- [26934] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 48}, -- Boost 9
    -- [26935] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 49}, -- Boost 10
    -- [26936] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 50}, -- Boost 11
    -- [26937] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 51}, -- Boost 12
    -- [26938] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 52}, -- Boost 13
    
    -- -- Critical
    
    -- [26939] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 53}, -- Critical 1
    -- [26940] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 54}, -- Critical 2
    -- [26941] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 55}, -- Critical 3
    -- [26942] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 56}, -- Critical 4
    -- [26943] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 57}, -- Critical 5
    -- [26944] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 58}, -- Critical 6
    -- [26945] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 59}, -- Critical 7
    -- [26946] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 60}, -- Critical 8
    -- [26947] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 61}, -- Critical 9
    -- [26948] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 62}, -- Critical 10
    -- [26949] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 63}, -- Critical 11
    -- [26950] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 64}, -- Critical 12
    -- [26951] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 65}, -- Critical 13
    
    -- -- Defense
    
    -- [26952] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 66}, -- Defense 1
    -- [26953] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 67}, -- Defense 2
    -- [26954] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 68}, -- Defense 3
    -- [26955] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 69}, -- Defense 4
    -- [26956] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 70}, -- Defense 5
    -- [26957] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 71}, -- Defense 6
    -- [26958] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 72}, -- Defense 7
    -- [26959] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 73}, -- Defense 8
    -- [26960] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 74}, -- Defense 9
    -- [26961] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 75}, -- Defense 10
    -- [26962] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 76}, -- Defense 11
    -- [26963] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 77}, -- Defense 12
    -- [26964] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 78}, -- Defense 13
    
    -- -- Elemental
    
    -- [26965] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 79}, -- Elemental 1
    -- [26966] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 80}, -- Elemental 2
    -- [26967] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 81}, -- Elemental 3
    -- [26968] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 82}, -- Elemental 4
    -- [26969] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 83}, -- Elemental 5
    -- [26970] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 84}, -- Elemental 6
    -- [26971] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 85}, -- Elemental 7
    -- [26972] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 86}, -- Elemental 8
    -- [26973] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 87}, -- Elemental 9
    -- [26974] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 88}, -- Elemental 10
    -- [26975] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 89}, -- Elemental 11
    -- [26976] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 90}, -- Elemental 12
    -- [26977] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 91}, -- Elemental 13
    
    -- -- Experience
    
    -- [26978] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 92},  -- Experience 1
    -- [26979] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 93},  -- Experience 2
    -- [26980] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 94},  -- Experience 3
    -- [26981] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 95},  -- Experience 4
    -- [26982] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 96},  -- Experience 5
    -- [26983] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 97},  -- Experience 6
    -- [26984] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 98},  -- Experience 7
    -- [26985] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 99},  -- Experience 8
    -- [26986] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 100}, -- Experience 9
    -- [26987] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 101}, -- Experience 10
    -- [26988] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 102}, -- Experience 11
    -- [26989] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 103}, -- Experience 12
    -- [26990] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 104}, -- Experience 13

    --  -- Cooldown
        
    -- [26991] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 105}, -- Cooldown1
    -- [26992] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 106}, -- Cooldown2
    -- [26993] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 107}, -- Cooldown3
    
    -- -- Harden
    
    -- [26994] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 108}, -- Harden 1
    -- [26995] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 109}, -- Harden 2
    -- [26996] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 110}, -- Harden 3
    -- [26997] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 111}, -- Harden 4
    -- [26998] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 112}, -- Harden 5
    -- [26999] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 113}, -- Harden 6
    -- [27000] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 114}, -- Harden 7
    -- [27001] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 115}, -- Harden 8
    -- [27002] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 116}, -- Harden 9
    -- [27003] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 117}, -- Harden 10
    -- [27004] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 118}, -- Harden 11
    -- [27005] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 119}, -- Harden 12
    -- [27006] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 120}, -- Harden 13
    
    -- -- Haste
    
    -- [27007] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 121}, -- Haste 1
    -- [27008] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 122}, -- Haste 2
    -- [27009] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 123}, -- Haste 3
    -- [27010] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 124}, -- Haste 4
    -- [27011] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 125}, -- Haste 5
    -- [27012] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 126}, -- Haste 6
    -- [27013] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 127}, -- Haste 7
    -- [27014] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 128}, -- Haste 8
    -- [27015] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 129}, -- Haste 9
    -- [27016] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 130}, -- Haste 10
    -- [27017] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 131}, -- Haste 11
    -- [27018] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 132}, -- Haste 12
    -- [27019] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 133}, -- Haste 13
    
    -- -- Hellfire
    
    -- [27020] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 134}, -- Hellfire 1
    -- [27021] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 135}, -- Hellfire 2
    -- [27022] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 136}, -- Hellfire 3
    -- [27023] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 137}, -- Hellfire 4
    -- [27024] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 138}, -- Hellfire 5
    -- [27025] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 139}, -- Hellfire 6
    -- [27026] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 140}, -- Hellfire 7
    -- [27027] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 141}, -- Hellfire 8
    -- [27028] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 142}, -- Hellfire 9
    -- [27029] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 143}, -- Hellfire 10
    -- [27030] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 144}, -- Hellfire 11
    -- [27031] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 145}, -- Hellfire 12
    -- [27032] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 146}, -- Hellfire 13
    
    -- -- Lucky
    
    -- [27033] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 147}, -- Lucky 1
    -- [27034] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 148}, -- Lucky 2
    -- [27035] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 149}, -- Lucky 3
    -- [27036] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 150}, -- Lucky 4
    -- [27037] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 151}, -- Lucky 5
    -- [27038] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 152}, -- Lucky 6
    -- [27039] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 153}, -- Lucky 7
    -- [27040] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 154}, -- Lucky 8
    -- [27041] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 155}, -- Lucky 9
    -- [27042] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 156}, -- Lucky 10
    -- [27043] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 157}, -- Lucky 11
    -- [27044] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 158}, -- Lucky 12
    -- [27045] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 159}, -- Lucky 13
    
    -- -- Poison
    
    -- [27046] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 160}, -- Poison 1
    -- [27047] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 161}, -- Poison 2
    -- [27048] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 162}, -- Poison 3
    -- [27049] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 163}, -- Poison 4
    -- [27050] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 164}, -- Poison 5
    -- [27051] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 165}, -- Poison 6
    -- [27052] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 166}, -- Poison 7
    -- [27053] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 167}, -- Poison 8
    -- [27054] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 168}, -- Poison 9
    -- [27055] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 169}, -- Poison 10
    -- [27056] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 170}, -- Poison 11
    -- [27057] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 171}, -- Poison 12
    -- [27058] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 172}, -- Poison 13

    --  -- Rage

    -- [27059] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 173}, -- Rage 1
    -- [27060] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 174}, -- Rage 2
    -- [27061] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 175}, -- Rage 3
    -- [27062] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 176}, -- Rage 4
    -- [27063] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 177}, -- Rage 5
    -- [27064] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 178}, -- Rage 6
    -- [27065] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 179}, -- Rage 7
    -- [27066] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 180}, -- Rage 8
    -- [27067] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 181}, -- Rage 9
    -- [27068] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 182}, -- Rage 10
    -- [27069] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 183}, -- Rage 11
    -- [27070] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 184}, -- Rage 12
    -- [27071] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 185}, -- Rage 13

    --     -- Return

    -- [27072] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 186}, -- Return 1
    -- [27073] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 187}, -- Return 2
    -- [27074] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 188}, -- Return 3
    -- [27075] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 189}, -- Return 4
    -- [27076] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 190}, -- Return 5
    -- [27077] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 191}, -- Return 6
    -- [27078] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 192}, -- Return 7
    -- [27079] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 193}, -- Return 8
    -- [27080] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 194}, -- Return 9
    -- [27081] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 195}, -- Return 10
    -- [27082] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 196}, -- Return 11
    -- [27083] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 197}, -- Return 12
    -- [27084] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 198}, -- Return 13

    -- -- Strafe

    -- [27085] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 199}, -- Strafe 1
    -- [27086] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 200}, -- Strafe 2
    -- [27087] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 201}, -- Strafe 3
    -- [27088] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 202}, -- Strafe 4
    -- [27089] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 203}, -- Strafe 5
    -- [27090] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 204}, -- Strafe 6
    -- [27091] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 205}, -- Strafe 7
    -- [27092] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 206}, -- Strafe 8
    -- [27093] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 207}, -- Strafe 9
    -- [27094] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 208}, -- Strafe 10
    -- [27095] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 209}, -- Strafe 11
    -- [27096] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 210}, -- Strafe 12
    -- [27097] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 211}, -- Strafe 13

    -- -- Vitality

    -- [27098] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 212}, -- Vitality 1
    -- [27099] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 213}, -- Vitality 2
    -- [27100] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 214}, -- Vitality 3
    -- [27101] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 215}, -- Vitality 4
    -- [27102] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 216}, -- Vitality 5
    -- [27103] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 217}, -- Vitality 6
    -- [27104] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 218}, -- Vitality 7
    -- [27105] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 219}, -- Vitality 8
    -- [27106] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 220}, -- Vitality 9
    -- [27107] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 221}, -- Vitality 10
    -- [27108] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 222}, -- Vitality 11
    -- [27109] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 223}, -- Vitality 12
    -- [27110] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 224}, -- Vitality 13

    -- -- Control Mind

    -- [27115] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 225}, -- Control Mind 1
    -- [27116] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 226}, -- Control Mind 2
    -- [27117] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 227}, -- Control Mind 3
    -- [27118] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 228}, -- Control Mind 4
    -- [27119] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 229}, -- Control Mind 5
    -- [27120] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 230}, -- Control Mind 6
    -- [27121] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 231}, -- Control Mind 7
    -- [27122] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 232}, -- Control Mind 8
    -- [27123] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 233}, -- Control Mind 9
    -- [27124] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 234}, -- Control Mind 10
    -- [27125] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 235}, -- Control Mind 11
    -- [27126] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 236}, -- Control Mind 12
    -- [27127] = {attribute = ITEM_ATTRIBUTE_HELDX, ident = 237}, -- Control Mind 13

    --  -- Cure
    -- [27128] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 238}, -- Cure1
    -- [27129] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 239}, -- Cure2
    -- [27130] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 240}, -- Cure3
    -- [27131] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 241}, -- Cure4
    -- [27132] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 242}, -- Cure5
    -- [27133] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 243}, -- Cure6
    -- [27134] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 244}, -- Cure7
    -- [27135] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 245}, -- Cure8
    -- [27136] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 246}, -- Cure9
    -- [27137] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 247}, -- Cure10
    -- [27138] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 248}, -- Cure11
    -- [27139] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 249}, -- Cure12
    -- [27140] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 250}, -- Cure13

    -- -- U-Utility
    -- [27141] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 251}, -- Cut
    -- [27142] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 252}, -- Dig
    -- [27143] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 253}, -- Ghost
    -- [27144] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 254}, -- Headbutt
    -- [27145] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 255}, -- Light
    -- [27159] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 256}, -- Smash
    -- [27111] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 257}, -- Antiburn
    -- [27113] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 258}, -- Antipoison
    -- [26925] = {attribute = ITEM_ATTRIBUTE_HELDU, ident = 259}, -- Blink

    -- -- Heal
    -- [27146] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 260}, -- Heal 1
    -- [27147] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 261}, -- Heal 2
    -- [27148] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 262}, -- Heal 3
    -- [27149] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 263}, -- Heal 4
    -- [27150] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 264}, -- Heal 5
    -- [27151] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 265}, -- Heal 6
    -- [27152] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 266}, -- Heal 7
    -- [27153] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 267}, -- Heal 8
    -- [27154] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 268}, -- Heal 9
    -- [27155] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 269}, -- Heal 10
    -- [27156] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 270}, -- Heal 11
    -- [27157] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 271}, -- Heal 12
    -- [27158] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 272}, -- Heal 13

    -- -- Teleport
    -- [27160] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 273}, -- Teleport1
    -- [27161] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 274}, -- Teleport2
    -- [27162] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 275}, -- Teleport3
    -- [27163] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 276}, -- Teleport4
    -- [27164] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 277}, -- Teleport5
    -- [27165] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 278}, -- Teleport6
    -- [27166] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 279}, -- Teleport7
    -- [27167] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 280}, -- Teleport8
    -- [27168] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 281}, -- Teleport9
    -- [27169] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 282}, -- Teleport10
    -- [27170] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 283}, -- Teleport11
    -- [27171] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 284}, -- Teleport12
    -- [27172] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 285}, -- Teleport13
    -- -- Wing
    -- [27173] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 286}, -- Wing1
    -- [27174] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 287}, -- Wing2
    -- [27175] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 288}, -- Wing3
    -- [27176] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 289}, -- Wing4
    -- [27177] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 290}, -- Wing5
    -- [27178] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 291}, -- Wing6
    -- [27179] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 292}, -- Wing7
    -- [27180] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 293}, -- Wing8
    -- [27181] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 294}, -- Wing9
    -- [27182] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 295}, -- Wing10
    -- [27183] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 296}, -- Wing11
    -- [27184] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 297}, -- Wing12
    -- [27185] = {attribute = ITEM_ATTRIBUTE_HELDY, ident = 298}, -- Wing13
}

local action_held = Action()

function action_held.onUse(player, item, fromPosition, target, toPosition)
     local held = heldTable[item.itemid]

	if type(target) ~= "userdata" or not Item(target.uid) or not target:isItemPokeball() then
		return player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use em uma pokebola!")
  	end

	if hasSummons(player) then
		return player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Guarde seu pokémon!")
	end

	if not held then
		return error(("[Held System - ACTION]: Item não configurado: %d"):format(item.itemid))
	end

	local verificar = target:getAttribute(held.attribute)
    local newInfos = HELD_CONVERT_NAME_TO_TABLE[held.attribute][held.ident]

    if not newInfos then
        return error(("[Held System - ACTION]: Held não configurado! Ident: %d - Attribute: %s"):format(held.ident, held.attribute))
    end

    local newTier = newInfos.tier
    local newType = newInfos.type
    local oldInfos = verificar ~= 0 and HELD_CONVERT_NAME_TO_TABLE[held.attribute][verificar] or nil
    local oldTier = oldInfos and oldInfos.tier or nil
    local oldType = oldInfos and oldInfos.type or nil

    if (verificar == 0 and newTier ~= 1) or (verificar ~= 0 and newTier ~= 1 and oldType ~= newType) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você deve utilizar o tier 1 primeiro!")
        return true
    elseif verificar ~= 0 and oldType == newType then
        if oldTier > newTier then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você não pode usar um held já existente no pokémon!")
            return true
        end

        if oldTier+1 ~= newTier then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você deve seguir a ordem numérica dos helds. O próximo held deve ser: " .. oldTier+1)
            return true
        end
    end

    local pokeName = target:getPokeName()

	target:setAttribute(held.attribute, held.ident)
	item:remove(1)
	player:getPosition():sendMagicEffect(EFFECT_FIREWORK_YELLOW)

	local heldName = newInfos.heldName

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("Seu %s, recebeu o Held %s"):format(pokeName, heldName))
	return true
end

for id in pairs(heldTable) do
    action_held:id(id)
end

action_held:register()