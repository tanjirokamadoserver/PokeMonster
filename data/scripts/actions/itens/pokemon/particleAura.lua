local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition)
	if not target or type(target) ~= "userdata" or not Item(target.uid) or not target:isPokeball() then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use em uma pokebola!.")
	end

	local particle = target:getSpecialAttribute("shader")

    if particle then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Seu pokémon já possui particle aura!")
        return true
    end
    target:setSpecialAttribute("shader", 0)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você ativou a particle aura no seu pokémon!")
    item:remove(1)
    return true
end

action:id(23150)
action:register()