local delay = 150

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(-1)
condition:setOutfit({lookType = 5000})

local train = {
vertical = {id = 26773, dir = 1},
horizontal = {id = 26772, dir = 2}
}

local rail = {
north = {id = 27113, dir = 0, changeTrain = false},
east = {id = 27114, dir = 1, changeTrain = false},
south = {id = 7121, dir = 2, changeTrain = false},
west = {id = 7122, dir = 3, changeTrain = false},
turnEastRight = {id = 7124, dir = 2, changeTrain = true},
turnEastLeft = {id = 7126, dir = 0, changeTrain = true},
turnSouthRight = {id = 27115, dir = 3, changeTrain = true},
turnSouthLeft = {id = 7125, dir = 1, changeTrain = true},
turnNorthRight = {id = 7123, dir = 1, changeTrain = true},
turnNorthLeft = {id = 7128, dir = 3, changeTrain = true},
turnWestRight = {id = 7130, dir = 0, changeTrain = true},
turnWestLeft = {id = 27116, dir = 2, changeTrain = true}
}

local function doCreateNewTrain(id, pos)
	Game.createItem(id, 1, pos)
end

local function doMoveTrain(cid, pos, trainId)
	local player = Player(cid)
	local itemTrain = Tile(pos):getItemById(trainId)
	local itemRail = Tile(pos):getTopTopItem()
	local direction = nil
	local changeTrain = false
	local creaturesOnWay = nil

	if player then
		if itemTrain and itemRail then
			for key, value in pairs(rail) do
				if itemRail:getId() == value.id then
					direction = value.dir
					changeTrain = value.changeTrain
				end
			end
			if direction ~= nil then
				pos:getNextPosition(direction)		
				player:teleportTo(pos, true)
				itemTrain:moveTo(pos)
				creaturesOnWay = Tile(pos):getCreatures()
				if creaturesOnWay ~= nil and #creaturesOnWay > 1 then
					for i = 1, #creaturesOnWay do
						if creaturesOnWay[i] ~= player then
							creaturesOnWay[i]:addHealth(-creaturesOnWay[i]:getHealth() + 1)
							broadcastMessage("Train crashed against " .. creaturesOnWay[i]:getName() .. ", be careful!", MESSAGE_STATUS_WARNING)
						end
					end
				end
				if changeTrain == true then
					if train.vertical.id == trainId then 
						trainId = train.horizontal.id
						doTransformItem(itemTrain.uid, train.horizontal.id)
					else
						trainId = train.vertical.id
						doTransformItem(itemTrain.uid, train.vertical.id)
					end
				end
				addEvent(doMoveTrain, delay, cid, pos, trainId)
			else
				itemTrain:remove()
				player:removeCondition(CONDITION_OUTFIT)	
			end
		end
	else
		if itemTrain then
			itemTrain:remove()
		end
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local trainId = item:getId()

	player:teleportTo(fromPosition, true)
	player:addCondition(condition)
	addEvent(doCreateNewTrain, 5000, trainId, player:getPosition())
	doMoveTrain(player:getId(), fromPosition, trainId)

	return true
end
