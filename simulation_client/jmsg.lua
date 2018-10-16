local h = require "glzp.head_file"  

local msg ={}
function msg.init(jpack)
	msg.auth = jpack.createPackage('auth',
		{
		userName = "robot90",
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
	msg.challengeSignIn = jpack.createPackage('challengeSignIn',
		{
			challengeId = 1,
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.ROOM_CHALLENGE_MG,
		0,
		h.enumKeyAction.CHALLENGE_SIGN_IN
		)
	msg.getChallengeSeasonMessage = jpack.createPackage('getChallengeSeasonMessage',
		{
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.ROOM_CHALLENGE_MG,
		0,
		h.enumKeyAction.GET_CHALLENGE_SEASON_MESSAGE
		)
	msg.testP1 = jpack.createPackage('testP1',
		{
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.ROOM_J,
		0,
		h.enumKeyAction.TEST_P1
		)
	msg.testP2 = jpack.createPackage('testP2',
		{
		},
		h.enumEndPoint.CLIENT,
		h.enumEndPoint.ROOM_J,
		0,
		h.enumKeyAction.TEST_P2
		)	
end

return msg