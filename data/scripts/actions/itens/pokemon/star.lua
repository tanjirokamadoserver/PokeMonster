local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition)
	if not target or type(target) ~= "userdata" or not Item(target.uid) or not target:isPokeball() then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use em uma pokebola!.")
	end

    local star =  target:getSpecialAttribute("starFusion") or 0

    if star >= CONST_MAX_STAR then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você está no nível máximo de star em seu pokémon!")
        return true
    end
    target:setSpecialAttribute("starFusion", star + 1)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você aumentou um nível da star de seu pokémon.")
    item:remove(1)
    return true
end

action:id(20669)
action:register()