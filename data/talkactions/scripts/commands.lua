function onSay(player, words, param)
	local msg = "Comandos disponiveis: \n\n"
	msg = msg .. "!autoloot\n!online\n!tutorial\n!desbugar\n!buyvip\n!changesex\n!up\n!down\n!teleport\nm1\nm2\nm3\nm4\nm5\nm6\nm7\nm8\nm9\nm10\nm11\nm12\n\nComandos para houses:\n!buyhouse\n!invite\n!invitesub\n!invitedoor\n!kick\n!leavehouse\n!sellhouse"
	player:showTextDialog(2263, msg)
	return false
end
