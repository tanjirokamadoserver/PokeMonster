function sendGameInterfaceInfoByJSON(player, action, data)
  local MAX_PACKET_SIZE = 50000
  local OPCODE = 12
  
  local buffer = json.encode({action = action, data = data})
  local s = {}
  for i = 1, #buffer, MAX_PACKET_SIZE do
      s[#s + 1] = buffer:sub(i, i + MAX_PACKET_SIZE - 1)
  end
  local msg = NetworkMessage()
  if #s == 1 then
      msg:addByte(50)
      msg:addByte(OPCODE)
      msg:addString(s[1])
      msg:sendToPlayer(player)
      return
  end
  -- split message if too big
  msg:addByte(50)
  msg:addByte(OPCODE)
  msg:addString("S" .. s[1])
  msg:sendToPlayer(player)
  for i = 2, #s - 1 do
      msg = NetworkMessage()
      msg:addByte(50)
      msg:addByte(OPCODE)
      msg:addString("P" .. s[i])
      msg:sendToPlayer(player)
  end
  msg = NetworkMessage()
  msg:addByte(50)
  msg:addByte(OPCODE)
  msg:addString("E" .. s[#s])
  msg:sendToPlayer(player)
end