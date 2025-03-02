local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition)
	if not target or type(target) ~= "userdata" or not Item(target.uid) or not target:isPokeball() then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use em uma pokebola!.")
	end

    local star =  target:getSpecialAttribute("starFusion") or 0

    if star >= CONST_MAX_STAR then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voc� est� no n�vel m�ximo de star em seu pok�mon!")
        return true
    end
    target:setSpecialAttribute("starFusion", star + 1)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voc� aumentou um n�vel da star de seu pok�mon.")
    item:remove(1)
    return true
end

action:id(20669)
action:register()