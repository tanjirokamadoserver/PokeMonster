local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition)
	if not target or type(target) ~= "userdata" or not Item(target.uid) or not target:isPokeball() then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use em uma pokebola!.")
	end

	local maestria = target:getSpecialAttribute("maestria") or 0

    if maestria >= CONST_MAX_MAESTRIA then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você está no nível máximo!")
        return true
    end

    target:setSpecialAttribute("maestria", maestria + 1)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você aumentou a maestria do seu pokémon")
    item:remove(1)
    return true
end

action:id(16361)
action:register()