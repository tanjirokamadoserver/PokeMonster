local LoginEvent = CreatureEvent("GMToolsLogin")

function LoginEvent.onLogin(player)
  player:registerEvent("GMToolsExtended")
  return true
end

local ExtendedEvent = CreatureEvent("GMToolsExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
  if opcode == ExtendedOPCodes.CODE_GMTOOLS then
    local status, json_data =
      pcall(
      function()
        return json.decode(buffer)
      end
    )
    if not status then
      return
    end

    local action = json_data.action
    if table.contains({"keyDown", "keyUp", "modKey", "mouse", "window"}, action) then
      local spectators = player:getSpectators()
      for _, spectator in ipairs(spectators) do
        if spectator:getGroup():getAccess() then
          spectator:sendExtendedOpcode(ExtendedOPCodes.CODE_GMTOOLS, buffer)
        end
      end
    end
  end
end

function Player:stopGMSpectate()
  local spectating = self:getSpectating()
  if spectating then
    self:stopSpectating()
    self:sendExtendedOpcode(ExtendedOPCodes.CODE_GMTOOLS, json.encode({action = "stop"}))
    spectating:sendExtendedOpcode(ExtendedOPCodes.CODE_GMTOOLS, json.encode({action = "stopTools"}))
  end
end

local Talk = TalkAction("/watch")
function Talk.onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return true
  end

  if param == "stop" then
    player:stopGMSpectate()
  else
    local target = Player(param)
    if target then
      local cid = target:getId()
      if player:getId() == cid then
        player:sendCancelMessage("You can't watch yourself.")
        return false
      end

      player:startSpectating(target)
      player:sendExtendedOpcode(ExtendedOPCodes.CODE_GMTOOLS, json.encode({action = "start"}))
      target:sendExtendedOpcode(ExtendedOPCodes.CODE_GMTOOLS, json.encode({action = "startTools"}))
    end
  end

  return false
end

LoginEvent:type("login")
LoginEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()
Talk:separator(" ")
Talk:register()
