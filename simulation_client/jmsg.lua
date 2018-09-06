local h = require "glzp.head_file"  

local msg ={}
function msg.init(jpack)
	msg.auth = jpack.createPackage('auth',
		{
		userName = "robot88",
		thirdToken = '123456',
		thirdPlatformID = h.thirdPlatformID.Zipai,
		-- version = param.appver,
		version = "0.0",
		deviceID = h.deviceID.PC,
		extraData = nil,
		timestamp = os.time(),
		spreader = "",
		newSpreader = "",
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.LOGIN_SERVER,
		0,
		h.enumKeyAction.AUTH
		)

	msg.heart = jpack.createPackage('heartbeatReply',
		{
			userID = 5088,
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.LOBBY_SERVER,
		0,
		h.enumKeyAction.HEARTBEAT
		)
end

return msg