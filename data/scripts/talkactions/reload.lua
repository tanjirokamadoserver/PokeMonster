local reloadTalkAction = TalkAction("/reload")


reloadTypes = {
	["all"] = RELOAD_TYPE_ALL,

	["global"] = RELOAD_TYPE_GLOBAL,

	["action"] = RELOAD_TYPE_ACTIONS,
	["ac"] = RELOAD_TYPE_ACTIONS,
	["actions"] = RELOAD_TYPE_ACTIONS,

	["chat"] = RELOAD_TYPE_CHAT,
	["channel"] = RELOAD_TYPE_CHAT,
	["chatchannels"] = RELOAD_TYPE_CHAT,

	["config"] = RELOAD_TYPE_CONFIG,
	["configuration"] = RELOAD_TYPE_CONFIG,

	["creaturescript"] = RELOAD_TYPE_CREATURESCRIPTS,
	["cr"] = RELOAD_TYPE_CREATURESCRIPTS,
	["creaturescripts"] = RELOAD_TYPE_CREATURESCRIPTS,

	["events"] = RELOAD_TYPE_EVENTS,
	["script"] = RELOAD_TYPE_SCRIPTS,
	["scripts"] = RELOAD_TYPE_SCRIPTS,

	["globalevent"] = RELOAD_TYPE_GLOBALEVENTS,
	["globalevents"] = RELOAD_TYPE_GLOBALEVENTS,

	["items"] = RELOAD_TYPE_ITEMS,

	["monster"] = RELOAD_TYPE_MONSTERS,
	["monsters"] = RELOAD_TYPE_MONSTERS,

	["mount"] = RELOAD_TYPE_MOUNTS,
	["mounts"] = RELOAD_TYPE_MOUNTS,

	["move"] = RELOAD_TYPE_MOVEMENTS,
	["mv"] = RELOAD_TYPE_MOVEMENTS,
	["movement"] = RELOAD_TYPE_MOVEMENTS,
	["movements"] = RELOAD_TYPE_MOVEMENTS,

	["npc"] = RELOAD_TYPE_NPCS,
	["npcs"] = RELOAD_TYPE_NPCS,

	["quest"] = RELOAD_TYPE_QUESTS,
	["quests"] = RELOAD_TYPE_QUESTS,

	["raid"] = RELOAD_TYPE_RAIDS,
	["raids"] = RELOAD_TYPE_RAIDS,

	["spell"] = RELOAD_TYPE_SPELLS,
	["spells"] =  RELOAD_TYPE_SPELLS,

	["talk"] = RELOAD_TYPE_TALKACTIONS,
	["ta"] = RELOAD_TYPE_TALKACTIONS,
	["talkaction"] = RELOAD_TYPE_TALKACTIONS,
	["talkactions"] = RELOAD_TYPE_TALKACTIONS,

	["weapon"] = RELOAD_TYPE_WEAPONS,
	["weapons"] = RELOAD_TYPE_WEAPONS,

	["outfit"] = RELOAD_TYPE_OUTFITS,
	["outfits"] = RELOAD_TYPE_OUTFITS,

	["wings"] = RELOAD_TYPE_WINGS,
	["wing"] = RELOAD_TYPE_WINGS,

	["shader"] = RELOAD_TYPE_SHADERS,
	["shaders"] = RELOAD_TYPE_SHADERS,

	["aura"] = RELOAD_TYPE_AURAS,
	["auras"] = RELOAD_TYPE_AURAS,

	["libs"] = RELOAD_TYPE_LIBSCRIPT,

	["stage"]  = RELOAD_TYPE_STAGE,
	["stages"] = RELOAD_TYPE_STAGE,
}

function reloadTalkAction.onSay(player, words, param)

	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	--logCommand(player, words, param)

	local reloadType = reloadTypes[param:lower()]
	if not reloadType then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Reload type not found.")
		return false
	end
	
	Game.reload(reloadType)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Reloaded %s.", param:lower()))
	return false
end

reloadTalkAction:separator(" ")
reloadTalkAction:register()
