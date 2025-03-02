local CHANNEL_ID = 23

function canJoin(player)
  if player:isHosting() then
    return true
  end
  if player:getSpectating() then
    return true
  end
  return false
end

function onSpeak(player, type, message)
  local spectating = player:getSpectating()
  if spectating then
    spectating:channelSay(player, TALKTYPE_CHANNEL_Y, message, CHANNEL_ID)
  elseif player:isHosting() then
    player:channelSay(player, TALKTYPE_CHANNEL_O, message, CHANNEL_ID)
  end
  return false
end