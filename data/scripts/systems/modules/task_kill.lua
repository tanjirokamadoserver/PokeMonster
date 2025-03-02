STORAGE_MAIN_TASKS = 99500
STORAGE_POINTS = STORAGE_MAIN_TASKS - 1
STORAGE_ACTIVE_TASK = STORAGE_MAIN_TASKS - 2
OPCODE_TASKS_KILL = 95

STORAGE_DONE_TASK = STORAGE_MAIN_TASKS + 20000

local TASKS_KILL = {
    [1] = {
        name = "Kill 10 oddish",
        missionRequeriment = {storage = 10001, value = 1, desc = "Complete a miss�o de jorge em saffron."},
        killRequeriment = 10,
        pokemon = "oddish",
        taskPoints = 10,
        rewardExp = 40000,
        itemRewardList = { -- max items = 10
            {itemid = 2152, count = 10},
            {itemid = 26662, count = 15},
            -- {itemid = 40608, count = 1},
            {itemid = 27645, count = 5},
        }
    },
    [2] = {
        name = "Kill 30 Pidgeotto",
     --   missionRequeriment = {storage = 10002, value = 1, desc = "Alcance o nivel 1000"},
        killRequeriment = 30,
        pokemon = "Pidgeotto",
        taskPoints = 15,
        rewardExp = 80000,
        itemRewardList = { -- max items = 10
            {itemid = 2152, count = 30},
            {itemid = 26663, count = 25},
            -- {itemid = 40608, count = 1},
            {itemid = 27645, count = 15},
        }
    },
    [3] = {
        name = "Kill 50 Dugtrio",
        -- missionRequeriment = {storage = 10001, value = 1, desc = "Complete a miss�o de jorge em saffron."},
        killRequeriment = 50,
        pokemon = "Dugtrio",
        taskPoints = 50,
        rewardExp = 50000,
        itemRewardList = { -- max items = 10
           {itemid = 2160, count = 2},
            {itemid = 26688, count = 55},
            -- {itemid = 40608, count = 1},
            {itemid = 27645, count = 100},
        }
    },
    [4] = {
        name = "Kill 100 Abra",
        -- missionRequeriment = {storage = 10003, value = 1, desc = "Fa�a a miss�o secreta psiquica."},
        killRequeriment = 100,
        pokemon = "abra",
        taskPoints = 15,
        rewardExp = 30000,
        itemRewardList = { -- max items = 10
            {itemid = 2152, count = 80},
            {itemid = 26663, count = 20},
            {itemid = 26688, count = 100},
            -- {itemid = 40608, count = 1},
            {itemid = 27645, count = 35},
        }
    },
    [5] = {
        name = "Kill 150 Charizard",
        -- missionRequeriment = {storage = 10004, value = 1, desc = "Fale com o rei do vale do charizard!"},
        killRequeriment = 150,
        pokemon = "charizard",
        taskPoints = 15,
        rewardExp = 100000,
        itemRewardList = { -- max items = 10
            {itemid = 2160, count = 4},
            {itemid = 26688, count = 200},
            -- {itemid = 40608, count = 1},
            {itemid = 27645, count = 50},
        }
    }
}

function Player.setMissionActive(self, id)
    if id == -1 then
        local task = self:getActiveTask() -- reset kills
        self:setStorageValue(STORAGE_MAIN_TASKS+task, -1)
    end
    self:setStorageValue(STORAGE_ACTIVE_TASK, id)
end

function Player.getActiveTask(self)
    return math.max(0, self:getStorageValue(STORAGE_ACTIVE_TASK))
end

function Player.hasDoneTask(self, id)
    return self:getStorageValue(STORAGE_DONE_TASK+id) == 1
end

function Player.completeTask(self)
    local activeTask = self:getActiveTask()
    if self:hasDoneTask(activeTask) then
        return
    end
    self:setStorageValue(STORAGE_ACTIVE_TASK, -1)
    self:setStorageValue(STORAGE_DONE_TASK+activeTask, 1)
    self:addTaskPoints(TASKS_KILL[activeTask].taskPoints)
    self:addExperience(TASKS_KILL[activeTask].rewardExp)
    for i, item in ipairs(TASKS_KILL[activeTask].itemRewardList) do
        self:addItem(item.itemid, item.count)
    end
end
-- compat func monster
MonsterType.getOutfit = MonsterType.outfit

function Player.ParseTaskTable(self, originalTable)
    local parsedTable = {}
    for i, task in ipairs(originalTable) do
        local monsterType = MonsterType(task.pokemon)
        parsedTable[i] = {}
        parsedTable[i].name = task.name
        parsedTable[i].background = monsterType and monsterType:getRaceName():lower() or "normal"
        parsedTable[i].access = not task.missionRequeriment and true or self:getStorageValue(task.missionRequeriment.storage) == task.missionRequeriment.value
        parsedTable[i].descRequeriment = task.missionRequeriment and task.missionRequeriment.desc or ""
        parsedTable[i].killRequeriment = task.killRequeriment
        parsedTable[i].kills = math.max(0, self:getStorageValue(STORAGE_MAIN_TASKS + i))
        parsedTable[i].pokemon = task.pokemon
        parsedTable[i].taskPoints = task.taskPoints
        parsedTable[i].type = monsterType and monsterType:getRaceName() or "none"
        parsedTable[i].type2 = monsterType and monsterType:getRace2Name() or "none"
        parsedTable[i].outfit = {type = monsterType:getOutfit().lookType or 0}
        parsedTable[i].rewardExp = task.rewardExp
        parsedTable[i].itemRewardList = {}
        for j, item in ipairs(task.itemRewardList) do
            local itemType = ItemType(item.itemid)
            if not itemType then
               return error("[TASK_KILL ERROR]: Item not found: " .. item.itemid) and {}
            end
            parsedTable[i].itemRewardList[j] = {}
            parsedTable[i].itemRewardList[j].name = itemType:getName()
            parsedTable[i].itemRewardList[j].itemid = itemType:getClientId()
            parsedTable[i].itemRewardList[j].count = item.count
        end
    end
    return parsedTable
end

function Player.getTaskPoints(self)
    return  math.max(0, self:getStorageValue(STORAGE_POINTS))
end

function Player.addTaskPoints(self, points)
    local currentPoints = self:getTaskPoints()
    self:setStorageValue(STORAGE_POINTS, currentPoints + points)
    self:sendTaskData()
end

function Player.removeTaskPoints(self, points)
    local currentPoints = self:getTaskPoints()
    self:setStorageValue(STORAGE_POINTS, currentPoints - points)
    self:sendTaskData()
end


function Player.sendTaskData(self)
    local buffer = {
        type = "parseTasks",
        tasks = self:ParseTaskTable(TASKS_KILL),
        points = self:getTaskPoints(),
        activeTask = self:getActiveTask()
    }
    self:sendExtendedOpcode(OPCODE_TASKS_KILL, json.encode(buffer))
end

function Player.sendKillTask(self)
    local buffer = {
        type = "killTask",
        kills = self:getStorageValue(STORAGE_MAIN_TASKS + self:getActiveTask())
    }
    self:sendExtendedOpcode(OPCODE_TASKS_KILL, json.encode(buffer))
end

function Player.handleTasksKill(self, buffer)
    local data = json.decode(buffer)
    local data_type = data.type
    if data_type == "parseTasks" then
        self:sendTaskData()
    elseif data_type == "acceptTask" then
        local task = TASKS_KILL[data.taskId]
        if not task then
            self:popupFYI("Miss�o n�o encontrada.")
            return
        end
        if self:getActiveTask() > 0 then
            self:popupFYI("Voc� j� possui uma miss�o ativa.")
            return
        end
        if task.missionRequeriment and task.access and not self:getStorageValue(task.missionRequeriment.storage) == task.missionRequeriment.value then
            self:popupFYI("Miss�o bloqueada: " .. task.descRequeriment)
            return
        end
        self:setMissionActive(data.taskId)
        self:sendTaskData()
    elseif data_type == "cancelTask" then
        self:setMissionActive(-1)
        self:sendTaskData()
    end
end

local creatureevent = CreatureEvent("onKillPokemon")
function creatureevent.onKill(creature, target)
    if not creature:isPlayer() then
        return true
    end
    local activeTask = creature:getActiveTask()
    if activeTask <= 0 then
        return true
    end
    local targetName = target:getName():lower()
    local task = TASKS_KILL[activeTask]
    if targetName ~= task.pokemon then
        return true
    end
    creature:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voc� matou um " .. targetName)
    local kills = math.max(0, creature:getStorageValue(STORAGE_MAIN_TASKS + activeTask))
    kills = kills + 1
    creature:setStorageValue(STORAGE_MAIN_TASKS + activeTask, kills)
    if kills >= task.killRequeriment then
        creature:completeTask()
    end
    creature:sendKillTask()
	return true
end
creatureevent:register()

local creatureevent = CreatureEvent("onLoginKillPokemon")

function creatureevent.onLogin(player)
	player:registerEvent("onKillPokemon")
	return true
end

creatureevent:register()