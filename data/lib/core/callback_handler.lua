callbackHandlers = {}

local function register(self)
	if isScriptsInterface() then
		if not self.onReceive then
			print("[Warning - CallbackHandler::register] need to setup a callback before you can register.")
			return
		end

		if type(self.onReceive) ~= "function" then
			print(string.format("[Warning - CallbackHandler::onReceive] a function is expected."))
			return
		end

		callbackHandlers[self.packetType] = self.onReceive
	end
end

local function clear(self)
	callbackHandlers[self.packetType] = nil
end

function CallbackHandler(packetType)
	return {
		clear = clear,
		packetType = packetType,
		register = register,
	}
end