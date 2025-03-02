-- Core API functions implemented in Lua
-- Core API functions implemented in Lua
dofile('data/lib/core/core.lua')

-- Compatibility library for our old Lua API
dofile('data/lib/compat/compat.lua')

-- custom systems
dofile('data/lib/systems/donationgoals.lua')
dofile('data/lib/systems/apipix.lua')
dofile('data/lib/systems/shop.lua')

-- icaro's systems
dofile('data/lib/systems/pokedex.lua')
dofile('data/lib/systems/newCatchs.lua')
dofile('data/lib/systems/particle.lua')
dofile('data/lib/systems/newShop.lua')
dofile('data/lib/systems/redeem_codes.lua')
dofile('data/lib/systems/highscores.lua')
dofile('data/lib/systems/dailyTournament.lua')
dofile('data/lib/systems/bankLib.lua')
dofile('data/lib/systems/partyMinimap.lua')
dofile('data/lib/systems/bossesCeu.lua')
dofile('data/lib/systems/vip_plus.lua')

dofile('data/lib/zones/events.lua')