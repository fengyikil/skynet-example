--[[
	common lib.
	create by mingyuan.xie
	create time: 2015.8.18
--]]


local skynet = require "skynet"  
local cluster = require "cluster" 
local h = require "head_file"  
local hs = require "headfile_server"
local crypt=require "crypt" 
local json = require "json"  
local md5=require("md5")
local logic_ctrl=require "logic_ctrl"
local commonTool = {} 
--------------------------------Begin 黄祥瑞 2015.10.15  等级 与 剩余经验---------

-----key 为 等级
commonTool.levelInfo = {
[1] = 47,
[2] = 99,
[3] = 164,
[4] = 239,
[5] = 323,
[6] = 415,
[7] = 514,
[8] = 620,
[9] = 732,
[10] = 851,
[11] = 975,
[12] = 1105, 
[13] = 1240,
[14] = 1381,
[15] = 1526,
[16] = 1676,
[17] = 1830,
[18] = 1989,
[19] = 2153,
[20] = 2321,
[21] = 2492,
[22] = 2668,
[23] = 2848,
[24] = 3032,
[25] = 3219,
[26] = 3411,
[27] = 3605,
[28] = 3804,
[29] = 4006,
[30] = 4211,
[31] = 4420,
[32] = 4632,
[33] = 4848,
[34] = 5066,
[35] = 5288,
[36] = 5513,
[37] = 5741,
[38] = 5972,
[39] = 6206,
[40] = 6444,
[41] = 6684,
[42] = 6927,
[43] = 7173,
[44] = 7421,
[45] = 7673,
[46] = 7927,
[47] = 8184,
[48] = 8444,
[49] = 8707,
[50] = 8972,
[51] = 9240,
[52] = 9510,
[53] = 9783,
[54] = 10059,
[55] = 10337,
[56] = 10617,
[57] = 10900,
[58] = 11186,
[59] = 11474,
[60] = 11765,
[61] = 12057,
[62] = 12353,
[63] = 12650,
[64] = 12950,
[65] = 13253,
[66] = 13557,
[67] = 13864,
[68] = 14174,
[69] = 14485,
[70] = 14799,
[71] = 15115,
[72] = 15433,
[73] = 15753,
[74] = 16076,
[75] = 16401,
[76] = 16728,
[77] = 17057,
[78] = 17388,
[79] = 17721,
[80] = 18057,
[81] = 18394,
[82] = 18734,
[83] = 19075,
[84] = 19419,
[85] = 19765,
[86] = 20112,
[87] = 20462,
[88] = 20814,
[89] = 21168,
[90] = 21524,
[91] = 21881,
[92] = 22241,
[93] = 22603,
[94] = 22966,
[95] = 23332,
[96] = 23699,
[97] = 24068,
[98] = 24440,
[99] = 0 -- 99级为满级
}

--升级金币奖励
commonTool.levelUpAward=100
--刷新排行榜最大数量,999999999为不限制
commonTool.rankNum=30
--特殊排行榜最大数，999999999为不限制
commonTool.specialRankNum=30
--K币兑换字牌金币的比例
commonTool.kCoin2goldCoinRate=10000
--老K金币兑换字牌金币比例
commonTool.kGoldCoin2goldCoinRate=1
--------------------------------End 黄祥瑞 2015.10.15  等级 与 剩余经验---------
----- begin guanying  
--相应倍率赢牌所得经验 
commonTool.levelInfoOfRate = {
	[1] = 1,
	[100] = 4,
	[200] = 6,
	[500] = 7,
	[1000] = 9,
	[2000] = 11,
	[5000] = 13,
	[10000] = 15,
	[20000] = 17,
	[50000] = 19,
	[100000] = 21,
	[500000] = 23,
	[1000000] = 25,
}
------房间倍率所对应的服务费  (私人场除外)
commonTool.costOfRate = {
	[100] = 31,
	[200] = 61,
	[500] = 151,
	[1000] = 301,
	[2000] = 601,
	[5000] = 1501,
	[10000] = 3001,
	[20000] = 6001,
	[50000] = 15001,
	[100000] = 30001,
}

-----end
--相应倍率翻醒桂花奖励   冰块/醒
commonTool.fanxingReward = {
	[-1] = "2018-1-31 00:00:00",               --开始日期
	[0] = "2018-2-25 23:59:59",                --截止日期
	[1] = 0,
	[500] = 1,
	[1000] = 2,
	[2000] = 4,
	[5000] = 10,
	[10000] = 15,  
	[20000] = 30,
	[50000] = 75,
	[100000] = 200,
	[500000] = 200,
	[1000000] = 200,
	
}
--agent state
commonTool.connState = {
	ON_LINE				= 1,	-- 在线
	OFF_LINE_NORMAL		= 2,	-- 正常离线
	OFF_LINE_ABNORMAL	= 3,	-- 掉线
}

--agent game state
commonTool.gameState = {
	NON				= 0,	-- 不在线
	IDLE			= 1,	-- 在线，空闲态
	SIT_IN_DESK		= 2,	-- 占桌
	ACCOUNT			= 3,	-- 游戏结束，结算
	GAMING			= 4,	-- 游戏中
    REST            = 5,    -- 打完一局后等待淘汰结果
    OUT             = 6,    -- 淘汰
    WAIT_GAME       = 7,    -- 即将配桌，等待开打
    WAIT_ALLOC_DESK	= 8,	-- 等待分配桌子, 定时赛的时候使用
    READY           = 9,    -- 准备状态 ,私人场用
}

--agent wakeup reason
commonTool.wakeupReason = {
	NON				= -1,	-- 无
	OFF_LINE		= 0,	-- 下线或掉线
	REMAIN_DESK		= 1,	-- 主动留在桌子上
}

--desk state
commonTool.deskState = {
	EMPTY		= 0,	-- 空桌子
	WAITING		= 1,	-- 等待其他玩家进入
	FULL		= 2,	-- 桌子已坐满
	ACCOUNT		= 3,	-- 游戏结束，结算
	GAMING		= 4,	-- 游戏中
}

--player state
commonTool.playerState = {
	ON_LINE				= 1,	-- 在线
	OFF_LINE 			= 2,	-- 正常离线
	OFF_LINE_ABNORMAL	= 3,	-- 掉线
}

commonTool.SERVER_TYPE = {
	CENTER		= "CENTER",
	GATE		= "GATE",
	LOGIN		= "LOGIN",
	DB			= "DB",
	DB_LOG 		= "DB_LOG",
	DB_DISPATCHER 		= "DB_DISPATCHER",
	REDIS 		= "REDIS",
	LOBBY 		= "LOBBY",		--大厅
	GAMEROOM	= "GAMEROOM",	--倍率房
	ROOM_MATCH	= "ROOM_MATCH",	--比赛房
	ROOM_SELF	= "ROOM_SELF",	--私人房  mingyuan.xie added 2016.4.18
	MALL		= "MALL",	    --商城    mingyuan.xie added 2016.8.4
	NEW_ROOM_SELF = "NEW_ROOM_SELF",  --新私人房
	ROOM_SELF_MG = "ROOM_SELF_MG",  --新私人场管理
	MINING      = "MINING",      --挖矿小游戏
	RADIO       = "RADIO",      --广播
	EMAIL       = "EMAIL", 		--邮件
	RANK       = "RANK", 		--排行榜
	MISSION       = "MISSION", 		--任务
	HTTPS       = "HTTPS", 		--HTTPS
	OUTER_WEB       = "OUTER_WEB", 		--OUTER_WEB
	ROOM_NIUNIU_MG  = "ROOM_NIUNIU_MG",  
	ROOM_NIUNIU  = "ROOM_NIUNIU",
	RATE_ROOM_PDK_MG = "RATE_ROOM_PDK_MG",
	RATE_ROOM_PDK = "RATE_ROOM_PDK",
	NN_RATE_SERVER  = "NN_RATE_SERVER",   --牛牛金币场
	RATE_NIUNIU_MG  = "RATE_NIUNIU_MG",   --金币场管理
	ROOM_PDK_MG = "ROOM_PDK_MG",
	ROOM_PDK = "ROOM_PDK",
	CLUB     	= "CLUB",  --俱乐部
	DATA_SHARER = "DATA_SHARER",
	TIMER 		= "TIMER",		--计时器
	DB_OFFER    = "DB_OFFER",
	ROOM_CHALLENGE = "ROOM_CHALLENGE",        --连胜挑战房
	ROOM_CHALLENGE_MG = "ROOM_CHALLENGE_MG",  --连胜挑战管理

}

commonTool.CENTER_INFO = {
	name		= "center",
	service		= "center_service",
}


--Begin: mingyuan.xie added, agent和desk在房间中的存储位置 2015.10.13
commonTool.deskPosition = {
	EMPTY		= 0,	-- 空队列
	READY		= 1,	-- 等待队列
	FULL		= 2,	-- FULL表（deskID为索引）
}

commonTool.agentPosition = {
	FREE			= 0,	-- 空队列
	FORCE_Q_GAME	= 1,	-- FORCE_Q_GAME表，存储游戏中掉线或强退的agent（userID索引）
	LOBBY			= 2,	-- 存储游戏结束后返回大厅的agent（fd索引）
	CONN			= 3,	-- 已连接队列（fd索引）
}
--End : mingyuan.xie added, 座子在房间中的存储位置 2015.10.13

commonTool.centerDogTime	= 2	-----mingyuan.xie add 喂狗时间 2015.12.16

------------------------Begin  黄祥瑞 2015.10.03  增加判断第三方标识--------------------------------------

--Redis关联表的键
commonTool.userName_userID="userName_userID"  --用户名与用户id
commonTool.userID_missionIDs="userID_missionIDs"  --用户id与任务id
commonTool.userID_accountID="userID_accountID"  --用户id与账户id
commonTool.userID_emailIDs="userID_emailIDs"  --用户id与邮件id
commonTool.userID_receivedEmailIDs="userID_receivedEmailIDs" -- 用户id与已领取邮件id
commonTool.userID_roleIDs="userID_roleIDs"   --用户id与形象id
commonTool.userID_billIDs="userID_billIDs"  --用户id与账单id
commonTool.userID_billGoodsIDs="userID_billGoodsIDs"  --用户id与消费商品id
commonTool.userID_userDataID="userID_userDataID"  --用户id与游戏事件id
commonTool.userID_userGoods="userID_userGoods" --用户物品表ID
commonTool.userID_newGameRecord="userID_newGameRecord" --用户与玩家战绩
commonTool.userID_hgwGameRecord="userID_hgwGameRecord" --用户与玩家战绩
commonTool.userID_newGameVideo="userID_newGameVideo" --用户与玩家录像
commonTool.userID_hgwGameVideo="userID_hgwGameVideo" --用户与玩家录像
commonTool.userID_blackList="userID_blackList" --用户与玩家黑名单
commonTool.userID_playerList="userID_playerList" --用户与玩家对战历史
commonTool.matchEnrollNameList="matchEnrollNameList"
commonTool.keyExpireTime=48 * 3600  --Redis的key的过期时间  2015.10.12
commonTool.emailExpireTime=30 --邮件过期时间，天
------------------------End  黄祥瑞 2015.10.03  增加判断第三方标识--------------------------------------


--二级服务器名
commonTool.secServiceName = {
	gamelog_db = "gamelog_db",
	ai_info = "ai_info",
	lobby = "lobby",
	rank  = "rank",
	mission  = "mission",
	special_rank  = "special_rank",
    email = "email",
    mall = "mall",	--min.luo 2016.8.5
    radio = "radio",
    https = "https",
    outer_web = "outer_web",
}

commonTool.gamelog_db_server = commonTool.secServiceName.gamelog_db	------mingyuan.xie added for game log db service 2015.10.8

commonTool.ai_info_mgr = commonTool.secServiceName.ai_info		------mingyuan.xie added for ai info mgr service 2015.10.19
commonTool.lobby = commonTool.secServiceName.lobby	--大厅service


commonTool.traceLog_F = false 	--跟踪打印开关

local callbackFuncMgr = {}


commonTool.forceCloseGamingTime = 8 	--强行关闭异常桌子的时间

-- mingyuan.xie added 2015.10.3
commonTool.printFlag = true		--printF打印开关
commonTool.logFlag = false		--printF记日志开关

-----Begin: mingyuan.xie modify, 修改封装格式和记录日志 2015.10.3 -----------
local printFlag = commonTool.printFlag
local logFlag = commonTool.logFlag
local function printF(serverName, ...)
	local logStr = ""
	if printFlag then
		if serverName then
			logStr = logStr .. "  ["..serverName.."]"-- .. commonTool.getTime()
		else
			logStr = logStr .. "  [COMMON_LIB]"-- .. commonTool.getTime()
		end
		print(logStr, ...)

		if logFlag then
			skynet.error(logStr, ...)
		end
	end
end

local function printE(serverName, ...)
	local logStr = ""
	if serverName then
		logStr = logStr .. "\n[ERROR "..serverName.."]" .. commonTool.getTime()
	else
		logStr = logStr .. "\n[ERROR COMMON_LIB]" .. commonTool.getTime()
	end
	print(logStr, ...)
	skynet.error(logStr, ...)
end
-----End  : mingyuan.xie modify, 修改封装格式和记录日志 2015.10.3 -----------
---------------------------Begin  黄祥瑞  2015.10.03----------------------
--szFullString 		string   字符串
--szSeparator 		string   分隔符
function commonTool.splitString(szFullString, szSeparator)
    if szFullString == nil or szFullString == "" then
        return {}
    end
    if szSeparator == nil or szSeparator == "" then
        return {}
    end
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function commonTool.sec2Date(sec)
	if sec == nil then
		sec=os.time()
	end
	return os.date("%Y-%m-%d %H:%M:%S",tonumber(sec))
end

function commonTool.printE( ... )
	printE("",...)
end

--积分道具做id映射
--[[
固定hs.loginUserGoodsID与hs.loginUserGoodsIDMapID互转，如果都不是，则保持原来的id
]]
function commonTool.pointTrans(itemID)
	itemID=tonumber(itemID)
	if itemID == hs.loginUserGoodsID then
		return hs.loginUserGoodsIDMapID
	end
	if itemID == hs.loginUserGoodsIDMapID then
		return hs.loginUserGoodsID
	end

	return itemID
end

--检查字符串中是否带有标点符号
--返回值   bool   是否带有标点符号
function commonTool.checkSymbol(str)
	if str == nil then
		return false
	end

	str=tostring(str)

	if string.find(str,'"') then
		return true
	end

	if string.find(str,"'") then
		return true
	end

	if string.find(str,"/") ~= nil then
		return true
	end

	if string.find(str,"\\") ~= nil then
		return true
	end

	if string.find(str,"#") ~= nil then
		return true
	end

	if string.find(str,"@") ~= nil then
		return true
	end

	if string.find(str,";") ~= nil then
		return true
	end

	if string.find(str," ") ~= nil then
		return true
	end

	if string.find(str,"`") ~= nil then
		return true
	end

	if string.find(str,"&") ~= nil then
		return true
	end
	if string.find(str,"=") ~= nil then
		return true
	end

	return false
end

function commonTool.replaceSymbol(str)
	if str == nil then
		return ""
	end

	str=tostring(str)

	str=string.gsub(str,'"',"")
	str=string.gsub(str,"'","")
	str=string.gsub(str,"/","")
	str=string.gsub(str,"\\","")
	str=string.gsub(str,"#","")
	str=string.gsub(str,"@","")
	str=string.gsub(str,";","")
	str=string.gsub(str," ","")
	str=string.gsub(str,"`","")
	str=string.gsub(str,"&","")
	str=string.gsub(str,"=","")

	return str
end

--str 			string 		字符串
--return 		bool 		是否合法
function commonTool.checkUnlawwedString(str)
	if str == nil then
		return false
	end

	str=tostring(str)

	if string.find(str,"'") ~= nil then
		return false
	end

	if string.find(str,'"') ~= nil then
		return false
	end

	if string.find(str,"-") ~= nil then
		return false
	end

	if string.find(str,"#") ~= nil then
		return false
	end

	if string.find(str,"=") ~= nil then
		return false
	end

	if string.find(str,"!") ~= nil then
		return false
	end

	if string.find(str,"%(") ~= nil then
		return false
	end

	if string.find(str,"*") ~= nil then
		return false
	end

	if string.find(str," ") ~= nil then
		return false
	end

	if string.find(str,"+") ~= nil then
		return false
	end

	if string.find(str,"%%") ~= nil then
		return false
	end

	if string.find(str,";") ~= nil then
		return false
	end

	if string.find(str,"/") ~= nil then
		return false
	end

	if string.find(str,"@") ~= nil then
		return false
	end

	if string.find(str,"\\") ~= nil then
		return false
	end

	if string.find(str,"`") ~= nil then
		return false
	end

	if string.find(str,"&") ~= nil then
		return false
	end

	return true
end

--args 			table 		参数
--return 		bool 		是否合法
function commonTool.checkTableUnlawwedString(args)
	if args == nil or type(args) ~= "table" then
		return commonTool.checkUnlawwedString(args)
	end
	for k,v in pairs(args) do
		if type(v) == "table" then
			local res=commonTool.checkTableUnlawwedString(v)
			if res == false then
				return false
			end
		else
			local res=commonTool.checkUnlawwedString(v)
			if res == false then
				return false
			end
		end
	end
	return true
end

--判断身份证是否合法
function commonTool.checkIdCard(str)
	if commonTool.isStringEmpty(str) == true then
		printE("checkIdCard nil")
		return false
	end

	local function checkBirthday(year,month,day)
		year=tonumber(year)
		month=tonumber(month)
		day=tonumber(day)
		local days={31,28,31,30,31,30,31,31,30,31,30,31}
		if year == nil or month == nil or day == nil then
			printE("checkBirthday args is nil",year,month,day)
			return false
		end

		if month < 1 or month > 12 then
			printE("checkBirthday month err",month)
			return false
		end

		local isLeapYear=false--闰年
		if year%4 == 0 then
			isLeapYear=true
			if not (year%100 == 0 and year%400 == 0) then
				--printE("check birth day : is isLeapYear true",year)
				isLeapYear=false
			end
		end

		if isLeapYear == true then
			days[2]=29
		else
			days[2]=28
		end

		if days[month] == nil or day < 0 or day > days[month] then
			printE("checkBirthday day err",day,days[month])
			return false
		end

		return true
	end

	local function varifyCode(str)
		local tmp={}
		local len=string.len(str)
		for i=1,len,1 do
			table.insert(tmp,string.sub(str,i,i))
		end
		local iS=0
		local iW={7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2}
		local lastCode={'1','0','X','9','8','7','6','5','4','3','2'}
		for i=1,17,1 do
			iS=iS+(string.byte(tmp[i])-48)*iW[i]
		end

		local iY=iS%11
		local ch=lastCode[iY+1]
		local lastChar=ch
		if lastChar ~= string.sub(str,18,18) then
			printE("checkBirthday last char err",iY,ch,lastChar,string.sub(str,18,18))
			return false
		end

		return true
	end

	local function idCard15to18(str)
		if commonTool.getStringLen(str) ~= 15 then
			return ""
		end

		local tmp={}
		local len=string.len(str)
		for i=1,len,1 do
			table.insert(tmp,string.sub(str,i,i))
		end

		local iS=0
		local iW={7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2}
		local lastCode={'1','0','X','9','8','7','6','5','4','3','2'}

		local newId={}
		for i=1,6,1 do
			newId[i]=tmp[i]
		end
		newId[7]="1"
		newId[8]="9"

		for i=9,17,1 do
			newId[i]=tmp[i-2]
		end

		for i=1,17,1 do
			iS=iS+(string.byte(newId[i])-48)*iW[i]
		end

		local iY=iS%11
		newId[18]=lastCode[iY+1]
		local new=""
		for i=1,#newId,1 do
			new=new..newId[i]
		end
		if string.len(new) ~= 18 then
			printE("idCard15to18 new id not 18 len",new,#newId)
			return ""
		end

		return new
	end

	local function check18IdCard(str)
		local address={"11","22","35","44","53","12","23","36","45","54","13","31","37","46","61","14","32","41","50","62","15","33","42","51","63","21","34","43","52","64","65","71","81","82","91"}
		for i=1,35,1 do
			if string.sub(str,1,2) ~= address[i] then
				break
			elseif i == 35 then
				return false
			end
		end

		local birth=string.sub(str,7,14)
		if checkBirthday(string.sub(birth,1,4),string.sub(birth,5,6),string.sub(birth,7,8)) == false then
			return false
		end
		if varifyCode(str) == false then
			return false
		end

		return true
	end

	local function check15IdCard(str)
		str=idCard15to18(str)
		if check18IdCard(str) == false then
			return false
		end

		return true
	end

	--18位
	if commonTool.getStringLen(str) == 18 then
		local res=check18IdCard(str)
		return res
	end

	--15位
	if commonTool.getStringLen(str) == 15 then
		local res=check15IdCard(str)
		return res
	end

	return false
end

--获取随机AscII字符，范围是48~57 65~90 97~122
--len字符串长度
function commonTool.getRandomAscII(len)
	if len == nil or len <= 0 then
		printE("getRandomAscII args is nil")
		return ""
	end
	local str=""
	while len > 0 do
		local char=""
		local i=math.random(1,3)
		if i == 1 then
			char=string.char(math.random(48,57))
		end
		if i == 2 then
			char=string.char(math.random(65,90))
		end
		if i == 3 then
			char=string.char(math.random(97,122))
		end
		str=str..char
		len=len-1
	end

	return str
end

--获取随机数字字符，范围是0~9
--len字符串长度
function commonTool.getRandomNumString(len)
	if len == nil or len <= 0 then
		printE("getRandomNumString args is nil")
		return ""
	end
	local str=""
	while len > 0 do
		local char=math.random(0,9)
		str=str..char
		len=len-1
	end

	return str
end

function commonTool.tableRemoveAll(tab)
	local i = 1
	while i <= #tab do
		if remove[tab[i]] then
		    table.remove(tab,i)
		else
		    i = i + 1
		end
	end
end

--根据preTableName表前缀获得相应的key
function commonTool.getKeyByPreTableName(preTableName)
	if preTableName == h.newRoomSelfPreTableName.NewRoomSelf then
		return {lastVideo="lastNewRoomSelfVideoTime",lastPlay="lastNewRoomSelfPlayTime",uidRecord=commonTool.userID_newGameRecord,uidVideo=commonTool.userID_newGameVideo,rdsVideo="NewGameVideo",lastCount="lastNewRoomSelfPlayCount",groupAdminCreate=hs.rdsTabName.NewGroupAdminCreateList}
	end
	if preTableName == h.newRoomSelfPreTableName.HgwRoomSelf then
		return {lastVideo="lastHgwRoomSelfVideoTime",lastPlay="lastHgwRoomSelfPlayTime",uidRecord=commonTool.userID_hgwGameRecord,uidVideo=commonTool.userID_hgwGameVideo,rdsVideo="HgwGameVideo",lastCount="lastHgwRoomSelfPlayCount",groupAdminCreate=hs.rdsTabName.NewGroupAdminCreateList}
	end
	return {lastVideo="lastNewRoomSelfVideoTime",lastPlay="lastNewRoomSelfPlayTime",uidRecord=commonTool.userID_newGameRecord,uidVideo=commonTool.userID_newGameVideo,rdsVideo="NewGameVideo",lastCount="lastNewRoomSelfPlayCount",groupAdminCreate=hs.rdsTabName.NewGroupAdminCreateList}
end

--[[
创建微信签名
]]
function commonTool.makeWxSign(args)
	if type(args) ~= "table" then
		printE("makeWxSign args is nil",args)
		return ""
	end

	--Key排序
    local key_table = {}
    --取出所有的键
    for k,_ in pairs(args) do
        table.insert(key_table,k)
    end
    --对所有键进行排序
    local sign=""
    table.sort(key_table)
    for _,k in pairs(key_table) do
        sign=sign..k.."="..tostring(args[k]).."&"
    end

    if commonTool.isStringEmpty(sign) == true then
        printE("makeWxSign sign is empty")
        return ""
    end
    sign=commonTool.cutStringLast(sign)

    sign=sign.."&key="..hs.WeiXinRedPaperKey

    sign=md5.sumhexa(sign)
    sign=string.upper(sign)
    return sign
end

--转换微信用户信息
function commonTool.changeWeiXinUserInfo(weiXinUserInfo)
	if weiXinUserInfo == nil then
		printE("changeWeiXinUserInfo args is nil")
		return nil
	end

	--替换非法字符串
	weiXinUserInfo.nickname=commonTool.replaceSymbol(weiXinUserInfo.nickname or "")

	weiXinUserInfo.userID=0--微信没有第三方userID
	weiXinUserInfo.sexID=tonumber(weiXinUserInfo.sex) or 1 -- 微信中 男性为1，女性为2 ，字牌里男性为0，女性为1，因此这里-1做一个转换
    weiXinUserInfo.nickName=weiXinUserInfo.nickname
    weiXinUserInfo.thirdPartNickName=weiXinUserInfo.nickname
    weiXinUserInfo.thirdPartToken=weiXinUserInfo.accessToken
    weiXinUserInfo.thirdPartUnionID=weiXinUserInfo.unionid
    weiXinUserInfo.thirdPartAppOpenID=weiXinUserInfo.openid
    weiXinUserInfo.thirdPartPublicOpenID=weiXinUserInfo.publicOpenID
	weiXinUserInfo.thirdPartRefreshToken=weiXinUserInfo.refreshToken
	weiXinUserInfo.thirdAvatarID=weiXinUserInfo.headimgurl
	weiXinUserInfo.sexID=weiXinUserInfo.sexID-1
	if weiXinUserInfo.sexID > 1 then
		weiXinUserInfo.sexID=1
	end
	if weiXinUserInfo.sexID < 0 then
		weiXinUserInfo.sexID=0
	end
    return weiXinUserInfo
end

--去掉空格
function commonTool.trimString(str)
	str=tostring(str)
	str=string.gsub(str, " ", "")
	return str
end

--截取字符串
--len  从0开始截取多少个字符
function commonTool.subString(inputstr,len)
	if inputstr == nil or len == nil or len <= 0 then
		printE("subString args is nil")
        return ""
    end
    local out=""
    inputstr=tostring(inputstr)
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount
        out=out..char
		len=len-1
		if len <= 0 then
		    return out
		end
    end
    return out
end

--计算字符串长度
--inputstr  string
function commonTool.getStringLen(inputstr)
	if inputstr == nil then
        return 0
    end
    inputstr=tostring(inputstr)
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount                                              
        if byteCount == 1 then
            width = width + 1
        else
            width = width + 2  --中文算2个字符
        end
    end
    return width
end

--是否包含绘文字
function commonTool.hasEmoji(inputstr)
	if inputstr == nil then
        return false
    end
    inputstr=tostring(inputstr)
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount                                              
        if byteCount == 1 then
            width = width + 1
        else
            width = width + 2  --中文算2个字符
        end
        if byteCount > 3 then
        	printE("hasEmoji : this char has emoji",char,byteCount)
        	return true
        end
    end
    return false
end
function commonTool.emojiPos(inputstr)
	if inputstr == nil then
        return -1
    end
    inputstr=tostring(inputstr)
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount                                              
        if byteCount == 1 then
            width = width + 1
        else
            width = width + 2  --中文算2个字符
        end
        if byteCount > 3 then
        	printE("hasEmoji : this char has emoji",char,byteCount)
        	return i-byteCount
        end
    end
    return -1
end

--字符串转table
function commonTool.string2Table(str)
	str=tostring(str)
	local tb = {}
	--[[
    UTF8的编码规则：
    1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244); UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致
    2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中 
    3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字) 
    ]]
    for utfChar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tb, utfChar)
    end
    return tb
end

--去除字符串中的emoji
function commonTool.deleteEmojiFromString(str)
	str=tostring(str)
	local newStr=""
	local tab=commonTool.string2Table(str)
	for k,v in pairs(tab) do
		if commonTool.hasEmoji(v) == false then
			newStr=newStr..tostring(v)
		end
	end

	return newStr
end

--tab 			table  		表
--szSeparator   string      分隔符
function commonTool.array2String(tab,szSeparator)
	if tab == nil or type(tab) ~= "table" or szSeparator == nil then
		return ""
	end
	local str=""
	for k,v in pairs(tab) do
		str=str..v..szSeparator
	end
	--去掉最后的逗号
	if str ~= "" then
		str=string.sub(str,1,-2)
	end
	return str
end

--tab 			table  		表
--szSeparator   string      分隔符
function commonTool.string2Array(tab,szSeparator)
	return commonTool.splitString(tab,szSeparator)
end

function commonTool.cutStringLast(str)
	if str ~= "" then
		str=string.sub(str,1,-2)
	end
	return str or ""
end

--比较table，相同返回true
function commonTool.compareTable(tab1,tab2)
	if tab1 == nil or tab2 == nil then
		return false
	end

	for k,v in pairs(tab1) do
		if v ~= tab2[k] then
			return false
		end
	end

	return true
end

function commonTool.showTable(tab,space)
	if tab == nil or type(tab) ~= "table" then
		printE(nil,"show Table : nil table",tab,type(tab))
		return
	end
	if space == nil then
		space=""
	end
	space=space.."   "
	local count=0
	for k,v in pairs(tab) do
		if type(v) == "table" then
			printE(nil,space,k,"[table]")
			commonTool.showTable(v,space)
		else
			printE(nil,space,k,tostring(v))
		end
		count=count+1
	end
	if count == 0 then
		printE(nil,"show Table : empty table",tab)
	end
end

--Redis操作
--[[*****************************************************************************
--redis：        redis数据库        通常是allServerList.redisServerList[1]
--func：         string             redisService函数名
--返回值：       调用结果
******************************************************************************]]
local callRedis=function(redis,func,...)
	if nil == func or "string" ~= type(func) then
		printE("callRedis func is nil or type error.")
		return
	end
	if redis == nil then
		printE("redis is nil or server have't up.")
		return
	end

	local ok, result = pcall(cluster.call, redis.serverName,redis.service, func, ...)
	if false == ok then
		commonTool.showTable(redis)
		commonTool.showDebugStack()
		printE("callRedis request redis server failed, server down?","func:",func)
	end
	return result
end

--MySql操作
local MySql={
--[[*****************************************************************************
--msdb：        MySql数据库        通常是allServerList.dbServerList[1]
--sql：         string             sql语句
--返回值：      调用结果
******************************************************************************]]
Exec = function(msdb,sql)
    if sql == nil or sql == "" or msdb == nil then
        return nil
    end

    local ok, res = pcall(cluster.call, msdb.serverName, msdb.service,"launchSQL", sql)
	if false == ok then
		printE("request SQL failed, sql: "..sql)
	end
	return res

end,
ExecEx = function(msdb,sql)
    local res = MySql.Exec(msdb,sql)
    if res.badresult == true or #res <= 0 then
        return nil
    end

    return res
end
}

--[[*****************************************************************************
--调用DBService的函数
--func:string    DBService函数名
--返回值：调用结果
******************************************************************************]]
local callDBService=function(mysql,func,...)
	if nil == func or "string" ~= type(func) or mysql == nil then
		printE("callDBService func is nil or type error.",mysql,func)
		return
	end

	local ok, result = pcall(cluster.call, mysql.serverName, mysql.service, func, ...)
	if false == ok then
		printE("callDBService request mysql server failed, server down?","func:",func,result)
	end
	return result
end

--lua列表
function commonTool.luaList()
    local first = 1
    local last = 0
    local list = {}
    local listManager = {}
    function listManager.pushFront(_tempObj)
        first = first - 1
        list[first] = _tempObj
    end
    function listManager.pushBack(_tempObj)
        last = last + 1
        list[last] = _tempObj
    end
    function listManager.getFront()
        if listManager.bool_isEmpty() then
            return nil
        else
            local val = list[first]
            return val
        end
    end
    function listManager.getBack()
        if listManager.bool_isEmpty() then
            return nil
        else
            local val = list[last]
            return val
        end
    end
    function listManager.popFront()
        list[first] = nil
        first = first + 1
    end
    function listManager.popBack()
        list[last] = nil
        last = last - 1
    end
    function listManager.clear()
        while false == listManager.bool_isEmpty() do
        listManager.popFront()
    end
    end
    function listManager.bool_isEmpty()
        if first > last then
            first = 1
            last = 0
            return true
        else
            return false
        end
    end
    function listManager.getSize()
        if  listManager.bool_isEmpty() then
            return 0
        else
            return last - first + 1
        end
    end
    return listManager
end

---------------------------End  黄祥瑞  2015.10.03----------------------

function commonTool.word2String(word)

	if type(word) ~="number" then
		return nil
	end
	
	local str1,str2
	str1 = string.char(math.floor(word / 256))
	str2 = string.char(word % 256)

	return str1..str2
end

function commonTool.stringGetWord (str)

	local word = str:byte(1) * 256 + str:byte(2)
	return word
end


function commonTool.registerCallbackFunc (actionCode, func)
	if actionCode == nil then
		return
	end
	if func == nil then
		return
	end
	callbackFuncMgr[actionCode] = func
end

function commonTool.getCallbackFunc (actionCode)
	if actionCode == nil then
		return nil
	end
	if actionCode < h.enumKeyAction.BEGIN then
		if actionCode > h.enumKeyAction.END then
			return nil
		end
	end

	return callbackFuncMgr[actionCode]
end

-- loading msg head with payload.
function commonTool.loadMsgHead (msg, srcEndPoint, dstEndPoint, dstModule, keyAction)
	local msgHeadData = {}
	msgHeadData.msgTag = h.MSG_HEAD_TAG
	msgHeadData.src = srcEndPoint
	msgHeadData.dst = dstEndPoint
	msgHeadData.dstModule = dstModule
	msgHeadData.keyAction = keyAction

	-- h5客户端那边需要，正式服一定要同步 add by sikun
	msgHeadData.rawMsgSize = #msg

	local strTemp = commonTool.word2String(msgHeadData.msgTag)
	strTemp = strTemp..commonTool.word2String(msgHeadData.src)
	strTemp = strTemp..commonTool.word2String(msgHeadData.dst)
	strTemp = strTemp..commonTool.word2String(msgHeadData.dstModule)
	strTemp = strTemp..commonTool.word2String(msgHeadData.keyAction)

    strTemp=strTemp .. msg

if h.encodeFlag == true then
    strTemp=crypt.aesencode(strTemp,hs.passwd,"")
end

	return strTemp, msgHeadData
end

local config_name = skynet.getenv "cluster"
local node_address = {}


local function open_channel(t, key)
	local host, port = string.match(node_address[key], "([^:]+):(.*)$")
	local c = sc.channel {
		host = host,
		port = tonumber(port),
		response = read_response,
		nodelay = true,
	}
	assert(c:connect(true))
	t[key] = c
	node_session[key] = 1
	return c
end

local node_channel = setmetatable({}, { __index = open_channel })

local function loadconfig()

	local f = assert(io.open(config_name))
	local source = f:read "*a"
	f:close()
	local tmp = {}
	assert(load(source, "@"..config_name, "t", tmp))()
	for name,address in pairs(tmp) do
		assert(type(address) == "string")
		if node_address[name] ~= address then
			-- address changed
			if rawget(node_channel, name) then
				node_channel[name] = nil	-- reset connection
			end
			node_address[name] = address
		end
	end
end

function commonTool.getClusterAddr(name)
	if name then
		loadconfig()
		local ip, port = string.match(node_address[name], "([^:]+):(.*)$")
		return ip, port
	end
end


local function getServerList(srcServerName, srcType, dstType)
	if commonTool.SERVER_TYPE.DB == srcType then
		printF(srcServerName, "get dbServer now.")
	end

	local ok, serverList = pcall(cluster.call,commonTool.CENTER_INFO.name,commonTool.CENTER_INFO.service,"getServerList",dstType)
	if ok then
		if commonTool.SERVER_TYPE.DB == dstType then
			printF(srcServerName, "get dbServer success.")
		end
		return serverList
	else
		printE("getServerList error.")
		printE(serverList)
	end
	if commonTool.SERVER_TYPE.DB == dstType then
		printF(srcServerName, "get dbServer failed.")
	end
end

--获取倍率表
local function getRoomRateList(serverName)

	local ok, roomRateList = pcall(cluster.call,commonTool.CENTER_INFO.name,commonTool.CENTER_INFO.service,"getRoomRateList",dstType)
	if ok then
		printF(serverName,"getRoomRateList success, len: "..tostring(roomRateList))
		return roomRateList
	end
	printF(serverName,"getRoomRateList failed.")
end

--同步服务器列表
local function synServerList(allServerList, selfType, serverName, serverSelf)
	printF(serverName,"synServerList, self: "..selfType)
	if selfType ~= commonTool.SERVER_TYPE.GATE then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.GATE)
		if serverList then
			allServerList.gateServerList = serverList
			printF(serverName,"synServerList gate server num: "..tostring(#allServerList.gateServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.LOGIN then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.LOGIN)
		if serverList then
			allServerList.loginServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.loginServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.GAMEROOM then

		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.GAMEROOM)
		if serverList then
			allServerList.roomServerList = serverList
			--[[
			if serverList[500] then
				printF(serverName,"room rate 500 Getting serverList len: "..tostring(#serverList[500]))
				printF(serverName,"room rate 500 Save roomServerList len: "..tostring(#allServerList.roomServerList[500]))
				printF(serverName,"get room id: "..tostring(allServerList.roomServerList[500][1].id))
				printF(serverName,"get room rate: "..tostring(allServerList.roomServerList[500][1].rate))
				printF(serverName,"synServerList room server.")
			end
			if serverList[2000] then
				printF(serverName,"room rate 500 Getting serverList len: "..tostring(#serverList[2000]))
				printF(serverName,"room rate 500 Save roomServerList len: "..tostring(#allServerList.roomServerList[2000]))
				printF(serverName,"get room id: "..tostring(allServerList.roomServerList[2000][1].id))
				printF(serverName,"get room rate: "..tostring(allServerList.roomServerList[2000][1].rate))
				printF(serverName,"synServerList room server.")
			end
			]]
		end

	end
	if selfType ~= commonTool.SERVER_TYPE.DB then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.DB)
		if serverList then
			allServerList.dbServerList = serverList
			printF(serverName,"synServerList db server num: "..tostring(#allServerList.dbServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.DB_LOG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.DB_LOG)
		if serverList then
			allServerList.dblogServerList = serverList
			printF(serverName,"synServerList dblog server num: "..tostring(#allServerList.dblogServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.DB_DISPATCHER then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.DB_DISPATCHER)
		if serverList then
			allServerList.dbDispatcherServerList = serverList
			printF(serverName,"synServerList dbDispatcherServerList server num: "..tostring(#allServerList.dbDispatcherServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.DB_OFFER then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.DB_OFFER)
		if serverList then
			allServerList.dbOfferServerList = serverList
			printF(serverName,"synServerList dbOfferServerList server num: "..tostring(#allServerList.dbOfferServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.TIMER then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.TIMER)
		if serverList then
			allServerList.timerServerList = serverList
			printF(serverName,"synServerList timerServerList server num: "..tostring(#allServerList.timerServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.REDIS then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.REDIS)
		if serverList then
			allServerList.redisServerList = serverList
			printF(serverName,"synServerList redis server num: "..tostring(#allServerList.redisServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.LOBBY then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.LOBBY)
		if serverList then
			allServerList.lobbyServerList = serverList
			printF(serverName,"synServerList lobby server num: "..tostring(#allServerList.lobbyServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_MATCH then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_MATCH)
		if serverList then
			allServerList.roomMatchList = serverList
			printF(serverName,"synServerList roomMatch server num: "..tostring(#allServerList.roomMatchList))
			--大厅需要将比赛房间放入对应赛区
			if selfType == commonTool.SERVER_TYPE.LOBBY then
				for i=1,  #serverList do
					table.insert(serverSelf.matchZoneList[serverList[i].matchZone].matchRoomList, serverList[i])
					printF(serverSelf.serverName, serverSelf.matchZoneList[serverList[i].matchZone].title.."区 上线一个比赛: "
							..serverList[i].matchTitle)
				end
			end
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_SELF then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_SELF)
		if serverList then
			allServerList.roomSelfList = serverList
			printF(serverName,"synServerList roomSelf server num: "..tostring(#allServerList.roomSelfList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.MALL then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.MALL)
		if serverList then
			allServerList.mallServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.mallServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.CLUB then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.CLUB)
		if serverList then
			allServerList.clubServerList = serverList
			printF(serverName,"synServerList club server num: "..tostring(#allServerList.clubServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.DATA_SHARER then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.DATA_SHARER)
		if serverList then
			allServerList.dataSharerServerList = serverList
			printF(serverName,"synServerList DATA_SHARER server num: "..tostring(#allServerList.dataSharerServerList))
		end
	end
	
	if selfType ~= commonTool.SERVER_TYPE.NEW_ROOM_SELF  then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.NEW_ROOM_SELF)
		if serverList then  
			allServerList.newRoomSelfList = serverList
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.MINING  then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.MINING)
		if serverList then  
			allServerList.miningServerList = serverList
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.RADIO then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.RADIO)
		if serverList then
			allServerList.radioServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.radioServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.EMAIL then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.EMAIL)
		if serverList then
			allServerList.emailServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.emailServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.RANK then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.RANK)
		if serverList then
			allServerList.rankServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.rankServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.MISSION then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.MISSION)
		if serverList then
			allServerList.missionServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.missionServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.HTTPS then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.HTTPS)
		if serverList then
			allServerList.httpsServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.httpsServerList))
		end
	end
	
	if selfType ~= commonTool.SERVER_TYPE.ROOM_SELF_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_SELF_MG)
		if serverList then
			printE(" get roomSelfMgServerList success ",serverName)
			allServerList.roomSelfMgServerList = serverList
			printF(serverName,"synServerList ROOM_SELG_MG server num: "..tostring(#allServerList.roomSelfMgServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.OUTER_WEB then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.OUTER_WEB)
		if serverList then
			allServerList.outerWebServerList = serverList
			printF(serverName,"synServerList login server num: "..tostring(#allServerList.outerWebServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_NIUNIU then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_NIUNIU)
		if serverList then
			allServerList.roomNiuniuServerList = serverList
			printF(serverName,"synServerList roomNiuniuServerList server num: "..tostring(#allServerList.roomNiuniuServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_NIUNIU_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_NIUNIU_MG)
		if serverList then
			allServerList.roomNiuniuMgServerList = serverList
			printE(serverName,"synServerList roomNiuniuMgServerList server num: "..tostring(#allServerList.roomNiuniuMgServerList))
		end
	end
	
	if selfType ~= commonTool.SERVER_TYPE.NN_RATE_SERVER then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.NN_RATE_SERVER)
		if serverList then
			allServerList.rateNiuniuServerList = serverList
			printE(serverName,"synServerList rateNiuniuServerList server num: "..tostring(#allServerList.rateNiuniuServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.RATE_NIUNIU_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.RATE_NIUNIU_MG)
		if serverList then
			allServerList.rateNiuniuMgServerList = serverList
			printE(serverName,"synServerList rateNiuniuMgServerList server num: "..tostring(#allServerList.rateNiuniuMgServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_PDK then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_PDK)
		if serverList then
			allServerList.roomPDKServerList = serverList
			printE(serverName,"synServerList roomPDKServerList server num: "..tostring(#allServerList.roomPDKServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.ROOM_PDK_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_PDK_MG)
		if serverList then
			allServerList.roomPDKMgServerList = serverList
			printE(serverName,"synServerList roomPDKMgServerList server num: "..tostring(#allServerList.roomPDKMgServerList))
		end
	end

	if selfType ~= commonTool.SERVER_TYPE.RATE_ROOM_PDK then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.RATE_ROOM_PDK)
		if serverList then
			allServerList.ratePDKServerList = serverList
			printE(serverName,"synServerList ratePDKServerList server num: "..tostring(#allServerList.ratePDKServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.RATE_ROOM_PDK_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.RATE_ROOM_PDK_MG)
		if serverList then
			allServerList.ratePDKMgServerList = serverList
			printE(serverName,"synServerList ratePDKMgServerList server num: "..tostring(#allServerList.ratePDKMgServerList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.ROOM_CHALLENGE then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_CHALLENGE)
		if serverList then
			allServerList.roomChallengeServerList = serverList
			printE(serverName, "synServerList roomChallenge server num: "..tostring(#serverList))
		end
	end
	if selfType ~= commonTool.SERVER_TYPE.ROOM_CHALLENGE_MG then
		local serverList = getServerList(serverName, selfType, commonTool.SERVER_TYPE.ROOM_CHALLENGE_MG)
		if serverList then
			allServerList.roomChallengeMgServerList = serverList
			printE(serverName, "synServerList roomChallengeMg server num: "..tostring(#serverList))
		end
	end
	if selfType == commonTool.SERVER_TYPE.ROOM_PDK_MG or selfType == commonTool.SERVER_TYPE.ROOM_PDK or 
		selfType == commonTool.SERVER_TYPE.RATE_ROOM_PDK_MG or selfType == commonTool.SERVER_TYPE.RATE_ROOM_PDK  then 
		if allServerList.gateServerList and #allServerList.gateServerList > 0 then 
			printE("changeServerIndex gate")
			allServerList[commonTool.SERVER_TYPE.GATE] = allServerList.gateServerList
		end
		if allServerList.dbServerList and #allServerList.dbServerList > 0 then
			printE("changeServerIndex DB") 
			allServerList[commonTool.SERVER_TYPE.DB] = allServerList.dbServerList
		end
		if allServerList.redisServerList and #allServerList.redisServerList > 0 then 
			printE("changeServerIndex REDIS")
			allServerList[commonTool.SERVER_TYPE.REDIS] = allServerList.redisServerList
		end
		if allServerList.roomPDKMgServerList and #allServerList.roomPDKMgServerList > 0 then 
			printE("changeServerIndex ROOM_PDK_MG")
			allServerList[commonTool.SERVER_TYPE.ROOM_PDK_MG] = allServerList.roomPDKMgServerList
		end
		if allServerList.roomPDKServerList and #allServerList.roomPDKServerList > 0 then 
			allServerList[commonTool.SERVER_TYPE.ROOM_PDK] = allServerList.roomPDKServerList
		end
		if allServerList.ratePDKMgServerList and #allServerList.ratePDKMgServerList > 0 then 
			printE("changeServerIndex RATE_ROOM_PDK_MG")
			allServerList[commonTool.SERVER_TYPE.RATE_ROOM_PDK_MG] = allServerList.ratePDKMgServerList
		end
		if allServerList.ratePDKServerList and #allServerList.ratePDKServerList > 0 then 
			allServerList[commonTool.SERVER_TYPE.RATE_ROOM_PDK] = allServerList.ratePDKServerList
		end
	end

end

local function keepAliveCenter(serverSelf, registerFlag, allServerList)
	local i = 1
	local broken = false
	while true do
		skynet.sleep(commonTool.centerDogTime*100)
		if registerFlag then
			--printF(serverSelf.serverName, "send keepAliveCenter msg >>>>>>  type: "..serverSelf.serverType ..", id: "..tostring(serverSelf.id))
			local ok, result = pcall(cluster.call,commonTool.CENTER_INFO.name,commonTool.CENTER_INFO.service,"keepAlive",
								serverSelf.serverType, serverSelf.id, serverSelf.rate, serverSelf.connectNum)
			if true ~= ok then
				registerFlag = false
				printE("keepAliveCenter failed, error info:",result)
			else
				if true ~= result then
					registerFlag = false
					printE("keepAliveCenter failed, serverSelf maybe down, will reconnect. server info:",serverSelf.serverName, serverSelf.id)
				end
				--printF(serverSelf.serverName, "keepAliveCenter, type: "..serverSelf.serverType ..", id: "..tostring(serverSelf.id))
			end
		else
			--reregister.
			printF(serverSelf.serverName, "CenterServer is not online, try to register again: "..tostring(i).." times.")
			ok, serverSelf.id = pcall(cluster.call,  commonTool.CENTER_INFO.name,  commonTool.CENTER_INFO.service, "registerServer", serverSelf)
			if ok then
				printF(serverSelf.serverName, "server id: "..tostring(serverSelf.id))
				registerFlag = true
				--同步服务器列表
				synServerList(allServerList, serverSelf.serverType, serverSelf.serverName, serverSelf)
				
			end
			i = i + 1
		end
		if false then
			local fileName="./bin/center/config/downServerName"
			local serverName=commonTool.readFile(fileName)
			if commonTool.isStringEmpty(serverName) == false and serverSelf.serverName == serverName then
				printE("checkServerDown there is a service need down : ",serverName)
				local f=io.open(fileName,"w")
				if f then
					f:write("")
					f:close()
				end
				break
			end
		end
	end
end

function commonTool.registerServer(serverSelf, allServerList)
	skynet.setenv("serverTypeSelf",serverSelf.serverType)

	local ok = false
	local i = 0

	while false == ok do
		ok, serverSelf.id = pcall(cluster.call, commonTool.CENTER_INFO.name, commonTool.CENTER_INFO.service, "registerServer", serverSelf)
		if ok then
			printF(serverSelf.serverName, "id: "..tostring(serverSelf.id))
			registerFlag = true
			--同步服务器列表
			synServerList(allServerList, serverSelf.serverType, serverSelf.serverName, serverSelf)

			break
		end
		i = i + 1
		printF(serverSelf.serverName, "CenterServer is not online, try to register again: "..tostring(i).." times.")
		skynet.sleep(300)
	end

	printF(serverSelf.serverName, "register server success, id: "..tostring(serverSelf.id))
	if serverSelf.id and (0 < serverSelf.id) then
			skynet.fork(keepAliveCenter, serverSelf, registerFlag, allServerList)
	end
end

--Bgein: mingyuan.xie added 高、中、低倍率等级金币上限 2015.10.12
commonTool.lowRateRoomCoin		= 60000		--低倍房上限
commonTool.middleRateRoomCoin	= 1000000	--中倍房上限
commonTool.highRateRoomCoin		= 6000000	--高倍房上限

commonTool.minGameCoin	 		= 3000		--进入游戏最低金币要求，可登陆但不能游戏
--End: mingyuan.xie added 高、中、低倍率等级金币上限 2015.10.12

-- 上传录像的花费, Zhenyu Yao, 2015.12.12
commonTool.uploadHistoryPrice	= 50000

commonTool.RATE_ROOM_MAX_LOW		= 500		--低倍房倍率最大值，即：rate <= LOW_MAX
commonTool.RATE_ROOM_MAX_MID		= 10000	    --中倍房倍率最大值，即：LOW_MAX < rate < MID_MAX
commonTool.RATE_ROOM_MAX_HIG		= 100000	--高倍房倍率最大值，即：MID_MAX < rate

--[[
解析套接字
]]
function commonTool.getIpAddressInfo(ipAddress)
	if type(ipAddress) ~= "string" or commonTool.isStringEmpty(ipAddress) == true then
		printE("getIpAddressInfo args err",ipAddress)
		return {ip="",port=0}
	end

	local info=commonTool.splitString(ipAddress,":")
	if #info ~= 2 then
		printE("getIpAddressInfo addr err",ipAddress)
		return {ip="",port=0}
	end

	return {ip=tostring(info[1]),port=tonumber(info[2])}
end

--[[*****************************************************************************
功能描述：获取倍率房对应的最低金币(用于AI金币显示)
参数：无
作者：mingyuan.xie
时间：2015.10.12
*********************************************************************************]]
function commonTool.getRateMinCoin(rate)

	if "number" ~= type(rate) then
		print("getRateMinCoin error, rate is not number.")
		return -1
	end
--[[ 内测临时分配策略
	if 500 == rate then
		return 6000
	elseif 5000 == rate then
		return 50000
	else
		return -1
	end]]

	if 100 == rate then
		return 3000
	--elseif 200 == rate then
	--	return 6000--12000
	elseif 500 == rate then
		return 6000--30000
	elseif 1000 == rate then
		return 30000
	elseif 2000 == rate then
		return 100000
	elseif 5000 == rate then
		return 200000
	elseif 10000 == rate then
		return 600000
	elseif 20000 == rate then
		return 1000000
	elseif 50000 == rate then
		return 3000000
	elseif 100000 == rate then
		return 6000000
	else
		return -1
	end

end

--[[*****************************************************************************
功能描述：获取倍率房对应的最高金币(用于AI金币显示)
参数：无
作者：mingyuan.xie
时间：2015.10.20
*********************************************************************************]]
function commonTool.getRateMaxCoin(rate)

	if "number" ~= type(rate) then
		print("getRateMinCoin error, rate is not number.")
		return 0
	end
--[[ 内测临时分配策略
	if 500 == rate then
		return 50000
	elseif 5000 == rate then
		return 10000000
	else
		return 0
	end]]

	if 100 == rate then
		return 12000
	--elseif 200 == rate then
	--	return 30000
	elseif 500 == rate then
		return 30000
	elseif 1000 == rate then
		return 100000
	elseif 2000 == rate then
		return 200000
	elseif 5000 == rate then
		return 600000
	elseif 10000 == rate then
		return 1000000
	elseif 20000 == rate then
		return 3000000
	elseif 50000 == rate then
		return 6000000
	elseif 100000 == rate then
		return 86666666	--无穷大
	else
		return 0
	end

end

--[[*****************************************************************************
功能描述：获取倍率房降级金币数
参数：无
作者：mingyuan.xie
时间：2015.10.21
*********************************************************************************]]
function commonTool.getRateCoin_Down(rate)

	if "number" ~= type(rate) then
		print("getRateCoin_Down error, rate is not number.")
		return -1
	end
--[[ 内测临时分配策略
	if 5000 == rate then
		return 50000
	elseif 500 == rate then
		return 5800
	else
		return -1
	end]]

	if 100 == rate then
		return 3000
	--elseif 200 == rate then
	--	return 6000
	elseif 500 == rate then
		return 6000--25000
	elseif 1000 == rate then
		return 25000--60000
	elseif 2000 == rate then
		return 80000
	elseif 5000 == rate then
		return 150000
	elseif 10000 == rate then
		return 500000
	elseif 20000 == rate then
		return 800000
	elseif 50000 == rate then
		return 2600000--1500000
	elseif 100000 == rate then
		return 5200000--3000000
	else
		return -1
	end

end

--[[*****************************************************************************
功能描述：获取倍率房的升级金币数
参数：无
作者：mingyuan.xie
时间：2015.10.20
*********************************************************************************]]
function commonTool.getRateCoin_Up(rate)

	if "number" ~= type(rate) then
		print("getRateCoin_Up error, rate is not number.")
		return 0
	end
--[[ 内测临时分配策略
	if 500 == rate then
		return 50000
	elseif 5000 == rate then
		return 2000000000
	else
		return 0
	end]]

	if 100 == rate then
		return 12000--60000
	--elseif 200 == rate then
	--	return 30000--60000
	elseif 500 == rate then
		return 30000
	elseif 1000 == rate then
		return 100000--120000--1000000
	elseif 2000 == rate then
		return 200000--1000000
	elseif 5000 == rate then
		return 600000--600000--1000000
	elseif 10000 == rate then
		return 1000000
	elseif 20000 == rate then
		return 3000000--6000000
	elseif 50000 == rate then
		return 6000000
	elseif 100000 == rate then
		return 4294967295	--无穷大
	else
		return 0
	end

end

--------------------------------------------------------------------Begin 黄祥瑞 2015.10.09-------------------------------------------------
--[[*****************************************************************************
冒泡排序
key排序的字段
*********************************************************************************]]
function commonTool.bubbleSort(tab,key)
    if tab == nil or type(tab) ~= "table" or key == nil then
        printE("bubbleSort : tab or key is nil",tab,key)
        return
    end
    local isF = true
    for m = #tab - 1, 1, -1 do
        isF = true
        for i = #tab - 1, 1, -1 do
            if tab[i][key] < tab[i + 1][key] then
                tab[i], tab[i + 1] = tab[i + 1], tab[i]
                isF = false
            end
        end
        if isF then
            break
        end
    end
end

--[[*****************************************************************************
反冒泡排序
key排序的字段
*********************************************************************************]]
function commonTool.antiBubbleSort(tab,key)
    if tab == nil or type(tab) ~= "table" or key == nil then
        printE("bubbleSort : tab or key is nil",tab,key)
        return
    end
    local isF = true
    for m = #tab - 1, 1, -1 do
        isF = true
        for i = #tab - 1, 1, -1 do
            if tab[i][key] > tab[i + 1][key] then
                tab[i], tab[i + 1] = tab[i + 1], tab[i]
                isF = false
            end
        end
        if isF then
            break
        end
    end
end

--[[*****************************************************************************
深拷贝
*********************************************************************************]]
function commonTool.deepCopy(st)
	if st == nil then
		return nil
	end
    local tab = { }
    for k, v in pairs(st or { }) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = commonTool.deepCopy(v)
        end
    end
    return tab
end

--[[********************************************************************
比较时间字符串
time1 		string 	YYYY-mm-dd HH:MM:SS
time2 		string 	YYYY-mm-dd HH:MM:SS
返回值 		int 	time1比time2多多少秒
************************************************************************]]
function commonTool.compareTime(time1,time2)
	if time1 == nil or time2 == nil then
		printE("compareTime args is nil",time1,time2)
		return 0
	end

	time1=commonTool.date2Sec(time1)
	time2=commonTool.date2Sec(time2)

	local val=time1-time2
	return val
end

--[[********************************************************************
比较时间字符串是否在startTime与endTime之间
time 			string 	YYYY-mm-dd HH:MM:SS
startTime 		string 	YYYY-mm-dd HH:MM:SS
endTime 		string 	YYYY-mm-dd HH:MM:SS
返回值 		bool
************************************************************************]]
function commonTool.ifTimeInZone(time,startTime,endTime)
	if time == nil or startTime == nil or endTime == nil then
		printE("ifTimeInZone args is nil",time,startTime,endTime)
		return false
	end
	time=commonTool.date2Sec(time)
	startTime=commonTool.date2Sec(startTime)
	endTime=commonTool.date2Sec(endTime)

	if startTime > endTime then
		printE("ifTimeInZone : startTime is bigger than endTime",time,startTime,endTime)
		return false
	end

	if time >= startTime and time <= endTime then
		return true
	end
	return false
end


--[[********************************************************************
指定日期转为秒数
date            string          日期  YYYY-mm-dd HH:MM::SS
返回值          int             秒数
************************************************************************]]
function commonTool.date2Sec(date)
    if date == nil then
        printE("date2Sec : args is nil")
        date=commonTool.sec2Date()
    end

    local function split(str, pat)
        local t = { }
        -- NOTE: use {n = 0} in Lua-5.0
        local fpat = "(.-)" .. pat
        local last_end = 1
        local s, e, cap = str:find(fpat, 1)
        while s do
            if s ~= 1 or cap ~= "" then
                table.insert(t, cap)
            end
            last_end = e + 1
            s, e, cap = str:find(fpat, last_end)
        end
        if last_end <= #str then
            cap = str:sub(last_end)
            table.insert(t, cap)
        end
        return t
    end

    local a = split(date, " ")
    local b = split(a[1], "-")
    local c = split(a[2], ":")
    local t = os.time({year=b[1],month=b[2],day=b[3], hour=c[1], min=c[2], sec=c[3]})
    return t
end

--jikan  YYYY-mm-dd HH:MM:SS
function commonTool.stringTime2DateTime(jikan)
	local Y=0
	local m=0
	local d=0
	local H=0
	local M=0
	local S=0
	jikan=commonTool.splitString(jikan," ")
	if #jikan == 2 then
		local date=commonTool.splitString(jikan[1],"-")
		local time=commonTool.splitString(jikan[2],":")
		Y=date[1]
		m=date[2]
		d=date[3]
		H=time[1]
		M=time[2]
		S=time[3]
	end
	if #jikan == 1 then
		jikan=commonTool.splitString(jikan[1],"-")
		if #jikan == 1 then
			local time=commonTool.splitString(jikan[1],":")
			H=time[1]
			M=time[2]
			S=time[3]
		else
			Y=jikan[1]
			m=jikan[2]
			d=jikan[3]
		end
	end

	return {year=Y,month=m,day=d,hour=H,minute=M,second=S}
end

--jikan    int   秒
function commonTool.sec2DateTime(jikan)
	jikan=commonTool.sec2Date(jikan)
	return commonTool.stringTime2DateTime(jikan)
end

--dateTime {year,month,day,hour,minute,second}
function commonTool.dateTime2StringTime(dateTime)
	local year=dateTime.year or "0000"
	local month=dateTime.month or "00"
	local day=dateTime.day or "00"
	local hour=dateTime.hour or "00"
	local minute=dateTime.minute or "00"
	local second=dateTime.second or "00"

	local str=year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second
	return str
end

function commonTool.num2bool(num)
	num=math.floor(tonumber(num))
	if num == 0 then
		return false
	end
	return true
end

function commonTool.string2bool(str)
	if str == "true" then
		return true
	end
	return false
end

function commonTool.redisTable2LuaTable(res)
	if #res > 0 then
        local rtab = { }
        if #res % 2 ~= 0 then
            return nil
        end
        for i = 1, #res, 2 do
            if i+1 <= #res then
                rtab[res[i]] = res[i + 1]
            end
        end
        return rtab
    end
    return nil
end

function commonTool.redisTable2LuaTable2(res)
	if #res > 0 then
        local list = { }
        if #res % 2 ~= 0 then
            return nil
        end
        for i = 1, #res, 1 do
        	local cell = { }
        	for j=1,#res[i],2 do
        		if j+1 <= #res then
	                cell[res[i][j]] = res[i][j+1]
	            end
        	end
        	if #res[i] > 0 then
        		table.insert(list,cell)
        	end
        end
        return list
    end
    return nil
end

function commonTool.isNumber(str)
	if tonumber(str) == nil then
		return false
	end
	return true
end

function commonTool.safe2Num(str)
	if tonumber(str) == nil then
		return str
	end
	return tonumber(str)
end

function commonTool.safeTable2Num(tab)
	if tab == nil or type(tab) ~= "table" then
		printE("safeTable2Num : nil table",tab)
		return
	end
	local count=0
	for k,v in pairs(tab) do
		if type(v) == "table" then
			commonTool.safeTable2Num(v)
		else
			tab[k]=commonTool.safe2Num(v)
		end
		count=count+1
	end
	if count == 0 then
	end

	return tab
end

--[[*****************************************************************************
--获得用户金币
mysql           mysql服务
redis           redis服务
userID          int         用户名
返回值          int    金币
******************************************************************************]]
function commonTool.getUserGoldCoin(mysql,redis,userID)
    if mysql == nil or redis == nil or userID == nil then
        printE("getUserGoldCoin : args is nil",mysql,redis,userID)
        return 0
    end
    local gc=0
    local acc=callRedis(redis,"GetAccount",userID)
    --如果redis查不到，从mysql查
    if acc == nil then
        local res=callDBService(mysql,"launchSQL","select ID,goldCoin from Account where userID="..userID)
        if callDBService(mysql,"SafeCheck",res) == false then
            printE("getUserGoldCoin : safe check fail",userID)
            return 0
        end
        if #res == 0 then
            printE("getUserGoldCoin : user is not exists",userID)
            return 0
        end
        gc=tonumber(res[1].goldCoin)
    else
        gc=tonumber(acc.goldCoin)
    end
    return gc
end

--[[*****************************************************************************
--获得用户货币
mysql           mysql服务
redis           redis服务
userID          int         用户名
currency        string 货币
返回值          int    金币
******************************************************************************]]
function commonTool.getUserCurrency(mysql,redis,userID,currency)
    if mysql == nil or redis == nil or userID == nil or currency == nil then
        printE("getUserCurrency : args is nil",mysql,redis,userID,currency)
        return 0
    end
    local gc=0
    local acc=callRedis(redis,"GetAccount",userID)
    --如果redis查不到，从mysql查
    if acc == nil then
        local res=callDBService(mysql,"launchSQL","select ID,"..currency.." from Account where userID="..userID)
        if callDBService(mysql,"SafeCheck",res) == false then
            printE("getUserCurrency : safe check fail",userID)
            return 0
        end
        if #res == 0 then
            printE("getUserCurrency : user is not exists",userID)
            return 0
        end
        gc=tonumber(res[1][currency])
    else
        gc=tonumber(acc[currency])
    end
    return gc
end

--[[*****************************************************************************
获得用户全部道具
没有返回空表
返回值[N]={
	amount  int  数量
    userGoodsID  int  UserGoods表ID
    goodsID      int  Goods表ID
    expireTime   string 过期时间
    maxOverlayNum int  最大叠加数
}
******************************************************************************]]
function commonTool.getUserAllGoods(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserAllGoods : args is nil",mysql,redis,userID)
		return {}
	end
	--同步
	commonTool.syncUserGoodsToRedis(mysql,redis,userID)

	--判断用户是否在线
	local rdsF=true
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		printE("not online",userID)
		rdsF=false
	end

	local resTab={}
	if rdsF == true then
		--从redis查
		local key="User:"..commonTool.userID_userGoods..":"..userID
		local goods=callRedis(redis,"GetSet",key)
		if goods == nil then
			return {}
		end
		for k,v in pairs(goods) do
			local cell=callRedis(redis,"GetHashUserGoods","UserGoods:"..v)
			if cell ~= nil then
				table.insert(resTab,{goodsID=tonumber(cell.goodsID),amount=tonumber(cell.amount),userGoodsID=tonumber(cell.ID),expireTime=tostring(cell.expireTime),obtainTime=tostring(cell.obtainTime)})
			end
		end
	else
		--从mysql查
		local goods=callDBService(mysql,"GetUserAllGoods",userID)
		resTab=goods
	end

	local list={}
	for k,v in pairs(resTab) do
		v.maxOverlayNum=0
		--获取redis的Goods表配置
		v.maxOverlayNum=tonumber(v.maxOverlayNum)
		--判断是否过期
		if commonTool.isGoodsExpire({userID=userID},v,redis) == false then
			table.insert(list,v)
		end
	end

	return list
end

--[[*****************************************************************************
获得道具过期时间
userInfo={
	userID
}
goodsInfo={
	goodsID
}
返回值   string   2016-01-01 00:00:00，失败返回nil
******************************************************************************]]
function commonTool.getGoodsExpireTime(userInfo,goodsInfo,redis)
	if userInfo == nil or goodsInfo == nil or redis == nil then
		printE("getGoodsExpireTime : args is nil",userInfo,goodsInfo,redis)
		return nil
	end

	--获得redis道具配置
	local goods=callRedis(redis,"GetHash1","Goods:"..tostring(goodsInfo.goodsID))
	if goods == nil then
		printE("getGoodsExpireTime : can not get redis goods conf",goodsInfo.userGoodsID,goodsInfo.goodsID,userInfo.userID)
		return nil
	end

	local now=os.time()
	local duration=commonTool.date2Sec(goodsInfo.obtainTime)+tonumber(goods.keepDuration)*3600
	local expire=commonTool.date2Sec(goods.usedTime)

	local item_conf=require("glzp.item_conf")
	if goods.variety == item_conf.itemVariety.timely then
		--时效性道具，判断配置过期时间以及时效时间
		return commonTool.sec2Date(duration)
	elseif goods.variety == item_conf.itemVariety.normal then
		--非时效性道具，判断配置过期时间
		return commonTool.sec2Date(expire)
	end

	return nil
end

--[[*****************************************************************************
判断道具是否过期
userInfo={
	userID
}
goodsInfo={
	goodsID
	userGoodsID
	expireTime
	obtainTime
}
返回值   bool   是否过期
******************************************************************************]]
function commonTool.isGoodsExpire(userInfo,goodsInfo,redis)
	if userInfo == nil or goodsInfo == nil or redis == nil then
		printE("isGoodsExpire : args is nil",userInfo,goodsInfo,redis)
		return false
	end
	
	return commonTool.isGoodsExpire2(redis,userInfo,goodsInfo)
end

function commonTool.isGoodsExpire2(redis,userInfo,goodsInfo)
	if userInfo == nil or goodsInfo == nil or redis == nil then
		printE("isGoodsExpire : args is nil",userInfo,goodsInfo,redis)
		return false
	end
	--获得redis道具配置
	local goods=callRedis(redis,"GetHash1","Goods:"..tostring(goodsInfo.goodsID))
	if goods == nil then
		printE("isGoodsExpire : can not get redis goods conf",goodsInfo.goodsID,userInfo.userID)
		return false
	end

	goodsInfo.obtainTime=goodsInfo.obtainTime or 0

	local now=os.time()
	if commonTool.isStringEmpty(goodsInfo.obtainTime) == true then
		goodsInfo.obtainTime=commonTool.sec2Date(os.time())
	end
	local duration=commonTool.date2Sec(goodsInfo.obtainTime)+tonumber(goods.keepDuration)*3600
	local expire=commonTool.date2Sec(goods.usedTime)

	local item_conf=require("glzp.item_conf")
	if goods.variety == item_conf.itemVariety.timely then
		--时效性道具，判断配置过期时间以及时效时间
		if now > duration then
			return true
		end
		return false
	elseif goods.variety == item_conf.itemVariety.normal then
		--非时效性道具，判断配置过期时间
		return false
	end

	return false
end

--[[*****************************************************************************
同步UserGoods数据到reids
******************************************************************************]]
function commonTool.syncUserGoodsToRedis(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("syncUserGoodsToRedis : args is nil",mysql,redis,userID)
		return false
	end

	--废除
	if true then
		return true
	end

	--判断用户是否在线
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		printE("syncUserGoodsToRedis : user not online",userID)
		return false
	end

	local key="User:"..commonTool.userID_userGoods..":"..userID
	--如果没有同步，则同步数据
	--if callRedis(redis,"Exists",key) == false then
		local sql="select * from UserGoods where userID="..userID
	    local res=callDBService(mysql,"launchSQL",sql)
	    if commonTool.dbSafeCheck(res) == false then
	        printE("ct :  syncUserGoods select * from UserGoods fail:",userID,sql)
	        return false
	    end

	    if callRedis(redis,"SyncByUserGoodsTab","UserGoods",res) == false then
	        printE("ct :  syncUserGoods SyncByResTab UserGoods fail userID:",userID)
	        return false
	    end

	    local ids={}
	    for k,v in pairs(res) do
	        table.insert(ids,tonumber(v.ID))
	    end

	    local function SyncUserID_UserGoods(userID,ids)
		    if userID == nil or ids == nil then
		        printE("ct : SyncUserID_UserGoods : userID or ids is nil","userID:",userID,"ids:",ids)
		        return false
		    end
		    local key="User:"..commonTool.userID_userGoods..":"..userID
		    callRedis(redis,"AddSet",key,ids)
		    return true
		end

	    if SyncUserID_UserGoods(userID,ids) == false then
	        printE("ct SyncUserID_UserDataID fail userID:",userID)
	        return false
	    end
	--end

	return true
end

--[[*****************************************************************************
--获得用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
itemID          int 	h.goodsTypeID
返回值          int    金币
******************************************************************************]]
function commonTool.getUserItemAmount(mysql,redis,userID,itemID)
	if mysql == nil or redis == nil or userID == nil or itemID == nil then
        printE("getUserItemAmount : args is nil",mysql,redis,userID,itemID)
        return 0
    end

    userID=tonumber(userID)
    if itemID == h.goodsTypeID.goldCoin then
    	return commonTool.getUserCurrency(mysql,redis,userID,"goldCoin")
    elseif itemID == h.goodsTypeID.point then
    	return commonTool.getUserCurrency(mysql,redis,userID,"point")
    else
    	return commonTool.getUserGoodsAmount(mysql,redis,userID,itemID)
    end
    return 0
end

--[[*****************************************************************************
--获得用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
userGoodsID          int 	UserGoods表ID
返回值          int    
******************************************************************************]]
function commonTool.getUserItemAmountByUserGoodsID(mysql,redis,userID,userGoodsID)
    if mysql == nil or redis == nil or userID == nil or userGoodsID == nil then
        printE("getUserItemAmountByUserGoodsID : args is nil",mysql,redis,userID,userGoodsID)
        return 0
    end
    userID=tonumber(userID)
    userGoodsID=tonumber(userGoodsID)

    --如果查询金币
    if userGoodsID == h.goodsTypeID.goldCoin then
		return commonTool.getUserCurrency(mysql,redis,userID,"goldCoin")
	end

	--如果查询道具

    local rdsF=true--标记
	--判断用户是否在线
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		rdsF=false
	end

	--从redis查
	local amount=0
	if rdsF == true then
		--判断是否已经同步
		commonTool.syncUserGoodsToRedis(mysql,redis,userID)
    	local info=callRedis(redis,"GetUserGoodsInfo",userID,userGoodsID)
    	if info.amount ~= nil then
    		amount=tonumber(info.amount)
    	end
    else
    --从mysql查
    	local info=callDBService(mysql,"GetUserGoodsInfo",userID,userGoodsID)
    	if info.amount ~= nil then
    		amount=tonumber(info.amount)
    	end
	end
	return amount
end

--[[*****************************************************************************
--获得用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
goodsID          int 	Goods表ID
返回值          int    金币
******************************************************************************]]
function commonTool.getUserGoodsAmount(mysql,redis,userID,goodsID)
    if mysql == nil or redis == nil or userID == nil or goodsID == nil then
        printE("getUserGoodsAmount : args is nil",mysql,redis,userID,goodsID)
        return 0
    end
    userID=tonumber(userID)
    local rdsF=true--标记
	--判断用户是否在线
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		rdsF=false
	end
	if rdsF == true then
		--判断是否已经同步
		commonTool.syncUserGoodsToRedis(mysql,redis,userID)
	end
	local info=commonTool.getUserGoodsDetail(mysql,redis,userID,goodsID)
	local amount=0
	for k,v in pairs(info) do
		amount=amount+tonumber(v.amount)
	end
	return amount
end

--[[*****************************************************************************
--获得用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
goodsID          int 	Goods表ID
返回值[N]={    可能会返回多个
    amount  int  数量
    userGoodsID  int  UserGoods表ID
    goodsID      int  Goods表ID
    expireTime   string 过期时间
    maxOverlayNum int  最大叠加数
    obtainTime string 获得道具的时间
}
******************************************************************************]]
function commonTool.getUserGoodsDetail(mysql,redis,userID,goodsID)
	if mysql == nil or redis == nil or userID == nil or goodsID == nil then
		printE("getUserGoodsDetail : args is nil",mysql,redis,userID,goodsID)
		return {}
	end

	userID=tonumber(userID)
	goodsID=tonumber(goodsID)
    local rdsF=true--标记
	--判断用户是否在线
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		rdsF=false
	end

	--从redis获取Goods配置
	local rdscnf=callRedis(redis,"GetHash1","Goods:"..goodsID)
	if rdscnf == nil then
		rdscnf=0
	else
		rdscnf=tonumber(rdscnf.maxOverlayNum)
	end
	local maxOverlayNum=rdscnf
	local goods={}
	--从redis查
	if rdsF == true then
		--判断是否已经同步
		if goodsID == h.goodsTypeID.goldCoin then
			local gcamt=commonTool.getUserItemAmount(mysql,redis,userID,goodsID)
			goods={[1]={amount=gcamt,userGoodsID=h.goodsTypeID.goldCoin,goodsID=h.goodsTypeID.goldCoin,commonTool.sec2Date(os.time()+1*24*3600),maxOverlayNum=0,obtainTime=commonTool.sec2Date(os.time())}}
		else
			commonTool.syncUserGoodsToRedis(mysql,redis,userID)
    		goods=callRedis(redis,"GetUserGoodsDetail",userID,goodsID)
		end
		
    else
        --从mysql查
        if goodsID == h.goodsTypeID.goldCoin then
        	local acc=callDBService(mysql,"getUserAccount",userID)
        	if acc == nil then
        		printE("getUserAccount get acc from db fail",userID)
        		return {}
        	end
        	goods={[1]={amount=acc.goldCoin,userGoodsID=h.goodsTypeID.goldCoin,goodsID=h.goodsTypeID.goldCoin,commonTool.sec2Date(os.time()+1*24*3600),maxOverlayNum=0,obtainTime=commonTool.sec2Date(os.time())}}
        else
        	goods=callDBService(mysql,"getUserGoodsDetail",userID,goodsID)
        end
    	
	end

	local list={}
	for k,v in pairs(goods) do
		v.maxOverlayNum=maxOverlayNum
		--判断是否过期
		if commonTool.isGoodsExpire({userID=userID},v,redis) == false then
			table.insert(list,v)
		end
	end

	return list
end

--[[*****************************************************************************
--插入一条系统送金记录
userInfo  table  包含userID/userName/nickName
account   table  包含giftGoldCoin int/giftPoint int  赠送的金币与积分，没有为0
gift      table  包含giftGoodsID int/giftGoodsAmount int  没有要赠送的道具，gift为nil
--remark：           string       备注
******************************************************************************]]
function commonTool.InsertSystemGiftLog(mysql,userInfo,account,gift,remark)
    return callDBService(mysql,"InsertSystemGiftLog",userInfo,account,gift,remark)
end

--[[*****************************************************************************
--修改用户金币
mysql           mysql服务
redis           redis服务
userID          int         用户名
dVal            int         变化量，+为正，-为负
remark          string      修改用户金币的原因
返回值          bool,int    是否成功，最新金币
******************************************************************************]]
function commonTool.changeUserGoldCoin(mysql,redis,userID,dVal,remark)
    if userID == nil or dVal == nil or remark == nil or mysql == nil or redis == nil then
        printE("changeUserGoldCoin : args is nil",userID,dVal,remark,mysql,redis)
        return false
    end

    local acc=callRedis(redis,"GetAccount",userID)
    local gc=0
    local uif=nil
    if acc == nil then
    	printE("changeUserGoldCoin : user may not online ,get data from mysql",userID)
        --从mysql查
        local res=callDBService(mysql,"launchSQL","select ID,goldCoin from Account where userID="..userID)
        if callDBService(mysql,"SafeCheck",res) == false then
            printE("changeUserGoldCoin : safe check fail",userID)
            return false
        end
        if #res == 0 then
            printE("changeUserGoldCoin : user is not exists",userID)
            return false
        end
        
        gc=tonumber(res[1].goldCoin)
        acc={}
        acc.ID=tonumber(res[1].ID)

        --用户信息
        uif=callDBService(mysql,"launchSQL","select * from User where ID="..userID)
        if callDBService(mysql,"SafeCheck",uif) == false then
            printE("changeUserGoldCoin : user safe check fail",userID)
            return false
        end
        if #uif == 0 then
            printE("changeUserGoldCoin user: user is not exists",userID)
            return false
        end
        uif=uif[1]
    else
        --从redis查
        gc=tonumber(acc.goldCoin)
        uif=callRedis(redis,"GetHash","User:"..userID)
        if uif == nil then
            printE("changeUserGoldCoin : get user info fail",userID)
            return false
        end
    end

    if gc == nil or type(gc) ~= "number" then
    	printE("changeUserGoldCoin err ERR gc is err",gc,userID,dVal,remark)
    	commonTool.showTable(acc)
    	return false
    end

    local ngc=gc+tonumber(dVal)
    if ngc < 0 then
        printE("changeUserGoldCoin : goldCoin is less than 0",userID,"goldCoin:",ngc)
        return false
    end
    if callRedis(redis,"ExistsAccount","Account:"..acc.ID) == true then
        callRedis(redis,"SetHashAccount","Account:"..acc.ID,{goldCoin=ngc})
    end
    local res=callDBService(mysql,"launchSQL","update Account set goldCoin="..ngc.." where userID="..userID)
    if res == nil or res.affected_rows == 0 or res.bad_result == true then
    	printE("changeUserGoldCoin : update gold coin fail",userID,res.bad_result)
    end
    callDBService(mysql,"InsertCurrencyLog",tonumber(uif.ID),uif.userName,uif.nickName,"金币",gc,ngc,0,remark,h.currencyRemarkID.Null,h.goodsTypeID.goldCoin,tonumber(uif.code))
    return true,ngc
end

--[[*****************************************************************************
--修改用户货币
mysql           mysql服务
redis           redis服务
userID          int         用户名
dVal            int         变化量，+为正，-为负
remark          string      修改用户金币的原因
currency        string      货币
currencyTxt     string      货币中文名
返回值          bool,int    是否成功，最新货币
******************************************************************************]]
function commonTool.changeUserCurrency(mysql,redis,userID,dVal,remark,currency,currencyTxt)
    if userID == nil or dVal == nil or remark == nil or mysql == nil or redis == nil or currency == nil or currencyTxt == nil then
        printE("changeUserCurrency : args is nil",userID,dVal,remark,mysql,redis,currency,currencyTxt)
        return false,0
    end

    local acc=callRedis(redis,"GetAccount",userID)
    local gc=0
    local uif=nil
    if acc == nil then
        --从mysql查
        printE("changeUserCurrency : user may not online ,get data from mysql",userID)
        local res=callDBService(mysql,"launchSQL","select ID,goldCoin from Account where userID="..userID)
        if callDBService(mysql,"SafeCheck",res) == false then
            printE("changeUserCurrency : safe check fail",userID)
            return false,0
        end
        if #res == 0 then
            printE("changeUserCurrency : user is not exists",userID)
            return false,0
        end
        
        gc=tonumber(res[1][currency])
        acc={}
        acc.ID=tonumber(res[1].ID)

        --用户信息
        uif=callDBService(mysql,"launchSQL","select * from User where ID="..userID)
        if callDBService(mysql,"SafeCheck",uif) == false then
            printE("changeUserCurrency : user safe check fail",userID)
            return false,gc
        end
        if #uif == 0 then
            printE("changeUserCurrency user: user is not exists",userID)
            return false,gc
        end
        uif=uif[1]
    else
        --从redis查
        gc=tonumber(acc[currency])
        uif=callRedis(redis,"GetHash","User:"..userID)
        if uif == nil then
            printE("changeUserCurrency : get user info fail",userID)
            return false,gc
        end
    end

    if gc == nil or type(gc) ~= "number" then
    	printE("changeUserCurrency err ERR gc is err",userID,dVal,remark,currency,currencyTxt)
    	commonTool.showTable(acc)
    	return false,0
    end

    local ngc=gc+tonumber(dVal)
    if ngc < 0 then
        printE("changeUserCurrency : val is less than 0",userID,"val:",ngc)
        return false,gc
    end
    local tab={}
    tab[currency]=ngc
    if callRedis(redis,"ExistsAccount","Account:"..acc.ID) == true then
        callRedis(redis,"SetHashAccount","Account:"..acc.ID,tab)
    end
    local res=callDBService(mysql,"launchSQL","update Account set "..currency.."="..ngc.." where userID="..userID)
    if res == nil or res.affected_rows == 0 or res.bad_result == true then
    	printE("changeUserCurrency : update acc fail",userID,res.bad_result,currency)
    end
    --callDBService(mysql,"InsertCurrencyLog",tonumber(uif.ID),uif.userName,uif.nickName,currencyTxt,gc,ngc,0,remark)
    return true,ngc
end

--[[*****************************************************************************
--获得玩家所在大厅，没有返回nil，否则返回table
*****************************************************************************]]
function commonTool.getPlayerLobby(userInfo,redis)
	if userInfo == nil or redis == nil then
		printE("getPlayerLobby args is nil",userInfo,redis)
		commonTool.showDebugStack()
		return nil
	end

	local lobby=callRedis(redis,"getPlayerLobby",userInfo.userID)
	if lobby == nil or lobby.serverName == nil then
		printE("getPlayerLobby fail ,user may offline",userInfo.userID)
		return nil
	end

	return lobby
end

--[[*****************************************************************************
--发送新道具提醒
userInfo={userID}
goodsInfo[N]={   可能有多个
	amount  int  数量
    userGoodsID  int  UserGoods表ID
    goodsID      int  Goods表ID
    expireTime   string 过期时间
    obtainTime   string 获得道具的时间
}
******************************************************************************]]
function commonTool.sendNewItemMatter(userInfo,goodsInfo,mysql,redis)
	if userInfo == nil or goodsInfo == nil or #goodsInfo == 0 or mysql == nil or redis == nil then
		printE("sendNewItemMatter : args is nil",userInfo,goodsInfo,mysql,redis)
		return false
	end

	local json=require ("glzp.json")
	local crypt = require "crypt"

	local newItem=callRedis(redis,"getUserNewItem",userInfo)
	local newData={}
	for k,v in pairs(newItem) do
		newData[k]={goodsID=v.goodsID,userGoodsID=v.userGoodsID}
	end
	--没有新道具
	if #newItem == 0 then
		printE("sendNewItemMatter there is no new item in this user package",userInfo.userID)
		return true
	end

	local matter={
		startTime=commonTool.sec2Date(os.time()),
		endTime=commonTool.sec2Date(os.time()),
		matterKey=h.UserMatter.matterKey.newItem,
		matterValue=tostring(#newItem),
		flag=h.UserMatter.flag.login,
		remark="",
		extra=json.encode(newData)
	}
	--callDBService(mysql,"InsertUserMatter",userInfo,matter)

	local lobby=callRedis(redis,"getPlayerLobby",userInfo.userID)
	if lobby == nil or lobby.serverName == nil then
		printE("sendNewItemMatter can not get user lobby , user may offline",userInfo.userID)
		return true
	end

	--发送消息给客户端
	--matter.extra=crypt.base64decode(matter.extra)
	pcall(cluster.call,lobby.serverName, ".lobby_self", "callPlayerFunction", "send2Client", userInfo.userID,"sendUserMatter",{data=json.encode(matter)},h.enumKeyAction.SEND_USER_MATTER)

	return true
end

--[[*****************************************************************************
--获得事项
userInfo={userID}
matter={matterKey  string  matter的key}  
返回值   没有为nil
}
******************************************************************************]]
function commonTool.getUserMatter(userInfo,matter,mysql)
	if userInfo == nil or matter == nil or mysql == nil then
		printE("getUserMatter args is nil",userInfo,matter,mysql)
		return nil
	end

	--return callDBService(mysql,"getUserMatter",userInfo,matter)
	return nil
end

--[[*****************************************************************************
--删除事项
userInfo={userID}
matter={matterKey  string  matter的key}
}
******************************************************************************]]
function commonTool.deleteUserMatter(userInfo,matter,mysql)
	if userInfo == nil or matter == nil or mysql == nil then
		printE("deleteUserMatter args is nil",userInfo,matter,mysql)
		return false
	end

	return true
end

--[[*****************************************************************************
--修改用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
dVal            int         变化量，+为正，-为负
remark          string      修改用户道具的原因
goodsID        int      Goods表ID
expireTime     string   过期时间
返回值          bool,int    是否成功，最新数量
******************************************************************************]]
function commonTool.changeUserGoodsAmount(mysql,redis,userID,dVal,remark,goodsID,expireTime)
    if userID == nil or dVal == nil or remark == nil or mysql == nil or redis == nil or goodsID == nil then
        printE("changeUserGoodsAmount : args is nil",userID,dVal,remark,mysql,redis,goodsID)
        return false,0
    end

    if tonumber(dVal) == nil or tonumber(dVal) == 0 then
    	printE("changeUserGoodsAmount dVal is 0",userID,dVal,remark,goodsID)
    	return false,0
    end

    local amt=commonTool.getUserGoodsAmount(mysql,redis,userID,goodsID)
    amt=amt+tonumber(dVal)
    if amt < 0 then
    	printE("changeUserGoodsAmount : amt < 0",amt,dVal)
    	return false,0
    end

    --获取服务器配置
    local goods=callRedis(redis,"GetHash1","Goods:"..goodsID)
    if goods == nil then
    	printE("changeUserGoodsAmount : can not get redis goods conf",goodsID,userID)
    	return false,0
    end

    --选择时效和有效日期中距离当前时间最短的
    if expireTime == nil or expireTime == "" then
    	expireTime=goods.usedTime
    end

    --是否是时效性道具
    local isTimely=false
    if goods.variety == h.itemVariety.timely then
    	isTimely=true
    end

    local res=false
    local info=commonTool.getUserGoodsDetail(mysql,redis,userID,goodsID)
    local flag=false--是否处理
    for k,v in pairs(info) do
    	if isTimely == true then
			--时效性道具不做数量修改，只插入
			break
		end
    	--如果当前userGoodsID的数量已经小于配置的最大叠加数，可以往里添加
    	if tonumber(goods.maxOverlayNum) > 0 and tonumber(v.amount) <  tonumber(goods.maxOverlayNum) then
    		res=commonTool.changeUserItemAmountByUserGoodsID(mysql,redis,{userID=userID},dVal,remark,tonumber(v.userGoodsID))
    		flag=true
    		break
    	end
    	--不限最大叠加数
    	if tonumber(goods.maxOverlayNum) == 0 then
    		res=commonTool.changeUserItemAmountByUserGoodsID(mysql,redis,{userID=userID},dVal,remark,tonumber(v.userGoodsID))
    		flag=true
    		break
    	end
    end

    --插入一个新的userGoodsID
    if flag == false then
    	if dVal > 0 then
    		--增加
    		local loop=1
    		local realAmt=dVal
    		if isTimely == true then
    			loop=dVal
    			realAmt=1
    		end
    		for i=1,loop,1 do
    			local ist=callDBService(mysql,"insertUserGoodsInfo",{userID=userID},{amount=realAmt,goodsID=goodsID,expireTime=expireTime,isNew=false})
		    	if ist == -1 then
		    		printE("changeUserGoodsAmount insertUserGoodsInfo fail",userID,goodsID,amount)
		    		return false,0
		    	else
		    		--插入redis
		    		callRedis(redis,"insertUserGoodsInfo",{userID=userID},{userGoodsID=ist,amount=realAmt,goodsID=goodsID,expireTime=expireTime,isNew=true})
		    		res=true
		    	end
    		end
	    else
	    	--减少
	    	for k,v in pairs(info) do
	    		res=commonTool.changeUserItemAmountByUserGoodsID(mysql,redis,{userID=userID},dVal,remark,tonumber(v.userGoodsID))
	    		break
		    end
	    end
    end

    return res,amt
end


--[[*****************************************************************************
--修改用户道具
mysql           mysql服务
redis           redis服务
userID          int         用户名
dVal            int         变化量，+为正，-为负
remark          string      修改用户金币的原因
itemID        int      h.goodsTypeID
返回值          bool,int    是否成功，最新数量
******************************************************************************]]
function commonTool.changeUserItemAmount(mysql,redis,userID,dVal,remark,itemID)
    if userID == nil or dVal == nil or remark == nil or mysql == nil or redis == nil or itemID == nil then
        printE("changeUserItemAmount : args is nil",userID,dVal,remark,mysql,redis,itemID)
        return false,0
    end
    
    userID=tonumber(userID)
    dVal=tonumber(dVal)
    itemID=tonumber(itemID)

    if h.goodsTypeID.goldCoin == itemID then
		return commonTool.changeUserCurrency(mysql, redis, userID, dVal, remark, "goldCoin", "金币")
	elseif h.goodsTypeID.point == itemID then
		return commonTool.changeUserCurrency(mysql, redis, userID, dVal, remark, "point", "积分")
	else
		return commonTool.changeUserGoodsAmount(mysql,redis,userID,dVal,remark,itemID)
	end 
	return false,0
end

--[[*****************************************************************************
--修改用户道具，该接口是通过userGoodsID修改，因此说明玩家一定拥有该道具
mysql           mysql服务
redis           redis服务
userInfo={userID,userName,nickName}
dVal            int         变化量，+为正，-为负
remark          string      修改用户金币的原因
userGoodsID        int      UserGoods表ID
返回值          bool    是否成功
******************************************************************************]]
function commonTool.changeUserItemAmountByUserGoodsID(mysql,redis,userInfo,dVal,remark,userGoodsID)
	if mysql == nil or redis == nil or userInfo == nil or dVal == nil or remark == nil or userGoodsID == nil then
		printE("changeUserItemAmountByUserGoodsID : args is nil",mysql,redis,userInfo,dVal,remark,userGoodsID)
		return false
	end

	userID=tonumber(userID)
    dVal=tonumber(dVal)
    userGoodsID=tonumber(userGoodsID)

    if dVal == 0 or dVal == nil then
    	printE("changeUserItemAmountByUserGoodsID dVal is 0",dVal,userGoodsID,userInfo.userID)
    	return false
    end

    --如果查询金币
    if h.goodsTypeID.goldCoin == userGoodsID then
		return commonTool.changeUserCurrency(mysql, redis, userInfo.userID, dVal, remark, "goldCoin", "金币")
	end

	--如果查询道具
	local info=commonTool.getUserGoodsInfo(mysql,redis,userInfo.userID,userGoodsID)
	if info == nil then
		printE("changeUserItemAmountByUserGoodsID : can not get goods info",userInfo.userID,userGoodsID,dVal)
		return false
	end
	--获得道具配置
	local goods=callRedis(redis,"GetHash1","Goods:"..tostring(info.goodsID))
	if goods == nil then
		printE("changeUserItemAmountByUserGoodsID : can not get goods conf in redis",tostring(info.goodsID),userInfo.userID,userGoodsID)
		return false
	end

	--是否是时效性道具
    local isTimely=false
    if goods.variety == h.itemVariety.timely then
    	isTimely=true
    end

	--local goodsamount=commonTool.getUserItemAmount(mysql,redis,userInfo.userID,tonumber(info.goodsID))

	local item_utils=require "glzp.item_utils"
	--callDBService(mysql,"InsertCurrencyLog",tonumber(userInfo.userID),userInfo.userName,userInfo.nickName,item_utils.getName(tonumber(info.goodsID)),goodsamount,goodsamount+dVal,0,remark)

	--判断是否需要分组
	if tonumber(goods.maxOverlayNum) > 0 and tonumber(info.amount)+dVal > tonumber(goods.maxOverlayNum) then
		--分组
		local newNum=tonumber(info.amount)+dVal-tonumber(goods.maxOverlayNum)
		local oldNum=tonumber(goods.maxOverlayNum)
		--更新旧数据
		local goodsInfo={amount=oldNum,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
		local res=callDBService(mysql,"updateUserGoodsInfo",userInfo,goodsInfo)
		if res == -1 then
			return false
		end
		--插入新数据
		local goodsInfo={amount=newNum,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),isNew=false}
		local res=callDBService(mysql,"insertUserGoodsInfo",userInfo,goodsInfo)
		if res == -1 then
			return false
		end

		--更新到redis
		local goodsInfo={amount=oldNum,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
		callRedis(redis,"updateUserGoodsInfo",userInfo,goodsInfo)

		local goodsInfo={amount=newNum,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=res,isNew=false}
		callRedis(redis,"insertUserGoodsInfo",userInfo,goodsInfo)
		return true
	else
		--不用分组
		local loop=1
		local realAmt=dVal
		if isTimely == true then
			--时效性道具，新增
			if dVal > 0 then
				--增加
				loop=dVal
				realAmt=1
				for i=1,loop,1 do
					local ist=callDBService(mysql,"insertUserGoodsInfo",{userID=userInfo.userID},{amount=realAmt,goodsID=tonumber(goods.goodsID),expireTime=tostring(info.expireTime),isNew=false})
			    	if ist == -1 then
			    		printE("changeUserGoodsAmount insertUserGoodsInfo fail",userID,goodsID,amount)
			    		return false
			    	else
			    		--插入redis
			    		callRedis(redis,"insertUserGoodsInfo",{userID=userID},{userGoodsID=ist,amount=realAmt,goodsID=tonumber(goods.goodsID),expireTime=tostring(info.expireTime),isNew=true})
			    		return true
			    	end
				end
			else
				--减少
				local goodsInfo={amount=tonumber(info.amount)+dVal,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
				local res=callDBService(mysql,"updateUserGoodsInfo",userInfo,goodsInfo)
				if res == -1 then
					return false
				end

				--更新到redis
				local goodsInfo={amount=tonumber(info.amount)+dVal,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
				callRedis(redis,"updateUserGoodsInfo",userInfo,goodsInfo)
				return true
			end
		else
			--非时效性道具
			local goodsInfo={amount=tonumber(info.amount)+dVal,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
			local res=callDBService(mysql,"updateUserGoodsInfo",userInfo,goodsInfo)
			if res == -1 then
				return false
			end

			--更新到redis
			local goodsInfo={amount=tonumber(info.amount)+dVal,goodsID=tonumber(info.goodsID),expireTime=tostring(info.expireTime),userGoodsID=userGoodsID}
			callRedis(redis,"updateUserGoodsInfo",userInfo,goodsInfo)
			return true
		end
		
	end

	return true
end

--[[*****************************************************************************
--获得玩家道具信息
mysql           mysql服务
redis           redis服务
userID          int         用户名
userGoodsID  	    int 		UserGoodsID
返回值          {amount,goodsID,expireTime},没有为nil
******************************************************************************]]
function commonTool.getUserGoodsInfo(mysql, redis, userID, userGoodsID)
	if mysql == nil or redis == nil or userID == nil or userGoodsID == nil then
		printE("getUserGoodsInfo : args is nil",mysql, redis, userID, userGoodsID)
		return nil
	end

	local rdsF=true
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		rdsF=false
	end
	local goods=nil
	if rdsF == true then
		goods=callRedis(redis,"GetUserGoodsInfo",userID,userGoodsID)
	else
		goods=callDBService(mysql,"GetUserGoodsInfo",userID,userGoodsID)
	end

	return goods
end

--[[*****************************************************************************
--判断昵称是否有效（没有敏感词，没有非法字符，没有其他玩家使用，长度合理）
userInfo={userID,userName,nickName}
返回值 int  0:可以使用   1：参数错误  2：长度过长   3：昵称为空  4:昵称非法  5:已被使用
*****************************************************************************]]
function commonTool.isNickNameVaild(userInfo,newNickName,mysql,redis)
	if userInfo == nil or newNickName == nil or mysql == nil or redis == nil then
		printE("isNickNameVaild args is nil",userInfo,newNickName,mysql,redis)
		return 1
	end

	--判断是否重名
    if newNickName == userInfo.nickName then
        printE("isNickNameVaild user use same nickname",userInfo.userID,userInfo.nickName)
        return 5
    end

	--长度判断
	local strlen=commonTool.getStringLen(newNickName)
	if strlen <= 0 then
		printE("isNickNameVaild too short",userInfo.userID,newNickName,strlen)
		return 3
	end
	if strlen > h.changeNickNameConf.nickNameMaxLength then
		printE("isNickNameVaild too long",userInfo.userID,newNickName,strlen)
		return 2
	end

	--绘文字判断
    if commonTool.hasEmoji(newNickName) == true then
        printE("isNickNameVaild this nick name has emoji",userInfo.userID,newNickName)
        return 4
    end

    --上锁判断
    if callRedis(redis,"GetHash",hs.changeNickName_lockNickNameKey..":"..tostring(newNickName)) ~= nil then
    	printE("isNickNameVaild : ",newNickName," locked")
    	return 5
    end

	--屏蔽词检查
    local banned_words=require "glzp.banned_words"
    if banned_words ~= nil then
        if banned_words.check(newNickName) == true then
            printE("isNickNameVaild : ban word",userInfo.userID,newNickName)
            return 4
        end
    end

    --非法字符
    if commonTool.checkSymbol(newNickName) == true then
    	printE("isNickNameVaild : symbol",userInfo.userID,newNickName)
        return 4
    end

    --判断已被使用
    local has=callDBService(mysql,"launchSQL","select ID from User where nickName ='"..tostring(newNickName).."'")
    if commonTool.dbSafeCheck(has) == false then
        printE("isNickNameVaild : can not pass SafeCheck",userInfo.userID,newNickName)
        return 5
    end

    if #has > 0 then
        printE("isNickNameVaild : has used",userInfo.userID,newNickName)
        return 5
    end

    local has=callDBService(mysql,"launchSQL","select ID from AI where nickName ='"..tostring(newNickName).."'")
    if commonTool.dbSafeCheck(has) == false then
        printE("isNickNameVaild : can not pass SafeCheck 2",userInfo.userID,newNickName)
        return 5
    end

    if #has > 0 then
        printE("isNickNameVaild : has used 2",userInfo.userID,newNickName)
        return 5
    end

    return 0
end
--[[*****************************************************************************
昵称上锁
******************************************************************************]]
function commonTool.lockNickName(userInfo,nickName,redis)
	if userInfo == nil or nickName == nil or redis == nil then
		printE("lockNickName args is nil",userInfo,nickName,redis)
		return false
	end

	if commonTool.isStringEmpty(nickName) == true then
		printE("lockNickName args is nil",userInfo,nickName,redis)
		return false
	end

	local key1=hs.changeNickName_lockNickNameKey..":"..tostring(nickName)
	local key2=hs.changeNickName_lockUserIDKey..":"..tostring(userInfo.userID)
	callRedis(redis,"SetHash",key1,{userID=userInfo.userID})
	callRedis(redis,"SetKeyExpireTime",key1,hs.lockNickNameTime)
	callRedis(redis,"SetHash",key2,{nickName=nickName})
	callRedis(redis,"SetKeyExpireTime",key2,hs.lockNickNameTime)
	printE("lock nick name",tostring(nickName)," lock ",userInfo.userID)
	return true
end

--[[*****************************************************************************
昵称解锁
******************************************************************************]]
function commonTool.unlockNickName(userInfo,nickName,redis)
	if userInfo == nil or nickName == nil or redis == nil then
		printE("unlockNickName args is nil",userInfo,nickName,redis)
		return false
	end

	if commonTool.isStringEmpty(nickName) == true then
		printE("unlockNickName args is nil",userInfo,nickName,redis)
		return false
	end

	local key1=hs.changeNickName_lockNickNameKey..":"..tostring(nickName)
	local key2=hs.changeNickName_lockUserIDKey..":"..tostring(userInfo.userID)
	callRedis(redis,"Delete",key1)
	callRedis(redis,"Delete",key2)
	printE("unlock nick name",tostring(nickName)," lock ",userInfo.userID)
	return true
end

--[[*****************************************************************************
--获得玩家道具信息
mysql           mysql服务
redis           redis服务
userID          int         用户名
goodsID  	    int 		道具ID
返回值          {amount,goodsID,expireTime},没有为nil
******************************************************************************]]
function commonTool.getUserGoodsInfoByGoodsID(mysql, redis, userID, goodsID)
	if mysql == nil or redis == nil or userID == nil or goodsID == nil then
		printE("getUserGoodsInfoByGoodsID args is nil",mysql, redis, userID, goodsID)
		return nil
	end

	local rdsF=true
	local uif=callRedis(redis,"GetHash","User:"..userID)
	if uif == nil then
		rdsF=false
	end
	local goods=nil
	if rdsF == true then
		goods=callRedis(redis,"GetUserGoodsInfo",userID,userGoodsID)
	else
		goods=callDBService(mysql,"GetUserGoodsInfo",userID,userGoodsID)
	end

	return goods
end

--[[*****************************************************************************
--更新购买房卡与使用房卡
userInfo={userID=用户ID}
info={
	buy=购买数量,
	use=使用数量
}
******************************************************************************]]
function commonTool.updateUserRoomCardInfo(mysql,redis,userInfo,info)
	if mysql == nil or redis == nil or userInfo == nil or info == nil then
		printE("updateUserRoomCardInfo args is nil",mysql,redis,userInfo,info)
		return false
	end

	if commonTool.isStringEmpty(userInfo.newSpreader)  == true then
		return true
	end

	info.buy=info.buy or 0
	info.use=info.use or 0

	callDBService(mysql,"launchSQL",string.format("update UserData set roomCardBuyTimes=roomCardBuyTimes+%d,roomCardUseTimes=roomCardUseTimes+%d where userID=%d",info.buy,info.use,userInfo.userID))
	local datda=callRedis(redis,"GetUserData",userInfo.userID)
	if data ~= nil then
		callRedis(redis,"SetHash","UserData:"..tostring(data.ID,{roomCardBuyTimes=tonumber(data.roomCardBuyTimes+info.buy),roomCardUseTimes=tonumber(data.roomCardUseTimes+info.use)}))
	end

	return true
end

--定期清理内存
--log   输出文本
function commonTool.cleanMem(log)
	if h.cleanMemFlag == false then
		return
	end
	skynet.fork(function()
		while true do
			skynet.sleep(h.cleanMemSleepTime * 100)
			pcall(skynet.send,skynet.self(),"debug","GC")
			--printE(log," free mem per"..tostring(h.cleanMemSleepTime).."s")
		end
	end)
end

--服务器热更新
--service  string  服务标记
--list     table   监视列表
--[[
list={
	[glzp.head_file]=h,
	[glzp.common_lib]=ct,
}  
]]
function commonTool.hotUpdateCheckFunc(service,list,mysql)
	skynet.fork(function()
		skynet.sleep(10 * 100)--等待大厅启动
		if service == nil or mysql == nil or list == nil or type(list) ~= "table" then
			printE("hotUpdateCheckFunc args is nil",service,mysql,list,type(list))
			return
		end

		if h.hotUpdateFlag == false then
			return
		end

		while true do
			skynet.sleep(h.hotUpdateCheckTime * 100)
			for k,v in pairs(list) do
				commonTool.hotUpdateFunc(mysql,service,v,k)
			end
		end
	end)
	
end
function commonTool.hotUpdateFunc(mysql,service,watchedModule,moduleName)
	if mysql == nil or service == nil or watchedModule == nil or moduleName == nil then
		printE("hotUpdateFunc args is nil",service,watchedModule,mysql,moduleName)
		return
	end

	local sql="select * from ServerHotUpdate where flag=1 and service='"..tostring(service).."' and oldPackage='"..tostring(moduleName).."'"
	local patch=callDBService(mysql,"launchSQL",sql)
	if commonTool.dbSafeCheck(patch) == false then
		printE("hotUpdateFunc : safe check fail",sql)
		return
	end

	if #patch == 0 then
		return
	end
	patch=patch[1]

	printE("hotUpdateFunc need update package:",patch.oldPackage)
	package.loaded[tostring(patch.oldPackage)]=nil
	local ok,new=pcall(require,patch.newPackage)
	if ok == false then
		printE("hotUpdateFunc require package fail",patch.newPackage,new)
		return
	end
	for a,b in pairs(new) do
		watchedModule[a]=b
	end
	package.loaded[tostring(patch.oldPackage)]=watchedModule
	printE("hotUpdateFunc update over:",patch.oldPackage)

	sql="update ServerHotUpdate set flag=0 where flag=1 and service='"..tostring(service).."'"
	callDBService(mysql,"launchSQL",sql)
end

--读取文件内容
function commonTool.readFile(path)
	local file = io.open(path, "r")
	local data=""
	if file ~= nil then
		data = file:read("*a")
		file:close()

		if data ~= nil then
			--printE("readFile : load OK")
		else
			printE("readFile : load fail")
		end
	else
		printE("readFile : can not get data:",path)
	end

	return data
end

--获取路径  
function commonTool.getFilePath(filename)  
	filename=filename or ""
    return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system  
    --return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows  
end  
  
--获取文件名  
function commonTool.getFileName(filename) 
	filename=filename or "" 
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system  
    --return string.match(filename, “.+\\([^\\]*%.%w+)$”) — *nix system  
end  
  
--去除扩展名  
function commonTool.getFileNameWithoutExtension(filename)
	filename=filename or ""
    local idx = filename:match(".+()%.%w+$")  
    if(idx) then  
        return filename:sub(1, idx-1)  
    else  
        return filename  
    end  
end  
  
--获取扩展名  
function commonTool.getFileExtension(filename)  
	filename=filename or ""
    return filename:match(".+%.(%w+)$")  
end  

function commonTool.selectService(list,balance)
	if type(list) ~= "table" then
		return 1
	end
	balance=balance or 0
	balance=balance+1
	if balance > #list then
		balance=1
	end
	return balance
end



--读取排行榜配置
function commonTool.readRankConf()
	return commonTool.json2Table(commonTool.readFile("./bin/lobby/config/rank_conf.json"))
end

--读取redis配置
function commonTool.readRedisConf()
	return commonTool.json2Table(commonTool.readFile("./bin/redis/config/redis_conf.json"))
end

--读取db配置
function commonTool.readDbConf()
	return commonTool.json2Table(commonTool.readFile("./bin/db/config/db_conf.json"))
end


-- 获得当前玩家的道具数量
-- @param mysql mysql 服务
-- @param redis redis 服务
-- @param userID 玩家的 ID
-- @param goodID 道具的 ID
-- @return 道具的数量
-- @author Zhenyu Yao
function commonTool.getUserGoods(mysql, redis, userID, goodID)
	return commonTool.getUserItemAmount(mysql,redis,userID,goodID)
end

-- 改变玩家的道具数量
-- @param mysql mysql 服务
-- @param redis redis 服务
-- @param userID 玩家的 ID
-- @param goodID 道具的 ID
-- @param amount 道具的数量
-- @param remark 注释
-- @return true 成功, false 失败
function commonTool.changeUserGoods(mysql, redis, userID, goodID, amount, remark)
	return commonTool.changeUserItemAmount(mysql,redis,userID,amount,remark,goodID)
end

--[[*****************************************************************************
--根据金币获得房间倍率
--gCoin：     int        字牌金币
--返回值：    int/0        房间倍率，失败为0，即金币少于最底倍率要求的金币值
******************************************************************************]]
function commonTool.GetRoomRateByGoldCoin(gCoin)
	--[[ 内测临时分配策略
	if gCoin < 6000 then
        return 0
    elseif 6000 <= gCoin and gCoin < 50000 then
        return 500
    elseif 50000 <= gCoin then
        return 5000
    end
    return 0]]

    if gCoin < 6000 then
        return 0
    --elseif 3000 <= gCoin and gCoin < 12000 then
    --    return 100
    --elseif 6000 <= gCoin and gCoin < 30000 then
    --    return 200
    elseif 6000 <= gCoin and gCoin < 30000 then
        return 500
    elseif 30000 <= gCoin and gCoin < 100000 then
        return 1000
    elseif 100000 <= gCoin and gCoin < 200000 then
        return 2000
    elseif 200000 <= gCoin and gCoin < 600000 then
        return 5000
    elseif 600000 <= gCoin and gCoin < 1000000 then --1000000 then
        return 10000
    elseif 1000000 <= gCoin and gCoin < 3000000 then
        return 20000
    elseif 3000000 <= gCoin and gCoin < 6000000 then 
        return 50000
    elseif 6000000 <= gCoin then 
        return 100000
    end

	--[[1月22日暂时屏蔽，用上面的分配策略
    if gCoin < 6000 then
        return 0
    --elseif 3000 <= gCoin and gCoin < 12000 then
    --    return 100
    elseif 6000 <= gCoin and gCoin < 30000 then
        return 200
    elseif 30000 <= gCoin and gCoin < 60000 then
        return 500
    elseif 60000 <= gCoin and gCoin < 120000 then
        return 1000
    elseif 120000 <= gCoin and gCoin < 300000 then
        return 2000
    elseif 300000 <= gCoin and gCoin < 600000 then
        return 5000
    elseif 600000 <= gCoin and gCoin < 3000000 then --1000000 then
        return 10000
    --elseif 1000000 <= gCoin and gCoin < 3000000 then
    --    return 20000
    elseif 3000000 <= gCoin then--and gCoin < 6000000 then 
        return 50000
    --elseif 6000000 <= gCoin then 
    --    return 100000
    end
    ]]
    return 0
end

--[[*****************************************************************************
--mysql结果安全判断
--tab：      table           表
--返回值：   bool    是否安全
******************************************************************************]]
function commonTool.dbSafeCheck(sqlres)
    if sqlres == nil then
        printE("dbSafeCheck : sqlres is nil")
        return false
    end
    if sqlres.badresult == true then
        printE("dbSafeCheck : sql fail.","err:",sqlres.err)
        return false
    end
    return true
end

--[[
table转xml
]]
function commonTool.table2Xml(tab)
	local function table_to_xml_table(old_table,new_table)
		for key,value in pairs(old_table) do  
	        if "table" == type(value) then  
	            table.insert(new_table,"<")  
	            table.insert(new_table,key)  
	            table.insert(new_table,">")  
	            table_to_xml_table(value,new_table)  
	            table.insert(new_table,"</")  
	            table.insert(new_table,key)  
	            table.insert(new_table,">")  
	        else  
	            table.insert(new_table,"<")  
	            table.insert(new_table,key)  
	            table.insert(new_table,">")  
	            table.insert(new_table,value)  
	            table.insert(new_table,"</")  
	            table.insert(new_table,key)  
	            table.insert(new_table,">")  
	        end  
	    end  
	end
	
	local newtab={}
	table_to_xml_table(tab,newtab)
	table.insert(newtab,1,'<?xml version="' .. "1.0" .. '" encoding="' .. "utf-8" .. '" ?><xml>')
	table.insert(newtab,'</xml>')
    return table.concat(newtab)
end

--[[*****************************************************************************
--表转json字符串
--tab：      table           表
--返回值：   string          json字符串
******************************************************************************]]
function commonTool.table2Json(tab)
    if tab == nil or type(tab) ~= "table" then
        printE("table2Json : tab is nil",tab,type(tab))
        return ""
    end

    local json = require("glzp.json")
    local ok,val = pcall(json.encode,tab)
    if ok == false then
    	return ""
    end
    return val
end

--[[*****************************************************************************
--json字符串转表
--text：      string         json字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.json2Table(text)
    if text == nil then
        printE("json2Table : text is nil",text,type(text))
        return {}
    end

    local json = require("glzp.json")
    local ok,val = pcall(json.decode,text)
    if ok == false then
    	printE("json2Table decode fail",val)
    	return {}
    end
    return val
end

--[[*****************************************************************************
--xml字符串转表
--text：      string         xml字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.xml2Table(text)
    if text == nil then
        printE("xml2Table : text is nil",text,type(text))
        return {}
    end

    local xml = require("xml")
    local ok,val = pcall(xml.txml,text)
    if ok == false then
    	printE("xml2Table err",val)
    	return {}
    end
    return val
end

--[[*****************************************************************************
根据成功率随机获得是否成功
successRate    int   (0~100) 成功率
返回值   bool  是否成功
******************************************************************************]]
function commonTool.isSuccess(successRate)
	if type(successRate) ~= "number" then
		return false
	end

	math.randomseed(os.time())

	successRate=math.floor(successRate)
	local res=math.random(1,100)
	if res <= successRate then
		return true
	end
	return false
end

--[[*****************************************************************************
--是否在同一天
--time1  "YYYY-MM-DD hh:mm:ss"
--time2  "YYYY-MM-DD hh:mm:ss"
return bool
******************************************************************************]]
function commonTool.isSameDay(time1,time2) 
	time1=commonTool.date2Sec(os.date("%Y-%m-%d 00:00:00",commonTool.date2Sec(time1)))
	time2=commonTool.date2Sec(os.date("%Y-%m-%d 00:00:00",commonTool.date2Sec(time2)))
	if time1 == time2 then
		return true
	end
	return false
end

--[[
url编码
]]
function commonTool.urlEncode(s)
     s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)  
    return string.gsub(s, " ", "+")  
end  
  
function commonTool.urlDecode(s)  
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)  
    return s  
end  

--[[*****************************************************************************
--table转url字符串
--tab      string         表
--返回值：   string          url字符串
******************************************************************************]]
function commonTool.table2Url(tab,split,symbol)
	if tab == nil or type(tab) ~= "table" then
		printE("table2Url args is nil",tab)
		return ""
	end

	if commonTool.countTable(tab) == 0 then
		return ""
	end

	split=split or "&"
	symbol=symbol or "="

	local str=""
	for k,v in pairs(tab) do
		str=str..tostring(k)..symbol..tostring(v)..split
	end
	--去掉最后的 &
	str=commonTool.cutStringLast(str)

	return str
end

--[[*****************************************************************************
--url字符串转表
--url      string         url字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.url2Table(url) 
	if url == "" or url == nil then
		return {}
	end 
    local t1 = nil  
    --,  
    t1= commonTool.splitString(url,',')  
       
    --?  
    url = t1[1]  
    t1=commonTool.splitString(t1[1],'?')  
       
    url=t1[2]  
    --&  
  
    t1=commonTool.splitString(t1[2],'&')  
    local res = {}  
    for k,v in pairs(t1) do  
        i = 1  
        t1 = commonTool.splitString(v,'=')  
        res[t1[1]]={}  
        res[t1[1]]=t1[2]  
        i=i+1  
    end  
    return res  
end

function commonTool.findString(str,findStr)
	if commonTool.isStringEmpty(str) == true or commonTool.isStringEmpty(findStr) == true then
		return false
	end

	if string.find(str,findStr) then
		return true
	end

	return false
end

--[[*****************************************************************************
--url字符串转表
--url      string         url字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.urlParam2Table(url,split,symbol) 
	if url == "" or url == nil then
		return {}
	end 

	split=split or "&"
	symbol=symbol or "="
    local t1=commonTool.splitString(url,split)  
    local res = {}  
    for k,v in pairs(t1) do  
        i = 1  
        t1 = commonTool.splitString(v,symbol) 
        res[t1[1]]={}  
        res[t1[1]]=t1[2]  
        i=i+1  
    end  
    return res  
end

--[[*****************************************************************************
--url字符串转表
--url      string         url字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.urlParam2Table2Num(url) 
	local tab=commonTool.urlParam2Table(url)
	local res={}
	for k,v in pairs(tab) do
		k=math.floor(tonumber(k))
		v=math.floor(tonumber(v))
		res[k]=v
	end

	return res
end

--[[*****************************************************************************
--url字符串转itemStruct
--url      string         url字符串
--返回值：   table          表
******************************************************************************]]
function commonTool.urlParam2ItemStruct(url) 
	if url == "" or url == nil then
		return {}
	end 
  
    url=commonTool.urlParam2Table(url)
    local res={}
    for k,v in pairs(url) do
    	table.insert(res,{itemId=tonumber(k),num=tonumber(v)})
    end

    return res
end

--[[*****************************************************************************
字符串是否为空
******************************************************************************]]
function commonTool.isStringEmpty(str)
	if str == "" or str == nil then
		return true
	end

	return false
end

--[[*****************************************************************************
table是否为空
******************************************************************************]]
function commonTool.isTableEmpty(tab)
	if tab == nil or type(tab) ~= "table" then
		return true
	end

	for k,v in pairs(tab) do
		return false
	end

	return true
end

--转整形
function commonTool.toInt(val)
	if val == nil or tonumber(val) == nil then
		return 0
	end

	return math.floor(tonumber(val))
end

--判断是否是数字
function commonTool.isNumber(num)
	if tonumber(num) == nil then
		return false
	end

	return true
end


--[[
生成sql插入语句
]]
function commonTool.createInsertSql(tableName,argsTable)
	local sql = string.format("insert into %s(", tableName)
	for k, v in pairs(argsTable) do
		sql  = string.format(sql .. "%s,", k)
	end

	sql = string.sub(sql, 1, #sql-1)
	sql = sql .. ') values('

	for k, v in pairs(argsTable) do
		sql = string.format(sql .. "'%s',", v)
	end

	sql = string.sub(sql, 1, #sql-1)
	sql = sql .. ");"
	return sql
end

--[[
生成sql更新语句
whereTable table and条件
]]
function commonTool.createUpdateSql(tableName,argsTable,whereTable)
	local sql = string.format("update %s set ", tableName)
	for k, v in pairs(argsTable) do
		sql = string.format(sql .. "%s='%s',", k, v)
	end

	sql = string.sub(sql, 1, #sql-1)
	sql=sql.." where "
	for k, v in pairs(whereTable) do
		sql = string.format(sql .. " %s='%s' ", k, v)
		sql = sql.."and"
	end

	sql = string.sub(sql, 1, #sql-3) --去掉最后的and
	return sql
end

--[[
set string age=10,sex=1
where string where userID=1 limit 1
]]
function commonTool.createFullUpdateSql(tableName,set,where)
	if commonTool.isStringEmpty(tableName) == true or commonTool.isStringEmpty(where) == true or commonTool.isStringEmpty(set) == true then
		return nil
	end
	local sql = string.format("update %s ", tableName)
	sql=sql.." "..set
	sql=sql.." "..where
	return sql
end

--[[
生成sql删除语句
]]
function commonTool.createDeleteSql(tableName,whereTable)
	local sql = string.format("delete from %s ", tableName)
	sql=sql.." where "
	for k, v in pairs(whereTable) do
		sql = string.format(sql .. " %s='%s' ", k, v)
		sql = sql.."and"
	end

	sql = string.sub(sql, 1, #sql-3) --去掉最后的and
	return sql
end

--[[
生成sql查询语句
fileds string * aaa,bbb,ccc
whereTable 条件，没有传nil,否则传key=value的表 {name="aa",age=10} and条件
]]
function commonTool.createSelectSql(tableName,fileds,whereTable)
	local sql = string.format("select %s from %s ", fileds,tableName)
	if whereTable == nil or commonTool.countTable(whereTable) == 0 then
		return sql
	end
	sql=sql.." where "
	for k, v in pairs(whereTable) do
		sql = string.format(sql .. " %s='%s' ", k, v)
		sql = sql.."and"
	end

	sql = string.sub(sql, 1, #sql-3) --去掉最后的and
	return sql
end

--[[
fileds string * aaa,bbb,ccc
where  string  where userID=123 and userName='aaa' limit 1

]]
function commonTool.createFullSelectSql(tableName,fileds,where)
	local sql = string.format("select %s from %s ", fileds,tableName)
	if commonTool.isStringEmpty(where) == true then
		return sql
	end
	sql=sql.." "..where
	return sql
end

--[[
生成sql替换语句
]]
function commonTool.createReplaceSql(tableName,argsTable)
	local sql = string.format("replace into %s(", tableName)
	for k, v in pairs(argsTable) do
		sql  = string.format(sql .. "%s,", k)
	end

	sql = string.sub(sql, 1, #sql-1)
	sql = sql .. ') values('

	for k, v in pairs(argsTable) do
		sql = string.format(sql .. "'%s',", v)
	end

	sql = string.sub(sql, 1, #sql-1)
	sql = sql .. ");"
	return sql
end



--[[*****************************************************************************
--解析Json文件
--json：     string          json字符串
--返回值：   table/nil       解析后的结果
******************************************************************************]]
function commonTool.DecodeLKJson(json)
    if json == nil or json == "" then
        printE("json is nil")
        return nil,{RetCode="",RetMsg=""}
    end

    local js = require("glzp.json")
    local val = js.decode(json)

    if val == "" or val == nil or type(val) ~= "table" then
        printE("DecodeLKJson : decode json fail",tostring(val.RetCode),val.RetMsg)
        return nil,{RetCode="",RetMsg=""}
    end

    if val.RetCode ~= nil and tostring(val.RetCode) ~= "0" then
        printE("DecodeLKJson ： ERROR",tostring(val.RetCode),val.RetMsg)
        return nil,{RetCode=tostring(val.RetCode),RetMsg=val.RetMsg}
    end

    return val,{RetCode="",RetMsg=""}
end
function commonTool.decodeLkJsonTable(lktable)
	if lktable == nil then
		return nil
	end
	local res = { }
    res.userName = lktable.Account
    res.nickName = lktable.NickName
    res.sexID = tonumber(lktable.Gender)
    res.KGoldCoin = tonumber(lktable.Treasure)
    res.KCoin = tonumber(lktable.KCoin)
	res.kGoldCoin = tonumber(lktable.Treasure)
	res.kCoin = tonumber(lktable.KCoin)
	res.lkGoldCoin = tonumber(lktable.Treasure)
    res.userID = tonumber(lktable.UserID)
    res.spreader = lktable.Spreader
    return res
end

--K币转游戏金币
--kCoin：    int     K币
--返回值：   int    转换后的字牌金币
function commonTool.kCoin2GoldCoin(kCoin)
    if kCoin == nil or type(kCoin) ~= "number" then
        printE("kCoin2GoldCoin : kCoin error:",kCoin)
        return nil
    end
    -- 1K币 = 10000游戏金币
    return kCoin * commonTool.kCoin2goldCoinRate
end

--判断与今天是否相隔超过1天
function commonTool.overOneDay(date)
    --获得当前日期
    local nowY=os.date("%Y", os.time())
    local nowM=os.date("%m", os.time())
    local nowD=os.date("%d", os.time())

    --解析记录中的日期时间
    local lastDate=commonTool.splitString(date,"-")
    if lastDate == "" or lastDate == nil then
        return false
    end
    local lastY=tonumber(lastDate[1])
    local lastM=tonumber(lastDate[2])
    local lastD=tonumber(lastDate[3])
    --超过1年
    if nowY-lastY >= 1 then
        return true
    end
    --超过1个月
    if nowM-lastM >= 1 then
        return true
    end
    --超过1天
    if nowD-lastD >= 1 then
        return true
    end
    return false
end


--[[
判断用户是否在游戏中
userInfo={userID=xxx}
为nil则表示不在任何状态，不为nil表示在游戏中
]]
function commonTool.isUserInGaming(allServerList,userInfo)
	if allServerList == nil or userInfo == nil then
		printE("isUserInGaming args is nil",allServerList,userInfo)
		return nil
	end

	return commonTool.callRandomService(allServerList,commonTool.SERVER_TYPE.LOBBY,"isUserInGaming",userInfo)
end

--[[*****************************************************************************
--通过账号获得用户ID
userName    string
返回值  int  失败返回nil
******************************************************************************]]
function commonTool.getUserIDByUserName(userName,mysql)
	if commonTool.isStringEmpty(userName) == true or mysql == nil then
		printE("getUserIDByUserName args is nil",userName,mysql)
		return nil
	end

	if commonTool.checkUnlawwedString(userName) == false then
		printE("getUserIDByUserName userName unlaw",userName)
		return nil
	end

	local uif=callDBService(mysql,"launchSQL","select * from User where userName='"..userName.."' limit 1")
	if uif == nil or #uif ==0 then
		printE("getUserIDByUserName can not get user info",userName)
		return nil
	end

	return tonumber(uif[1].ID)
end

--开始计时
function commonTool.startStopWatch()
	return {start=os.time()}
end

--停止计时
function commonTool.stopStopWatch(stopWatch,text)
	if stopWatch == nil then
		stopWatch={start=os.time()}
	end
	printE(nil,tostring(text),os.time()-stopWatch.start)
end

--[[*****************************************************************************
--打印调用堆栈
******************************************************************************]]
function commonTool.showDebugStack()
	printE(debug.traceback())
end

--[[*****************************************************************************
--获得用户的信息
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--redis：       redis数据库     通常是allServerList.redisServerList[1]
userID          int         用户ID
返回值         table/nil    用户信息{userID,userName,nickName,goldCoin,point,spreader,userSpreader,level,exp(百分比),avatarID,code},失败返回nil
******************************************************************************]]
function commonTool.getUserInfo(mysql,redis,userID)
    if mysql == nil or redis == nil or userID == nil then
        printE("getUserInfo : get user info fail,args is nil",mysql,redis,userID)
        commonTool.showDebugStack()
        return nil
    end

    local redisFlag=true--标记
    --从redis查询
    local uif=callRedis(redis,"GetHash","User:"..userID)
    --如果用户不在线
    if uif == nil then
        redisFlag=false
    end

    --积分类道具
    local pt=commonTool.getUserItemAmount(mysql,redis,userID,hs.loginUserGoodsID)

    --从mysql查
    if redisFlag == false then
        uif=callDBService(mysql,"launchSQL","select User.*,goldCoin,point,infoID from User,Account,Role where User.ID="..userID.." and User.ID=Account.userID and Role.ID=User.currentRoleID")
        if callDBService(mysql,"SafeCheck",uif) == false or #uif == 0 then
            printE("getUserInfo : safe check fail or no this user:",userID)
            return nil
        end
        uif=uif[1]
        local userInfo={code=tonumber(uif.code),userID=tonumber(userID),userName=uif.userName,nickName=uif.nickName,regTime=uif.regTime,goldCoin=tonumber(uif.goldCoin),point=pt,spreader=uif.spreader,level=tonumber(uif.level),exp=math.floor(uif.exp/commonTool.levelInfo[tonumber(uif.level)]*100),avatarID=tonumber(uif.infoID),newSpreader=uif.newSpreader,userSpreader=tonumber(uif.userSpreader),thirdAvatarID=uif.thirdAvatarID}
        return userInfo
    end

    --账户
    local acc=callRedis(redis,"GetAccount",userID)

    if uif.currentRoleID == nil then
    	printE("get user info : currentRoleID=nil",userID)
    	uif.currentRoleID=1
    end
    --角色
    local role=callRedis(redis,"GetHash","Role:"..tostring(uif.currentRoleID))

    if acc == nil or role == nil then
        printE("getUserInfo : user may offline",userID)
        return nil
    end

    local userInfo={ip=uif.ip,code=tonumber(uif.code),userID=tonumber(userID),userName=uif.userName,nickName=uif.nickName,regTime=uif.regTime,goldCoin=tonumber(acc.goldCoin),point=pt,spreader=uif.spreader,level=tonumber(uif.level),exp=math.floor(uif.exp/commonTool.levelInfo[tonumber(uif.level)]*100),avatarID=tonumber(role.infoID),newSpreader=uif.newSpreader,userSpreader=tonumber(uif.userSpreader),thirdAvatarID=uif.thirdAvatarID}
    return userInfo
end

--[[
获得用户UserData信息
没有返回nil
返回值={
	rechargeRmb double 总充值金额，人民币
	rateGames   int    倍率总局数
	matchGames   int   比赛总局数
	selfGames   int    旧私人场总局数
	newSelfGames int   包厢总局数
}
]]
function commonTool.getUserDataInfo(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserDataInfo args is nil",mysql,redis,userID)
		return nil
	end

	local data=callRedis(redis,"GetUserData",userID)
	if data == nil then
		--从mysql读取
		data=callDBService(mysql,"launchSQL",string.format("select * from UserData where userID=%d limit 1",userID))
		if commonTool.dbSafeCheck(data) == false or #data == 0 then
			printE("getUserDataInfo get user data fail",userID)
			return nil
		end
		data=data[1]
	end

	data=commonTool.safeTable2Num(data)
	return data
end

--[[
获得用户UserAuth信息
没有返回nil
返回值={
	idCard string 身份证号  没有为空字符串
	phone  string 手机号    没有为空字符串
}
]]
function commonTool.getUserAuthInfo(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserAuthInfo args is nil",mysql,redis,userID)
		return nil
	end

	local data=callRedis(redis,"GetHash1","UserAuth:"..tostring(userID))
	if data == nil then
		--从mysql读取
		data=callDBService(mysql,"launchSQL",string.format("select * from UserAuth where userID=%d limit 1",userID))
		if commonTool.dbSafeCheck(data) == false or #data == 0 then
			printE("getUserAuthInfo get user data fail",userID)
			return nil
		end
		data=data[1]
	end
	local ok,idCard=pcall(crypt.base64decode,data.idCard)
	if ok == true then
		data.idCard=idCard
	end
	
	return data
end

--[[*****************************************************************************
--获得有效新推广号
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
返回值         没有返回空表,正常返回[N]={userID,nickName,userName}
******************************************************************************]]
function commonTool.getVaildNewSpreader(mysql)
	if mysql == nil then
		printE("getVaildNewSpreader args is nil")
		return {}
	end

	local list=callDBService(mysql,"launchSQL","select * from NewSpreader where stateID="..h.spreaderState.valid)
	if commonTool.dbSafeCheck(list) == false then
		printE("getVaildNewSpreader dbSafeCheck fail")
		return {}
	end

	return list
end

--[[
解绑newSpreader
]]
function commonTool.unbindNewSpreader(mysql,redis,userInfo,payInfo,mallInfo)
	local cost=commonTool.urlParam2Table(mallInfo.costGoods)
	local uif=commonTool.getUserInfo(mysql,redis,userInfo.userID)
	printE("unbindNewSpreader user wants unbind",userInfo.userID)
	if uif == nil then
		printE("unbindNewSpreader get user info fail",userInfo.userID,mallInfo.costGoods)
		return false
	end
	local res=callDBService(mysql,"launchSQL",string.format("update User set newSpreader='' where ID=%d limit 1",userInfo.userID))
	if commonTool.dbSafeCheck(res) == false or res.affected_rows ~= 1 then
		printE("unbindNewSpreader update mysql fail",userInfo.userID)
		commonTool.showTable(res)
		return false
	end

	if callRedis(redis,"GetHash","User:"..tostring(userInfo.userID)) ~= nil then
		callRedis(redis,"SetHash","User:"..tostring(userInfo.userID),{newSpreader=""})
		printE("unbindNewSpreader user unbind redis",userInfo.userID)
	end

	--减少用户数
	callDBService(mysql,"updateNewSpreaderInfo",uif.newSpreader,{userNum=-1})
	res=callDBService(mysql,"InsertNewSpreaderChangeLog",userInfo,uif.newSpreader,"",cost)
	if res == false then
		printE("unbindNewSpreader insert mysql fail",userInfo.userID)
		return false
	end
	printE("unbindNewSpreader user unbind ok",userInfo.userID)
	return true
end

--[[*****************************************************************************
获得玩家User表数据
******************************************************************************]]
function commonTool.getUser(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUser args is nil",mysql,redis,userID)
		return nil
	end

	local info=callRedis(redis,"GetHash","User:"..tostring(userID))
	if info == nil then
		info=callDBService(mysql,"launchSQL","select * from User where ID="..tostring(userID))
		if commonTool.dbSafeCheck(info) == false or #info <= 0 then
			return nil
		end
		info=info[1]
	end
	info.userID=tonumber(info.ID)
	info.code=tonumber(info.code)
	info.avatarID=commonTool.getAvatarID(mysql,info.currentRoleID)

	return info
end

function commonTool.getAvatarID(mysql,currentRoleID)
	local avatar=callDBService(mysql,"launchSQL","select infoID as avatarID from Role where ID="..tostring(currentRoleID))
	if commonTool.dbSafeCheck(avatar) == false or #avatar == 0 then
		avatar=1
	else
		avatar=avatar[1].avatarID
	end
	return tonumber(avatar) or 1
end

--[[*****************************************************************************
通过code获得玩家数据
******************************************************************************]]
function commonTool.getUserByCode(mysql,redis,code)
	if mysql == nil or redis == nil or code == nil then
		printE("getUserByCode args is nil",mysql,redis,code)
		return nil
	end

	local info=callDBService(mysql,"launchSQL","select * from User where code="..tostring(code))
	if commonTool.dbSafeCheck(info) == false or #info <= 0 then
		printE("getUserByCode get user info fail",code)
		return nil
	end
	info=info[1]
	info.userID=tonumber(info.ID)
	info.avatarID=commonTool.getAvatarID(mysql,info.currentRoleID)

	return info
end

--[[*****************************************************************************
更新UserData数据
field 			string 			字段名
dValue 			number   变化量，增为+，减为-
******************************************************************************]]
function commonTool.updateUserData(mysql,redis,userInfo,field,dValue)
	if mysql == nil or redis == nil or userInfo == nil or field == nil or dValue == nil then
		printE("updateUserData args is nil",mysql,redis,userInfo,field,dValue)
		return
	end

	if math.floor(dValue) < dValue then
		callDBService(mysql,"launchSQL",string.format("update UserData set %s=%s+%.2f where userID=%d",field,field,dValue,userInfo.userID))
	else
		callDBService(mysql,"launchSQL",string.format("update UserData set %s=%s+%d where userID=%d",field,field,dValue,userInfo.userID))
	end

	
end

--[[*****************************************************************************
--是否是有效的新推广号
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--newSpreader :string  新推广号
返回值         bool
******************************************************************************]]
function commonTool.isNewSpreaderValid(mysql,newSpreader)
	if mysql == nil or commonTool.isStringEmpty(newSpreader) == true then
		printE("getVaildNewSpreader args is nil",mysql,newSpreader)
		return false
	end

	local sql="select * from NewSpreader where stateID="..h.spreaderState.valid.." and userName='"..tostring(newSpreader).."'"
	local list=callDBService(mysql,"launchSQL",sql)
	if commonTool.dbSafeCheck(list) == false then
		printE("getVaildNewSpreader dbSafeCheck fail",newSpreader,sql)
		return false
	end

	if #list <= 0 then
		printE("getVaildNewSpreader not vaild",newSpreader,sql)
		return false
	end

	return true
end

--[[*****************************************************************************
--是否是有效的推广号
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--newSpreader :string  新推广号
返回值         bool
******************************************************************************]]
function commonTool.isSpreaderValid(mysql,spreader)
	if mysql == nil or commonTool.isStringEmpty(spreader) == true then
		printE("isSpreaderValid args is nil",mysql,spreader)
		return false
	end

	local sql="select * from Spreader where stateID="..h.spreaderState.valid.." and userName='"..tostring(spreader).."'"
	local list=callDBService(mysql,"launchSQL",sql)
	if commonTool.dbSafeCheck(list) == false then
		printE("isSpreaderValid dbSafeCheck fail",spreader)
		return false
	end

	if #list <= 0 then
		printE("isSpreaderValid not vaild",spreader,sql)
		return false
	end

	return true
end

--从数据库获得玩家数据，失败为nil
function commonTool.getUserInfoFromDb(userID,mysql,redis)
	if userID == nil or mysql == nil or redis == nil then
		printE("getUserInfoFromDb : args is nil",mysql,redis,userID)
		return nil
	end

	local pt=commonTool.getUserItemAmount(mysql,redis,userID,hs.loginUserGoodsID)
	local uif=callDBService(mysql,"launchSQL","select User.*,goldCoin,infoID as avatarID from User,Account,Role where User.ID="..userID.." and User.ID=Account.userID and Role.ID=User.currentRoleID")
    if callDBService(mysql,"SafeCheck",uif) == false or #uif == 0 then
        printE("getUserInfoFromDb : safe check fail",userID)
        return nil
    end
    uif=uif[1]

    uif.point=pt

    return uif
end

--[[
获得用户UserData信息
没有返回nil
返回值={
	rechargeRmb double 总充值金额，人民币
	rateGames   int    倍率总局数
	matchGames   int   比赛总局数
	selfGames   int    旧私人场总局数
	newSelfGames int   包厢总局数
}
]]
function commonTool.getUserDataInfo(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserDataInfo args is nil",mysql,redis,userID)
		return nil
	end

	local data=callRedis(redis,"GetUserData",userID)
	if data == nil then
		--从mysql读取
		data=callDBService(mysql,"launchSQL",string.format("select * from UserData where userID=%d limit 1",userID))
		if commonTool.dbSafeCheck(data) == false or #data == 0 then
			printE("getUserDataInfo get user data fail",userID)
			return nil
		end
		data=data[1]
	end

	data=commonTool.safeTable2Num(data)
	return data
end


--[[
获得用户UserData信息
没有返回nil
返回值={
	rechargeRmb double 总充值金额，人民币
	rateGames   int    倍率总局数
	matchGames   int   比赛总局数
	selfGames   int    旧私人场总局数
	newSelfGames int   包厢总局数
}
]]
function commonTool.getUserDataInfo(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserDataInfo args is nil",mysql,redis,userID)
		return nil
	end

	local data=callRedis(redis,"GetUserData",userID)
	if data == nil then
		--从mysql读取
		data=callDBService(mysql,"launchSQL",string.format("select * from UserData where userID=%d limit 1",userID))
		if commonTool.dbSafeCheck(data) == false or #data == 0 then
			printE("getUserDataInfo get user data fail",userID)
			return nil
		end
		data=data[1]
	end

	data=commonTool.safeTable2Num(data)
	return data
end

--[[
获得用户UserAuth信息
没有返回nil
返回值={
	idCard string 身份证号  没有为空字符串
	phone  string 手机号    没有为空字符串
}
]]
function commonTool.getUserAuthInfo(mysql,redis,userID)
	if mysql == nil or redis == nil or userID == nil then
		printE("getUserAuthInfo args is nil",mysql,redis,userID)
		return nil
	end

	local data=callRedis(redis,"GetHash1","UserAuth:"..tostring(userID))
	if data == nil then
		--从mysql读取
		data=callDBService(mysql,"launchSQL",string.format("select * from UserAuth where userID=%d limit 1",userID))
		if commonTool.dbSafeCheck(data) == false or #data == 0 then
			printE("getUserAuthInfo get user data fail",userID)
			return nil
		end
		data=data[1]
	end
	local ok,idCard=pcall(crypt.base64decode,data.idCard)
	if ok == true then
		data.idCard=idCard
	end
	
	return data
end


--老K金币转游戏金币
--kGoldCoin：    int     老K金币
--返回值：       int     转换后的字牌金币
function commonTool.kGoldCoin2GoldCoin(kGoldCoin)
    if kGoldCoin == nil or type(kGoldCoin) ~= "number" then
        printE("kGoldCoin2GoldCoin : kGoldCoin error:",kGoldCoin)
        return nil
    end
    -- 1老K金币 = 1游戏金币
    return kGoldCoin * commonTool.kGoldCoin2goldCoinRate
end

--id=num&id=num 转 goodsID=id,id goodsAmount=num,num
function commonTool.splitUrlAward(awdstr)
    if commonTool.isStringEmpty(awdstr) == true then
        return nil
    end
    local awd=commonTool.urlParam2Table(awdstr)
    return commonTool.splitTableAward(awd)
end

--[id]=num 转 goodsID=id,id goodsAmount=num,num
function commonTool.splitTableAward(awd)
	if type(awd) ~= "table" then
		return nil
	end
    local ids=""
    local amt=""
    for k,v in pairs(awd) do
        ids=ids..k..","
        amt=amt..v..","
    end
    if commonTool.isStringEmpty(ids) == false and commonTool.isStringEmpty(amt) == false then
        ids=commonTool.cutStringLast(ids)
        amt=commonTool.cutStringLast(amt)
    else
        return nil
    end

    return {goodsID=ids,goodsAmount=amt}
end

--[[*****************************************************************************
--改变邮件的状态
typeID 		int 	原类型
stateID 	int 	新状态
******************************************************************************]]
function commonTool.changeEmailState(mysql,redis,emailInfo,newTypeID,newStateID,userID)
	if mysql == nil or redis == nil or emailInfo == nil or userID == nil or newTypeID == nil or newStateID == nil then
		printE("changeEmailState args is nil",mysql,redis,emailInfo,userID,newTypeID,newStateID)
		return false
	end

	if tonumber(emailInfo.infoID) ~= 0 then
		printE("changeEmailState : can not change system notice email state",emailInfo.ID)
		return false
	end

	local emailID=tonumber(emailInfo.ID)
	local typeID=tonumber(emailInfo.typeID)
	newTypeID=tonumber(newTypeID)
	newStateID=tonumber(newStateID)
	userID=tonumber(userID)
	local originalTypeID=tonumber(emailInfo.originalTypeID)

	--获取邮件信息
	local email=callRedis(redis,"GetHash","Email:"..emailID)
	if email == nil then
		printE("changeEmailState : can not get email info ",emailID,userID)
		return false
	end

	--重要邮件不允许删除
	if newStateID == h.emailStateID.Expire and typeID == h.emailType.Important then
		printE("changeEmailState can not delete Important email",emailID,userID)
		return false
	end

	--改变状态
	callRedis(redis,"SetHash","Email:"..emailID,{stateID=newStateID,typeID=newTypeID,readTime=commonTool.sec2Date(os.time())})
	callDBService(mysql,"launchSQL",string.format("update Email set typeID=%d,stateID=%d,readTime='%s' where ID=%d",newTypeID,newStateID,commonTool.sec2Date(os.time()),emailID))


	--判断类型
	if newStateID == h.emailStateID.Read then
		if typeID == h.emailType.Award or typeID == h.emailType.MatchAward then
			--从Email表删除，放入ReceivedEmail表
			callDBService(mysql,"launchSQL",string.format("insert into ReceivedEmail_%s (select * from Email where ID=%d)",os.date("%Y_%m",os.time()),emailID))
			callDBService(mysql,"launchSQL",string.format("delete from Email where ID=%d",emailID))
		else
	 
		end
	elseif newStateID == h.emailStateID.Expire then
		--从Email表删除，转移到HistoryEmail表
		if originalTypeID == h.emailType.Notice then

			callDBService(mysql,"launchSQL",string.format("insert into HistoryEmail_%s (select * from Email where ID=%d)",os.date("%Y_%m",os.time()),emailID))
			callDBService(mysql,"launchSQL",string.format("delete from Email where ID=%d",emailID))
		elseif originalTypeID == h.emailType.Award or originalTypeID == h.emailType.MatchAward then

			callDBService(mysql,"launchSQL",string.format("insert into HistoryEmail_%s (select * from ReceivedEmail_%s where ID=%d)",os.date("%Y_%m",os.time()),os.date("%Y_%m",os.time()),emailID))
			callDBService(mysql,"launchSQL",string.format("delete from ReceivedEmail_%s where ID=%d",os.date("%Y_%m",os.time()),emailID))
		end
	end

	return true
end

--[[*****************************************************************************
--批量插入邮件到mysql
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
emails[N]={
goodsID     string 		
goodsAmount string	
userInfo    table 			{userID,nickName,userName}
title 		string 			标题
content 	string 			内容
expireTime  int 			天
typeID      int 			邮件类型
sender 		table 			{userID,nickName,userName}赠送人
}
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendSomeEmailsToDB(mysql,emails)
	if mysql == nil or emails == nil or #emails == 0 then
		printE("SendSomeEmailsToDB : args is nil",mysql,emails)
		return false
	end
	local sd=os.date("%Y-%m-%d",os.time())
    local now=commonTool.sec2Date(os.time())
	local sql="insert into Email (title,content,userID,fromUserID,toUserID,sendTime,expireTime,stateID,infoID,typeID,goodsID,goodsAmount,fromNickName,toNickName,fromUserName,toUserName,readTime,originalTypeID) values"
	for k,v in pairs(emails) do
		--检查奖励
		local gids=v.goodsID
		local gamt=v.goodsAmount
		local ed=os.date("%Y-%m-%d",os.time() + tonumber(v.expireTime)*24*3600)
		local subSql=string.format("('%s','%s',%d,%d,%d,'%s','%s',%d,%d,%d,'%s','%s','%s','%s','%s','%s','%s 00:00:00',%d),",
								v.title,v.content,v.userInfo.userID,v.sender.userID,v.userInfo.userID,
								sd,ed,h.emailStateID.notRead,0,v.typeID,gids,gamt,
								v.sender.nickName,v.userInfo.nickName,v.sender.userName,v.userInfo.userName,
								now,v.typeID)
		sql=sql..subSql
	end
	sql=commonTool.cutStringLast(sql)
	local res=callDBService(mysql,"launchSQL",sql)
	if commonTool.dbSafeCheck(res) == false then
		printE("SendSomeEmailsToDB sql err",sql)
		commonTool.showTable(res)
	end
	return true

end
--[[*****************************************************************************
emails[N]={
goodsID     string 		
goodsAmount string	
userInfo    table 			{userID,nickName,userName}
title 		string 			标题
content 	string 			内容
expireTime  int 			天
typeID      int 			邮件类型
sender 		table 			{userID,nickName,userName}赠送人
}
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendSomeEmailsToRedis(redis,emails)
	if redis == nil or emails == nil then
		printE("SendSomeFakeEmailsToRedis : args is nil",redis,emails)
		return false
	end

	local sd=os.date("%Y-%m-%d",os.time())

	for k,v in pairs(emails) do
		callRedis(redis,"SetHash","Email:"..v.ID,{ID=v.ID,title=v.title,content=v.content,userID=v.userInfo.userID,fromUserID=v.sender.userID,toUserID=v.userInfo.userID,sendTime=sd,expireTime=v.expireTime,stateID=h.emailStateID.notRead,infoID=v.infoID,typeID=v.typeID,fromNickName=v.sender.nickName,toNickName=v.userInfo.nickName,goodsID=v.goodsID,goodsAmount=v.goodsAmount,fromUserName=v.sender.userName,toUserName=v.userInfo.userName})
        --callRedis(redis,"AddSet","User:"..commonTool.userID_emailIDs..":"..v.userID,{v.ID})
	end

	return true
end

--[[*****************************************************************************
emails[N]={
goodsID     string 		
goodsAmount string	
userInfo    table 			{userID,nickName,userName}
title 		string 			标题
content 	string 			内容
expireTime  int 			天
typeID      int 			邮件类型
sender 		table 			{userID,nickName,userName}赠送人
}
eg:
奖励邮件
emails={
	[1]=
	{
		goodsID="0,105",        --道具ID
		goodsAmount="100,10",	--道具数量，位置要与ID相对应
		userInfo={				--收件人信息
			userID=4001,
			userName="robot1",
			nickName="robot1"
		},
		title="标题",
		content="内容",
		expireTime=h.emailExpireTime,
		typeID=h.emailType.Award,
		sender={				--发件人信息
			userID=0,
			userName="glzp",
			nickName="系统"
		}
	}
}

公告邮件
emails={
	[1]=
	{
		goodsID="",
		goodsAmount="",
		userInfo={				--收件人信息
			userID=4001,
			userName="robot1",
			nickName="robot1"
		},
		title="标题",
		content="内容",
		expireTime=h.emailExpireTime,
		typeID=h.emailType.Notice,
		sender={				--发件人信息
			userID=0,
			userName="glzp",
			nickName="系统"
		}
	}
}
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendSomeEmails(mysql,redis,emails)
	if redis == nil or emails == nil or mysql == nil or #emails == 0 then
		printE("SendSomeEmails : args is nil",mysql,redis,emails)
		return false
	end

	local sd=os.date("%Y-%m-%d",os.time())

    local now=commonTool.sec2Date(os.time())
	for k,v in pairs(emails) do
		--检查奖励
		if v.userInfo ~= nil then
			local gids=v.goodsID
			local gamt=v.goodsAmount
			local ed=os.date("%Y-%m-%d",os.time() + tonumber(v.expireTime)*24*3600)
			local sql=string.format("insert into Email (title,content,userID,fromUserID,toUserID,sendTime,expireTime,stateID,infoID,typeID,goodsID,goodsAmount,fromNickName,toNickName,fromUserName,toUserName,readTime,originalTypeID) values ('%s','%s',%d,%d,%d,'%s','%s',%d,%d,%d,'%s','%s','%s','%s','%s','%s','%s',%d)",
									v.title,v.content,v.userInfo.userID,v.sender.userID,v.userInfo.userID,
									sd,ed,h.emailStateID.notRead,0,v.typeID,gids,gamt,
									v.sender.nickName,v.userInfo.nickName,v.sender.userName,v.userInfo.userName,
									now,v.typeID)
			local ist=callDBService(mysql,"launchSQL",sql)
			if commonTool.dbSafeCheck(ist) == true then
				ist=tonumber(ist.insert_id)
				local uif=callRedis(redis,"GetHash","User:"..v.userInfo.userID)
				if uif ~= nil then
					callRedis(redis,"SetHash","Email:"..ist,{ID=ist,title=v.title,content=v.content,userID=v.userInfo.userID,fromUserID=v.sender.userID,toUserID=v.userInfo.userID,sendTime=sd,expireTime=v.expireTime,stateID=h.emailStateID.notRead,infoID=0,typeID=v.typeID,fromNickName=v.sender.nickName,toNickName=v.userInfo.nickName,goodsID=v.goodsID,goodsAmount=v.goodsAmount,fromUserName=v.sender.userName,toUserName=v.userInfo.userName})
					callRedis(redis,"AddSet","User:"..commonTool.userID_emailIDs..":"..v.userInfo.userID,{ist})
				end
			end
		end
	end

	return true
end


--[[
10进制转62进制
]]
function commonTool.radix10ToRadix62(num)
	local charSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	local list=commonTool.luaList()
	local result=""
	num=math.floor(num)
	while num ~= 0 do
		local tmpNum1=math.floor(math.floor(num/62)*62)
		local tmpNum2=math.floor(num-tmpNum1)
		local tmpNum=tmpNum2+1
		local tmpChar=string.sub(charSet,tmpNum,tmpNum)
		list.pushBack(tmpChar)
		num=math.floor(math.floor(num)/62)
	end

	while list.bool_isEmpty() == false do
		local char=list.getBack()
		list.popBack()
		result=result..char
	end

	return result
end

--[[
62进制转10进制
]]
function commonTool.radix62ToRadix10(num)
	local charSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	local bytearr={}
	local numIdx=1
	local count=0
	local kei=0
	local dec=0
	while numIdx <= string.len(num) do
		local bt=string.byte(num,numIdx,numIdx)
		table.insert(bytearr,bt)
		numIdx=numIdx+1
	end

	for i=#bytearr,1,-1 do
		local tempNum=0
		if bytearr[i] > 48 and bytearr[i] <= 57 then
			tempNum=bytearr[i]-48
		elseif bytearr[i] >= 65 and bytearr[i] <= 90 then
			tempNum=bytearr[i]-65+10
		elseif bytearr[i] >= 97 and bytearr[i] <= 122 then
			tempNum=bytearr[i]-97+10+26
		end

		kei=62^count
		dec=dec+(tempNum*kei)
		count=count+1
	end

	return tonumber(string.format("%d",dec))
end

--[[
获得用户token
]]
function commonTool.createUserToken(redis,userInfo)
	
	if redis == nil or userInfo == nil then
		printE("createUserToken args is nil",redis,userInfo)
		return nil
	end
	local token=md5.sumhexa(userInfo.thirdPartUnionID..os.time()..math.random(0,99999))--混淆
	callRedis(redis,"SetHashMem",hs.rdsTabName.UserTokenList,token,userInfo.thirdPartUnionID)
    return token
end

--[[
解析用户token
]]
function commonTool.analysisUserToken(redis,token)
	if redis == nil or commonTool.isStringEmpty(token) == true then
		printE("analysisUserToken args is nil",redis,token)
		return nil
	end
	
	local info=callRedis(redis,"GetHashMem",hs.rdsTabName.UserTokenList,token)
	if info == nil then
		printE("analysisUserToken get userinfo fail",token)
		return nil
	end
	return info
end

--[[
删除用户token
]]
function commonTool.deleteUserToken(redis,token)
	callRedis(redis,"DeleteHash",hs.rdsTabName.UserTokenList,token)
	return true
end

--[[*****************************************************************************
--发送未读邮件数给玩家
userInfo={userID}
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.sendNotReadEmailToPlayer(userInfo,redis)
	if userInfo == nil or redis == nil then
		printE("sendNotReadEmailToPlayer : args is nil",userInfo,redis)
		commonTool.showDebugStack()
		return false
	end
	local lobby=commonTool.getPlayerLobby(userInfo,redis)
	if lobby ~= nil then
		pcall(cluster.call,lobby.serverName, ".lobby_self", "callPlayerFunction", "sendNeverReadEmailAmount", userInfo.userID,userInfo.userID)
	end
	return true
end

--[[
获得玩家未读邮件数
]]
function commonTool.getUserNotReadEmailNum(mysql,redis,userInfo)
	if mysql == nil or redis == nil or userInfo == nil then
		printE("getUserNotReadEmailNum : args is nil",mysql,redis,userInfo)
		return 0
	end

	local amt=callDBService(mysql,"launchSQL",string.format("select count(ID) as c from Email where userID=%d and expireTime >='%s' and expireTime <= '%s'",userInfo.userID,os.date("%Y-%m-%d",os.time()),os.date("%Y-%m-%d",os.time())))
	if commonTool.SafeCheck(amt) == false or #amt == 0 then
		printE("getUserNotReadEmailNum safe check fail",userInfo.userID)
		return 0
	end
	amt=tonumber(amt[1]["c"]) or 0
	if amt > h.emailAmountLimit then
        amt=h.emailAmountLimit
    end

    return amt
end

--[[
随机获取一个服务
]]
function commonTool.randomService_glzp(allServerList,serverType)
	if type(allServerList) ~= "table" or serverType == nil then
		printE("randomService_glzp service not in table list",allServerList,serverType)
		commonTool.showDebugStack()
		return nil
	end

	local tmpList={}
	if serverType == commonTool.SERVER_TYPE.LOGIN then
		tmpList=allServerList.loginServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.GATE then
		tmpList=allServerList.gateServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB then
		tmpList=allServerList.dbServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.REDIS then
		tmpList=allServerList.redisServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.LOBBY then
		tmpList=allServerList.lobbyServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.MISSION then
		tmpList=allServerList.missionServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB_LOG then
		tmpList=allServerList.dblogServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB_DISPATCHER then
		tmpList=allServerList.dbDispatcherServerList or {}
	elseif serverType == commonTool.SERVER_TYPE.MALL then
		tmpList=allServerList.mallServerList or {}
	elseif serverType == commonTool.SERVER_TYPE.DATA_SHARER then
		tmpList=allServerList.dataSharerServerList or {}
	elseif serverType == commonTool.SERVER_TYPE.DB_OFFER then
		tmpList=allServerList.dbOfferServerList or {}
	elseif serverType == commonTool.SERVER_TYPE.TIMER then
		tmpList=allServerList.timerServerList or {}
	end

	if #tmpList == 0 then
		printE("randomService_glzp no service list",allServerList,serverType)
		commonTool.showDebugStack()
		return nil
	end

	local idx=math.random(1,#tmpList)
	return tmpList[idx]
end

function commonTool.randomService_phz(allServerList,serverType)
	if type(allServerList) ~= "table" or serverType == nil or allServerList[serverType] == nil or #allServerList[serverType] == 0 then
		printE("randomService_phz service not in table list",allServerList,serverType)
		commonTool.showDebugStack()
		return nil
	end

	local idx=math.random(1,#allServerList[serverType])
	return allServerList[serverType][idx]
end

function commonTool.randomService(allServerList,serverType)
	local func=logic_ctrl.getRandomServiceFuncName()
    if commonTool[func] == nil then
        printE("randomService func is nil",func)
        return false
    end
    return commonTool[func](allServerList,serverType)
end

--[[
随机获取一个服务
]]
function commonTool.findService_glzp(allServerList,serverType,serverName)
	if type(allServerList) ~= "table" or serverType == nil or serverName == nil then
		printE("findService_glzp service not in table list",allServerList,serverType,serverName)
		commonTool.showDebugStack()
		return nil
	end

	local tmpList={}
	if serverType == commonTool.SERVER_TYPE.LOGIN then
		tmpList=allServerList.loginServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.GATE then
		tmpList=allServerList.gateServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB then
		tmpList=allServerList.dbServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.REDIS then
		tmpList=allServerList.redisServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.LOBBY then
		tmpList=allServerList.lobbyServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.MISSION then
		tmpList=allServerList.missionServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB_LOG then
		tmpList=allServerList.dblogServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB_DISPATCHER then
		tmpList=allServerList.dbDispatcherServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DATA_SHARER then
		tmpList=allServerList.dataSharerServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.DB_OFFER then
		tmpList=allServerList.dbOfferServerList or {}

	elseif serverType == commonTool.SERVER_TYPE.TIMER then
		tmpList=allServerList.timerServerList or {}

	end

	if #tmpList == 0 then
		printE("findService_glzp no service list",allServerList,serverType,serverName)
		commonTool.showDebugStack()
		return nil
	end

	for k,v in pairs(tmpList) do
		if v.serverName == serverName then
			return v
		end
	end

	printE("findService_glzp service not exists",allServerList,serverType,serverName)
	return nil
end

function commonTool.findService_phz(allServerList,serverType,serverName)
	if type(allServerList) ~= "table" or serverType == nil or allServerList[serverType] == nil or #allServerList[serverType] == 0 or serverName == nil then
		printE("findService_phz service not in table list",allServerList,serverType,serverName)
		commonTool.showDebugStack()
		return nil
	end

	for k,v in pairs(allServerList[serverType]) do
		if v.serverName == serverName then
			return v
		end
	end

	printE("findService_phz service not exists",allServerList,serverType,serverName)
	return nil
end

function commonTool.findService(allServerList,serverType,serverName)
	local func=logic_ctrl.getFindServiceFuncName()
    if commonTool[func] == nil then
        printE("randomService func is nil",func,serverType,serverName)
        return false
    end
    return commonTool[func](allServerList,serverType,serverName)
end

--[[
调用服务
]]
function commonTool.callService(service,funcName,...)
	if type(service) ~= "table" or funcName == nil or service.serverName == nil or service.service == nil then
		printE("callService args is nil",service,funcName,...)
		commonTool.showDebugStack()
		return nil
	end
	local ok,result=pcall(cluster.call,service.serverName,service.service,funcName,...)
	if ok == false then
		printE("callService call service fail,",result,service.serverName,funcName,...)
		commonTool.showDebugStack()
		return nil
	end
	return result
end

--[[
随机调用服务
]]
function commonTool.callRandomService(allServerList,serverType,funcName,...)
	if allServerList == nil or serverType == nil or funcName == nil then
		printE("callRandomService args is nil",allServerList,serverType,funcName,...)
		commonTool.showDebugStack()
		return nil
	end
	local service=commonTool.randomService(allServerList,serverType)
	if service == nil then
		printE("callRandomService service is nil",allServerList,serverType,funcName)
		commonTool.showDebugStack()
		return nil
	end

	return commonTool.callService(service,funcName,...)
end

--[[
调用指定db_log服务，主要用户根据不同的日志类型，调用不同的db_log服务插入数据，避免两个db_log同时插入一张表造成死锁
dblogModel 定义在 hs.dblogModel
]]
function commonTool.callDbLogService(allServerList,dblogModel,funcName,...)
	if allServerList == nil or type(allServerList) ~= "table" or dblogModel == nil or funcName == nil then
		printE("callDbLogService args is nil",allServerList,dblogModel,funcName)
		commonTool.showDebugStack()
		return nil
	end
	local serverName=hs.delogModelMap[dblogModel]
	if commonTool.isStringEmpty(serverName) == true then
		printE("callDbLogService can not find dblog map",allServerList,dblogModel,funcName)
		commonTool.showDebugStack()
		return nil
	end
	local service=commonTool.findService(allServerList,commonTool.SERVER_TYPE.DB_LOG,serverName)
	if service == nil then
		printE("callDbLogService service not exists",allServerList,dblogModel,funcName)
		commonTool.showDebugStack()
		return nil
	end
		
	return commonTool.callService(service,funcName,...)
end

--[[*****************************************************************************
--调用player函数
--返回值        table/nil            失败为nil
******************************************************************************]]
function commonTool.callPlayerFunction(redis,funcName,userID,...)
	local ok=false
	local res=false
	local lobby=commonTool.getPlayerLobby({userID=userID},redis)
	if lobby ~= nil then
		ok,res=pcall(cluster.call,lobby.serverName,lobby.service, "callPlayerFunction", funcName,userID,...)
	end
	if ok == false then
		printE("call player func fail",funcName,userID,res)
		return nil
	end

	return res
end

--[[*****************************************************************************
--调用email函数
--返回值        table/nil            失败为nil
******************************************************************************]]
function commonTool.callEmailFunction(funcName,...)
	local ok,res=pcall(cluster.call,commonTool.secServiceName.email, ".email_self", funcName,...)
	if ok == false then
		printE("call player func fail",funcName,userID,res)
		return nil
	end

	return res
end

--数table元素
function commonTool.countTable(tab)
	if type(tab) ~= "table" then
		return 0
	end

	local count=0
	for k,v in pairs(tab) do
		count=count+1
	end
	return count
end

--[[*****************************************************************************
--发送一条自定义奖励邮件
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--redis：       redis数据库     通常是allServerList.redisServerList[1]
--userID        int             拥有该邮件的用户ID
--title         string          标题
--content       string          内容
--goodsID       table           奖励ID
--goodsAmount   table           奖励数量
--expireAwardTime int           奖励过期时间，单位，天
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendCustomAwardEmail(mysql,redis,userID,title,content,goodsID,goodsAmount,expireAwardTime,typeID)
    if mysql == nil or redis == nil or userID == nil or title == nil or content == nil or goodsID == nil or goodsAmount == nil or expireAwardTime == nil or typeID == nil then
        printE("SendCustomAwardEmail : args is nil",mysql,redis,userID,title,content,goodsID,goodsAmount,expireAwardTime,typeID)
        return false
    end
    if type(goodsID) ~= "table" or type(goodsAmount) ~= "table" then
        printE("SendCustomAwardEmail : goodsID or goodsAmount is not table type",type(goodsID),type(goodsAmount))
    end
    --奖励类型
    local goodsTypeID=""
    for i=1,#goodsID,1 do
        if goodsID[i] == nil then
            printE("SendCustomAwardEmail goodsID err","i:",i)
            return false
        end
        goodsTypeID=goodsTypeID..goodsID[i]
        if i < #goodsID then
            goodsTypeID=goodsTypeID..","
        end
    end
    --奖励数量
    local goodsAmt=""
    for i=1,#goodsAmount,1 do
        if goodsAmount[i] == nil then
            printE("SendCustomAwardEmail goodsAmount err","i:",i)
            return false
        end
        goodsAmt=goodsAmt..goodsAmount[i]
        if i < #goodsAmount then
            goodsAmt=goodsAmt..","
        end
    end

    --获得收件人信息
    local userInfo=commonTool.getUserInfo(mysql,redis,userID)
    if userInfo == nil then
    	printE("SendCustomAwardEmail get user info fail",userID)
    	return false
    end

    --判断类型确定发送人
    local senderID=0
    local senderName="系统"
    local senderUN="glzp"
    typeID=tonumber(typeID)
    if typeID == h.emailType.Notice then
        senderID=0
        senderName="系统"
    elseif typeID == h.emailType.Award then
        senderID=0
        senderName="系统"
    elseif typeID == h.emailType.MatchAward then
        senderID=1
        senderName="赛事组委会"
    end

    local now=commonTool.sec2Date(os.time())

    --发送和过期时间，这个由调用函数的时间决定，不由emailinfo决定
    local sd=os.date("%Y-%m-%d",os.time())
    local ed=os.date("%Y-%m-%d",os.time() + tonumber(expireAwardTime)*24*3600)
    local istres=callDBService(mysql,"launchSQL",string.format([[insert into Email (title,content,userID,fromUserID,toUserID,sendTime,expireTime,stateID,infoID,typeID,goodsID,goodsAmount,fromNickName,toNickName,fromUserName,toUserName,readTime,originalTypeID) 
                        values ('%s','%s',%d,%d,%d,'%s','%s',%d,%d,%d,'%s','%s','%s','%s','%s','%s','%s 00:00:00',%d)]],
                        title,content,userID,senderID,userID,sd,ed,h.emailStateID.notRead,0,typeID,goodsTypeID,goodsAmt,senderName,userInfo.nickName,senderUN,userInfo.userName,now,typeID))
    --刚插入的ID
    if istres == nil then
        printE("SendCustomAwardEmail : istres is nil",userID,title)
        return false
    end
    if istres.badresult == true then
        printE("SendCustomAwardEmail : insert email fail",istres.err)
        return false
    end

    istres=istres.insert_id
    --判断玩家是否在线
    --将数据关联到Email的Set中
    local uif=callRedis(redis,"GetHash","User:"..userID)
    if uif ~= nil then
        callRedis(redis,"SetHash","Email:"..istres,{ID=istres,title=title,content=content,userID=userID,fromUserID=senderID,toUserID=userID,sendTime=sd,expireTime=ed,stateID=h.emailStateID.notRead,infoID=0,typeID=typeID,fromNickName=senderName,toNickName=uif.nickName,goodsID=goodsTypeID,goodsAmount=goodsAmt,fromUserName=senderUN,toUserName=uif.userName})
        callRedis(redis,"AddSet","User:"..commonTool.userID_emailIDs..":"..userID,{istres})
    end
    return true
end

--[[*****************************************************************************
--发送一条自定义奖励邮件
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--redis：       redis数据库     通常是allServerList.redisServerList[1]
--userID        int             拥有该邮件的用户ID
--title         string          标题
--content       string          内容
--award       table           奖励{goodsID=goodsAmount}
--expireAwardTime int           奖励过期时间，单位，天
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendAwardEmail(mysql,redis,userID,title,content,award,expireAwardTime,typeID)
    if mysql == nil or redis == nil or userID == nil or title == nil or content == nil or award == nil or expireAwardTime == nil or typeID == nil then
        printE("SendCustomAwardEmail : args is nil",mysql,redis,userID,title,content,award,expireAwardTime,typeID)
        return false
    end
    if type(award) ~= "table" then
        printE("SendCustomAwardEmail : goodsID or goodsAmount is not table type",type(award))
    end
    
    local goodsID={}
    local goodsAmount={}
    local count=1
    for k,v in pairs(award) do
    	goodsID[count]=tonumber(k)
    	goodsAmount[count]=tonumber(v)
    	count=count+1
    end

    return commonTool.SendCustomAwardEmail(mysql,redis,userID,title,content,goodsID,goodsAmount,expireAwardTime,typeID)
end

--[[*****************************************************************************
--发送一条公告邮件
--mysql：       MySql数据库     通常是allServerList.dbServerList[1]
--redis：       redis数据库     通常是allServerList.redisServerList[1]
--userID        int             拥有该邮件的用户ID
--infoID        int             EmailInfo的UD
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendNoticeEmail(mysql,redis,userID,title,content)
    if userID == nil or mysql == nil or redis == nil or title == nil or content == nil then
        printE("SendNoticeEmail : args error : ","userID:",userID,mysql,redis,title,content)
        return false
    end

    --获得收件人信息
    local userInfo=commonTool.getUserInfo(mysql,redis,userID)
    if userInfo == nil then
    	printE("SendNoticeEmail get user info fail",userID)
    	return false
    end
    local now=commonTool.sec2Date(os.time())
    local sd=os.date("%Y-%m-%d",os.time())
    local ed=os.date("%Y-%m-%d",os.time() + tonumber(commonTool.emailExpireTime)*24*3600)
    local istres=callDBService(mysql,"launchSQL",string.format([[insert into Email (title,content,userID,fromUserID,toUserID,sendTime,expireTime,stateID,infoID,typeID,fromNickName,toNickName,fromUserName,toUserName,readTime,originalTypeID) 
                        values ('%s','%s',%d,%d,%d,'%s','%s',%d,%d,%d,'%s','%s','%s','%s','%s 00:00:00',%d)]],
                        title,content,userID,0,userID,sd,ed,h.emailStateID.notRead,0,h.emailType.Notice,"系统",userInfo.nickName,"glzp",userInfo.userName,now,h.emailType.Notice))
    --刚插入的ID
    if istres == nil or istres.badresult == true then
        printE("SendNoticeEmail : insert email fail",istres.err)
        return false
    end

    istres=istres.insert_id
    
    --判断玩家是否在线
    --将数据关联到Email的Set中
    local uif=callRedis(redis,"GetHash","User:"..userID)
    if uif ~= nil then
        callRedis(redis,"SetHash","Email:"..istres,{ID=istres,title=title,content=content,userID=userID,fromUserID=0,toUserID=userID,sendTime=sd,expireTime=ed,stateID=h.emailStateID.notRead,infoID=0,typeID=h.emailType.Notice,fromNickName="系统",toNickName=uif.nickName,fromUserName="glzp",toUserName=uif.userName})
        callRedis(redis,"AddSet","User:"..commonTool.userID_emailIDs..":"..userID,{istres})
    end
    
    return true
end

--[[*****************************************************************************
--发送一条历史邮件
eg:
奖励邮件
emails={
	[1]=
	{
		goodsID="0,105",        --道具ID
		goodsAmount="100,10",	--道具数量，位置要与ID相对应
		userInfo={				--收件人信息
			userID=4001,
			userName="robot1",
			nickName="robot1"
		},
		title="标题",
		content="内容",
		expireTime=h.emailExpireTime,
		typeID=h.emailType.Award,
		sender={				--发件人信息
			userID=0,
			userName="glzp",
			nickName="系统"
		}
	}
}

公告邮件
emails={
	[1]=
	{
		goodsID="",
		goodsAmount="",
		userInfo={				--收件人信息
			userID=4001,
			userName="robot1",
			nickName="robot1"
		},
		title="标题",
		content="内容",
		expireTime=h.emailExpireTime,
		typeID=h.emailType.Notice,
		sender={				--发件人信息
			userID=0,
			userName="glzp",
			nickName="系统"
		}
	}
}
--返回值        bool            成功或失败
******************************************************************************]]
function commonTool.SendHistoryEmail(mysql,redis,emails)
    if redis == nil or emails == nil or mysql == nil or #emails == 0 then
		printE("SendHistoryEmail : args is nil",mysql,redis,emails)
		return false
	end

	local sd=os.date("%Y-%m-%d",os.time())
	local data={}
    local now=commonTool.sec2Date(os.time())
    local uid=0
	for k,v in pairs(emails) do
		--检查奖励
		if v.userInfo ~= nil then
			local gids=v.goodsID
			local gamt=v.goodsAmount
			local ed=os.date("%Y-%m-%d",os.time() + tonumber(v.expireTime)*24*3600)
			local sql=string.format("insert into HistoryEmail (title,content,userID,fromUserID,toUserID,sendTime,expireTime,stateID,infoID,typeID,goodsID,goodsAmount,fromNickName,toNickName,fromUserName,toUserName,readTime,originalTypeID) values ('%s','%s',%d,%d,%d,'%s','%s',%d,%d,%d,'%s','%s','%s','%s','%s','%s','%s 00:00:00',%d)",
									v.title,v.content,v.userInfo.userID,v.sender.userID,v.userInfo.userID,
									sd,ed,h.emailStateID.notRead,0,v.typeID,gids,gamt,
									v.sender.nickName,v.userInfo.nickName,v.sender.userName,v.userInfo.userName,
									now,v.typeID)
			local ist=callDBService(mysql,"launchSQL",sql)
			if commonTool.dbSafeCheck(ist) == true then
				ist=tonumber(ist.insert_id)
				uid=v.userInfo.userID or 0
				table.insert(data,{
					ID=ist or 0,
					title=tostring(v.title),
					sendTime=tostring(sd),
					expireTime=tostring(ed),
					fromNickName=tostring(v.sender.nickName),
					toNickName=tostring(v.userInfo.nickName),
					stateID=h.emailStateID.notRead or h.emailStateID.notRead,
					typeID=v.typeID or h.emailType.Notice,
					readTime=tostring(sd).." 00:00:00",
					content=tostring(v.content)
				})
			end
		end
	end

	--通知客户端
	commonTool.callPlayerFunction(redis,"send2Client",uid,"sendEmailToUser",data,h.enumKeyAction.SEND_EMAIL_TO_USER)

	return true
end

--[[*****************************************************************************
--发送未读邮件数给用户，暂时没用
******************************************************************************]]
function commonTool.sendNeverReadEmailAmount(mysql,redis,userID)

end

--[[*****************************************************************************
发送赠送房卡的邮件
emails[N]={
goodsID     string 		
goodsAmount string	
userInfo    table 			{userID,nickName,userName,newSpreader}
title 		string 			标题
content 	string 			内容
expireTime  int 			天
typeID      int 			邮件类型
sender 		table 			{userID,nickName,userName}赠送人
}
onlyDb     bool  是否只存db
******************************************************************************]]
function commonTool.sendRoomCardAwardEmail(mysql,redis,userInfo,onlyDb)
	if mysql == nil or userInfo == nil or onlyDb == nil or redis == nil then
		printE("sendRoomCardAwardEmailToDB args is nil",mysql,userInfo,onlyDb,redis)
		return false
	end

	local cnf=ct.readFile("./conf/bindNewSpreaderConf.json")
    if ct.isStringEmpty(cnf) == true then
        printE("sendRoomCardAwardEmailToDB conf is nil",mysql,userInfo,onlyDb,redis)
        return false
    end
	cnf=commonTool.json2Table(cnf)
	if type(cnf) ~= "table" then
		printE("sendRoomCardAwardEmailToDB conf is err",mysql,userInfo,onlyDb,redis)
		return false
	end
	cnf=cnf.bindNewSpreaderConf

	if cnf == nil then
		printE("sendRoomCardAwardEmail can not get award conf",h.redisSystemKey.bindNewSpreaderAward,userInfo.userID)
		return true
	end
	local gids=""
	local gamt=""
	local curConf=""
	for k,v in pairs(cnf) do
		local sd=commonTool.date2Sec(v.startTime)
		local ed=commonTool.date2Sec(v.endTime)
		local itm=v.item or {}
		if sd <= os.time() and os.time() <= ed then
			for a,b in pairs(itm) do
				gids=gids..a..","
				gamt=gamt..b..","
			end
			curConf=k
			break
		end
	end

	if commonTool.isStringEmpty(gids) == true or commonTool.isStringEmpty(gamt) == true or commonTool.isStringEmpty(curConf) == true then
		printE("sendRoomCardAwardEmail award empty",userInfo.userID)
		return true
	end

	gids=commonTool.cutStringLast(gids)
	gamt=commonTool.cutStringLast(gamt)

	if cnf[curConf] == nil then
		printE("sendRoomCardAwardEmail can not get email conf",curConf)
		cnf[curConf]={}
	end
	local text=cnf[curConf].email
	if commonTool.isStringEmpty(text) == true then
		printE("sendRoomCardAwardEmail email conf is nil",h.redisSystemKey.bindNewSpreaderEmail,userInfo.userID)
		text="您是我们推广员*的特邀用户，请查收您的奖励。"
	end

	--替换文本
	text=string.gsub(text,"*","("..tostring(userInfo.newSpreader)..")")

	local email={[1]={
 					goodsID=gids,
 					goodsAmount=gamt,
 					userInfo={userName=userInfo.userName,nickName=userInfo.nickName,userID=userInfo.userID},
 					title=h.paySpecialEmail.roomCard.title,
 					content=text,
 					expireTime=h.emailExpireTime,
 					typeID=h.emailType.Award,
 					sender={userID=0,nickName="系统",userName="czzp"}
 				}}

 	if onlyDb == false then
 		commonTool.SendSomeEmails(mysql,redis,email)
 		commonTool.sendNotReadEmailToPlayer(userInfo,redis)
 	else
 		commonTool.SendSomeEmailsToDB(mysql,email)
 	end

	return true
end

--[[*****************************************************************************
查询用户是否认证了手机
******************************************************************************]]
function commonTool.getUserAuthPhone(userID,token)
	if userID == nil or token == nil or token == "" then
		printE("getUserAuthPhone : args is nil",userID,token)
		return ""
	end

	local httpc = require "http_lk.lkhttpc"
    local header = { }
    local args = { }
    args.Token = token

    local status, body = httpc.post("api.lkgame.com", "/User/GetUserBindInfo", args, header)
    if body == nil or body == "" then
        printE("getUserAuthPhone : http post user info from LK fail",userID,token,status)
        return ""
    end
    if status ~= 200 then
        printE("getUserAuthPhone : status ~= 200:", userID,token,status,body)
        return ""
    end
    local val,ok = commonTool.DecodeLKJson(body)
    
    if val == nil then
        printE("getUserAuthPhone : val is nil",userID,ok.RetCode,ok.RetMsg,token)
        return ""
    end
    --未认证
    if val.AuthMobileNo == nil or val.AuthMobileNo == "" then
    	return ""
    end

    return tostring(val.AuthMobileNo)
end
--------------------------------------------------------------------End 黄祥瑞 2015.10.09-------------------------------------------------


--[[*****************************************************************************
功能描述：获取系统日期和时间
参数：无
作者：mingyuan.xie
时间：2015.10.1
*********************************************************************************]]
function commonTool.getTime()
	local tabTime = os.date("*t",time)
	local formatTime = ""
	local format = "-"
	formatTime = formatTime.."["..tabTime.year..format..tabTime.month..format..tabTime.day.." "..tabTime.hour..":"..tabTime.min..":"..tabTime.sec.."]"
	return formatTime
end

--[[*****************************************************************************
功能描述：获取系统日期
参数：无
作者：mingyuan.xie
时间：2015.10.1
*********************************************************************************]]
function commonTool.getDate()
	local tabTime = os.date("*t",time)
	local formatDate = ""
	local format = "-"
	formatDate = formatTime.."["..tabTime.year..format..tabTime.month..format..tabTime.day"]"
	return formatDate
end

--[[*****************************************************************************
功能描述：获取系统日期和时间
参数：无
作者：mingyuan.xie
时间：2015.10.1
*********************************************************************************]]
function commonTool.getTimeRaw()
	local tabTime = os.date("*t",time)
	local formatTime = ""
	local format = "-"
	formatTime = formatTime..tabTime.year..format..tabTime.month..format..tabTime.day.." "..tabTime.hour..":"..tabTime.min..":"..tabTime.sec
	return formatTime
end

--[[*****************************************************************************
功能描述：写日志
参数说明：1、fileName:文件名;  2、日志内容
作者：mingyuan.xie
时间：2015.10.9
*********************************************************************************]]
function commonTool.writeLog(fileName, ...)
	if "string" ~= type(fileName) then
		print("  ERROR writeLog: fileName is not string.")
		return
	end
    local path = "./log/"..fileName..".log"
    local f = io.open(path, "a+")
    if f then
        local logHead = "\n"
        --logHead = logHead .. "[".. skynet.getenv("name") .."]"..commonTool.getTime()
        f:write(logHead,...)
        f:close()
    end
end

--[[*****************************************************************************
功能描述：写消息日志 模式为w+ 换行符
参数说明：1、fileName:文件名;  2、日志内容
作者：guanying
时间：2016.12.14
*********************************************************************************]]
function commonTool.writeMsgLog(fileName, ...)
	if "string" ~= type(fileName) then
		print("  ERROR writeLog: fileName is not string.")
		return
	end
    local path = "./log/"..fileName..".log"
    local f = io.open(path, "w+")
    if f then
        f:write(...)
        f:flush()
        f:close()
    end
end
--[[*****************************************************************************
记录redis日志
*********************************************************************************]]
function commonTool.writeRedisLog(fileName,...)
	fileName=tostring(fileName)
	local name=os.date("_command%Y-%m-%d_%H",os.time())
	local args={...}
	local str="["..commonTool.sec2Date(os.time()).."]   "
	for k,v in pairs(args) do
		str=str.."   "..tostring(v)
	end
    local path = "./log/redis/"..fileName..tostring(name)..".log"
    local f = io.open(path, "a+")
    if f then
        local logHead = "\n"
        --logHead = logHead .. "[".. skynet.getenv("name") .."]"..commonTool.getTime()
        f:write(logHead,str)
        f:close()
    end
end


--[[*****************************************************************************
记录redis日志
*********************************************************************************]]
function commonTool.writeDbLog(fileName,...)
	fileName=tostring(fileName)
	local name=os.date("_command%Y-%m-%d_%H",os.time())
	local args={...}
	local str="["..commonTool.sec2Date(os.time()).."]   "
	for k,v in pairs(args) do
		str=str.."   "..tostring(v)
	end
    local path = "./log/db/"..fileName..tostring(name)..".log"
    local f = io.open(path, "a+")
    if f then
        local logHead = "\n"
        --logHead = logHead .. "[".. skynet.getenv("name") .."]"..commonTool.getTime()
        f:write(logHead,str)
        f:close()
    end
end

--[[*****************************************************************************
功能描述：校验是否能够继续留在本倍率房间
参数：goldCoin：玩家持有的金币
作者：mingyuan.xie
时间：2015.10.20
*********************************************************************************]]
function commonTool.stayRoomCheck(goldCoin, rate)
	local downCoin = commonTool.getRateCoin_Down(rate)
	local upCoin = commonTool.getRateCoin_Up(rate)
	if goldCoin < downCoin or upCoin < goldCoin then
		--金币越界
		return false
	else
		--金币正常，留在本房间
		return true
	end
end

-- 发送网络消息, 支持服务间和节点间
-- @param cmd 网络消息命令, messageForPlayers 和 sendSysNotice
-- @param ... cmd 不同传入的参数也不相同, 详细的描述请查看 lobby_message_helper.lua 文件
-- @return 对应命令的返回值
-- @author Zhenyu Yao
function commonTool.sendNetMessage(lobbyList, cmd, conf, userIds)
    skynet.fork(function()
        for _, v in pairs(lobbyList) do
    	   cluster.call(v.serverName, ".netmessage", "handleNetMessage", cmd, conf, userIds)
        end
    end)
end

-- 客户端刷新金币/道具的数量
-- @param userID 用户 ID
-- @param itemId 道具的 ID
-- @return true 成功, false 失败
-- @author Zhenyu Yao
function commonTool.flushItem(userID, itemId)
	return cluster.call(commonTool.secServiceName.lobby, ".lobby_self", "callPlayerFunction", "flushGoods", userID, userID, itemId)
end

-- 客户端刷新金币/道具的数量
-- @param userID 用户 ID
-- @param itemId 道具的 ID
-- @param userGoodsId 道具的 ID
-- @return true 成功, false 失败
-- @author Zhenyu Yao
function commonTool.flushItemWithUserGoodsId(userID, itemId,userGoodsId)
	return cluster.call(commonTool.secServiceName.lobby, ".lobby_self", "callPlayerFunction", "flushGoodsWithUserGoodsID", userID, userID, itemId,userGoodsId)
end

--------------------------Begin: 队列模板-------------------------------
local Queue={}
function Queue.new(maxLen)
	if nil ~= maxLen and "number" == type(maxLen) and maxLen > 0 then
		return {first = 0, last = -1, maxLen = maxLen}
	else
		return {first = 0, last = -1}
	end
end

----向队列尾添加元素
function Queue.push_last(queue, value)
	if (queue.last - queue.first + 1) > queue.maxLen then
		--队列满
		return -1
	end

	local last = queue.last + 1
	queue.last = last
	queue[last] = value
	return 0
end
----弹出队列头
function Queue.pop_first(queue)
	local first = queue.first
	if first > queue.last then
		--队列空
		return nil
	end

	local value = queue[first]
	queue[first] = nil
	queue.first = first + 1
	return value
end

function Queue.isEmpty(queue)
	if queue.first > queue.last then
		--队列空
		return true
	end
	return false
end

function Queue.isFull(queue)
	if nil == queue.maxLen then
		return false
	end
	
	if (queue.last - queue.first + 1) > queue.maxLen then
		--队列满
		return true
	end
	return false
end

function Queue.getLen(queue)
	return queue.last - queue.first + 1
end

function Queue.getMaxLen(queue)
	return queue.maxLen
end

function Queue.setMaxLen(queue, maxLen)
	queue.maxLen = maxLen
end

commonTool.Queue = Queue
--------------------------End : 队列模板-------------------------------


--[[*****************************************************************************
功能描述：时间对应的基础在线人数范围
参数：
作者：mingyuan.xie
时间：2015.11.23
*********************************************************************************]]
function commonTool.onlineTimeScope(hour)
	if 0 <= hour and hour < 2 then
		return 100, 150
	elseif 2 <= hour and hour < 9 then
		return 0, 50
	elseif 9 <= hour and hour < 12 then
		return 50, 100
	elseif 12 <= hour and hour < 18 then
		return 100, 150
	elseif 18 <= hour and hour < 23 then
		return 150, 200
	else
		return 125, 135
	end
end

--[[*****************************************************************************
功能描述：获取在线人数基数
参数：
作者：mingyuan.xie
时间：2015.11.23
*********************************************************************************]]
function commonTool.getOnlineBase()
	local tabTime = os.date("*t",time)
	local scopeMin, scopeMax = commonTool.onlineTimeScope(tabTime.hour)
	
	return math.random(scopeMin, scopeMax)
end

--[[*****************************************************************************
功能描述：比较时间
参数：time1,time2   格式 os.date("%Y-%m-%d %H:%M:%S", os.time()) 
作者：guanying
返回：true : time1 > time2    false : time1 <= time2 
*********************************************************************************]]
function commonTool.compareTimes(time1,time2)
	
	local y1,mon1,d1 = string.match(time1,"(%d+)-(%d+)-(%d+)")
	local h1,m1,s1 = string.match(time1,"(%d+):(%d+):(%d+)")

	local y2,mon2,d2 = string.match(time2,"(%d+)-(%d+)-(%d+)")
	local h2,m2,s2 = string.match(time2,"(%d+):(%d+):(%d+)")
	
	local temp1 = os.time({year = y1, month = mon1, day = d1, hour = h1, min = m1, sec = s1})
	local temp2 = os.time({year = y2, month = mon2, day = d2, hour = h2, min = m2, sec = s2})
	
	return temp1 > temp2
end

--[[*****************************************************************************
创建伪随机的玩家编号
*********************************************************************************]]
function commonTool.getFakeRandomUserCode(userID)
	local bitlen=26
	local bit={data={}}
	for i=1,bitlen do
	    bit.data[i]=2^(bitlen-i)
	end

	function bit:d2b(arg)
	    local tr={}
	    for i=1,bitlen do
	        if arg >= self.data[i] then
	        tr[i]=1
	        arg=arg-self.data[i]
	        else
	        tr[i]=0
	        end
	    end
	    return   tr
	end   --bit:d2b

	function bit:b2d(arg)
	    local   nr=0
	    for i=1,bitlen do
	        if arg[i] ==1 then
	        nr=nr+2^(bitlen-i)
	        end
	    end
	    return  nr
	end   --bit:b2d

	function bit:_xor(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if op1[i]==op2[i] then
	            r[i]=0
	        else
	            r[i]=1
	        end
	    end
	    return  self:b2d(r)
	end --bit:xor

	function bit:_and(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if op1[i]==1 and op2[i]==1  then
	            r[i]=1
	        else
	            r[i]=0
	        end
	    end
	    return  self:b2d(r)

	end --bit:_and

	function bit:_or(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if  op1[i]==1 or   op2[i]==1   then
	            r[i]=1
	        else
	            r[i]=0
	        end
	    end
	    return  self:b2d(r)
	end --bit:_or

	function bit:_not(a)
	    local   op1=self:d2b(a)
	    local   r={}

	    for i=1,bitlen do
	        if  op1[i]==1   then
	            r[i]=0
	        else
	            r[i]=1
	        end
	    end
	    return  self:b2d(r)
	end --bit:_not

	function bit:_rshift(a,n)
	    local   op1=self:d2b(a)
	    local   r=self:d2b(0)

	    if n < bitlen and n > 0 then
	        for i=1,n do
	            for i=31,1,-1 do
	                op1[i+1]=op1[i]
	            end
	            op1[1]=0
	        end
	    r=op1
	    end
	    return  self:b2d(r)
	end --bit:_rshift

	function bit:_lshift(a,n)
	    local   op1=self:d2b(a)
	    local   r=self:d2b(0)

	    if n < bitlen and n > 0 then
	        for i=1,n   do
	            for i=1,31 do
	                op1[i]=op1[i+1]
	            end
	            op1[bitlen]=0
	        end
	    r=op1
	    end
	    return self:b2d(r)
	end --bit:_lshift


	function bit:print(ta)
	    local   sr=""
	    for i=1,bitlen do
	        sr=sr..ta[i]
	    end
	    print(sr)
	end

	function bit:toStr(ta)
	    local   sr=""
	    for i=1,bitlen,1 do
	        sr=sr..ta[i]
	    end
	    return sr
	end

	function bit:reverseTable(tab)
		local rand={26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1}
		local tmp = {}
		for i = 1, #rand,1 do
			local key = rand[i]
			tmp[i] = tab[key]
		end

		return tmp
	end

	local bs=bit:d2b(tonumber(userID))
	local arr=bit:reverseTable(bs)
	return math.floor(tonumber(bit:b2d(arr))+10000000)--凑齐8为数
end

--[[*****************************************************************************
根据伪随机号推算出userID
*********************************************************************************]]
function commonTool.getUserIDByCode(code)
	local bitlen=26
	local bit={data={}}
	for i=1,bitlen do
	    bit.data[i]=2^(bitlen-i)
	end

	function bit:d2b(arg)
	    local tr={}
	    for i=1,bitlen do
	        if arg >= self.data[i] then
	        tr[i]=1
	        arg=arg-self.data[i]
	        else
	        tr[i]=0
	        end
	    end
	    return   tr
	end   --bit:d2b

	function bit:b2d(arg)
	    local   nr=0
	    for i=1,bitlen do
	        if arg[i] ==1 then
	        nr=nr+2^(bitlen-i)
	        end
	    end
	    return  nr
	end   --bit:b2d

	function bit:_xor(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if op1[i]==op2[i] then
	            r[i]=0
	        else
	            r[i]=1
	        end
	    end
	    return  self:b2d(r)
	end --bit:xor

	function bit:_and(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if op1[i]==1 and op2[i]==1  then
	            r[i]=1
	        else
	            r[i]=0
	        end
	    end
	    return  self:b2d(r)

	end --bit:_and

	function bit:_or(a,b)
	    local   op1=self:d2b(a)
	    local   op2=self:d2b(b)
	    local   r={}

	    for i=1,bitlen do
	        if  op1[i]==1 or   op2[i]==1   then
	            r[i]=1
	        else
	            r[i]=0
	        end
	    end
	    return  self:b2d(r)
	end --bit:_or

	function bit:_not(a)
	    local   op1=self:d2b(a)
	    local   r={}

	    for i=1,bitlen do
	        if  op1[i]==1   then
	            r[i]=0
	        else
	            r[i]=1
	        end
	    end
	    return  self:b2d(r)
	end --bit:_not

	function bit:_rshift(a,n)
	    local   op1=self:d2b(a)
	    local   r=self:d2b(0)

	    if n < bitlen and n > 0 then
	        for i=1,n do
	            for i=31,1,-1 do
	                op1[i+1]=op1[i]
	            end
	            op1[1]=0
	        end
	    r=op1
	    end
	    return  self:b2d(r)
	end --bit:_rshift

	function bit:_lshift(a,n)
	    local   op1=self:d2b(a)
	    local   r=self:d2b(0)

	    if n < bitlen and n > 0 then
	        for i=1,n   do
	            for i=1,31 do
	                op1[i]=op1[i+1]
	            end
	            op1[bitlen]=0
	        end
	    r=op1
	    end
	    return self:b2d(r)
	end --bit:_lshift


	function bit:print(ta)
	    local   sr=""
	    for i=1,bitlen do
	        sr=sr..ta[i]
	    end
	    print(sr)
	end

	function bit:toStr(ta)
	    local   sr=""
	    for i=1,bitlen,1 do
	        sr=sr..ta[i]
	    end
	    return sr
	end

	function bit:reverseTable(tab)
		local rand={26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1}
		local tmp = {}
		for i = 1, #rand,1 do
			local key = rand[i]
			tmp[i] = tab[key]
		end

		return tmp
	end

	local bs=bit:d2b(tonumber(code-10000000))
	local arr=bit:reverseTable(bs)
	return math.floor(tonumber(bit:b2d(arr)))
end

--[[
转utf8
]]
function commonTool.convertUtf8(str)
	local function tail(n, k)
		local u, r=''
		for i=1,k do
		n,r = math.floor(n/0x40), n%0x40
		u = string.char(r+0x80) .. u
		end
		return u, n
	end

	local function to_utf8(a)
		local n, r, u = tonumber(a)
		if n<0x80 then                        -- 1 byte
			return string.char(n)
		elseif n<0x800 then                   -- 2 byte
			u, n = tail(n, 1)
			return string.char(n+0xc0) .. u
		elseif n<0x10000 then                 -- 3 byte
			u, n = tail(n, 2)
			return string.char(n+0xe0) .. u
		elseif n<0x200000 then                -- 4 byte
			u, n = tail(n, 3)
			return string.char(n+0xf0) .. u
		elseif n<0x4000000 then               -- 5 byte
			u, n = tail(n, 4)
			return string.char(n+0xf8) .. u
		else                                  -- 6 byte
			u, n = tail(n, 5)
			return string.char(n+0xfc) .. u
		end
	end
	

	return string.gsub(str, '&#(%d+);', to_utf8)
end

--获得utf8长度
function commonTool.getUtf8Len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

--是否包含中文
function commonTool.hasChinese(str)
	if str == nil then
		return false
	end
	str=tostring(str)
	local len = commonTool.getUtf8Len(str)
	--判断是否全部为中文
    for i=1,#str,1 do
        local tmp = string.byte(str, i)
        if tmp < 240 and tmp >= 224 then
            return true
        end
    end
    return false
end

function commonTool.checkChineseName(str)
	if str == nil then
		return false
	end
	str=tostring(str)

	local len = commonTool.getUtf8Len(str)
    if len <= 1 or len > 6 then
        return false
    end

    if #str > 0 and #str/3%1 == 0 then
        --判断是否全部为中文
        for i=1,#str,3 do
            local tmp = string.byte(str, i)
            print(" ----   ----",tmp)--230
            if tmp >= 240 or tmp < 224 then
                return false
            end
        end
        --判断中文中是否有中文标点符号
        for i=1,#str,3 do
            local tmp1 = string.byte(str, i)
            local tmp2 = string.byte(str, i+1)
            local tmp3 = string.byte(str, i+2)
            print("mp1,mp2,mp3",tmp1,tmp2,tmp3)
            --228 184 128 -- 233 191 191
            if tmp1 < 228 or tmp1 > 233 then
                return false
            elseif tmp1 == 228 then
                if tmp2 < 184 then
                    return false
                elseif tmp2 == 184 then
                    if tmp3 < 128 then
                        return false
                    end
                end
            elseif tmp1 == 233 then
                if tmp2 > 191 then
                    return false
                elseif tmp2 == 191 then
                    if tmp3 >191 then
                        return false
                    end
                end            
            end
        end
        return true
    end
    return false
end

--[[*****************************************************************************
功能描述：读取外部json文件
参数：path 文件路径
作者：guanying
返回：jsonData or nil 
*********************************************************************************]]
function commonTool.readJsonFile(path)

	if "string" ~= type(path) then
		printE("ERROR writeLog: fileName is not string.")
		return
	end
  	
    local f = io.open(path,"r")
    if f then
        local t = f:read( "*all" )
        --printE("-----> ",t)
        if nil ~= t and "" ~= t then
            local ok ,jsonData = pcall(json.decode,t)
            if not ok or not jsonData then
                printE("Json decode error")
            else
            	f:close()
            	return jsonData
            end
        else
            printE("empty file :",path)
        end
        f:close()
    else
    	printE("can not find this file ",path)
    end
end
--[[
判断是否是手机号
]]
function commonTool.checkPhone(phone)
	if phone == nil then
		printE("checkPhone phone is nil",phone)
		return false
	end

	return string.match(phone,"[1][3,4,5,6,7,8,9]%d%d%d%d%d%d%d%d%d") == tostring(phone)
end

--[[
生成指定长度的随机验证码
]]
function commonTool.getRandomAuthCode(len)
	len=tonumber(len)
	return math.random(1,9)..commonTool.getRandomNumString(len-1)--保证开头不为0
end

--[[
读取常规配置文件
conf table out 服务的通常配置表，用于接收读取的配置
]]
function commonTool.readDataFromJsonFile(filePath)
	local data=commonTool.readFile(filePath)
	if commonTool.isStringEmpty(data) == false then
		data=commonTool.json2Table(data)
		if type(data) == "table" then
			return data
		end
	end
	return nil
end

--[[
dump obj
]]
 
function commonTool.dumpObj(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 99 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    --local traceback = string.split(debug.traceback("", 2), "\n")
    --print("dump from: " .. string.trim(traceback[3]))

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)
    local strss=""
    for i, line in ipairs(result) do
       printE("dumpObj ",line)
    end
    return strss
end

      ------------------ 抽奖逻辑 -----------------
--conf ={ID , 编号 , rate 权重，正数}
--ID
function commonTool.raffFun(conf)
	-- 待加上对table的校验
	if #conf == 0 then
		return  nil
	end
        math.randomseed(tostring(os.time()):reverse():sub(1, 7))
        local totals = 0
        for k1,v1 in pairs(conf) do
            totals = totals + v1.rate
        end 

        if totals == 0 then
                printE("totals = 0 没有配置对应抽奖概率")
            return -1
        end

       local p =math.random(1,totals)
         --print("p ".. p)
         
        local goodsIDChoosed = conf[1].ID
           for k,v in pairs(conf) do
               p = p - v.rate 
               if p <= 0 then -- 属于该阶段
                 goodsIDChoosed = v.ID
                 printE("raffFun ID ",v.ID)
                 break
                end 
            end
        return goodsIDChoosed    
end 

    -- 转换成数组
  function commonTool.convertString2IntegerArray(cardsString)
    local cards = commonTool.splitString(cardsString,",")
         
    local putList = {}
    for i,v in ipairs(cards) do
        table.insert(putList,math.tointeger(v) )
        end
    return putList
end


--[[
   从redis中获取，如果不存在才进数据库查找 --2017.2.16-3 kf.qin 签到功能
  @param key: key
  @param sql: sql
--]]
 function commonTool.readFromRedisOrMysql(mysql,redis,key,sql) 
    -- 加入判断      
    local activitys={}
    local activitysInRedis=callRedis(redis,"GetHash1",key)
    if activitysInRedis == nil then
         printE("read from sql",key)

        activitys=callDBService(mysql,"launchSQL",sql)

        --printE("#activitys =    ",#activitys)

        for i=1,#activitys do
            local activitys2Store={}
            
            for key,value in pairs(activitys[i]) do
                activitys2Store[key]=value             
            end
            
            callRedis(redis,"SetHash1",key..":"..i,activitys2Store)
        end
        callRedis(redis,"SetHash1",key,{amount=tostring(#activitys)})
        
    else
        printE("read from redis  InRedis.amount = ",activitysInRedis.amount)
        for i=1, activitysInRedis.amount do
            local activitys2Get=callRedis(redis,"GetHash1",key..":"..i)
            if   activitys2Get ~= nil then
                for key,value in pairs(activitys2Get) do
                    --printE("read from redis key activity ",key,value)
                    --activitys2Get[key]=value
                    activitys[i]=activitys2Get
                end
            else
                --printE("  activitys2Get = ",activitys2Get)
            end           
            
        end
        --activitys[1] =  {ID=tonumber(activitysInRedis.ID),activityName=activitysInRedis.activityName,
        --    type=tonumber(activitysInRedis.type) ,startTimeUnix=tonumber(activitysInRedis.startTimeUnix)}
    end
    return activitys
end 


function commonTool.store2redis(mysql,redis,key,obj)

    if  type(obj) == "table" then
        for i=1,#obj do
            local obj2Store={}
            
            for key,value in pairs(obj[i]) do
                obj2Store[key]=value             
            end
            --obj[i]=obj2Store
            callRedis(redis,"SetHash1",key..":"..i,obj2Store)
        end
        callRedis(redis,"SetHash1",key,{amount=tostring(#obj)})
    else
        local obj2Store={}
        for key,value in pairs(obj) do
                obj2Store[key]=value             
        end
        callRedis(redis,"SetHash1",key,obj2Store)
    end
    
end


-- 反转table
function commonTool.tableReverse ( list )
  local tp = {}
  local index = 1
    for i=#list,0,-1 do
      tp[index] = list[i]
      index = index + 1
    end
   return tp
end

--读取luckyCards配置
--	"use" : "1",        	     
--	"useTimesLimit" : "50"  
function commonTool.readLCConf()
	local lukyCardsConf =  commonTool.json2Table(commonTool.readFile("./bin/new_room_self/config/config_new_room_self_luckycards_json.json"))
	local conf = {}
	if  lukyCardsConf.use and tonumber(lukyCardsConf.use) == 1 then 
		conf.luckyCardUse = true
	else
		conf.luckyCardUse = false 
	end
	 --启用好牌的个人输赢子的底线，比如是-50，则表示输赢积分少于-50则可能给他派发好牌
	if  lukyCardsConf.playerSorceBaseLine then
		conf.playerSorceBaseLine = tonumber(lukyCardsConf.playerSorceBaseLine) or -50
	end
	--录为好牌的最多的底牌数量不能少于该值（1-20之间），比如15表示，底牌大于15张则可以录入否
	if  lukyCardsConf.playerSorceUnderCardsLimit then
		conf.playerSorceUnderCardsLimit = tonumber(lukyCardsConf.playerSorceUnderCardsLimit) or 17
	end
	--获取好牌的概率，必须在1-100之间，不超过100
	if  lukyCardsConf.LuckyCardsRate then
		conf.LuckyCardsRate = tonumber(lukyCardsConf.LuckyCardsRate) or 70
	end 
	--存储好牌的限制
	if  lukyCardsConf.storeCardsLimit then
		conf.storeCardsLimit = tonumber(lukyCardsConf.storeCardsLimit) or 5000 
	end
	--开启好牌的条数限制
	if  lukyCardsConf.useCardsLimit then
		conf.useCardsLimit = tonumber(lukyCardsConf.useCardsLimit) or 5000 
	end

       --单副牌局的最多使用次数
	if  lukyCardsConf.useTimesLimit then
		conf.useTimesLimit = tonumber(lukyCardsConf.useTimesLimit) or 50
	end
	--
	if  lukyCardsConf.canRecord and tonumber(lukyCardsConf.canRecord) == 1 then 
		conf.canRecord = true
	else
		conf.canRecord = false 
	end 
  	if  lukyCardsConf.canUpdate and tonumber(lukyCardsConf.canUpdate) == 1 then 
		conf.canUpdate = true
	else
		conf.canUpdate = false 
	end

	return conf 
end



function commonTool.randomBool(current,max)
	if current <= 0 then
	 return false
	end
	 
	max = max or 100
	math.randomseed(tostring(os.time()):reverse():sub(1, 5))
	local p =math.random(1,max)
	if p <= current then
		return true
	else
		return false
	end
end

--[[********************************************************************
函数名：  containsKeyValue
功能描述：查询table是否包含指定的键值对
************************************************************************]]
function commonTool.containsKeyValue( table,key,value )
	local containsKey = false
    for i=1,#table do
    	local p1 = table[i]
    	if tostring(p1[key]) == tostring(value) then
    		containsKey = true
    		return containsKey,p1
    	end    	
    end
    return containsKey
end



function commonTool.valueJuege( obj,desc )
		desc = desc or ""
		if obj then
			printE("not nil ",desc,type(obj),obj)
		else			
			printE(" obj nil ",desc)
		end
end

 --读取表情配置
--	"use" : "1",        	     
function commonTool.readIEConf(path)
	path = path or "./bin/new_room_self/config/interactive_expression.json"
	local expConf =  commonTool.json2Table(commonTool.readFile(path))
	local conf = {}

	if expConf.use and tonumber(expConf.use) == 1 then 
		conf.use = true
	else
		conf.use = false 
	end
	  
	conf.expressions =  expConf.expressions

	return conf 
end

--续费局数选择排序
function commonTool.sortCountCost(countCost,gameCountSetSave,isClubDesk)    
	if not gameCountSetSave or not countCost then
		printE("gameCountSetSave or not countCost nil  ",gameCountSetSave ,"  ",countCost) 
		return
	end
	local countCost = commonTool.deepCopy(countCost)
	local index 
	for i,v in pairs(countCost) do 
		if v.count and v.count == gameCountSetSave then 
			index = i 
		end
	end
	if index then 
		local temp = table.remove(countCost,index)
		if isClubDesk then 
			countCost = {}
		end
		table.insert(countCost,1,temp)
		return countCost
	end
end



return commonTool
