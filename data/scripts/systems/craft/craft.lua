CRAFT_IDS = {
    [1] = "crafts",
    [2] = "crafts2",
    [3] = "crafts3",
    [4] = "crafts4",
    [5] = "crafts5",
    [6] = "crafts6",
}

RANKS_ORDERED = {
    ["crafts"] = {
        [1] = "Esferas",
        [2] = "Items Raros",
        [3] = "Boost",
    },   
	["crafts2"] = {
        [1] = "Helds Attack",
		[2] = "Helds Defense",
        [3] = "Helds Boost",
        [4] = "Helds Regeneration",
        [5] = "Helds Critical",
        [6] = "Helds Exp",
        [7] = "Helds Pxp",
    },
	["crafts3"] = {
        [1] = "Mineração",
        [2] = "Pesca",
    },
	["crafts4"] = {
        [1] = "Descompactar",
    },
	["crafts5"] = {
        [1] = "Cartas",
    },
	["crafts6"] = {
        [1] = "Craft Divinos",
        [2] = "Fusoes",
    },
}

craftData = {

    ["crafts"] = {
		["Boost"] = {
			{itemId = 13559, -- Boost Stone70
			quantity = 1,
			chance = 25,
				required = {
					{itemId = 13215, quantidade = 300}, 
					{itemId = 12237, quantidade = 50}, 
				}
			},
			{itemId = 13560, -- Boost Stones80
			chance = 50,
				required = {
					{itemId = 13559, quantidade = 5}, 
					{itemId = 12237, quantidade = 100}, 
				}
			},
			{itemId = 13561, -- Boost Stones 85
			chance = 50,
				required = {
					{itemId = 13560, quantidade = 10}, 
					{itemId = 12237, quantidade = 200}, 
				}
			},
			{itemId = 13562, -- Boost Stones 100
			chance = 50,
				required = {
					{itemId = 13561, quantidade = 10}, 
					{itemId = 12237, quantidade = 400}, 
				}
			},
			{itemId = 13563, -- Boost Stones 200
			chance = 50,
				required = {
					{itemId = 13562, quantidade = 10}, 
					{itemId = 12237, quantidade = 800}, 
				}
			},
			{itemId = 13564, -- Boost Stones 300
			chance = 50,
				required = {
					{itemId = 13563, quantidade = 10}, 
					{itemId = 12237, quantidade = 1000}, 
				}
			},
			{itemId = 13565, -- Boost Stones 400
			chance = 50,
				required = {
					{itemId = 13564, quantidade = 10}, 
					{itemId = 12237, quantidade = 1000}, 
				}
			},
			{itemId = 20679, -- Boost Stones 500
			chance = 50,
				required = {
					{itemId = 13565, quantidade = 10}, 
					{itemId = 12237, quantidade = 1000}, 
				}
			},
			{itemId = 20709, -- Boost Stones 750
			chance = 50,
				required = {
					{itemId = 20679, quantidade = 10}, 
					{itemId = 12237, quantidade = 2000}, 
				}
			},
			{itemId = 20708, -- Boost Stones 750
			chance = 50,
				required = {
					{itemId = 20709, quantidade = 10}, 
					{itemId = 12237, quantidade = 3000}, 
				}
			},
		},		
		["Esferas"] = {
			{itemId = 22927, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 20}, 
					{itemId = 22955, quantidade = 30}, 
					{itemId = 22959, quantidade = 15}, 
				}
			},
			{itemId = 22932, -- Esfera Mega
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 35}, 
					{itemId = 22955, quantidade = 55}, 
					{itemId = 22959, quantidade = 25}, 
				}
			},
			{itemId = 22928, -- Esfera Giga
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 45}, 
					{itemId = 22955, quantidade = 70}, 
					{itemId = 22959, quantidade = 37}, 
				}
			},
			{itemId = 22929, -- Esfera Tera
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 55}, 
					{itemId = 22955, quantidade = 85}, 
					{itemId = 22959, quantidade = 46}, 
				}
			},
			{itemId = 22931, -- Esfera Ultra
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 70}, 
					{itemId = 22956, quantidade = 10}, 
					{itemId = 22959, quantidade = 58},
				}
			},
			{itemId = 22930, -- Esfera Lendaria
			chance = 100,
				required = {
					{itemId = 22954, quantidade = 95}, 
					{itemId = 22956, quantidade = 25}, 
					{itemId = 22959, quantidade = 74}, 
				}
			},
		},
		["Items Raros"] = {
			{itemId = 13228, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 7}, 
					{itemId = 22962, quantidade = 25}, 
					{itemId = 2145, quantidade = 35}, 
				}
			},
			{itemId = 22919, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 1}, 
					{itemId = 22959, quantidade = 25}, 
					{itemId = 22954, quantidade = 35}, 
				}
			},
			{itemId = 23149, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 5}, 
					{itemId = 22959, quantidade = 50}, 
					{itemId = 22956, quantidade = 70}, 
				}
			},
			{itemId = 22868, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 1},
					{itemId = 22954, quantidade = 25}, 
				}
			},
			{itemId = 6569, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 1},
				}
			},
			{itemId = 22666, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 2},
				}
			},
			{itemId = 17311, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 17314, quantidade = 2},
					{itemId = 23039, quantidade = 1},
				}
			},
			{itemId = 17312, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 17311, quantidade = 2},
					{itemId = 23039, quantidade = 2},
				}
			},
			{itemId = 17313, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 17312, quantidade = 2},
					{itemId = 23039, quantidade = 4},
				}
			},
			{itemId = 21037, -- Esfera de Pal
			chance = 100,
				required = {
					{itemId = 23035, quantidade = 7},
					{itemId = 23036, quantidade = 7},
					{itemId = 23039, quantidade = 7},
				}
			},
		},	
	},
	
	["crafts2"] = {
			["Helds Attack"] = {
				{itemId = 13399, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13398, quantidade = 2}, 
						{itemId = 23036, quantidade = 1}, 
					}
				},
				{itemId = 13400, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13399, quantidade = 2}, 
						{itemId = 23036, quantidade = 2}, 
					}
				},
				{itemId = 13401, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13400, quantidade = 2}, 
						{itemId = 23036, quantidade = 3}, 
					}
				},
				{itemId = 13402, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13401, quantidade = 2}, 
						{itemId = 23036, quantidade = 4}, 
					}
				},
				{itemId = 13403, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13402, quantidade = 2}, 
						{itemId = 23036, quantidade = 5}, 
					}
				},
				{itemId = 13404, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13403, quantidade = 2}, 
						{itemId = 23036, quantidade = 6}, 
					}
				},
				{itemId = 16771, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 13404, quantidade = 2}, 
						{itemId = 23036, quantidade = 7}, 
					}
				},
				{itemId = 16781, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 16771, quantidade = 2}, 
						{itemId = 23036, quantidade = 8}, 
					}
				},
				{itemId = 16790, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 16781, quantidade = 2}, 
						{itemId = 23036, quantidade = 9}, 
					}
				},
				{itemId = 16797, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 16790, quantidade = 2}, 
						{itemId = 23036, quantidade = 10}, 
					}
				},
				{itemId = 16805, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 16797, quantidade = 2}, 
						{itemId = 23036, quantidade = 11}, 
					}
				},
				{itemId = 22595, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 16805, quantidade = 2}, 
						{itemId = 23036, quantidade = 12}, 
					}
				},
				{itemId = 22596, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22595, quantidade = 2}, 
						{itemId = 23036, quantidade = 13}, 
					}
				},
				{itemId = 22597, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22596, quantidade = 2}, 
						{itemId = 23036, quantidade = 14}, 
					}
				},
				{itemId = 22598, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22597, quantidade = 2}, 
						{itemId = 23036, quantidade = 15}, 
					}
				},
				{itemId = 22599, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22598, quantidade = 2}, 
						{itemId = 23036, quantidade = 16}, 
					}
				},
				{itemId = 22600, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22599, quantidade = 2}, 
						{itemId = 23036, quantidade = 17}, 
					}
				},
				{itemId = 22601, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22600, quantidade = 2}, 
						{itemId = 23036, quantidade = 18}, 
					}
				},
				{itemId = 22602, -- Boost Stone70
				chance = 100,
					required = {
						{itemId = 22601, quantidade = 2}, 
						{itemId = 23036, quantidade = 19}, 
					}
				},
			},		
			["Helds Boost"] = {
		{itemId = 13413, -- Held Boost 2
			chance = 100,
				required = {
					{itemId = 13412, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 13414, -- Held Boost 3
			chance = 100,
				required = {
					{itemId = 13413, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 13415, -- Held Boost 4
			chance = 100,
				required = {
					{itemId = 13414, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 13416, -- Held Boost 5
			chance = 100,
				required = {
					{itemId = 13415, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 13417, -- Held Boost 6
			chance = 100,
				required = {
					{itemId = 13416, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 13418, -- Held Boost 7
			chance = 100,
				required = {
					{itemId = 13417, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16773, -- Held Boost 8
			chance = 100,
				required = {
					{itemId = 13418, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16779, -- Held Boost 9
			chance = 100,
				required = {
					{itemId = 16773, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16789, -- Held Boost 10
			chance = 100,
				required = {
					{itemId = 16779, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16795, -- Held Boost 11
			chance = 100,
				required = {
					{itemId = 16789, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 16803, -- Held Boost 12
			chance = 100,
				required = {
					{itemId = 16795, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22603, -- Held Boost 13
			chance = 100,
				required = {
					{itemId = 16803, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22604, -- Held Boost 14
			chance = 100,
				required = {
					{itemId = 22603, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22605, -- Held Boost 15
			chance = 100,
				required = {
					{itemId = 22604, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22606, -- Held Boost 16
			chance = 100,
				required = {
					{itemId = 22605, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22607, -- Held Boost 17
			chance = 100,
				required = {
					{itemId = 22606, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22608, -- Held Boost 18
			chance = 100,
				required = {
					{itemId = 22607, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22609, -- Held Boost 19
			chance = 100,
				required = {
					{itemId = 22608, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},
		{itemId = 22610, -- Held Boost 20
			chance = 100,
				required = {
					{itemId = 22609, quantidade = 2}, 
					{itemId = 23036, quantidade = 20}, 
				}
		},
			},
			["Helds Defense"] = {
		{itemId = 13392, -- Held Defense 2
			chance = 100,
				required = {
					{itemId = 13391, quantidade = 2}, 
					{itemId = 23036, quantidade = 1}, 
				}
		},
		{itemId = 13393, -- Held Defense 3
			chance = 100,
				required = {
					{itemId = 13392, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 13394, -- Held Defense 4
			chance = 100,
				required = {
					{itemId = 13393, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 13395, -- Held Defense 5
			chance = 100,
				required = {
					{itemId = 13394, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 13396, -- Held Defense 6
			chance = 100,
				required = {
					{itemId = 13395, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 13397, -- Held Defense 7
			chance = 100,
				required = {
					{itemId = 13396, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 16770, -- Held Defense 8
			chance = 100,
				required = {
					{itemId = 13397, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16778, -- Held Defense 9
			chance = 100,
				required = {
					{itemId = 16770, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16786, -- Held Defense 10
			chance = 100,
				required = {
					{itemId = 16778, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16794, -- Held Defense 11
			chance = 100,
				required = {
					{itemId = 16786, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16802, -- Held Defense 12
			chance = 100,
				required = {
					{itemId = 16794, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 22587, -- Held Defense 13
			chance = 100,
				required = {
					{itemId = 16802, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22588, -- Held Defense 14
			chance = 100,
				required = {
					{itemId = 22587, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22589, -- Held Defense 15
			chance = 100,
				required = {
					{itemId = 22588, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22590, -- Held Defense 16
			chance = 100,
				required = {
					{itemId = 22589, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22591, -- Held Defense 17
			chance = 100,
				required = {
					{itemId = 22590, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22592, -- Held Defense 18
			chance = 100,
				required = {
					{itemId = 22591, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22593, -- Held Defense 19
			chance = 100,
				required = {
					{itemId = 22592, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22594, -- Held Defense 20
			chance = 100,
				required = {
					{itemId = 22593, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},
	},
			["Helds Regeneration"] = {
		{itemId = 13420, -- Held Regeneration 2
			chance = 100,
				required = {
					{itemId = 13419, quantidade = 2}, 
					{itemId = 23036, quantidade = 1}, 
				}
		},
		{itemId = 13421, -- Held Regeneration 3
			chance = 100,
				required = {
					{itemId = 13420, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 13422, -- Held Regeneration 4
			chance = 100,
				required = {
					{itemId = 13421, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 13423, -- Held Regeneration 5
			chance = 100,
				required = {
					{itemId = 13422, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 13424, -- Held Regeneration 6
			chance = 100,
				required = {
					{itemId = 13423, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 13425, -- Held Regeneration 7
			chance = 100,
				required = {
					{itemId = 13424, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 16775, -- Held Regeneration 8
			chance = 100,
				required = {
					{itemId = 13425, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16785, -- Held Regeneration 9
			chance = 100,
				required = {
					{itemId = 16775, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16788, -- Held Regeneration 10
			chance = 100,
				required = {
					{itemId = 16785, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16801, -- Held Regeneration 11
			chance = 100,
				required = {
					{itemId = 16788, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16809, -- Held Regeneration 12
			chance = 100,
				required = {
					{itemId = 16801, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 22611, -- Held Regeneration 13
			chance = 100,
				required = {
					{itemId = 16809, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22612, -- Held Regeneration 14
			chance = 100,
				required = {
					{itemId = 22611, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22613, -- Held Regeneration 15
			chance = 100,
				required = {
					{itemId = 22612, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22614, -- Held Regeneration 16
			chance = 100,
				required = {
					{itemId = 22613, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22615, -- Held Regeneration 17
			chance = 100,
				required = {
					{itemId = 22614, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22616, -- Held Regeneration 18
			chance = 100,
				required = {
					{itemId = 22615, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22617, -- Held Regeneration 19
			chance = 100,
				required = {
					{itemId = 22616, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22618, -- Held Regeneration 20
			chance = 100,
				required = {
					{itemId = 22617, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},	
},
			["Helds Critical"] = {
		{itemId = 13485, -- Held Critical 2
			chance = 100,
				required = {
					{itemId = 13484, quantidade = 2}, 
					{itemId = 23036, quantidade = 1}, 
				}
		},
		{itemId = 13486, -- Held Critical 3
			chance = 100,
				required = {
					{itemId = 13485, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 13487, -- Held Critical 4
			chance = 100,
				required = {
					{itemId = 13486, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 13488, -- Held Critical 5
			chance = 100,
				required = {
					{itemId = 13487, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 13489, -- Held Critical 6
			chance = 100,
				required = {
					{itemId = 13488, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 13490, -- Held Critical 7
			chance = 100,
				required = {
					{itemId = 13489, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 16777, -- Held Critical 8
			chance = 100,
				required = {
					{itemId = 13490, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16783, -- Held Critical 9
			chance = 100,
				required = {
					{itemId = 16777, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16791, -- Held Critical 10
			chance = 100,
				required = {
					{itemId = 16783, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16799, -- Held Critical 11
			chance = 100,
				required = {
					{itemId = 16791, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16807, -- Held Critical 12
			chance = 100,
				required = {
					{itemId = 16799, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 22619, -- Held Critical 13
			chance = 100,
				required = {
					{itemId = 16807, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22620, -- Held Critical 14
			chance = 100,
				required = {
					{itemId = 22619, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22621, -- Held Critical 15
			chance = 100,
				required = {
					{itemId = 22620, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22622, -- Held Critical 16
			chance = 100,
				required = {
					{itemId = 22621, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22623, -- Held Critical 17
			chance = 100,
				required = {
					{itemId = 22622, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22624, -- Held Critical 18
			chance = 100,
				required = {
					{itemId = 22623, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22625, -- Held Critical 19
			chance = 100,
				required = {
					{itemId = 22624, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22626, -- Held Critical 20
			chance = 100,
				required = {
					{itemId = 22625, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},
},
			["Helds Exp"] = {
		{itemId = 13464, -- Held Exp 2
			chance = 100,
				required = {
					{itemId = 13463, quantidade = 2}, 
					{itemId = 23036, quantidade = 1}, 
				}
		},
		{itemId = 13465, -- Held Exp 3
			chance = 100,
				required = {
					{itemId = 13464, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 13466, -- Held Exp 4
			chance = 100,
				required = {
					{itemId = 13465, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 13467, -- Held Exp 5
			chance = 100,
				required = {
					{itemId = 13466, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 13468, -- Held Exp 6
			chance = 100,
				required = {
					{itemId = 13467, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 13469, -- Held Exp 7
			chance = 100,
				required = {
					{itemId = 13468, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 16772, -- Held Exp 8
			chance = 100,
				required = {
					{itemId = 13469, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16784, -- Held Exp 9
			chance = 100,
				required = {
					{itemId = 16772, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16792, -- Held Exp 10
			chance = 100,
				required = {
					{itemId = 16784, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16800, -- Held Exp 11
			chance = 100,
				required = {
					{itemId = 16792, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16808, -- Held Exp 12
			chance = 100,
				required = {
					{itemId = 16800, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 22627, -- Held Exp 13
			chance = 100,
				required = {
					{itemId = 16808, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22628, -- Held Exp 14
			chance = 100,
				required = {
					{itemId = 22627, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22629, -- Held Exp 15
			chance = 100,
				required = {
					{itemId = 22628, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22630, -- Held Exp 16
			chance = 100,
				required = {
					{itemId = 22629, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22631, -- Held Exp 17
			chance = 100,
				required = {
					{itemId = 22630, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22632, -- Held Exp 18
			chance = 100,
				required = {
					{itemId = 22631, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22633, -- Held Exp 19
			chance = 100,
				required = {
					{itemId = 22632, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22634, -- Held Exp 20
			chance = 100,
				required = {
					{itemId = 22633, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},
},
			["Helds Pxp"] = {
		{itemId = 16813, -- Held Pxp 2
			chance = 100,
				required = {
					{itemId = 16812, quantidade = 2}, 
					{itemId = 23036, quantidade = 1}, 
				}
		},
		{itemId = 16814, -- Held Pxp 3
			chance = 100,
				required = {
					{itemId = 16813, quantidade = 2}, 
					{itemId = 23036, quantidade = 2}, 
				}
		},
		{itemId = 16815, -- Held Pxp 4
			chance = 100,
				required = {
					{itemId = 16814, quantidade = 2}, 
					{itemId = 23036, quantidade = 3}, 
				}
		},
		{itemId = 16816, -- Held Pxp 5
			chance = 100,
				required = {
					{itemId = 16815, quantidade = 2}, 
					{itemId = 23036, quantidade = 4}, 
				}
		},
		{itemId = 16817, -- Held Pxp 6
			chance = 100,
				required = {
					{itemId = 16816, quantidade = 2}, 
					{itemId = 23036, quantidade = 5}, 
				}
		},
		{itemId = 16818, -- Held Pxp 7
			chance = 100,
				required = {
					{itemId = 16817, quantidade = 2}, 
					{itemId = 23036, quantidade = 6}, 
				}
		},
		{itemId = 16819, -- Held Pxp 8
			chance = 100,
				required = {
					{itemId = 16818, quantidade = 2}, 
					{itemId = 23036, quantidade = 7}, 
				}
		},
		{itemId = 16820, -- Held Pxp 9
			chance = 100,
				required = {
					{itemId = 16819, quantidade = 2}, 
					{itemId = 23036, quantidade = 8}, 
				}
		},
		{itemId = 16821, -- Held Pxp 10
			chance = 100,
				required = {
					{itemId = 16820, quantidade = 2}, 
					{itemId = 23036, quantidade = 9}, 
				}
		},
		{itemId = 16822, -- Held Pxp 11
			chance = 100,
				required = {
					{itemId = 16821, quantidade = 2}, 
					{itemId = 23036, quantidade = 10}, 
				}
		},
		{itemId = 16823, -- Held Pxp 12
			chance = 100,
				required = {
					{itemId = 16822, quantidade = 2}, 
					{itemId = 23036, quantidade = 11}, 
				}
		},
		{itemId = 22635, -- Held Pxp 13
			chance = 100,
				required = {
					{itemId = 16823, quantidade = 2}, 
					{itemId = 23036, quantidade = 12}, 
				}
		},
		{itemId = 22636, -- Held Pxp 14
			chance = 100,
				required = {
					{itemId = 22635, quantidade = 2}, 
					{itemId = 23036, quantidade = 13}, 
				}
		},
		{itemId = 22637, -- Held Pxp 15
			chance = 100,
				required = {
					{itemId = 22636, quantidade = 2}, 
					{itemId = 23036, quantidade = 14}, 
				}
		},
		{itemId = 22638, -- Held Pxp 16
			chance = 100,
				required = {
					{itemId = 22637, quantidade = 2}, 
					{itemId = 23036, quantidade = 15}, 
				}
		},
		{itemId = 22639, -- Held Pxp 17
			chance = 100,
				required = {
					{itemId = 22638, quantidade = 2}, 
					{itemId = 23036, quantidade = 16}, 
				}
		},
		{itemId = 22640, -- Held Pxp 18
			chance = 100,
				required = {
					{itemId = 22639, quantidade = 2}, 
					{itemId = 23036, quantidade = 17}, 
				}
		},
		{itemId = 22641, -- Held Pxp 19
			chance = 100,
				required = {
					{itemId = 22640, quantidade = 2}, 
					{itemId = 23036, quantidade = 18}, 
				}
		},
		{itemId = 22642, -- Held Pxp 20
			chance = 100,
				required = {
					{itemId = 22641, quantidade = 2}, 
					{itemId = 23036, quantidade = 19}, 
				}
		},
	},
},
	["crafts3"] = {
			["Mineração"] = {
				{itemId = 4258, -- Picareta De Ferro
				chance = 100,
					required = {
						{itemId = 4257, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
				}
			},
				{itemId = 4259, -- Picareta De Ouro
				chance = 100,
					required = {
						{itemId = 4258, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
						{itemId = 22956, quantidade = 50}, 
				}
			},
				{itemId = 4260, -- Picareta De Diamond
				chance = 100,
					required = {
						{itemId = 4259, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
						{itemId = 22956, quantidade = 50}, 
						{itemId = 22954, quantidade = 100}, 

				}
			},
	},
			["Pesca"] = {
				{itemId = 16231, -- Picareta De Ferro
				chance = 100,
					required = {
						{itemId = 16230, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
				}
			},
				{itemId = 16232, -- Picareta De Ouro
				chance = 100,
					required = {
						{itemId = 16231, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
						{itemId = 22956, quantidade = 50}, 
				}
			},
				{itemId = 16233, -- Picareta De Diamond
				chance = 100,
					required = {
						{itemId = 16232, quantidade = 1}, 
						{itemId = 22955, quantidade = 25}, 
						{itemId = 22956, quantidade = 50}, 
						{itemId = 22954, quantidade = 100}, 
					
					
				}
			},
				{itemId = 16234, -- Picareta De Diamond
				chance = 100,
					required = {
						{itemId = 16233, quantidade = 1}, 
						{itemId = 22955, quantidade = 50}, 
						{itemId = 22956, quantidade = 100}, 
						{itemId = 22954, quantidade = 200}, 
					
					
				}
			},
	},
},
	["crafts4"] = {
			["Descompactar"] = {
				{itemId = 23035, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 22919, quantidade = 10}, 
				}
			},
				{itemId = 23035, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 22868, quantidade = 1}, 
				}
			},
				{itemId = 23035, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 6569, quantidade = 10}, 
				}
			},
				{itemId = 23035, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 22666, quantidade = 6}, 
				}
			},
				{itemId = 12237, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 13234, quantidade = 5}, 
				}
			},
				{itemId = 12237, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 13198, quantidade = 4}, 
				}
			},
				{itemId = 12237, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 14435, quantidade = 3}, 
				}
			},
				{itemId = 12237, -- Essencia Rosa
				chance = 100,
					required = {
						{itemId = 14434, quantidade = 2}, 
				}
			},
	},
},
	["crafts5"] = {
			["Cartas"] = {
				{itemId = 23457,
				chance = 100,
					required = {
						{itemId = 23467, quantidade = 1}, 
						{itemId = 23468, quantidade = 1}, 
						{itemId = 23469, quantidade = 1}, 
						{itemId = 23470, quantidade = 1}, 
				}
			},
				{itemId = 23458, 
				chance = 100,
					required = {
						{itemId = 23471, quantidade = 1}, 
						{itemId = 23472, quantidade = 1}, 
						{itemId = 23473, quantidade = 1}, 
						{itemId = 23474, quantidade = 1}, 
				}
			},
				{itemId = 23459, 
				chance = 100,
					required = {
						{itemId = 23475, quantidade = 1}, 
						{itemId = 23476, quantidade = 1}, 
						{itemId = 23477, quantidade = 1}, 
						{itemId = 23478, quantidade = 1}, 
				}
			},
				{itemId = 23463, 
				chance = 100,
					required = {
						{itemId = 23479, quantidade = 1}, 
						{itemId = 23480, quantidade = 1}, 
						{itemId = 23481, quantidade = 1}, 
						{itemId = 23482, quantidade = 1}, 
				}
			},
				{itemId = 23464, 
				chance = 100,
					required = {
						{itemId = 23483, quantidade = 1}, 
						{itemId = 23484, quantidade = 1}, 
						{itemId = 23485, quantidade = 1}, 
						{itemId = 23486, quantidade = 1}, 
				}
			},
				{itemId = 23460, 
				chance = 100,
					required = {
						{itemId = 23487, quantidade = 1}, 
						{itemId = 23488, quantidade = 1}, 
						{itemId = 23489, quantidade = 1}, 
						{itemId = 23490, quantidade = 1}, 
				}
			},
				{itemId = 23462, 
				chance = 100,
					required = {
						{itemId = 23491, quantidade = 1}, 
						{itemId = 23492, quantidade = 1}, 
						{itemId = 23493, quantidade = 1}, 
						{itemId = 23494, quantidade = 1}, 
				}
			},
},
},
	["crafts6"] = {
			["Craft Divinos"] = {
				{itemId = 24407,
				quantity = 10,
				chance = 100,
					required = {
						{itemId = 24384, quantidade = 1}, 
						{itemId = 21255, quantidade = 5}, 
				}
			},
				{itemId = 23155,
				quantity = 1,
				chance = 50,
					required = {
						{itemId = 24389, quantidade = 1}, 
				}
			},
	},
			["Fusoes"] = {
				{itemId = 24389,
				quantity = 1,
				chance = 100,
					required = {
						{itemId = 24384, quantidade = 1}, 
						{itemId = 24385, quantidade = 1}, 
				}
			},
},
},
}

craftTableToSend = {}

jsonData = {
    ["crafts"] = {},
    ["crafts2"] = {},
    ["crafts3"] = {},
    ["crafts4"] = {},
    ["crafts5"] = {},
    ["crafts6"] = {},
}

CRAFT_OPCODE = 72

function loadCraftTable()
    craftTableToSend = {}
    for profissao, data in pairs(craftData) do
        craftTableToSend[profissao] = {}
        for rank, items in pairs(data) do
            craftTableToSend[profissao][rank] = {}
            for index, item in ipairs(items) do
                local itemType = ItemType(item.itemId)
                craftTableToSend[profissao][rank][index] = {}
                craftTableToSend[profissao][rank][index].itemId                 = itemType:getClientId()
                craftTableToSend[profissao][rank][index].quantity               = item.quantity or 1
                craftTableToSend[profissao][rank][index].name                   = itemType:getName()
                craftTableToSend[profissao][rank][index].description            = itemType:getDescription()
                craftTableToSend[profissao][rank][index].chance                 = item.chance

                craftTableToSend[profissao][rank][index].required = {}
                for newIndex, requiredItem in ipairs(item.required) do
                    local itemType = ItemType(requiredItem.itemId)
                    craftTableToSend[profissao][rank][index].required[newIndex] = {}
                    craftTableToSend[profissao][rank][index].required[newIndex].itemId        =  itemType:getClientId()
                    craftTableToSend[profissao][rank][index].required[newIndex].name          =  itemType:getName()
                    craftTableToSend[profissao][rank][index].required[newIndex].description   =  itemType:getDescription()
                    craftTableToSend[profissao][rank][index].required[newIndex].quantidade    =  requiredItem.quantidade
                end
            end
        end
    end
    print("loaded craft table")
end

function loadJson()
    for profissao in pairs(jsonData) do
        local info = {
            data  = craftTableToSend[profissao],
            base = RANKS_ORDERED[profissao][1],
            order = RANKS_ORDERED[profissao],
            type = "open"
        }
        jsonData[profissao] = json.encode(info)
    end
    print("loaded craft json")
end

function Player:sendCraft(id)
    if not craftTableToSend["crafts"] then
        loadCraftTable()
        loadJson()
    end
    local profissao = CRAFT_IDS[id]
	self:setWork(profissao)

    if self:sendExtendedOpcode(CRAFT_OPCODE, jsonData[profissao]) then
        return true
    end
    return false
end

function showJson(data)
    print(json.encode(data))
end

STORAGE_WORKS = 750000

function Player:setWork(id)
    return self:setStringStorageValue(STORAGE_WORKS, id)
end

function Player:getWork()
    return self:getStringStorageValue(STORAGE_WORKS)
end

function Player:sendNotEnoughItems(data)
    local checkData = craftData[self:getWork()][data.rank]
    if not checkData then return end
    local items = checkData[data.index].required
    local itemsCache = {
        type = "notEnough",
        items = {}
    }
    local i = 1
    for _, item in ipairs(items) do
        local count = self:getItemCount(item.itemId)
        if count < item.quantidade * data.quantidade then
            local quantityNeeded = (item.quantidade * data.quantidade) - count
            local itemType = ItemType(item.itemId)
            local name = itemType:getName()
            itemsCache.items[i] = {needed = quantityNeeded, name = name}
            i = i + 1
        end
    end

    self:sendExtendedOpcode(CRAFT_OPCODE, json.encode(itemsCache))
end

function Player:handleCraft(buffer)
    local payload = json.decode(buffer)
    local type = payload.type
    local data = payload.info
    if type == "doCraft" then
        local checkData = craftData[self:getWork()][data.rank]
        if not checkData then return end
        local items = checkData[data.index].required
        local canCraft = true

        for _, item in ipairs(items) do
            if self:getItemCount(item.itemId) < item.quantidade * data.quantidade then
                canCraft = false
                return self:sendNotEnoughItems(data)
            end
        end
        local success = true
        local chance = checkData[data.index].chance * 100
        local randomChance = math.random(10000)
        if chance < randomChance then
            success = false
        end

        if canCraft then
            for _, item in ipairs(items) do
                self:removeItem(item.itemId, item.quantidade * data.quantidade)
            end
            if success then
                self:addItem(checkData[data.index].itemId, data.quantidade * (checkData[data.index].quantity or 1)) 
                self:getPosition():sendMagicEffect(1591)
            else
                self:getPosition():sendMagicEffect(1592)
            end
        end
    end
end

local craft_login = CreatureEvent("craft_event_login")
function craft_login.onLogin(player)
	player:registerEvent("craft_event_opcode")
	return true
end
craft_login:register()

local craft_event_opcode = CreatureEvent("craft_event_opcode")
function craft_event_opcode.onExtendedOpcode(player, opcode, buffer)
	if opcode == CRAFT_OPCODE then
        player:handleCraft(buffer)
        return
    end
end
craft_event_opcode:register()


local craftIds = {
	[13579] = 1,
	[18546] = 6,
	[13584] = 2,
	[13581] = 3,
	[13583] = 4,
	[13580] = 5,
}
local craftActions = Action()

function craftActions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendCraft(craftIds[item.itemid])
	return true
end

for id, _ in pairs(craftIds) do
	craftActions:id(id)
end

craftActions:register()