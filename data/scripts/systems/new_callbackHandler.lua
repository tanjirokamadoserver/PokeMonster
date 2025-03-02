local handler = PacketHandler(0xFF)
function handler.onReceive(player, msg)
    local recvByte = msg:getByte()
	local handlerCallback = callbackHandlers[recvByte]
	if not handlerCallback then
		print(string.format("Player: %s sent an unknown packet header: 0x%02X with %d bytes!\n", player:getName(), recvByte, msg:len()))
		return
	end
	handlerCallback(player, msg)
end

handler:register()