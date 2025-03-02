function onSay(cid, words, param, channel)
    local player = Player(cid)  -- Assuming Player(cid) returns the player object

    local p = param:explode(',')
    if param == "" then
        player:sendCancelMessage("Command requires parameter.")
        return true
    end

    if words == "/pass" then
        local targetPlayer = Player(p[1])
        if not targetPlayer then
            player:sendCancelMessage("Sorry, but player [" .. p[1] .. "] does not exist.")
            return true
        end

        local query = db.storeQuery("UPDATE `accounts` SET `password` = ? WHERE name = ?", p[2], p[1])
        if query then
            targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your password has been changed.")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have changed " .. p[1] .. "'s account password to " .. p[2] .. ".")
        end
        return true
    end

    if words == "/acc" then
        local targetPlayer = Player(p[1])
        if not targetPlayer then
            player:sendCancelMessage("Sorry, but player [" .. p[1] .. "] does not exist.")
            return true
        elseif Game.getAccount(p[2]) then
            player:sendCancelMessage("Sorry, but account [" .. p[2] .. "] already exists.")
            return true
        end

        local query = db.storeQuery("UPDATE `accounts` SET `name` = ? WHERE name = ?", p[2], p[1])
        if query then
            targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your account name has been changed.")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have changed " .. p[1] .. "'s account number to " .. p[2] .. ".")
        end
        return true
    end

    if words == "/rename" then
        local targetPlayer = Player(p[1])
        if not targetPlayer then
            player:sendCancelMessage("Sorry, but player [" .. p[1] .. "] does not exist.")
            return true
        elseif Player(p[2]) then
            player:sendCancelMessage("Sorry, but the name [" .. p[2] .. "] already exists.")
            return true
        end

        local query = db.storeQuery("UPDATE `players` SET `name` = '".. p[2] .."' WHERE name = '".. p[1] .."'")
        if query then
            targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your name has been changed.")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have changed " .. p[1] .. "'s name to " .. p[2] .. ".")
        end
        return true
    end
end
