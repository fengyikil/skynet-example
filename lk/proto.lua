local sprotoparser = require "sprotoparser"

local proto = {}
local niuniu_protoc2s = (require "niuniu_proto").c2s
local niuniu_protos2c = (require "niuniu_proto").s2c
local pdk_proto = require "pdk_proto"

proto.c2s = sprotoparser.parse ([[
.package {   
	type 0 : integer  
	session 1 : integer
}  

#道具与相关值信息  
.prop {
    seatIndex 0 : integer       #座位号
    userID 1: integer           #用户ID 
    propType 2 : integer        #道具类型
    propVal 3 : integer         #值
}      

#第三方信息
.thirdInfo {
    thirdAvatarID 0 : string                #第三方头像地址   
    thirdNickName 1 : string                #第三方昵称地址
    thirdSex 2 : string                     #普通用户性别，1为男性，2为女性  
    thirdPartUnionID 3 : string             #第三方平台的 ID 
    longitude 4 : string                    #经度
    latitude 5 : string                     #纬度
}

.gameRoomSerList {
    roomId 0 : integer
    rate 1 : integer
    onlineNumRate 2 : integer
    onlineNumMatch 3 : integer
    roomName 4 : string
}

.agentInfoSelfRoom {           
    seatIndex 0 : integer   #   1 到 3 
    nickName 1 : string     #   昵称
    level 2 : integer       #   等级
    goldCoin 3 : integer    #   金币
    avatarID 4 : integer    #   头像信息
    location 5 : string     #   位置信息
    winInfo 6 : integer     #   连胜信息  -1 为被终结  0 为无连胜  >0 为连胜次数
    automatic 7 : integer   #   是否掉线   1 为正常  2 为掉线
    thirdConf 8 : thirdInfo                 #   第三方信息
    dissoluteAction 9 : integer             #   解散时的动作  无动作为nil 
    continueAction 10 : integer             #   续费时的动作  无动作为nil           
    readyInfo 11 : integer                  #   准备状态      1 为准备，2 或 nil 为没准备
    userID 12 : integer                     #   userId
    isBlackTag 13 : integer                 #   是否有黑名单标示  1 为是 nil 为否
    code 14 : integer                       #   黑名单 ID
    isInBlackList 15 : integer              #   是否是获取方的黑名单用户  1 为是  nil 为否
    isNovice 16 : integer                   #   是否是新人 1 为 是 nil 为否

}


#----- Begin: huang xiang rui 定义用户信息 2015.10.21
#enumKeyAction:AUTH       enumEndPoint:LOGIN_SERVER
.userInfo{
	userID 0 : integer      #--用户ID
    nickName 1 : string     #--昵称
    level 2 : integer       #--等级
    exp 3 : integer         #--经验值
    goldCoin 4 : integer    #--金币
    userName 5 : string     #--用户名
    avatarID 6 : integer    #--角色形象ID  huang xiang rui 2015.10.14
    point    7 : integer    #积分
    pointItemID 8 : integer #积分类道具ID
    pointItemAmount 9 : integer #积分类道具数量
    expRate 10 : integer    #--经验值百分比
    code 11 : integer       #玩家编号
    isInBlackList 12 : integer  #是否是获取方的黑名单用户  1 为是  nil 为否
    headimgurl 13 : string      #头像地址
    thirdConf 14 : thirdInfo    #第三方信息
}
#----- End  : huang xiang rui 2015.10.21

#request extraData={
#    "weiXinData" : "xxxx" #微信用户信息的json字符串，询问客户端是否绑定LK账号，玩家做出选择后将服务器传的数据回传给服务器
#    "ifBindLk" : 1  #微信登录时，1为绑定老K账号，0为不绑定老K账号
#}

#response extraData={
#    "limit" : 0, #充值限制，1为限制，0为不限制
#    "minVersion" : {"version":"xxx.xx.xxx.xxx","newVsersion":"xxx.xxx.xxx.xxx"} #该设备允许登陆的最低版本号
#    "showRoomCard" : 0 #显示对战卡，1为显示，0为不显示
#    "weiXinData" : "xxxx" #微信用户信息的json字符串，未绑定微信，或者获取失败则为nil
#    "newSpreader" : "xxxx" #新私人场推广号，没有为空字符串
#    "spreader" : "xxx" #注册推广号，没有为空字符串
#}

auth 1 {
	request {
		userName 0 : string             #微信账号传unionID，没有传空字符串。360账号传access_token
		thirdToken 1 : string           #微信账号传code，没有传空字符串。360账号传access_token
		thirdPlatformID 2 : integer     #----- huang xiang rui 第三方ID 2015.10.03
        version 3 : string              #客户端版本号
        deviceID 4 : integer            #客户端设备ID  定义在head_file.deviceID
        extraData 5 : string            #额外信息（json字符串）目前只在询问是否绑定LK账号时不为nil，其他情况为nil
        timestamp 6 : integer            #时间戳
        spreader  7 : string            #绑定在安装包中的推广号，没有则为空字符串
        newSpreader 8 : string          #绑定在安装包中的新推广号，没有则为空字符串
        #wxInfo 9 : string               #客户端传来的微信信息，json字符串，没有为nil，通常传secret、appid
	}
	response {
		authResult 0 : integer
		token  1 : string
		gameRoomList 2 : gameRoomSerList
		userInfo_ 3 : userInfo  #----- huang xiang rui 用户信息 2015.09.30
        heartBeatTime 4 : integer   # 心跳间隔时间，单位:秒， huangxiangrui 2015.11.10
        extraData 5 : string        #额外信息（json字符串）
        headimgurl 6 : string       #头像地址
	}
}

enterRoom 2 {
	request {
		roomId 0 : integer
		token 1 : string
	}
	response {
		enterResult 0 : integer
		deskID 1 : integer
	}
}

# 请求回到比赛, Zhenyu Yao, 2015.12.24
comeBackGame 3 {
    request {
    }
    response {
        enterResult 0 : integer  # 结果, 0 正常, 非 0 错误码
        deskID 1 : integer  # 桌子 ID
        strData 2 : string  # 牌局数据
    }
}

.group {
        cardNum 0 : integer
    }

# Begin: mingyuan.xie added 2015.8.28 -----

leaveDesk 4 {
	request {
		deskID 0 : integer
	}
	response {
		result 0 : integer		# 返回状态, 0 是正常, 其他为非正常情况
		reason 1 : string		# 错误原因
	}
}

remainDesk 5 {
	request {
		deskID 0 : integer
		sessionCo 1 : integer
	}
	response {
		deskID 0 : integer		# -1 表示发生错误
        enterResult 1 : integer # 错误码
	}
}
# End  : mingyuan.xie added 2015.8.28 -----

#出牌
playCard 6 {
	request {
		cardId 0 : integer	
		msgTag 1 : integer
        deskID 2 : integer
	}
	response {
		isLegal 0 : integer       #出牌是否合法  
		cardId 1 : integer

	}
}

#请求点击的动作
requestAction 7 {
	request {
		actionId 0: integer
		details 1: *integer		#吃牌时的数据
		cardId 2: integer       #验证请求合法性时用
		msgTag 3 : integer	
        deskID 4 : integer 
	}
}

#牌局中刷新数据
refreshData 8 {
    request {
    }
    response {
        strData 0 : string  # 牌局数据
    }
}

# Begin: huang xiang rui added 2015.10.21 -----
#救济金
#暂时没用
relieve 40 {
    request {
		goldCoin 0 : integer    #--玩家奖励后的金币
        msg 1 : string          #--客户端需要显示的文字
	}
} 
# End: huang xiang rui added 2015.10.21 -----

# Begin: mingyuan.xie added 2015.10.10 -----
heartbeatReply 50 {
	request {
		userID 0 : integer  # mingyuan.xie agentID -> userID 2015.10.12
	}
    response {
        userID 0 : integer
    }
}
# End  : mingyuan.xie added 2015.10.10 -----

# Begin: mingyuan.xie added 2015.10.10 -----
comeToLobby 51 {
	request {
		deskID 0 : integer
	}
}
# End  : mingyuan.xie added 2015.10.10 -----

#Begin: huangxiangrui added 2015.11.02 -----

#排行榜中的一项
.rankCell {
    name     1 : string     #昵称
    value    2 : string    #值，为了通用，使用字符串
    order    3 : integer    #顺序
}

.rankList {
    rankCell        0 : *rankCell
    userNickName    1 : string
    userValue       2 : string      #为了通用，使用字符串
    userOrder       3 : integer    #玩家排名
    rankType        4 : integer    #排行榜类型
    
}

#获取排行榜列表
#enumKeyAction:GET_RANK       enumEndPoint:LOBBY_SERVER
getRank 55 {
	request {
		rankType 0 : integer	#排行榜类型
	}
    response {
        rankList   0 : rankList
        nextFlushTime 1 : integer       #下次刷新的日期时间，转为秒
    }
}

.emailList {
    ID              0 : integer     #邮件ID
    title           1 : string      #邮件标题
    sendTime        2 : string      #发送时间
    expireTime      3 : string      #截止时间
    fromNickName    4 : string      #发件人昵称
    toNickName      5 : string      #收件人昵称
    stateID         6 : integer     #邮件状态，0为未读，1为已读
    typeID          7 : integer     #邮件类型，定义在head_file.emailType中
    readTime        8 : string      #领取时间
}

.emailGoods {
    goodsTypeID          0 : integer     #物品类型
    amount               1 : integer     #物品数量
}

.emailInfo {
    ID              0 : integer     #邮件ID
    title           1 : string      #邮件标题
    content         3 : string      #邮件内容
    fromNickName    4 : string      #发送人昵称
    toNickName      5 : string      #收件人昵称
    stateID         6 : integer     #邮件状态，0为未读，1为已读
    typeID          7 : integer     #邮件类型，0为公告，1为奖励
    emailGoodsList  8 : *emailGoods #邮件奖励物品列表
    url             9 : string      #桂林字牌调查问卷链接
}

#邮件列表
#enumKeyAction:GET_EMAIL_LIST       enumEndPoint:EMAIL_SERVER
getEmailList 56 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        emailList           0 : *emailList
    }
}
#邮件信息
#enumKeyAction:GET_EMAIL_INFO       enumEndPoint:EMAIL_SERVER
getEmailInfo 57 {
    request {
        emailID 0 : integer
    }
    response {
        emailInfo 0 : emailInfo
    }
}
#领取邮件奖励
#enumKeyAction:GET_EMAIL_AWARD       enumEndPoint:EMAIL_SERVER
getEmailAward 58 {
    request {
        emailID 0 : integer
    }
    response {
        result      0 : integer     #领取结果，1为失败，0为成功
    }
}
#客户端发送位置消息
#enumKeyAction:SEND_LOCATION_INFO       enumEndPoint:LOBBY_SERVER
sendLocationInfo 59 {
    request {
        userID      0 : integer
        location    1 : string
        locationEx    2 : string
    }
}


#End  : huangxiangrui added 2015.11.05 -----

# 消息通知, Zhenyu Yao added 2015.11.11
netMessage 60 {
    request {
        cmd 0 : integer     # 消息通知类型, 1: 系统消息, 2: 定制型消息;
        args 1 : string     # 数组形式的 json 字符串, 消息通知使用的参数;
    }
    response {
    }
}

#删除邮件    huang xiang rui 2015.11.14
#enumKeyAction:DELETE_EMAIL       enumEndPoint:EMAIL_SERVER
deleteEmail 61 {
    request {
        emailID 0 : integer     #邮件ID
    }
    response {
        result 0 : integer      #成功为0，失败为1
    }
}

#获取服务器系统时间    huang xiang rui 2015.12.04
#enumKeyAction:GET_SERVER_TIME       enumEndPoint:LOBBY_SERVER
getServerTime 62 {
    request {
        userID 0 : integer     #用户ID
    }
    response {
        time 0 : integer       #秒数
    }
}

# 定时赛信息, Zhenyu Yao
.timingMatchInfo {
    matchShouldStartTime 0 : integer
    startTime 1 : string
    matchTitle 2 : string
    roomServer 3 : string 
    nameEx 4 : string

    # 以下数据只用于 getAllTimingMatchesInfo 协议
    startTimeSet 5 : string         # 定时赛开赛的时间配置
    isFollowed 6 : integer          # 是否关注, 1 关注, 0 不关注
    isEnrolled 7 : integer          # 是否报名, 1 报名, 0 不报名
    pushAheadOfTime 8 : integer     # 推送的提前时间
    pushCount 9 : integer           # 推送的次数
    pushInterval 10 : integer       # 推送的间隔
}

# 获得玩家的状态, Zhenyu Yao, 2015.12.23
getPlayerStatus 63 {
    request {
    }
    response {
        roomType 1 : integer    # 房间的类型
        roomRate 3 : integer    # 倍率, 用于倍率房
        roomID 2 : integer      # 房间 ID, 用于比赛房
        groupID 4 : integer     # 所在的比赛组 ID, 用于比赛房
        timingMatches 5 : *timingMatchInfo   # 定时赛信息集合
        followMatchNames 6 : *string    # 关注比赛的服务名字
        areaID 7 : integer      # 私人场区域号
        selfDeskID 8 : integer  # 私人场桌号
    }
}

# 获得玩家的报名定时赛集合, Zhenyu Yao, 2016.02.25
getTimingMatches 64 {
    request {
    }
    response {
        timingMatches 5 : *timingMatchInfo   # 定时赛信息集合
    }
}

#已领取邮件列表
#enumKeyAction:GET_RECEIVED_EMAIL_LIST       enumEndPoint:EMAIL_SERVER
getReceivedEmailList 65 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        emailList           0 : *emailList
    }
}

#已领取邮件信息
#enumKeyAction:GET_RECEIVED_EMAIL_INFO       enumEndPoint:EMAIL_SERVER
getReceivedEmailInfo 100 {
    request {
        emailID 0 : integer
    }
    response {
        emailInfo 0 : emailInfo
    }
}

#系统公告邮件列表
#enumKeyAction:GET_SYSTEM_NOTICE_EMAIL_LIST       enumEndPoint:EMAIL_SERVER
getSystemNoticeEmailList 120 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        emailList           0 : *emailList
    }
}

#系统公告邮件信息
#enumKeyAction:GET_SYSTEM_NOTICE_EMAIL_INFO       enumEndPoint:EMAIL_SERVER
getSystemNoticeEmailInfo 121 {
    request {
        emailID 0 : integer
    }
    response {
        emailInfo 0 : emailInfo
    }
}

#标记邮件已读
#enumKeyAction:MARK_ALL_EMAILS_READ       enumEndPoint:EMAIL_SERVER
markAllEmailsRead 122 {
    request {
        emailTab           0 : integer     #邮件标签，定义在headFile.emailTab
    }
    response {
        emailIDs           0 : *integer   #标记的邮件ID
    }
}

#删除已读邮件
#enumKeyAction:DELETE_ALL_READ_EMAILS       enumEndPoint:EMAIL_SERVER
deleteAllReadEmails 123 {
    request {
    }
    response {
        emailIDs           0 : *integer   #删除的邮件ID
    }
}


# 请注意: 200 ~ 220 预留
# 上传历史记录, Zhenyu Yao, 2015.12.12
uploadHistory 200 {
    request {
        name 0 : string         # 文件名
        data 1 : string         # 回放数据
    }
    response {
        result 0 : integer      # 结果, 0 表示成功, 其他查看错误码
        curGold 1 : integer     # 当前的金币量
    }
}

# 请求上传历史记录的价格, Zhenyu Yao, 2015.12.12
uploadHistoryPrice 201 {
    request {
    }
    response {
        cost 0 : integer        # 价格, 金币为单位
    }
}

# 使用道具
useItem 221 {
    request {
        userGoodsID 0 : integer      #UserGoods表ID
        amount      1 : integer      #使用数量
        extraData   2 : string       #json字符串，传入特殊参数，根据道具的不同，json字符串中的字段名也不同，不需要特殊参数则为nil
    }
    response {
        result 0 : integer           # 定义在head.resultCode
        resultText 1 : string        # 显示在客户端上的文字
        extraData   2 : string       #json字符串，返回特殊参数，根据道具的不同，json字符串中的字段名也不同，没有为nil
    }
}

#-----------------------Bgein 获取所有比赛大区和比赛列表 mingyuan.xie 2015.11.18 -----------------------
.matchList {
	roomId			0 : integer			#比赛房ID
	matchTitle 		1 : string			#比赛名称
	matchType		2 : string			#比赛类型
	onlineNum		3 : integer			#该房间总在线人数
	matchIcon		4 : integer			#客户端显示的比赛图标码
	positionNo		5 : integer			#该比赛在大区挂接的相对位置，数值越小越靠前
	fullNum			6 : integer			# 开赛人数（该字段人满赛用）, 定时赛时表示该比赛允许的最大人数
	startTime		7 : string			# 开赛时间（该字段定时赛用）
    roomServer      8 : string          # 服务名字(该字段定时赛用)
    nameEx          9 : string          # 比赛名字
    riseIconUrl     10 : string         # 晋级 Icon 的链接
    riseBgUrl       11 : string         # 晋级背景的链接
}
.matchZone {
	title 			0 : string			#大区名
	priority		1 : integer			#显示优先级（客户端显示的先后顺序）
	matchList		2 : *matchList		#挂在该大区下的比赛列表
}
#获取所有比赛大区和比赛列表MSG
getAllMatch 66 {
    request {
        
    }
    response {
        matchZone  0 : *matchZone      #比赛分区和比赛列表
    }
}

# 报名的消费类型, Zhenyu Yao
.enrollCost {
    itemId 0 : integer      # 道具的 ID
    num 1 : integer         # 需要数量
    userGoodsID 2 : integer
}

# 比赛的排名信息
.matchRank {
    nickName 0 : string     # 昵称
    winDate 1 : integer     # 比赛日期
    avatarID 2 : integer    # 头像 ID
    thirdConf 3 : thirdInfo #第三方信息
}

#获取比赛概况
getMatchGeneral 67 {
    request {
        isRequestItems      0 : integer     # 请求是否需要同步道具数据, 1 是, 0 否
    }
    response {
    	ifComeBackMatch		0 : integer     #是否重新回到比赛, 1 重回, 0 不是, Zhenyu Yao modify 2015.12.16
        #matchTitle  		1 : string      #比赛标题
        enrollNum			2 : integer		#本场已报名人数
        matchTime			3 : string		#开赛时间（人满赛显示满N人开赛，定时赛显示开赛时间）
        enrollCosts         4 : *enrollCost # 报名消耗
        matchType           9 : string      # 比赛类型

        # 定时赛专用
        matching            6 : integer     # 是否比赛中, 1 是, 0 不是
        isEnrolled          7 : integer     # 是否之前报名过, 1 是, 0 不是
        matchShouldStartTime 8 : integer    # 定时赛的开赛时间
        maxLateTime 10 : integer            # 允许的迟到时间

        items               11 : *enrollCost    # 道具的数量
        ranking             12 : *matchRank     # 比赛的排名列表
    }
}


.onlineData {
	onlineNum 			0 : integer			#在线人数
	onlineType			1 : integer			#在线类型
}
#获取在线人数
getOnlineInfo 68 {
    request {
        
    }
    response {
        onlineData			0 : *onlineData		#在线数据
    }
}
#获取房间已报名人数
getEnrollNum 69 {
    request {}
    response {
        newestEnrollNum			0 : integer
    }
}
#-----------------------End   获取所有比赛大区和比赛列表 mingyuan.xie 2015.11.18 -----------------------

# 付费信息  Zhenyu Yao, 2015.11.16
payMessage 70 {
    request {
        ID 0 : integer      # 付费的交易 ID
        type 1 : integer    # 类型, 1 是计时检测请求, 2 是购买请求
    }
    response {
        ID 0 : integer              # 付费的交易 ID
        currentCoins 1 : integer    # 当前金币数量
        getCoins 2 : integer        # 增加金币数量
        type 3 : integer            # 类型, 1 是计时检测请求, 2 是购买请求
        result 4 : string           # 结果, success, failed
    }
}

#同步比赛场在线人数
#SYNC_MATCH_ONLINE_NUM           LOBBY_SERVER
syncMatchOnlineNum 71 {
    request {
        zoneIndex    0 : integer     #大区ID
    }
    response {
        matchZone  0 : *matchZone    #在该结构中，仅有matchList中的roomId与onlineNum数据有效
    }
}


#比赛中客户端请求获取比赛信息  huang xiang rui 2015.11.26
#enumKeyAction:GET_MATCH_INTEGRAL       enumEndPoint:ROOM_MATCH_SERVER
getMatchIntegral 80 {
    request {
        userID 0 : integer          #用户ID
    }
    response {
        userIntegral 0 : integer        #玩家积分
        riseIntegral 1 : integer        #晋级积分
        maxIntegral 2 : integer        #最高积分
        minIntegral 3 : integer        #最低积分
        outIntegral 4 : integer        #淘汰积分
    }
}

#扣除K币或老K金币消息
#enumKeyAction:RECHARGE_K_CURRENCY       enumEndPoint:LOBBY_SERVER
rechargeKCurrency 81 {
    request {
        amount 0 : integer      #扣除数量
        type   1 : integer      #扣除类型，定义在head_file.kCurrencyType
    }
    response {
        result  0 : integer     #扣除结果，定义在headFile.rechargeResultCode
        goldCoin 1 : integer    #充值了多少字牌金币
        type      2 : integer   #充值类型
    }
}

#请求获得老K货币
#enumKeyAction:GET_K_CURRENCY       enumEndPoint:LOBBY_SERVER
getKCurrency 82 {
    request {
        userID      0 : integer #用户ID
    }
}


.goodsList {
    goodsID  0 : integer #商品ID
    cost  1 : integer #所需货币数量
    costTypeID  2 : integer #兑换货币ID，定义在head_file.goodsTypeID
    name  3 : string #商品名称
    goodsStateID  4 : integer #商品状态 定义在head_file.goodsStateID
    amount 5 : integer  #商品库存
    intro 6 : string # 商品介绍
    zoneID  7 : integer #商品区域ID
    giftID   8: integer #礼品Ｉｄ
}
#请求获得商品列表
#enumKeyAction:GET_GOODS_LIST       enumEndPoint:LOBBY_SERVER
getGoodsList 83 {
    request {
        userID      0 : integer #用户ID
        zoneID      1  : integer #区域ID
        pageIndex   2 : integer #页序

    }
    response {
        goodsList 0 : *goodsList #商品列表
    }
}

#请求兑换商品
#enumKeyAction:EXCHANGE_GOODS       enumEndPoint:LOBBY_SERVER
exchangeGoods 84 {
    request {
        goodsID      0 : integer #商品ID
        amount       1 : integer #兑换数量
        giftID       2 : integer #礼品Ｉｄ
    }
    response {
        result      0 : integer #结果，定义在head_file.exchangeResultCode
        resultText  1 : string  #兑换结果文本
    }
}

#请求获得积分
#enumKeyAction:GET_POINT       enumEndPoint:LOBBY_SERVER
getPoint 85{
    request {
        userID      0 : integer #用户ID
    }
    response {
        point       0 : integer #积分
    }
}

#请求更改头像
#enumKeyAction:CHANGE_AVATAR       enumEndPoint:LOBBY_SERVER
changeAvatar 86{
    request {
        avatarID      0 : integer #头像ID
    }
    response {
        result       0 : integer #结果，定义在head_file.resultCode
        avatarID      1 : integer #头像ID	失败时该值为nil
    }
}

#请求获得头像列表
#enumKeyAction:GET_AVATAR_LIST       enumEndPoint:LOBBY_SERVER
getAvatarList 87{
    request {
        userID      0 : integer #用户ID
    }
    response {
        list       0 : *integer #头像ID
        curAvatarID 1 : integer #用户当前头像ID
    }
}


.exchangeList {
    goodsName 0 : string        #商品名称
    exchangeState 1 : integer   #兑换状态，定义在head_file.exchangeStateID
    time          2 : integer   #操作时间（os.time()）
}
#请求获得商品兑换记录
#enumKeyAction:GET_EXCHANGE_LIST       enumEndPoint:LOBBY_SERVER
getExchangeList 88{
    request {
        userID      0 : integer #用户ID
    }
    response {
        exchangeList 0 : *exchangeList
    }
}

#请求删除全部已读邮件
#enumKeyAction:DELETE_ALL_EMAILS       enumEndPoint:LOBBY_SERVER
deleteAllEmails 89{
    request {
        userID      0 : integer #用户ID
    }
    response {
        amount      0 : integer #删除了多少封邮件
        result      1 : integer #删除结果，定义在headFile.rechargeResultCode
    }
}

#积分兑换金币
#enumKeyAction:POINT_2_GOLDCOIN       enumEndPoint:LOBBY_SERVER
point2goldCoin 90 {
    request {
        amount 0 : integer      #扣除数量
    }
    response {
        result  0 : integer     #扣除结果，定义在headFile.point2goldCoinResultCode，兑换成功后，会再发一条flushCurrency消息
    }
}

#赠送红包
#enumKeyAction:SEND_RED_PAPER       enumEndPoint:LOBBY_SERVER
sendRedPaper 91 {
    request {
        amount 0 : integer      #数量
        toUserName 2 : string   #对方的账号(非userName，为code)
    }
    response {
        result 0 : integer  #结果，定义在headFile.sendRedPaperResultCode，成功后会再发一条flushCurrency
    }
}

#请求赠送红包
#enumKeyAction:REQUEST_SEND_RED_PAPER       enumEndPoint:LOBBY_SERVER
requestSendRedPaper 92 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        levelRequest 0 : integer   # 要求等级
        totalTimes   1 : integer   # 总次数限制
        leftTimes    2 : integer   # 剩余使用次数
        afterSendLeft    3 : integer   # 赠送后金币不低于
        amountList   4 : *integer  # 可选择赠送数量的列表
        serviceChargeRate 5 : string #手续费比率，由于是百分比，使用数字字符串
    }
}

#获得保险柜信息
.currencyInfo {
    currencyTypeID 0 : integer #货币类型，定义在goodsTypeID
    amount         1 : integer #数量
}

#请求使用保险柜
#enumKeyAction:USE_SAFE_BOX       enumEndPoint:LOBBY_SERVER
useSafeBox 93 {
    request {
        typeID 0 : integer #0是存钱，1是取钱，定义在headFile.safeBoxTypeID
        amount 1 : integer #数量
        currencyTypeID 2 : integer #货币类型，定义在goodsTypeID
        safePassword 3   : string  #保险柜密码
    }
    response {
        result 0 : integer #结果码，定义在headFile.safeBoxResultCode，成功后会追发一条flushCurrency消息
        typeID 1 : integer #类型headFile.safeBoxTypeID
        goldCoin 2 : integer #身上金币
        safeGoldCoin 3 : integer #保险柜金币
        goldCoinChange 4 : integer #金币变化量
        point 5 : integer #身上积分
        safePoint 6 : integer #保险柜积分
        pointChange 7 : integer #积分变化量
        resultText  8 : string #显示在客户端上的文字
    }
}

#enumKeyAction:GET_SAFE_BOX_INFO       enumEndPoint:LOBBY_SERVER
getSafeBoxInfo 94 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        safeBoxCurrencyInfo 0 : *currencyInfo #保险柜中货币数量，可能有多种货币，因此这里使用数组，点开保险柜界面除了返回这条消息，还会刷新用户货币flushCurrency
    }
}

#设置保险柜密码
setSafePassword 95 {
    request {
        oldPassword 0 : string #旧密码
        newPassword 1 : string #新密码
    }
    response {
        result 0 : integer #返回结果，定义在headFile.resultCode
    }

}
.zoneList {
    zoneID  0 : integer #区域ID
    zoneName  1 : string #分区名称
    onSaleTime  2 : string #上架时间 
    endSaleTime 3 : string # 下架时间
    imgUrl      4 : string #分区对应的图片url
    stateID     5 : integer # 上架状态 0为上架 1为下架
    sortNum     6 : integer # 排序权值 
}
#请求获得所有商品列表
#enumKeyAction:GET_ALL_GOODS_ZONE_LIST  enumEndPoint:LOBBY_SERVER
getAllGoodsZoneList 96 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        zoneList 0 : *zoneList #商品区域列表
    }
}


#使用兑换码
useRedeemCode 98 {
    request {
        redeemCode 0 : string #安全密码
    }
    response {
        result 0 : integer #返回结果，定义在headFile.redeemResultCode
        award 1 : *string #奖励内容，中文字符数组，没有返回空表
    }
}

.reasonList {
    reasonType 0 : integer # 1 个人不符合的条件，2 个人符合条件 3 服务器异常
    reasonCode 1 : integer #出错编号
    reasonText 2 : string #文字提示
}

# 报名, Zhenyu Yao, 2015.11.23
# 报名条件限制，KF.QIN 2017.4.1
matchEnroll 102 {
    request {
        userID 1 : integer          # user id
        enrollIdx 2 : integer       # 报名使用的道具索引
    }
    response {
        curNum 0 : integer          # 当前玩家数量
        fullNum 1 : integer         # 满玩家数量
        enrollIdx 2 : integer       # 使用的报名道具索引
        result 3 : integer          # 返回结果, 0 正确, 非 0 错误码
        reason 4 : string           # 预留
        reasonList 5: *reasonList        # 原因列表
    }
}

# 复活, Zhenyu Yao, 2015.11.24
matchRevive 103 {
    request {
        index 0 : integer       # 使用的复活道具索引
    }
    response {
        result 0 : integer      # 0 成功, 非 0 错误码
        reason 1 : string       # 预留
    }
}

# 取消复活, Zhenyu Yao, 2016.03.24
matchCancelRevive 104 {
    request {
    }
    response {
        result 0 : integer      # 0 成功, 非 0 错误码
        reason 1 : string       # 预留
    }
}

# 取消报名, Zhenyu Yao, 2015.12.01
matchCancelEnroll 105 {
    request {
        userID 1 : integer          # user id
    }
    response {
        result 0 : integer                  # 返回结果, 0 正确, 非 0 错误码
        matchTitle 1 : string               # 比赛标题
        matchType 2 : string                # 比赛类型
        curNum 3 : integer                  # 当前玩家数量
        fullNum 4 : integer                 # 满玩家数量
        isActive 5 : integer                # 用户主动取消, 1 主动, 0 被动
    }
}

#比赛阶段
.matchStage {
    phase      0 : integer       # 阶段
    lunNum     1 : integer       # 轮数
    juNum      2 : integer       # 局数
    riseRule   3 : *string       # 晋级规则
    riseNum    4 : integer       # 晋级人数
    matchTag   5 : integer       # 决赛或预赛，定义在head_file的matchTag中
}

# 回合信息
.roundInfo {
    phase 0 : integer                # 比赛的阶段, 打立出局, 定局积分
    curLunNum 1 : integer            # 定局积分的轮数
}

# 比赛重回牌局时, 请求当前回合的消息, Zhenyu Yao, 2015.12.17
matchRoundInfo 101 {
    request {
    }
    response {
        phase 0 : integer                   # 阶段类型
        roundInfo 1 : roundInfo             # 回合信息
        roundCount 2 : integer              # 第几局
        curRank 3 : integer                 # 当前排名
        maxRank 4 : integer                 # 最大排名
        matchBase 5 : integer               # 当前基数
        curMatchOutIntegral 6 : integer     # 当前淘汰积分
        title 7 : string                    # 比赛标题
        roundTitle 8 : string               # 当轮的标题
        maxIntegral 9 : integer             # 最大积分
        minIntegral 10 : integer            # 最小积分
        riseIntegral 11 : integer           # 晋级积分
        curStageNum 12 : integer            # 当前比赛阶段
        fullNum 13 : integer                # 最多人数
        matchStage 14 : *matchStage         # 比赛阶段详细信息
        integral 15 : integer               # 当前积分
        deskRank 16 : integer               # 桌排名
    }
}

#-----------------获取比赛详情 mingyuan.xie 2015.12.1 ----------------------
.matchRegular {
	roundTitle 			0 : string			#轮次标题: 预赛、复赛、决赛
	roundContent		1 : string			#每轮规则说明
}
getMatchDetail 106 {
    request {}
    response {
        matchExplain 0 : string 			#比赛说明
        winnerTime 	 1 : string				#夺冠时长
        initScore	 2 : integer			#初始积分
        matchRegular 3 : *matchRegular		#比赛规则说明
    }
}

#-----------------查看奖励方案 mingyuan.xie 2015.12.1 ----------------------
.awardPlan {
	awardTitle 			0 : string			#奖励标题（一般为具体名次）
	awardContent		1 : string			#奖励内容（对应名次能获得的奖励）
}
getAward 107 {
    request {}
    response {
        awardPlan 3 : *awardPlan		#奖励方案
    }
}

# 回到比赛牌局, Zhenyu Yao, 2015.12.17
matchComeBackGame 108 {
    request {
    }
    response {
        enterResult 0 : integer
    }
}

# 之前已经报名, 迟到回比赛
matchLateComeBack_Enrolled 109 {
    request {
    }
    response {
        result 0 : integer      # 为 0 表示回到比赛成功, 非 0 表示错误码
        roomId 1 : integer      # 房间 ID
    }
}

# 迟到报名进入定时赛
lateEnroll 110 {
    request {
        enrollIdx 0 : integer   # 报名使用的道具索引
    }
    response {
        result 0 : integer      # 为 0 表示回到比赛成功, 非 0 表示错误码
        roomId 1 : integer      # 房间 ID
        reason 2 : string       # 预留
    }
}

# 定时赛报名离开, Zhenyu Yao
timingMatchEnrollLeave 111 {
    request {
    }
    response {
        result 0 : integer      # 0 表示成功, 非 0 表示错误码
    }
}

# 关注比赛, Zhenyu Yao
followMatch 112 {
    request {
    }
    response {
        result 0 : integer      # 0 表示成功, 非 0 表示错误码
        reason 1 : string       # 预留
    }
}

# 取消比赛关注, Zhenyu Yao
unfollowMatch 113 {
    request {
    }
    response {
        result 0 : integer      # 0 表示成功, 非 0 表示错误码
        reason 1 : string       # 预留
    }
}

# 道具的数据结构
.itemStruct {
    itemId 0 : integer  # 道具的 ID
    num 1 : integer     # 数量
    userGoodsID 2 : integer # UserGoods表ID
    expireTime 3 : string   #过期时间
    maxOverlayNum 4 : integer  #最大叠加数，0为不限制
    obtainTime 5 : string  #获得道具时间
}

#特殊道具跳转的位置
.specialSkip {
    specialSkipName 0 : string
    specialSkipSeat 1 : integer   # 特殊道具跳转的位置 headFile.specialSkipSeat
}

# 道具配置, 字段的意义同 item_conf
.itemConf {
    itemId              0   : integer  # 道具的 ID

    chnName             1   : string
    descr               2   : string
    affectDescr         3   : string
    maxOverlayNum       4   : integer
    affectDuration      5   : integer
    useExpire           6   : string
    requireLevel        7   : integer
    recyclePrice        8   : itemStruct
    belongToActivity    9   : string
    kind                10  : string
    keyName             11  : string
    imgURL              12  : string
    canUse              13  : integer
    variety             14  : string
    keepDuration        15  : integer
    canSend             16  : integer
    canSynthesize       17  : integer
    canDecompose        18  : integer
    isVisible           19  : integer
    canRaffle           20  : integer
    specialSkip         21  : *specialSkip  #  {specialSkipName: 跳转位置的名称， specialSkipSeat :跳转的位置 }
}

# 同步道具的配置, Zhenyu Yao
synItemConf 114 {
    request {
        itemIds 0 : *integer    # 请求配置的道具 ID 集合
    }
    response {
        itemConfs 0 : *itemConf # 道具的配置集合
    }
}

# 同步所有的道具, Zhenyu Yao
synAllItems 115 {
    request {
    }
    response {
        items 0 : *itemStruct   # 玩家所有的道具信息
    }
}

# 回收道具, Zhenyu Yao
recycleItem 116 {
    request {
        itemInfo 0 : itemStruct     # 道具信息
    }
    response {
        result 0 : integer          # 操作结果
        reason 1 : string           # 预留
    }
    
}

##############私人场协议 150+      

#局数-消耗类型配置 
.gameCountCost {
    count 0 : integer                      #局数
    enrollCosts 1 : *enrollCost            #消耗类型
    enrollCostsAA 2 : *enrollCost          #AA 消耗类型
    enrollCosts4 3 : *enrollCost           #四人消耗类型
    enrollCosts4AA 4 : *enrollCost         #四人AA消耗类型
    enrollCostsKing 5 : *enrollCost        #多王消耗类型
    enrollCostsKingAA 6 : *enrollCost      #多王AA消耗类型
}

#翻醒配置
.fanXingConf {
    upXing 0 : integer         #选择为1   不选择为NIL
    midXing 1 : integer        #选择为1   不选择为NIL
    downXing 2 : integer       #选择为1   不选择为NIL
    followXing 3 : integer     #选择为1   不选择为NIL 1为跟醒
    seeCard 4 : integer        #选择为1   不选择为NIL 1为可看庄家牌
    fanXing 5 : integer        #翻醒 选择为1   不选择为NIL
    noXing 6 : integer         #无醒 选择为1   不选择为NIL
}

# 名堂配置
.mingTangConf {  
    mingTangDetails 1 : *integer            # 对应值定义在 headFile.MING_TANG_FAN_SHU_KIND    
}


#创建桌子配置
.createDeskInfo {      
    deskRate 0 : integer                    #倍率
    deskRemark 1: string                    #说明
    deskFlag 2 : integer                    #加密标示
    baseCoin 3 : integer                    #金币需求
    accountTime 4 : integer                 #结算界面等待时间
    selectCount 5 : integer                 #局数             公共桌为nil
    selectCost 6 : enrollCost               #选择的消耗类型   公共桌为nil
    huInterval 7 : integer                  #几胡一子 ( 3 或 5 ，无选择传 nil  )
    settlementRule 8 : integer              #结算规则 (1 或 2 ，1 为加一， 2 为翻倍， 无选择传 nil )
    fanXingRule 9 : fanXingConf             #翻醒规则 
    huPaiRule 10 : integer                  #胡牌规则, 10 胡起胡, 15 胡起胡
    isChangeSeat 11 : integer               #是否换位置 每局一换   1 为是 nil 为否
    isDianPao 12 : integer                  #是否开启点炮: 1 是, 其他否
    isChongXing 13 : integer                #是否开启重醒: 1 是, 其他否
    deskCostType 14 : integer               #桌子付费类型
    isMasterContinue 15 : integer           #群主开房是否可续桌
    clubID 16 : string                      #俱乐部ID，服务器内部自己填上，客户端无需填上，客户端可以通过服务器是否返回该字段判断是否是俱乐部建桌
    playerNum 17 : integer                  
    scoreLimit 20 : integer                 #封顶分数, 150, 120, 100, 0, 0 表示不封顶   
    kingNum 21 : integer                    #王数 2,3,4 必选一个
    mingTangRule 22 : mingTangConf          #名堂规则
    gameType 23 : integer
    isBaoDi 24 : integer                    #是否选择保底 1是 否nil
}

#倍率与最低金币、消耗类型配置
.rateGoldInfo {
    rate 0 : integer                        #倍率
    goldCoin 1 : integer                    #最低金币   
    createCount_Cost 2 : *gameCountCost     #局数-消耗类型 
}

#进入私人场大厅
.rebackDeskInfo {                    
        selfDeskID 0 : integer       #桌子ID
        ownerNickName 1 : string     #所有者昵称
        deskFlag 2 : integer         #是否加密     
        deskRate 3 : integer         #倍率
        agentNum 4 : integer         #本桌当前玩家个数
        deskRemark 5 : string        #桌子描述  
        areaID 6 : integer           #大区ID 预留
        baseCoin 7 : integer         #金币需求
        ownerAvatarID 8 : integer    #桌主的头像
        selfDeskState 9 : integer    #桌子的状态 
    }

enterRoomSelf 150 {
    request {
        roomId 0 : integer
        token 1 : string
    }
    response {
        enterResult 0 : integer
        selfDeskList 1 : *rebackDeskInfo      #其他桌子信息 显示
        createConf 2 : createDeskInfo         #保存的建桌配置  无保存为空
        rateGoldConf 3 : *rateGoldInfo        #倍率与最低金币配置
        isCreator   4 : integer               #是否有开房特权，1是，nil否
    }
}   

#创建桌子（房）
createSelfDesk 151 {
    request {
        roomId 0 : integer
        createConf 1 : createDeskInfo
        saveConf 2 : integer                    #是否保存配置
        thirdConf 3 : thirdInfo                 #第三方信息
    }
    response {
        createResult 0 : integer
        selfDeskID 1 : integer
        areaID 2 : integer
        agentInfos 3 : *agentInfoSelfRoom
        deskPW 4 : string                       #邀请码      
        accountTime 5 : integer                 #结算等待时间
        remainCount 6 : integer                 #剩余局数 
        totalCount 7 : integer                  #总局数 
        selfDeskType 8 : integer                #建桌类型  
        gameType 9 : integer                    #游戏类型  
        createConf 10 : createDeskInfo          #获取最新的配置
    }

}            

#黑名单信息提示  一定会有两个昵称 
.blackAgentInfo {
    nickName 1 : string                    #客户端提示 blackNickName 是 nickName 的黑名单用户 。若 nickName 是自己 返回 nickName = "您"
    blackNickName 2 : string               #
    blackSeatIndex 3 : integer             #若blackSeatIndex 和 blackUserID 不为空 将该位置的玩家添加黑名单标示
    blackUserID 4 : integer
}

#加入桌子（房）
.enterDeskInfo {
    selfDeskID 0 : integer                  #桌子ID    正常进入公共桌传ID 邀请进入传邀请码
    deskPW 1 : string                       #邀请码    
}

enterSelfDesk 152 {
    request {
        roomId 0 : integer         
        enterInfo 1 : enterDeskInfo
        thirdConf 2 : thirdInfo                 #第三方信息
    }
    response {
        enterResult 0 : integer
        selfDeskID 1 : integer
        areaID 2 : integer
        agentInfos 3 : *agentInfoSelfRoom
        seatIndexWait 4 : integer  
        createConf 5 : createDeskInfo       
        remainCount 6 : integer             #剩余局数 （公共桌为NIL）
        totalCount 7 : integer              #总局数
        blackListPrompt 8 : *blackAgentInfo  #黑名单提示 
        gameType 9 : integer                 #游戏类型
    }

}

#玩家请求准备或取消准备    
getReady 153 {
    request {
        readyInfo 1 : integer             #请求动作 1 准备  2 取消准备
    }
    response {
        readyResult 0 : integer           # 结果 ： 1 为成功 2 为失败
    }
}

#玩家取消 退出该桌 结算时返回
getCancel 154 {
    request {
        selfDeskID 0 :integer
        seatIndex 1 : integer
    }
    response {
        cancelResult 0 : integer
    }
}

#桌主踢人
ownerKick 155 {
    request {
         selfDeskID 0 : integer
         kickSeatIndex 1 : integer
    }
    response {
        kickResult 0 : integer
    }

}

#桌主请求游戏开始
requestGaming 156 {
    request {
         selfDeskID 0 :integer
    }
    response {
        gamingResult 0 : integer    
    }
}

#桌主解散桌子
ownerDestroyDesk 157 {
    request {
        selfDeskID 0 : integer
        deskOwnerID 1 : integer
    }
    response {
        destroyResult 0 : integer        
    }
}

#玩家离开私人房大厅
leaveRoomSelf 158 {
    request {
        
    }
    response {
        leaveResult 0 : integer      
    }
}

#保存建桌配置
saveCreateConf 159 {
    request {
        createConf 0 : createDeskInfo
    }
    response {
        saveResult 0 : integer
    }
}

#请求刷新列表
requestUpdate 160 {
    request {
        
    }
    response {
        selfDeskList 0 : *rebackDeskInfo      #刷新后显示桌子信息, 可能会存在与之前请求的桌子数据重叠的问题
    }
}

#获取战绩表
.scoreDate {
    gameIndex 0 : integer     #牌局 
    scoreList 1 : *integer    #对应每局计分记录 {玩家1 ，玩家2 ，玩家3}
}

getScoreTable 161 {
    request {

    }
    response {
        scoreTable 0 : *scoreDate    #最新的数据存储在尾部
        nickNames 1 : *string       #玩家昵称列表 {玩家1 ，玩家2 ，玩家3}  
    }
}

.recordInfo {
    moSelf 1 : integer          #自摸 次数   没有传 0 
    normal 2 : integer          #平胡 次数
    pointGun 3 : integer        #点炮 次数
    tianHu 4 : integer          #天湖 次数
    diHu 5 : integer            #地胡 次数
    sanLwuK 6 : integer         #三笼五坎 次数
    xingCount 7 : integer       #总醒数	次数
    hongHu 8 : integer          #红胡  	次数  
	dianHu 9 : integer          #点胡  	次数
	heiHu 10 : integer			#黑胡   次数	
	wangDiao 11 : integer       #王钓  	次数
	wangChuang 12 : integer     #王闯  	次数
	wangZha 13 : integer        #王炸   次数
	wangDiaoWang 14 : integer   #王钓王 次数
	wangChuangWang 15 : integer #王闯王 次数
	wangZhaWang 16 :integer     #王炸王 次数 

}

# 战绩表玩家信息
.selfRoomRecordSimpleAgent {
    userID 0 : integer              # 用户的 userID
    nickName 1 : string             # 昵称
    avatarID 2 : integer            # 头像 ID  
    scoreCount 3 : integer          # 子数
    recordDetails 4 : recordInfo    # 详细信息
    rankReward 5 : *prop            # 奖励道具与相关值信息  nil 为无奖励
    seatIndex 6 : integer           # 座位号
    isWinner 7 : integer            # 是否是大赢家，0否，1是
    code     8 : integer 	        # 用户ID
    isDeskOwner 9 : integer         # 是否是桌主，0否，1是
    rank       10 : integer         # 本场排名
    thirdConf 11 : thirdInfo        # 第三方信息
     winCount 12 : integer            # 赢的局数
    loseCount 13 : integer           # 负的局数
    pingCount 14 : integer           # 平的局数	
}

#俱乐部每一小局战绩结构
.clubGameRecordDetail {
    startTime 0 : string                        # 开始时间
    endTime 1 : string                          # 结束时间
    agentInfos 2 : *selfRoomRecordSimpleAgent   # 玩家数据集合（在该协议中，仅userID、scoreCount字段有值，scoreCount为每一小局游戏输赢子数）
    videoInfoLogName 3 : string                      # 回放的录像表名，请求回放时需传该参数
    videoInfoLogID 4 : integer                       # 回放的录像表ID，请求回放时需传该参数
}

# 战绩表记录数据结构
.selfRoomRecordData {
    startTime 0 : string                        # 开始时间
    deskRate 1 : integer                        # 桌子倍率
    gameCount 2 : integer                       # 总局数
    agentInfos 3 : *selfRoomRecordSimpleAgent   # 玩家数据集合
    deskOwnerUserID 4 : integer                 # 桌主的 userID
    deskPW 5 : string                           # 房间号
    dissoluteNickName 6 : string                # 解散者的昵称
    endTime 8 : string                          # 结束时间
    groupInfoLogID 9 : integer                  # 战绩表ID
    tableSubNameGroup 10 : string                # 战绩表名
    deskCostType 11 : integer                   # 房间消费类型
    playerNum 12 : integer                      # 游戏人数类型 3/4人
    gameType 13 : integer                       #游戏类型
    gameDetails 14 : *clubGameRecordDetail      # 每一小局的信息(用于H5麻将回放,桂林字牌没有用到)
}

# 获得私人场的记录数据   
getSelfRoomRecordDatas 162 {
    request {
        length 1 : integer      # 查询的记录长度
        beginTime 2 : string    # 查询的起始时间; 如果不传这个参数, 那么需要最新的数据;
        isCreator 3 : integer   #是否是创建者查看战绩，1是，nil否
        after   4 : integer     #是否查询beginTime时间之后的战绩，1是，nil否
        searchCode 5 : string   #查询的号码，6位长度是房间号deskPW，8位长度是玩家code，玩家未填写时则不传
        searchTime 6 : string   #查询时间，例：2017-09-19 如果该字段存在，则查询这一天的战绩，如果该字段为nil，则查询beginTime之前的战绩
        searchType 7 : integer  #筛选类型，定义在headFile.groupAdminSelfRoomRecordSearchType，0查询全部数据，1查询大赢家，2查询桌主
        index 8 : integer  #从第几条数据开始读，通常填上一次请求之后服务端返回的值，没有数据时传0
    }
    response {
        datas 0 : *selfRoomRecordData       # 返回的记录,以时间的降序存储
        index 1 : integer                   #从第几条数据开始读，通常为下一次请求时，客户端的index值，没有数据时传0
    }
}

# 私人场重回
comeBackSelfRoom 163 {
    request {
    }
    response {
        selfDeskInfo 0 : rebackDeskInfo     # 桌子的详细信息
        createConf 1 : createDeskInfo       # 桌子的配置
        strData 2 : string                  # 在牌局中的话, 是牌局数据
        state 3 : integer                   # 当前在私人场的状态
        result 4 : integer                  # 结果码, 正常返回: headFile.enterRoomResult.SUCCESS, 否则: headFile.enterRoomResult.COME_BACK_SELF_FAILED
        agentInfos 5 : *agentInfoSelfRoom   # 桌上用户的数据
        seatIndexWait 6 : integer           # 当前座位
        deskPW 7 : string                   # 邀请码
        gameCount 8 : integer               # 本场中当前局数
        remainCount 9 : integer             # 剩余局数
        totalCount 10 : integer             # 总局数  
        createCount_Cost 11 : *gameCountCost                #局数消耗类型(等待时断线重回)
        selfDeskType 12 : integer           #建桌类型 
        waitDissolute 13 : integer          #是否是等待选择解散的状态  1  为是   0 为否  
        dissoluteSendTime 14 : integer      #发送时间
        dissoluteWaitTime 15 : integer      #等待时间
        waitContinue 16 : integer           #是否是等待选择继续的状态  1  为是   0 为否  
        continueSendTime 17 : integer       #续费的消息发送时间   
        continueWaitTime 18 : integer       #续费的等待时间
        gameType 19 : integer               #游戏类型
        fourSendTime 20 : integer           #四人续费解散发送时间
        fourOwnerTime 21 : integer          #四人续费解散的等待时间
    }
}

# 私人场比较记录的时间
selfRoomCompareRecordTime 164 {
    request {
        lastestTime 0 : string
        gameCount 1 : integer     #客户端最新游戏局数
    }
    response {
        result 0 : integer      # 0 最新时间, 1 不是最新时间
    }
}

# 局数打完后继续游戏
gameContinue 165 {
    request {
        selectCount 1 : integer                 #局数             
        selectCost 2 : enrollCost               #选择的消耗类型   
    }
    response {                    
        result 0 : integer                      # 
        remainCount 1 : integer                 #剩余局数
        totalCount 2 : integer                  #总局数
        waitOthers 3 : integer                  # 0 表示不等待, 1 表示等待其他玩家
    }
}

#发送表情
sendExpression 167 {
    request {
        expressionID 1 : integer                #表情ID    
    }
}

#解散桌子信息
requestDissoluteDesk 168 {
    request {
        dissoluteAction 0 : integer
    }
}

#获取牌桌规则
getDeskRules 169 {
    request {
         deskPW 0 : string                       #邀请码 
    }
    response {
        result 0 : integer                    #获取结果码  
        createConf 1 : createDeskInfo         #建桌配置
        blackListPrompt 2 : *blackAgentInfo   #黑名单提示          
    }
}

#续费询问选择 
gameContinueSelect 170 {
    request {
        selectAction 0 : integer  
    }
}

#比较回放列表记录的时间
selfRoomCompareMsgRecordTime 171 {
    request {
        lastestTime 0 : string
        gameType 1 : integer    # 游戏类型
    }
    response {
        result 0 : integer      # 0 最新时间, 1 不是最新时间
    }
}

# 牌局回放表记录数据结构
.selfRoomMsgRecordData {
    msgStartTime 0 : string                     # 开始时间
    msgRecordID 1 : integer                     # 牌局ID
    infoLogName 2 : string                      # 分表的名称 数据库需要
    userInfo 3 : *userInfo                      # 本桌的用户（该协议只用到userInfo结构体的userID与nickName）
    playerNum 4 : integer                       # 游戏人数类型 3/4人
    gameType 5 : integer                        # 游戏类型
}

# 获得回放记录的列表
getSelfRoomMsgRecordList 172 {          
    request {
        length 1 : integer      # 查询的记录长度
        beginTime 2 : string    # 查询的起始时间; 如果不传这个参数, 那么需要最新的数据;
        gameType 3 : integer    # 游戏类型

    }
    response {
        datas 0 : *selfRoomMsgRecordData       # 返回的记录
    }
}

#获取指定的回放数据
getSelfRoomMsgRecordDatas 173 {
    request {
        msgRecordID 0 : integer     #牌局ID
        infoLogName 1 : string      #分表的名称 数据库需要
    }
    response {
        datas 0 : string       # 返回的记录
    }
}

#获取包厢是否能提前进入游戏
getSelfRoomBeginGame 174 {
    request {
        deskPW 1 : integer  #房间号
    }
    response {
    }
}

#获得战绩配置
#GET_SELF_ROOM_RECORD_CONF
getSelfRoomRecordConf 175 {
    request {
        groupInfoLogID 0 : integer     #战绩表ID
        tableSubNameGroup 1 : string    #战绩表名
    }
    response {
        conf 0 : string                #战绩配置，json字符串，获取失败则为空字符串
    }
}


####################################################################################################
# 挖矿小游戏协议定义 BEGIN
####################################################################################################

# 挖矿游戏道具配置
.miningItemStruct {
    itemId 0 : integer      # 道具 Id
    num 1 : string          # 数量
}

# 开采开销
.miningDigCost {
    costItem 0 : miningItemStruct   # 消耗道具
    digCount 1 : integer            # 开采次数
    onSale 2 : string               # 打折描述, 只写数字
}

# 开采区域
.miningRegion {
    costs 0 : *miningDigCost
    highestReward 1 : *miningItemStruct
}

# 挖矿游戏配置
.miningConfig {
    regions 0 : *miningRegion
}

# 挖矿游戏获取记录
.miningGainRecord {
    nickName 0 : string             # 昵称 (自己的不填)
    gainItem 1 : miningItemStruct   # 获得道具信息
    gainTime 2 : integer            # 获取时间
    avatarID 3 : integer            # 头像信息
    thirdConf 4 : thirdInfo         # 第三方信息


}

#排名和获取记录
.miningRankRecord {
    ranking 0 : integer
    record 1 : miningGainRecord
}
# --------------------------------------------------------------------------------------------------

# 进入挖矿界面
miningEnter 190 {
    request {
    }
    response {
        config 0 : miningConfig
        result 1 : integer          # 返回结果
    }
}

# 获得本周100强数据
miningGetAllWeekRecords 191 {
    request {        
    }
    response {
        records 0 : *miningGainRecord
        rankSelf 1 : miningRankRecord     #自己的排名信息  nil 为未入榜 
        refreshTime 2 : integer           #下次刷新时间
    }
}

# 获得自己最新的挖矿记录
miningGetSelfLatestData 192 {
    request {
    }
    response {
        records 0 : *miningGainRecord
    }
}

# 获得自己本周挖矿记录
miningGetSelfWeekData 193 {
    request {
    }
    response {
        
        goldNumber 0 : string           # 金币总数量
        pointNumber 1 : string          # 积分总数量
        itemNumber 2 : string           # 道具总数量    
        maxGoldInPer 3 : string         # 单次的金币最大数量
        maxPointInPer 4 : string        # 单次的积分最大数量
        sumDigCount 5 : integer         # 总的挖矿次数

    }
}

# 挖           
miningDig 194 {
    request {
        regionIdx 0 : integer           # 挖掘的区域索引
        costIdx 1 : integer             # 挖掘的消费索引
    }
    response {
        result 0 : integer              # 挖掘结果
        resultText 1 : string           # 挖掘结果文本, 预留
        records 2 : *miningGainRecord   # 挖掘的明细记录
    }
}

####################################################################################################
# 挖矿小游戏协议定义 END
####################################################################################################


#写留言板
#WRITE_MESSAGE_BOARD
writeMessageBoard 240 {
    request {
        message 0 : string     #文本
    }
    response {
        result 0 : integer           # 定义在head.resultCode，是否写入成功
        resultText 1 : string        # 显示在客户端上的文字
    }
}

#获得修改昵称参数
.costInfo {
    goodsID 0 : integer   #Goods表ID
    amount  1 : integer   #消耗数量
}
#GET_CHANGE_NICKNAME_INFO
getChangeNickNameInfo 241 {
    request {
        userID 0 : integer  #用户ID
    }
    response {
        cost 0 : string     #价格，元，数字字符串，客户端接收后需tonumber
        changeNickNameCardNum 1 : integer #改名卡数量
        freeTimes 2 : integer  #剩余免费改名次数
        mallID 3 : integer     #改名的mallID
        itemID 4 : integer     #改名卡ID
        itemName 5 : string    #改名卡名称
    }
}

#修改昵称
#CHANGE_NICKNAME
#extraData={
#    "nickName" : "新昵称"
#}
changeNickName 242 {
    request {
        userGoodsID 0 : integer      #UserGoods表ID，如果没有，传nil
        amount      1 : integer      #使用数量，参数为 1
        extraData   2 : string       #json字符串，传入特殊参数，根据道具的不同，json字符串中的字段名也不同，不需要特殊参数则为nil
    }
    response {
        result 0 : integer           # 定义在head.resultCode
        resultText 1 : string        # 显示在客户端上的文字
        extraData   2 : string       #json字符串，返回特殊参数，根据道具的不同，json字符串中的字段名也不同，没有为nil
    }
}



#获得道具合成表
#单个合成项
.synthetizeCell {
    name 0           : string  #合成名称
    info 1           : string  #其他说明
    canSynthetize 2  : integer #是否可以合成，0为不可，1为可以
    goodsVaryID   3  : integer #合成表ID
}
#分组
.synthetizeGroup {
    groupID 0 : integer #道具合成分组ID
    costGoods 1 : *itemStruct #消耗道具 (itemStruct结构中只有itemId有用)
    gainGoods 2 : *itemStruct #获得道具 (itemStruct结构中只有itemId有用)
    remark   3 : string #备注
    synthetizeList 4 : *synthetizeCell #合成项
    goodsID 5 : *integer #传入的道具ID
}
#GET_ITEM_SYNTHETIZE_LIST
getitemSynthetizeList 243 {
    request {
        goodsID 0 : *integer  #Goods表ID
    }
    response {
        synthetizeGroup 0 : *synthetizeGroup #合成分组
    }
}

#道具合成
#ITEM_SYNTHETIZE
itemSynthetize 244 {
    request {
        goodsVaryID 0 : integer  #道具变换表ID
    }
    response {
        result 0 : integer     #成功或失败，定义在head_file.resultCode
        resultText 1 : string  #显示在客户端上的文字
    }
}

#赠送道具
#SEND_ITEMS
sendItems 245 {
    request {
        getterUserName 0 : string   #对方的账号（非userName，为code）
        items          1 : *itemStruct  #赠送的道具数组，该协议中，itemStruct的num为赠送的数量
    }
    response {
        result 0 : integer     #成功或失败，定义在head_file.resultCode
        resultText 1 : string  #显示在客户端上的文字
    }
}

#删除用户处理事项
#DELETE_USER_MATTER
deleteUserMatter 246 {
    request {
        matterKey 0 : string #事项的key，定义在head_file.UserMatter.matterKey
    }
    response {
        result 0 : integer  #成功或失败，定义在head_file.resultCode
    }
}

.goodsInfoList {
    name 0 : string             #商品名称
    amount 1 : integer          #商品库存
    goodsID 2 : integer         #商品ID
    costGoodsNum 3 : integer    #购买花费道具数量
    costGoodsID 4 : integer     #购买花费道具ID
    exchangeGoodsNum 5 : integer #购买得到的道具数量
    exhcangeGoodsID 6 : integer  #购买得到的道具ID
    goodsKindID     7 : integer  #道具种类ID
}
#获得某个种类的商品数据
#GET_KIND_GOODS_LIST
getKindGoodsList 247 {
    request {
        goodsKindID 0 : integer   #道具种类ID
    }
    response {
        goodsInfoList 0 : *goodsInfoList   #商品列表
    }
}

#获得道具的信息
#GET_ITEM_INFO
getItemInfo 248 {
    request {
        itemID 0 : integer     #Goods表ID
    }
    response {
        itemInfo 0 : *itemStruct  #道具信息
    }
}

# 领取所有邮件奖励
# GET_ALL_EMAIL_AWARD    LOBBY
getAllEmailAward 249 {
    request {
        userID 0 : integer
    }
    response {
        result 0 : *itemStruct      # 获得的各种道具数量，该结构的userGoodsID在本协议中不使用
    }
}

# 获取用户可见的排行榜
#rankTabInfo={
#   title : "标题",
#   subTitle : "子标题",
#   infoMsg : "附加说明",
#   titleBgID : 0
#}
#extraInfo={
#rankingShowType : "排行榜右上角显示内容,head_file.rankingShowType" 
#}
.rankTabInfo {
    rankTabID   0 : integer #排行榜ID
    rankTabName 1 : string #排行榜名称
    rankValueText   2 : string   #显示在成绩之前的文字
    rankTabInfo     3 : string   #json字符串，用户显示额外的信息，如果不需要显示，该值为nil
}
.rankEventInfo {
    rankEventID 0 : integer  #排行榜活动ID
    rankEventName   1 : string   #排行榜活动名称
    rankTabInfo     3 : *rankTabInfo #排行榜
    extraInfo 4 : string #json字符串,显示额外的信息
}
getVisibleRanking 250 {
    request {
        userID      0 : integer #用户ID
    }
    response {
        rankEventInfo 0 : *rankEventInfo #排行榜信息
    }
}

#获取排行榜奖励配置
getRankingAwardConfig 251 {
    request {
        rankEventID 0 : integer  #排行榜活动ID
        rankTabID   1 : integer #排行榜ID
    }
    response {
        awardText 0 : string #奖励配置, 具体查看奖励配置模板, json 字符串
    }
}

#获取排行榜
.rankingCell {
    nickName 0 : string #昵称
    rank     1 : integer #名次，未入榜为0
    value    2 : integer #成绩
}
.rankingList {
    rankingCell     0 : *rankingCell  #排行榜内容
    nextFlushTime   1 : integer     #下次刷新时间，os.time()
    userRanking     2 : rankingCell   #玩家排行榜信息
}
getRanking 252 {
    request {
        rankEventID 0 : integer  #排行榜活动ID
        rankTabID   1 : integer #排行榜ID
        userID      2 : integer #玩家ID
    }
    response {
        rankingList 0 : rankingList  #排行榜
    }
}

#获得上一次排行榜
getHistoryRanking 253 {
    request {
        rankEventID 0 : integer  #排行榜活动ID
        rankTabID 1 : integer #排行榜ID
    }
    response {
        rankingList 0 : rankingList  #排行榜
    }
}

# 告诉服务器当前玩家语音的地址
tellVoiceUrl 254 {
    request {
        url 0 : string      # 语音的地址
        time 1 : integer    # 语音的时间, 单位毫秒
    }
}

# 获得所有定时比赛的内容
getAllTimingMatchesInfo 255 {
    request {
    }
    response {
        matches 0 : *timingMatchInfo
    }
}

#请求翻醒奖励配置  (如 倍率500基数2冰块数1 则 500倍每两醒奖励1 冰块)
.rateReward {
    rate 0 : integer         #倍率
    xingCount 1 : integer    #翻醒基数     
    reward 2 : integer       #冰块数    
}

getFanxingReward 256 {
    request {
        
    }
    response {
        rewardConf 0 :  *rateReward
        times 1 : *integer
    }
}

# min.luo 2016.8.5 添加客户首冲判定
getRechargeValid 257 {
    request {
        mallId 0 : integer
       quantity 1 : integer
    }
    response {
        result 0 : integer  # 1代表成功，0代表失败
        errCode 1 : integer # 错误码  code 0：成功 -1:请求错误 -2:商品未上架或已达到购买上限  -3:不在有效时间内
    }
}

# min.luo 2016.8.10 用户是否还在游戏中 result 1 代表游戏中 0代表否
getUserIsGame 258 {
    request {
        userID 0 : integer
    }
    response {
        result 0 : integer
    }
}

# min.luo 2016.8.12 请求首冲道具列表
.mallList {
    name 0 : string         #商品名称
    price 1 : string        #商品价格，人民币，元，因为有可能为小数，所以这里使用string类型
    info 2 : string         #商品说明，赠送xxx道具，没有为空字符串
    itemId 3 : integer      #购买获得的道具ID
    itemNum 4 : integer     # 购买获得的道具数量
    isSpecial 5 : integer   #是否是首充优惠
    tagTypeID 6 : integer   #充值角标，定义在h.tagType
    mallID 7 : integer      #商品的ID
    isValid 8 : integer     #是否可用，0为否，1为是，如果为否时按钮变灰，主要用于测试的时候暂时不对外开放
    specialTagTypeID 9 : integer    #类型ID，用于区分商品类型，定义在h.specialTagType
    startTime 10 : integer          #有效期开始时间,os.time()
    endTime 11 : integer            #有效期结束时间,os.time()
    costItemID 12 : integer         #购买所花费的道具ID，一般为字牌K币或人民币（108 or 106）
    saleTypeID 13 : integer         #销售种类ID 定义在head_file.saleTypeID
    unit 14 : string                #单位，中文
}
getFirstList 259 {
    request {
        userID 0 : integer #玩家ID
        costItemID 1 : integer #购买所花费的道具ID，一般为字牌K币或人民币（108 or 106）
        saleTypeID 2 : integer #销售种类ID 定义在head_file.saleTypeID
    }
    response {
        result 0 : *mallList     #道具列表
    }
}

# min.luo 2016.8.12 不同礼包的首冲标志
getFirstRechargeTag 260 {
    request {
        userID 0 : integer
    }
    response {
        result 0 : *integer      #不同礼包是否还有首冲 1:有 0:没有 
    }
}

# min.luo 2016.8.26 请求房卡的 mid
getRoomCardMID 261 {
    request {
    }
    response {
        mid 0 : *integer             # 房卡的有效 id, 如果无效就是 -1
        resultText 1 : string       # 无效的时候说明无效的原因
        price 2 : *string            # 房卡的价格
        gainGoods 3 : *string        # 获取的道具配置
    }
}

# 绑定微信账号
#BIND_WEIXIN
bindWeiXin 262 {
	request {
		code 0 : string
	}
	response {
		result 0 : integer #是否成功，定义在head_file.resultCode
		resultText 1 : string #绑定结果，直接显示在客户端上
        weiXinData 2 : string #微信用户数据，json字符串，获取失败返回空字符串
	}
}

# min.luo 2016.9.9 请求喇叭的 mid和价格
getLoudspeakerMidPrice 263 {
    request {
    }
    response {
        result 0 : integer      #有效1 或无效 -1
        mid 1 : *integer        #Mall ID
        price 2 : *string       #对应Mid的价格
    }
}

#设置新私人场推广号
#SET_NEW_SPREADER
setNewSpreader 264 {
    request {
        newSpreader 0 : string #新推广号
    }
    response {
        result 0 : integer     #是否成功，定义在head_file.resultCode
        resultText 1 : string  #显示在客户端上的文字
    }
}

#min.luo 2016.9.29  
getFirstBuyRoomCard 265 {
    request {
        mallID 0 : integer
    }
    response {
        result 0 : integer     #是否第一次购买 1 / -1
    }
}

#创建360订单
#CREATE_360_ORDER
create360Order 266 {
    request {
        userID 0 : integer
    }
    response {
        appOrderId 0 : string   #360订单，如果为空字符串，则表示创建订单失败
        qh360Uid   1 : string   #360UID
    }
}

.qh360Product {
    productId 0 : string  #商品ID
    productName 1 : string #商品名称
    cost        2 : string #商品价格，人民币，元，因为有可能为小数，所以这里使用string类型
    gain        3 : integer #获得金币数量
}

#获得360商品
#GET_360_PRODUCT
get360Product 267 {
    request {
        userID 0 : integer
    }
    response {
        list  0 : *qh360Product  #商品列表
    }
}

#检查昵称是否可用
#CHECK_NICKNAME_VAILD
checkNickNameVaild 268 {
    request {
        newNickName 0 : string       #新昵称
    }
    response {
        result      0 : integer      #是否可用  定义在head.resultCode
        resultText  1 : string       #显示在客户端上的文字
    }
}

#用户认证
#USER_AUTH
userAuth 269 {
    request {
        authValue 0 : string       #json字符串，根据不同的认证类型，json字符串中定义的字段也不相同
        authType 1 : string        #认证类型定义在head_file.authType
    }
    response {
        result      0 : integer      #是否成功  定义在head.resultCode
        resultText  1 : string       #显示在客户端上的文字
    }
}

#获取用户认证
#GET_USER_AUTH
getUserAuth 270 {
    request {
        authType 1 : string        #认证类型定义在head_file.authType
    }
    response {
        authValue 1 : string       #json字符串，根据不同的认证类型，json字符串中定义的字段也不相同，没有进行该认证时，为空字符串
    }
}


#shortMsg KF.QIN 2016.12.19
shortMessage 271 {
   request {         
        seatIndex 0 : integer   
        msgCode 1   :   integer
    }
}

#获得系统配置
#GET_SYSTEM_CONF
getSystemConf 272 {
    request {
        userID 1 : integer        #用户ID
    }
    response {
        conf 1 : string       #json字符串，获取失败时，字符串为空
    }
}

#玩家分享，玩家每分享一次都向服务器发送消息
#USER_SHARE
userShare 273 {
    request {
        typeID 0 : integer  #分享类型，分享有礼或分享房号定义在headFile.userShareTypeID
    }
    response {
        result 0 : integer #是否获得了奖励，第一次分享才会获得，所以返回失败不一定表示出错，0表示没有获得，1表示获得，定义在headfile.resultCode
    }
}

#获取玩家推广列表，用户第一次获取之后缓存在客户端中，玩家第二次点击列表按钮就不再向服务端请求了，直到用户下线
.userSpreaderList {
    code 0 : integer  #用户code
    nickName 1 : string #用户昵称
    gameCount        2 : integer #用户局数
    regTime        3 : string #用户注册时间
}

#GET_USER_SPREADER_LIST
getUserSpreaderList 274 {
    request {
        index 0 : integer #当前读取到第几条，第一次传0
    }
    response {
        index 0 : integer #读取到的条数，玩家往下拖动列表的时候把这个值传给服务端
        userSpreaderList 1 : *userSpreaderList #用户推广列表
    }
}

#获取玩家分享信息，可以实时向服务端获取
#GET_USER_SHARE_INFO
#{   shareAwardConf  json
#    "1":
#    {
#        "awardGoodsIconID":"id1,id2",  //可能有多个，用逗号分隔
#        "targetText":"成功推荐10名玩家",
#        "awardText":"1元微信红包",
#        "targetGamesNum":20,  //目标局数
#        "targetUserNum":10,  //目标用户数
#        "curUserNum":1      //当前用户数
#        "canReceive":0      //控制领取按钮是否可用，0否，1是
#        "configID":1        //当前配置的ID
#    }
#}
getUserShareInfo 275 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        userNum            0 : integer #推荐成功的玩家数
        todayGetSharePoint 1 : integer #今日获得的积分
        totalGetSharePoint 2 : integer #累计获得的积分
        sharePoint         3 : integer #当前剩余积分
        shareAwardConf     4 : string  #分享奖励显示，json字符串，客户端根据这个json字符串展示相应的配置，没有为空字符串
        reachUserNum       5 : integer #成功推荐的玩家数（达标玩家数）=shareAwardConf的curUserNum之和
    }
}

#通过道具购买,MALL服务
#PURCHASE_ITEM
purchaseItem 276 {
    request {
        mallID 0 : integer #商品ID
    }
    response {
        result 0 : integer #成功或失败，定义在head_file.resultCode
        resultText 1 : string #显示在客户端上的文字
        extraData 2 : string #json字符串，用于显示额外的信息，如果不需要显示，该值为nil
    }
}

#获得解绑newSpreader信息
#GET_UNBIND_NEWSPREADER_INFO
getUnbindNewSpreaderInfo 277 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        newSpreader 0 : string #用户邀请码
        costItemID 1 : integer #付费解绑消耗道具ID，rmb为106，定义在item_conf
        costItemNum 2 : string #付费解绑消耗道具数量
        coldDownTime 3 : integer #解绑冷却时间，天
        lastUnbindTime 4 : integer #上次解绑的时间戳，os.time()
        err             5 : string  #错误信息，当该字符串不为空时，则不允许解绑，客户端弹出提示，展示相应错误信息
        mallID          6 : integer #解绑支付的mallID
    }
}

#解绑newSpreader
#UNBIND_NEWSPREADER
unbindNewSpreader 278 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        result 0 : integer #是否成功，定义在head_file.resultCode
        isNeedPay 1 : integer #是否需要付费，0否，1是
        resultText 2 : string  #展示在客户端上的文字
    }
}

#获取累计玩家数量达标奖励
#GET_USER_GAMES_REACH_AWARD
getUserGamesReachAward 280 {
    request {
        configID 0 : integer #奖励配置ID
    }
    response {
        result 0 : integer #成功或失败，定义在head_file.resultCode
        resultText 1 : string #显示在客户端上的文字
        extraData 2 : string #json字符串，用于显示额外的信息，如果不需要显示，该值为nil
    }
}

#获得抽奖配置
#GET_ITEM_RAFFLE_LIST
.raffleList {
    configID 0 : integer  #抽奖结果ID
    award 1 : *itemStruct  #奖励的道具，可能有多种，因此用数组(itemStruct结构中只有itemId与num有用)
    configAmount 2 : integer #该抽奖配置的库存，无限为-1
}
getItemRaffleList 290 {
    request {
        goodsID 0 : integer #抽奖的道具ID
    }
    response {
        raffleList 0 : *raffleList #抽奖列表
        cost       1 : integer     #抽奖消耗道具的数量
    }
}

#道具抽奖
#ITEM_RAFFLE
itemRaffle 291 {
    request {
        goodsID 0 : integer #抽奖的道具ID
    }
    response {
        raffleID 0 : integer #抽奖结果ID，为-1表示系统异常，抽奖失败
        resultText 1 : string #错误结果，raffleID为-1时显示
    }
}

#生成订单号
#GET_OUT_TRADE_NO
getOutTradeNo 292 {
    request {
        type 0 : string #支付渠道，定义在headFile.payTypeName
        mallID 1 : integer #商品表ID
    }
    response {
        outTradeNo 0 : string #订单号，生成失败返回空字符串
        key 1 : string #notifyPaySuccess协议中用于生产签名的key
    }
}

#通知服务端支付成功
#NOTIFY_PAY_SUCCESS
notifyPaySuccess 293 {
    request {
        outTradeNo 0 : string #支付渠道，定义在headFile.payTypeName
        sign 1 : string #签名 md5(outTradeNo..timestamp..userID..key) 小写
        timestamp 2 : integer #时间戳
    }
    response {
        result 0 : integer #是否成功，定义在head_file.resultCode ok or fail
        resultText 1 : string #如果充值失败，提示在客户端上的文字
    }
}



#获取黑名单列表
getBlackList 300 {
    request {
    
    }
    response {
        blackList 0 : *userInfo     #黑名单列表  失败或无黑名单为nil
        maxUserNumber 1 : integer   #最大记录用户数量              
    }
}

#添加黑名单
setBlackList 301 {
     request {
        blackInfo 0 : userInfo      #添加目标信息 userID nickName avatarID level code 
    }
     response {   
        result 0 : integer          #添加结果   0 : 添加成功  1：添加失败 2：已在黑名单中
        userInfo 1 : userInfo       #用户数据      
    }   
}

#删除黑名单
deleteBlackList 302 {
     request {
        userID 0 : integer          #
        code 1 : integer            #要添加的ID
    }
     response {
        result 0 : integer          #结果  0 : 删除成功 1：失败      
    }
}

#获取对手记录
getRecentPlayerList 303 {
    request {
    
    }
    response {
        playerList 0 : *userInfo    #无对手为 nil 
    }
}

#根据code 获取黑名单 code
getBlackListByCode 304 {
    request {
        codeList 0 : *integer
    }
    response {
        blackCodeList 0 : *integer    #返回在黑名单中的code列表 都不在黑名单为nil 
    }
}


#checkIn KF.QIN 2017.2.20
checkIn 305 {
   request {                        
       
    }
    response {
        check 0 : integer    # 1 签到成功 2 已经签到 3 出错
    }
}

#统计
#STATISTICS
statistics 306 {
    request {
        name 0 : string     # 统计项名字
        extra 1 : string    # 额外信息（json字符串）
    }
    response {
        result 0 : string   #预留参数，可不传
    }
}

#获取任务列表
#GET_MISSION_LIST
.missionList {
    configID 0 : integer  #任务配置ID
    icon 1 : string       #任务图标文件名，xxx.png
    name 2 : string       #任务名称
    award 3 : *itemStruct #奖励的道具，该字段只有itemId与num有效
    stateID 4 : integer   #任务状态ID，定义在headFile.missionStateID
    curNum 5 : string     #当前任务进度，考虑到今后不同的任务可能会有不同的数据类型，因此使用字符串
    targetNum 6 : string  #达成任务需要的数量，考虑到今后不同的任务可能会有不同的数据类型，因此使用字符串
    gotoMissionBtnType 7 : string #做任务按钮的类型，进入的房间不同的房间，null:不进入任何房间，rate：进入倍率，match：进入比赛列表界面，createNewSelf：进入包厢建桌界面，joinNewSelf进入包厢加入房间界面，lobby：进入大厅，比赛具体房间名，例如:RM_1_F_1
    extra 8 : string      #额外扩展参数，预留字段，不需要时为空字符串，如有，则为json字符串
    typeID 9 : integer    #任务类型，定义在headFile.missionType
    info 10 : string      #任务信息，描述
    sortNum 11 : integer  #排序值，越小越靠前
}
getMissionList 350 {
    request {
        userID 0 : integer #用户ID
    }
    response {
        missionList 0 : *missionList  #任务列表
    }
}

#领取任务奖励  客户端暂时不需要接该协议
#RECEIVE_MISSION_AWARD
receiveMissionAward 351 {
    request {
        configID 0 : integer #任务配置ID
    }
    response {
        result 0 : integer #是否领取成功，定义在head_file.resultCode
        resultText 1 : string #领取失败的提示
        gain 2 : *itemStruct #获得的道具变化量，该字段只有itemId与num有效，领取失败时该字段为空表
        fact 3 : *itemStruct #变化后的道具数量，该字段只有itemId与num有效，领取失败时该字段为空表
    }
}

#客户端进行一次分享任务
#SHARE_GAME_MISSION
shareGameMission 352 {
    request {
        missionShareType 0 : string #任务分享类型，定义在h.missionShareTpye
        extra 1 : string #额外参数，可以不传，若有则为json字符串，具体内容根据任务而定
    }   
    response {
        result 0 : integer #是否弹出领奖提示，定义在head_file.resultCode
        resultText 1 : string #文字提示
    }
}

################################################################################
# 私人场建桌不打牌相关协议
################################################################################

# 私人场已创建桌子的信息
.selfRoomCreatedDeskInfo {
    deskPW 0 : string                  # 房间号
    createConf 1 : createDeskInfo       # 牌局规则
    remainCount 2 : integer             # 剩余局数
    totalCount 3 : integer              # 总局数
    agentInfos 4 : *agentInfoSelfRoom   # 桌上用户的数据
    state 5 : integer                   # headFile.roomSelfDeskState
    pastTime 6 :integer                 # 自动解散时间
}

# 获得已建房间的数据
getSelfRoomCreatedList 307 {
    request {
        index 0 : integer       # 从多少索引开始查询, 1 开始计数
        length 1 : integer      # 请求
    }
    response {
        createdDeskInfos 0 : *selfRoomCreatedDeskInfo
    }
}

# 快速建桌, 建桌不打牌
quickCreateSelfDesk 308 {
    request {
        createConf 0 : createDeskInfo       # 建桌配置
    }
    response {
        result 0 : integer      # headFile.createSelfDeskResult 返回结果码
        reason 1 : string       # 在失败的情景下, 错误原因, 如果存在该字段, 优先显示该字段内容, 否则以结果码描述显示
        deskPW 2 : string       # 房间号
    }
}

# 快速销毁桌子
quickDestroyDesk 309 {
    request {
        deskPW 0 : string       # 房间号
    }
    response {
        result 0 : integer      # headFile.destroyDeskResult 返回结果码
        reason 1 : string       # 在失败的情景下, 错误原因, 如果存在该字段, 优先显示该字段内容, 否则以结果码描述显示
    }
}

# 批量快速建桌
batchQuickCreateSelfDesks 310 {
    request {
        createConf 0 : createDeskInfo       # 建桌配置
        num 1 : integer                     # 建桌的数量
    }
    response {
        result 0 : integer      # headFile.createSelfDeskResult 返回结果码
        reason 1 : string       # 在失败的情景下, 错误原因, 如果存在该字段, 优先显示该字段内容, 否则以结果码描述显示
    }
} 


#interactiveExpression KF.QIN 2017.7.14
.expression {
    itemId 0 : integer    # goodsID 物品ID    
    cost 1 : integer     # 消耗的券
    itemName 2 : string  #  物品名称
    itemInfo 3 : string  #  物品相关介绍信息
    itemType 4 : integer  #  动画类型
    intervers 5 : integer  #  间隔时间(秒)
}

requestInteractiveExpression 311 {
    request {
    }
    response {
    expressionList 0 : *expression
    }
}

sendInteractiveExpression 312 {
    request {
        fromSeatIndex 0 : integer   # 发送者的座位次序
        toSeatIndex 1 : integer     # 目标者的座位次序
        itemId 2   :   integer       # goodsID 物品ID 
        num 3   :   integer         # 发送表情的数量（预留）
    }
    response {
        result 0 : integer      #  headFile.interactiveExpression 返回结果码
        reason 1 : string       # 在失败的情景下, 错误原因
    }
}

#获得拉起H5页面的url
getH5GameUrl 313 {
    request {
        gameID 0 : integer #游戏类型 headFile.GAME_ID
    }
    response {
        url 0 : string  #url
    }
}

# 新私人场四人模式下一局
getSelfRoomNextGame 315 {
    request {
        deskPW 1 : integer          #房间号
    }
    response {
        agentInfos 1 : *agentInfoSelfRoom
    }
}


# 获得小游戏的开启权限
# strPermission: { "isOpenNiuNiu": true, "isOpenHongZhong": true, "isOpenPaoDeKuai": true, "isOpenZhuaWaWa": true, "isOpenMining": true }
getMiniGamesPermission 320 {
    request {
    }
    response {
        strPermission 0 : string     # 权限开启配置
    }
}

#获得小游戏配置  #GET_MINI_GAMES_CONF  LOBBY_SERVER
.miniGameConf {
    gameID 0 : integer  #小游戏ID
    name 1 : string #名称
    icon 2 : string #图标地址
    isShow 3 : integer # 是否展示
    isNative 4 : integer # 是否本地
    showPlace 5 : integer # 展示的位置，定义在headfile里的 MiNiShowPlace
    isH5Game 6 : integer #是否是H5游戏
}
getMiniGamesConf 321 {
    request {

    }
    response {
        miniGameConf 0 : *miniGameConf #小游戏配置
    }
}

# !!!! 450 - 500 预留给俱乐部
#俱乐部房间玩家信息
.clubRoomPlayerInfo {
    seatIndex 0 : integer       # 座位号
    userID 1 : integer          # 用户ID
    thirdConf 2 : thirdInfo     # 第三方信息
    nickName 3 : string         # 昵称
    readyState 4 : integer      # 准备状态, 准备 1  未准备 2
    code 5 : integer            # 用户另外的唯一标志
    avatarID 6 : integer        # 用户头像 ID
    isOnline 7 : boolean        # 是否在线的标识
}

#俱乐部房间规则
.clubRoomRule {
    roomMaxNumber 0 : integer   # 房间最大人数
    roomRuleStr 1 : string      # 房间规则串
}

#俱乐部单个房间信息
.clubRoomNodeInfo {
    roomState 0 : integer       # 房间的状态（房间当前状态(1.空 2.缺 3.满未战 4.战斗中)
    roomID 1 : string           # 房间号 
    roomType 2 : string         # 房间类型 deskCostType
    preRoomCount 3 : integer    # 当前 游戏的局数
    playerList 4 : *clubRoomPlayerInfo  # 单个房间 多个玩家信息
    rule 5 : clubRoomRule       # 房间规则
    maxRoomCount 6 : integer    # 游戏的总局数
}

#俱乐部信息
.clubInfo{
    clubID 0 : string                          #俱乐部ID
    clubName 1 : string                        #名称俱乐部
    gameName 2 : string                        #游戏名称
    gameIconURL 3 : string                     #游戏图标地址
    clubCreatorName 4 : string                 #创建人
    clubCreatedTime 5 : string                 #创建时间
    preMemberNumber 6 : integer                #当前成员数
    maxMemberNumber 7 : integer                #最大成员数
    onlineMemberNumber 8 : integer             #在线成员数
    type 9 : integer                           #1.用户创建的, 2.用户加入的, 0.未加入。
    clubRemarks 10 : string                    #俱乐部的备注
    isAutoCreateRoom 11 : integer              # 是否自动开房(1开启自动开房，0关闭自动开房)
    gameID 12 : integer                        # 子游戏ID
}

#一个俱乐部的房间信息
.oneClubRoomInfo {
    club 0 : clubInfo         # 俱乐部对应的游戏类型
    permission 1 : integer      # 是否是俱乐部创建者 权限（身份）  MASTER=1(主席),MANAGER=2(副主席),MEMBER=3(成员)
    ruleSettingTemplate 2 : string  # 房间规则
    roomList 3 : *clubRoomNodeInfo  # 单个俱乐部, 多个房间的信息, 数组形式
    roomNumberLimit 4 : integer  # 俱乐部房间数目上限
}

# 获取一个俱乐部的信息(房间列表等)
getOneClubInfo 450 {
    request {
        clubID 0 : string   # 俱乐部ID
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        clubRoomInfo 2 : oneClubRoomInfo # 一个俱乐部的信息
    }
}

#俱乐部可解散房间信息
.canDismissClubRoomInfo {
    roomID 0 : string          # 房间ID
    curPlayerNum 1 : integer   # 当前房间玩家数量
    roomMaxNumber 2 : integer   # 房间最大玩家数量
}

#获取可解散的空或缺人的房间列表
getCanDismissClubRoomList 451 {
    request {
        clubID 0 : string   # 俱乐部ID
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        canDismissClubRoomList 2 : *canDismissClubRoomInfo # 一个俱乐部的信息
    } 
}

#俱乐部解散房间
clubDismissRoom 452 {
    request {
        clubID 0 : string   # 俱乐部ID
        roomIDs 1 : *string   # 房间号
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    } 
}

#俱乐部设置自动开房开启或者关闭
setAutoCreateRoomOpenOrClose 453 {
    request {
        clubID 0 : string   # 俱乐部ID
        isAutoCreateRoom 1 : integer   # 是否自动开房(1开启自动开房，0关闭自动开房)
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    } 
}

#俱乐部建房消耗
.createClubRoomCost {
    itemID 0 : integer      # 消耗道具
    itemNum 1 : integer     # 消耗道具数量
}

#俱乐部建房局数对应道具消耗
.createClubRoomCostToGameCount {
    selectCount 0 : integer         # 房间游戏局数
    roomItemCost 1 : *createClubRoomCost # 房间道具消耗
}

#俱乐部房间类型消耗
.clubRoomCostToRoomType {
    roomType 0 : integer            # 房间类型 1 AA； 3 会长
    selectCountList 1 : *createClubRoomCostToGameCount    # 不用局数消耗列表
    bullRoundCost 2 : *createClubRoomCostToGameCount      # 斗公牛圈数消耗
}

#创建俱乐部房间规则
.createClubRoomRuleInfo {
    clubID 0 : string               # 俱乐部ID
    clubName 1 : string             # 俱乐部名称
    gameName 2 : string             # 游戏名称
    isAutoCreateRoom 3 : integer    # 是否自动开房 (1开启自动开房，0关闭自动开房)
    roomRule 4 : string             # 房间规则串
}

#获取俱乐部创建房间规则,点击俱乐部的管理按钮的返回
getClubCreateRoomRuleInfo 454 {
    request {
        clubID 0 : string   # 俱乐部ID
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        clubRoomRuleInfo 2 : createClubRoomRuleInfo # 俱乐部房间规则
        clubRoomCostToGameCount 3 : *clubRoomCostToRoomType # 俱乐部房间不同房间类型对应的消耗列表
        canDismissRoomList 4 : *canDismissClubRoomInfo  # 俱乐部可解散的房间列表
    }     
}

#俱乐部手动创建房间
clubManualCreateRoom 455 {
    request {
        clubID 0 : string               # 俱乐部ID
        count 1 : integer               # 创建房间数量
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        roomIDList 2 : *string  # 俱乐部房间ID列表
    } 
}

#申请加入俱乐部
applyJoinClub 456 {
    request {
        clubID 0 : string               # 俱乐部ID
        message 1 : string              # 申请留言（无此功能，该字段暂未用到）
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        isInClub 2 : integer    # 玩家是否在俱乐部中, 1 在, 其他不在
    }
}


#俱乐部成员信息
.clubMemberInfo {
    userID 0 : integer          # 成员ID
    code 1 : integer            # 客户端显示的ID
    nickName 2 : string         # 昵称
    permission 3 : integer      # 身份1(主席),(副主席),MEMBER=3(成员)
    introducer 4 : string       # 介绍人
    introducerPermission 5 : integer    # 介绍人身份1(主席),(副主席),MEMBER=3(成员)
    todayWinTime 6 : integer    # 今日赢次数
    todayScore 7 : integer      # 今日总战绩
    joinClubTime 8 : string     # 加入俱乐部时间
    lastLoginTime 9 : string    # 最近登录时间
    thirdConf 10 : thirdInfo    # 第三方信息
    avatarID 11 : integer       # 用户头像 ID
    isOnline 12 : integer       # 玩家是否在线 1 在线， 0 不在线
	gameTimes 13 : integer      # 日场次
}

# (只有主席有此功能) 1. 获取俱乐部成员信息列表  2. 搜索查找具体成员的信息
getClubMemberInfoList 457 {
    request {
        clubID 0 : string               # 俱乐部ID, (searchKey不传的情况下， 查找整个俱乐部成员的信息)
        searchKey 1 : string            #  searchKey(成员ID或昵称) 和 clubID 一起传
        index 2 : integer               # 表示从成员的多少个开始请求
        count 3 : integer               # 一次固定请求的数据,默认请求40个成员的数据
        sort 4 : integer                # 请求服务器的数据排列方式 1 升序；0 降序
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        memberInfoList 2 : *clubMemberInfo # 成员信息列表
    }    
}

.clubApplyMember {
    clubID 0 : string               # 俱乐部ID
    clubName 1 : string             # 俱乐部名称
    requestTime 2 : string          # 申请时间
    code 3 : integer                # 成员ID
    nickName 4 : string             # 昵称
    thirdConf 5 : thirdInfo         # 第三方信息 
    message 6 : string              # 申请留言（无此功能，该字段暂未用到）
    avatarID 7 : integer            # 用户头像 ID
}

#获取俱乐部待审核成员列表
getClubApprovalMembers 458 {
    request {
        clubID 0 : string       # 俱乐部ID
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
        applyMemberList 2 : *clubApplyMember # 成员信息列表
    }
}

#俱乐部审核成员
clubApprovalMember 459 {
    request {
        clubID 0 : string       # 俱乐部ID
        status 1 : integer      # 1 同意 0 拒绝 
        introducer 2 : string   # 介绍人昵称
        introducerCode 3 : integer # 介绍人Code
        code 4 : integer # 申请人的code
        replyMessage 5 : string

    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    }  
}

#踢掉俱乐部成员
kickClubMember 460 {
    request {
        clubID 0 : string       # 俱乐部ID
        code 1 : integer        # 踢掉成员code
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    }     
}

#设置俱乐部成员身份
setClubPermission 461 {
    request {
        clubID 0 : string       # 俱乐部ID
        code 1 : integer        # 成员code
        permission 2 : integer  # 权限（身份）  MASTER=1,MANAGER=2,MEMBER=3 
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    }   
}

#修改俱乐部介绍人
modifyClubIntroducer 462 {
    request {
        clubID 0 : string       # 俱乐部ID
        code 1 : integer        # 目标userID
        introducer 2 : string   # 介绍人昵称 
        introducerCode 3 : integer # 介绍人Code
        introducerPermission 4 : integer  # 介绍人的权限  MASTER=1,MANAGER=2,MEMBER=3 
    }
    response {
        result 0 : integer      # headFile.resultCode 返回结果码
        reason 1 : string       # 文字提示
    }   
}

#获取俱乐部红点提示信息
getClubRedPointHint 463 {
    request {
        clubID 0 : string       # 俱乐部ID
    }
    response {
        result 0 : integer          # headFile.resultCode 返回结果码
        reason 1 : string           # 文字提示
        redPointHint 2 : integer    # 是否有红点提示 1 有红点, 0 无红点
    }   
}

#清理俱乐部红点提示信息
cleanClubRedPointHint 464 {
    request {
        clubID 0 : string       # 俱乐部ID
    }
    response {
        result 0 : integer          # headFile.resultCode 返回结果码
        reason 1 : string           # 文字提示
    }   
}

#获取所有俱乐部（包括加入的和自己创建的）红点提示信息
getAllClubRedPointHint 465 {
    request {
    }
    response {
        result 0 : integer              # headFile.resultCode 返回结果码
        reason 1 : string               # 文字提示
        redPointClubList 2 : *string    # 红点俱乐部列表 
    } 
}

#自己主动退出俱乐部，只有成员和副主席可以自主退出， 主席不能够退出
selfQuitClub 466 {
    request {
        clubID 0 : string       # 俱乐部ID
    }
    response {
        result 0 : integer          # headFile.resultCode 返回结果码
        reason 1 : string           # 文字提示
    } 
}

#查看俱乐部主席某种道具数量
getClubMasterItemNum 467 {
    request {
        clubID 0 : string       # 俱乐部ID
        itemID 1 : integer      # 道具ID
    }
    response {
        result 0 : integer          # headFile.resultCode 返回结果码
        reason 1 : string           # 文字提示
        itemNum 2 : integer         # 道具数量
    }   
}

#检查俱乐部的房间是否可以加入
checkClubRoomCanJoin 468 {
    request {
        clubID 0 : string       # 俱乐部ID
        roomID 1 : string       # 房间号
    }
    response {
        result 0 : integer          # 0 可以加入  1 不可以加入
        reason 1 : string           # 文字提示
    } 
}


createClub 469 {
    request {
        clubName 0 : string                 # 要创建的俱乐部名称
        gameId 1 : integer                  # 俱乐部所属的游戏ID
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        club 2 : clubInfo                   # 返回的俱乐部信息
    }
}

getClubList 470 {
    request {
        type 0 : integer                    #0.所有俱乐部（包括用户创建的和加入的), 1.用户创建的。
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        clubs 2 : *clubInfo                 # 返回的俱乐部信息列表
    }
}

clubCheckCanDissolution 471 {
    request {
        clubID 0 : string                  #俱乐部ID
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}

clubGetVerificationCode 472 {
    request {
        clubID 0 : string                  #俱乐部ID
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}

dissolutionClub 473 {
    request {
        clubID 0 : string                  #俱乐部ID
        authCode 1 : string                 #解散俱乐部短信验证码
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}

searchClub 474 {
    request {
        searchKey 0 : string                # 关键字 名称/ID
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        clubs 2 : *clubInfo                 # 返回的俱乐部信息列表
    }
}

queryGameRecords 475 {
    request {
        clubID 0 : string                  # 俱乐部ID
        length 1 : integer                  # 查询的记录长度
        beginTime 2 : string                # 查询的起始时间; 如果不传这个参数, 那么需要最新的数据;
        isCreator 3 : integer               # 是否是创建者查看战绩，1是，nil否
        after   4 : integer                 # 是否查询beginTime时间之后的战绩，1是，nil否
        searchCode 5 : string               # 查询的号码，6位长度是房间号deskPW，8位长度是玩家code，玩家未填写时则不传
        searchTime 6 : string               # 查询时间，例：2017-09-19 如果该字段存在，则查询这一天的战绩，如果该字段为nil，则查询beginTime之前的战绩
        searchType 7 : integer              # 筛选类型，定义在headFile.groupAdminSelfRoomRecordSearchType，0查询全部数据，1查询大赢家，2查询桌主
        index 8 : integer                   # 从第几条数据开始读，通常填上一次请求之后服务端返回的值，没有数据时传0
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        datas 2 : *selfRoomRecordData       # 返回的记录,以时间的降序存储
        index 3 : integer                   # 从第几条数据开始读，通常为下一次请求时，客户端的index值，没有数据时传0
    }
}

# 俱乐部管理员身份信息
.clubManager {
    nickName 0 : string
    code 1 : integer
    permission 2 : integer   # 身份
}

#获取指定俱乐部的管理员（包括主席）
getClubManagers 477 {
    request {
        clubID 0 : string                  # 俱乐部ID
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        managers 2 : *clubManager           # 俱乐部管理员
    }
}


#新包奖励 enumKeyAction: GET_UPDATE_AWARD enumEndPoint:LOBBY_SERVER 
getUpdateAward 478 {
    request {
        userID 0 : integer      # userID
        version 1 : string      # 版本号
        isLogin 2 : integer    # 0是登录，1是点击领奖
        platform 3 : integer    # 1 android 2 ios
    }
    response {
        resultCode 0 : integer    # 请求失败或成功 headFile.resultCode
        resultText 1 : string     # 请求失败或成功信息
        isUpdate 2 : integer     # 是否下载更新 0下载，1已经下载了, 2领过奖励了
        title 3 : string         # 标题
        content 4 : string       # 内容
        propList 5 : *prop      # 奖励道具列表
        endTime 6 : integer     # 活动结束时间
    }
}

# 修改俱乐部的备注信息
modifyClubRemarks 479 {
    request {
        clubID 0 : string                   # 俱乐部ID
        remarks 1 : string                  # 俱乐部新的备注
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}

.recordSimpleAgentByDay {
    userID 0 : integer                      # 成员ID
    code 1 : integer                        # 客户端显示的ID
    nickName 2 : string                     # 昵称
    permission 3 : integer                  # 身份1(主席),(副主席),MEMBER=3(成员)
    introducer 4 : string                   # 介绍人
    introducerPermission 5 : integer        # 介绍人的权限  MASTER=1,MANAGER=2,MEMBER=3
    avatarID 6 : integer                    # 头像ID
    scoreCount 7 : integer                  # 子数
    winnerCount 8 : integer                 # 大赢家次数
	thirdConf 9 : thirdInfo                 # 第三方信息
	gameTimes 10 : integer                  # 日场次
}

queryUserRecordsByDay 480 {
    request {
        clubID 0 : string                   # 俱乐部ID
        searchTime 1 : string               # 查询时间，例：2017-09-19 如果该字段存在，则查询这一天的战绩，如果该字段为nil，则查询beginTime之前的战绩
        searchKey 2 : string                # 8位长度是玩家code或者玩家昵称，玩家未填写时则不传
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        datas 2 : *recordSimpleAgentByDay   # 返回的记录,以时间的降序存储
    }
}

# 俱乐部邀请成员
clubInviteMember 481 {
    request {
        clubID 0 : string                   # 俱乐部ID
        code 1 : integer                    # 被邀请的玩家code
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}


# 获取指定ID的玩家信息
getUserInfoByCode 482 {
    request {
        code 1 : integer                    # 搜索玩家的code
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        info 1 : userInfo                   # （该协议只用到userInfo结构体的nickName）
        reason 2 : string                   # 文字提示
    }
}

# 获得支付数据
getPayData 483 {
    request {
        kind 0 : integer        # 支付类型
        mallID 1 : integer      # 商品 ID
    }
    response {
        result 0 : integer      # 返回结果
        reason 1 : string       # 失败原因
        data 2 : string         # 对应支付类型需要的数据
    }
}

#获取玩家俱乐部介绍人信息
getClubIntroducerInfo 484 {
    request {
        clubID 1 : string                  # 俱乐部ID
        code 2 : integer                   # 玩家code
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        introducerInfo 1 : clubMemberInfo   # 介绍人信息
        reason 2 : string                   # 文字提示
    }
}

# 保存俱乐部房间规则
saveClubRoomRule 485 {
    request {
        clubID 0 : string                   # 俱乐部ID
        roomRule 1 : string                 # 房间规则的 json 字符串
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
    }
}

# 俱乐部游戏信息
.clubGameInfo {
    name 0 : string                     # 游戏名
    gameID 1 : integer                  # 俱乐部所属的游戏ID
    gameIconURL 2 : string              # 游戏图标
}

# 获取可创建俱乐部的子游戏列表
getClubGameList 486 {
    request {
    }
    response {
        result 0 : integer                  # headFile.resultCode 返回结果码
        reason 1 : string                   # 文字提示
        clubGameList 2 : *clubGameInfo      # 返回的记录,以时间的降序存储
    }
}

# 地理位置信息
.GeographyCoordinate {
    longitude 0 : string    # 经度
    latitude 1 : string     # 纬度
}
# 发送地理位置坐标信息
sendCoordinateInfo 601 {
    request {
        coordinate 0 : GeographyCoordinate
    }
    response {
    }
}
# 查询地理位置坐标信息
findCoordinateInfo 602 {
    request {
        userIds 0 : *integer
    }
    response {
        coordinates 0 : *GeographyCoordinate
    }
}

.serverInfoH51 {
    serverID 0 : integer      #--服务ID
    serverName 1 : string     #--服务名
}

# h5测试用协议
testS2C 603 {
    request {
    }
}

# 查询地理位置坐标信息, 使用 code
findCoordinateInfoCode 605 {
    request {
        codes 0 : *integer
    }
    response {
        coordinates 0 : *GeographyCoordinate
    }
}

getJsApiTicket 606 {
    request {
    }
    response {
        ticket 0 : string
    }
}

getWechatGameSessionkey 607 {
    request {
        code 0 : string
    }
    response {
        session_key  0 : string 
    }
}

#key_action GET_WECHAT_LOCTION 411
#微信小游戏获得玩家地理位置
getWechatLoction 608 {
    request {
        longitude 0 : integer #经度
        latitude 1 : integer  #纬度
    }
    response {
        location  0 : string 
    }
}


]].. niuniu_protoc2s .. pdk_proto.c2s)

proto.s2c = sprotoparser.parse ([[

.package {                    
	type 0 : integer 
	session 1 : integer
}

# 报名的消费类型, Zhenyu Yao
.enrollCost {
    itemId 0 : integer      # 道具的 ID
    num 1 : integer         # 需要数量
}

.pickCardList {
	cardNum 0 : integer
	agentID 1 : integer
}

.handCardList {
    cardNum 0 : *integer
}


#第三方信息
.thirdInfo {
    thirdAvatarID 0 : string                #第三方头像地址   
    thirdNickName 1 : string                #第三方昵称地址
    thirdSex 2 : string                     #普通用户性别，1为男性，2为女性  
    thirdPartUnionID 3 : string             #第三方平台的 ID 
    longitude 4 : string                    #经度
    latitude 5 : string                     #纬度
}

.agentInfo {           
	agentId 0 : integer     #   1 到 3 
	nickName 1 : string     #	昵称
	level 2 : integer	    #	等级
	exp 3 : integer		    #	经验值(百分比)
	goldCoin 4 : integer    #	金币
	goldChange 5 : integer  #	金币变化
	avatarID 6 : integer    #   头像信息
	location 7 : string     #	位置信息
    winInfo 8 : integer     #   连胜信息  -1 为被终结  0 为无连胜  >0 为连胜次数
    automatic 9 : integer   #   是否掉线
    userID 10 : integer     #   userID
    isBlackTag 11 : integer     #   是否有黑名单标示  1 为是 nil 为否
    code 12 : integer           #   黑名单 ID
    isInBlackList 13 : integer  #   是否是获取方的黑名单用户  1 为是  nil 为否
    isNovice 14 : integer       #   是否是新人 1 为 是 nil 为否
    thirdConf 15 : thirdInfo    #   第三方信息
}

# 名堂番数
.MingTangFanShu {
    kind 0 : integer        # 类型, 在 headFile.MING_TANG_FAN_SHU_KIND 定义
    num 1 : integer         # 数值
}

#配桌完成
#发送用户信息
sendInfo 1 {
	request {
		info 0 : *agentInfo
		selfID 1 : integer
		rate 2 : integer
        deskID 3 : integer     
        gameCode 4 : integer    #区分不同局的标示  每局唯一并且不相同        
	}
}

#发送手牌
setHandCards 2 {
	request {
		pickCards 0 : *pickCardList
		handCards 1 : *integer
		dealerID 2 : integer 
		leftCardCount 3 : integer
        deskID 4 : integer     
        shuXingID 5: integer     #数醒座位号
        selfShuXing 6 : integer      #是否是自己数醒   1为是 nil为否
	}
}

heartbeat 3 {
	# mingyuan.xie add heartbeat timer 2015.10.12
	request {
		heartbeatTimer 0 : integer
	}
}

#通知出牌
notifyPlayCard 4 {
	request {
		agentId 0 : integer
		msgTag 1 : integer
        deskID 2 : integer     
	}
}

#显示出牌
doPlayCard 5 {
	request {
		agentId 0 : integer
		cardId 1 : integer
        deskID 2 : integer 
	}
}

#取消动作
cancelAct 6 {
	request {
		act 0 : integer
        deskID 1 : integer
	}
}

#倒计时
countDown 7 {
	request {
		curAgentId 0 : integer
		time 1 : integer
		downType 2 : integer
		curCardId 3 : integer
        deskID 4 : integer
        hideCard 5 : integer    #  1 ： 将中间的牌隐藏
	}
}

#通知选择
notifySelect 8 {
	request {
		actName 0 : *integer
		cardId 1 : integer
		agentId 2 : integer
		msgTag 3 : integer
        deskID 4 : integer
        hideCard 5 : integer    # 1 ： 将中间的牌隐藏
        discard 6 : integer   # 1 :  弃牌按钮高亮
        mingtangfanshu 7 : *MingTangFanShu          # 名堂番数 王钓王闯王炸（王）
	}
}

#执行动作
doAction 9 {
	request {
		agentId 0 : integer
		actionId 1 : integer
		cardId 2 : integer  
		details 3 : *integer  # {吃牌时的数据}     {胡牌的类型,飞牌的方向(3为扫穿胡)}   
        deskID 4 : integer
        showHandCards 5 : *integer                  #胡牌时刷新手牌，只发给胡的玩家
        hideCard 6 : integer    # 1 ： 将中间的牌隐藏
        mingtangfanshu 7 : *MingTangFanShu          # 名堂番数 王钓王闯王炸（王）
	}
}

#通知并执行丢牌 
notifyDiscard 10 {
	request {
		agentId 0 : integer
		cardId 1 : integer
        audioIndex 2 :integer
        deskID 3 : integer
	}
}

#摸牌+扫
.SweepType {
	typeId 0 : integer
	details 1 : integer	#过扫ID   	是否重招
}

moCard 11 {
	request {
		agentId 0 : integer     
		cardId 1 : integer		# 空值表示不显示
		sweepList 2 : SweepType
        deskID 3 : integer
	}
}


#点炮
pointGun 12 {
	request {
		agentId 0 : integer
        deskID 1 : integer
	}
}

#黄庄
huangZhuang 13 {
	request {
		agentId 0 : integer
        deskID 1 : integer
	}
}

 #翻醒消息
.fangXingList {
		cardId 0 : integer
		xingCount 1 : integer
}

fanXing 14 {
	request {
		agentId 0 : integer          
		details 1 : *fangXingList
        deskID 2 : integer
	}
}

#胡牌后展示手牌和盖牌
.showCard {
	agentId 0 : integer
	handCardList 1 : *integer
	backCardList 2 : *integer    # 盖牌列表 第一个值为 cardId 第二个值为cardNum
}         
showCardAfterHu 15 {
	request {
		details 0 : *showCard   
        deskID 1 : integer
	}     
}

#结算
.cardList {                #胡牌的牌型  
	details 0 : *integer
}

#道具与相关值信息  
.prop {
    seatIndex 0 : integer       #座位号
    userID 1: integer           #用户ID
    propType 2 : integer        #道具类型
    propVal 3 : integer         #值
}      

#新人奖励
.noviceProp {
    showText 0 : string         #展示的文字内容 
    propCount 1 : *prop         #道具与相关值信息
}

# 胡的相关信息
.scoreConf {
    defen 1 : integer                       # 得分
    mingtangfanshu 2 : *MingTangFanShu      # 名堂番数
    isMaxScore 3 : integer                  # 得分是否封顶  1 为是 nil 为否
    totalCounts 4 : integer                 # 合计
}

settlement 16 {
	request {     
		huInfo 0 : *integer          # {胡舵,自摸,翻醒,总舵数，地胡，天胡，三笼五坎,倍率}
		huCardList 1 : *integer      #胡牌的牌型 每个牌型之间用 0 隔开
		huCountList 2 : *integer     #胡数列表  
		diCardList 3 :*integer     	 #底牌
		huAgentId 4 : integer        #胡家ID
		huCount 5 : integer			 #胡数
		pointGunId 6 : integer		 #点炮玩家ID
		agentInfo 7 :*agentInfo 	 #玩家信息
		huType 8 : integer           #胡的类型
		cost 9 : integer			 #服务费
        propCount 10 : *prop         #道具与相关值信息
        huCardAddress 11 : *integer  #胡牌的位置  第一个值为牌值  第二个值为所在胡牌牌型的列数
        finishTime 12 : integer      #牌局结束的时间
        deskID 13 : integer
        diCard 14 : *integer
        novicePropInfo 15 : *noviceProp   #新人奖励弹窗  nil 为无奖励
        scoreInfo 16 : scoreConf     #分数（名堂）信息
        kingValList 17 : *integer    #王牌值列表
	}
	
}

#发送底牌
sendDiCard 17 {
	request { 
		diCard 0 : *integer
        deskID 1 : integer
	}
}


# Begin: mingyuan.xie added 2015.8.28 -----

account 18 {
	request {
		deskID 0 : integer
		sessionCo 1 : integer
       
	}
}
# End  : mingyuan.xie added 2015.8.28 -----

#重招时将手中的四张牌放入桌子
doubleDuo 19 {                  
	request {
		seatIndex 0 : integer
		groupNum 1 : integer     		#放入桌子的组数
		putCardIdList 3 : *integer      #放入桌子的牌值 其他人放时为空表
        deskID 4 : integer        
	}
}

#插入王牌
insertKingCard 20 {
	request {
		seatIndex 0 : integer 
		cardId 1 : integer
		deskID 2 : integer 	
	}
}

#Begin: mingyuan.xie added 2015.11.02 -----
rankBack 55 {
	request {
		rankType 0 : integer    #排行榜类型
	}
}
#End  : mingyuan.xie added 2015.11.02 -----

#Begin: huangxiangrui added 2015.11.05 -----

#升级消息
#enumKeyAction:无       enumEndPoint:GAMEROOM_SERVER
levelUpMsg 56 {
    request {
        level    0 : integer   #等级
        avatarID 1 : integer   #头像ID
        award    2 : integer   #奖励
	}
}

#倍率变化
#enumKeyAction:无       enumEndPoint:GAMEROOM_SERVER
roomRateChange 57 {
    request {
        beforeRate    0 : integer   #之前的倍率
        afterRate     1 : integer   #之后的倍率
	}
}

#刷新金币消息
#enumKeyAction:CHANGE_GOLD_COIN       enumEndPoint:GAMEROOM_SERVER、LOBBY_SERVER、ROOM_MATCH_SERVER
changeGoldCoin  58 {
    request {
        goldCoin    0 : integer     #新的金币数
    }
}

#End  : huangxiangrui added 2015.11.02 -----

# 网络消息服务, Zhenyu Yao added 2015.11.11
netMessage 59 {
    request {
        pop 0 : integer
        msg 1 : string
        buttons 2 : *string
        scripts 3 : *string
    }
}

#发送未读邮件数给客户端  huang xiang rui 2015.11.16
#enumKeyAction:NEVER_READ_EMAIL       enumEndPoint:LOBBY_SERVER
sendNeverReadEmailAmount 60 {
    request {
        systemNoticeAmount 0 : integer          #未读系统公告邮件数量（系统公告邮件）
        emailAmount 1 : integer                 #未读系统邮件数量（普通邮件）
    }
}

.awardGoods {
	goodsTypeID 0 : integer     #物品类型
	amount 1 : integer	        #物品数量
}

#发送比赛成绩消息给客户端     huang xiang rui 2015.11.24
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
sendMatchResult 80 {
    request {
        order           0 : integer     # 名次
        time            1 : integer     # 比赛时间
        awardGoods      2 : *awardGoods # 奖励
        phase           3 : integer     # 比赛阶段，定义在head_file.MatchPhase中
        nickName        4 : string      # 玩家昵称
        matchTitle      5 : string      # 比赛名称
        extra           6 : string      # 额外信息，（json字符串），没有为空字符串
    }
}

#悬浮消息提示框  huang xiang rui 2015.11.24
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
toastMsg 81 {
    request {
        msg 0 : string #消息
        showTime 1 : integer #持续时间
    }
}


#本桌排名  huang xiang rui 2015.11.24
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
userInDeskRank 82 {
    request {
        userOrder       0 : integer       #玩家排名
        userIntegral    2 : integer       #玩家积分
    }
}

#决赛阶段（定局积分）等待配桌消息
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
finMatchWaitDesk 83 {
    request {
        userOrder       0 : integer       #玩家排名
        totalAmount     1 : integer       #总玩家数
        userIntegral    2 : integer       #玩家积分
        curRound        3 : integer       #当前第几轮决赛
    }
}

#预赛阶段（打立出局）等待配桌消息
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
preMatchWaitDesk 84 {
    request {
        userOrder       0 : integer       #玩家排名
        totalAmount     1 : integer       #总玩家数
        userIntegral    2 : integer       #玩家积分
    }
}

#每桌开始的消息框，告诉玩家前多少名晋级
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
#例如     预赛      前12名晋级      则title是预赛       msg是前12名晋级
matchStartMsgBox 85 {
    request {
        title           0 : string        #比赛阶段名称
        msg             1 : string        #消息
    }
}

#发送当前最高积分与最低积分给玩家
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
matchIntegralRange 86 {
    request {
        maxIntegral 0 : integer     #最高积分
        minIntegral 1 : integer     #最低积分
        riseIntegral 2 : integer    #晋级积分（第12名积分）
    }
}

.riseCondition {
    riseRule 0 : string     #晋级条件
    complete 1 : integer    #是否达成，0为达成，1为未达成，定义在head_file的resultCode
}

#比赛晋级消息
#enumKeyAction:未定       enumEndPoint:ROOM_MATCH_SERVER
matchRise 87 {
    request {
        riseCondition 0 : *riseCondition              #晋级条件达成情况
    }
}

#剩余未打完的桌子数
remainDeskNum 88 {
    request {
        remainDeskNum 0 : integer              #数量
    }
}

#刷新货币
#enumKeyAction:FLUSH_CURRENCY       enumEndPoint:LOBBY_SERVER
flushCurrency 89 {
    request {
        kGoldCoin 1 : integer   #老K金币
        kCoin     2 : string    #K币
        goldCoin  3 : integer   #字牌金币
        usefulKGoldCoin 4 : integer #可兑换的老K金币
        point           5 : integer #积分
    }
}

#刷新用户积分（非比赛）
#enumKeyAction:CHANGE_POINT       enumEndPoint:LOBBY_SERVER
changePoint  90 {
    request {
        value    0 : integer     #新的积分
    }
}

#救济金
#enumKeyAction:SEND_RELIEVE       enumEndPoint:LOBBY_SERVER
RelieveMsg 91 {
    request {
        result 0 : integer #救济金发放结果，定义在headFile.relieveResult
        useTimes 1 : integer #使用了多少次救济金
        totalTimes 2 : integer #每天有多少次使用次数
        minGoldCoin 3 : integer #领取救济金的下限
        relieveGoldCoin 4 : integer #救济金金额
    }
}

# 道具的数据结构
.itemStruct {
    itemId 0 : integer  # 道具的 ID
    num 1 : integer     # 数量
    userGoodsID 2 : integer # UserGoods表ID
    expireTime 3 : string   #过期时间
    maxOverlayNum 4 : integer  #最大叠加数，0为不限制
    obtainTime 5 : string  #获得道具时间
}

#刷新道具
#enumKeyAction:FLUSH_GOODS       enumEndPoint:LOBBY_SERVER
flushGoods 92 {
    request {
        itemInfo 0 : *itemStruct  #道具信息
    }
}

#询问是否需要复活
.itemGroup {
    amount 0 : integer  #道具的数量
    id     1 : integer  #道具的ID  定义在headFile.goodsTypeID
    text   2 : string   #道具的中文名
}
#enumKeyAction:ASK_REVIVE       enumEndPoint:ROOM_MATCH_SERVER
askRevive 93 {
    request {
        countDown 1 : integer   #倒计时，秒
        userRank   2 : integer    #当前玩家排名
        reviveItem 3 : *itemGroup  #复活需要的道具
        reviveCount 4 : integer   #剩余复活次数
        reviveMaxCount 5 : integer  #最大复活次数
        reviveIntegral 6 : integer  #复活积分
    }
}

#比赛阶段
.matchStage {
    phase      0 : integer       # 阶段
    lunNum     1 : integer       # 轮数
    juNum      2 : integer       # 局数
    riseRule   3 : *string       # 晋级规则
    riseNum    4 : integer       # 晋级人数
    matchTag   5 : integer       # 决赛或预赛，定义在head_file的matchTag中
}

# 比赛信息, Zhenyu Yao
.matchInfo {
    groupID 0 : integer     # 开始的 group ID
    result 1 : integer      # 正常返回 0, 否则返回错误码
    roomId 2 : integer      # 房间的 ID
    title 3 : string        # 房间的标题
    matchStage 4 : *matchStage  # 比赛阶段
    fullNum 5 : integer     # 比赛总人数
    curStageNum 6 : integer # 当前阶段
    matchType 7 : string    # 比赛类型
}

# 开始比赛. Zhenyu Yao, 2015.11.23
matchBeginMatch 100 {
    request {
        matchInfo 8 : matchInfo

        groupID 0 : integer     # 开始的 group ID
        result 1 : integer      # 正常返回 0, 否则返回错误码
        roomId 2 : integer      # 房间的 ID
        title 3 : string        # 房间的标题
        matchStage 4 : *matchStage  # 比赛阶段
        fullNum 5 : integer     # 比赛总人数
        curStageNum 6 : integer # 当前阶段
        matchType 7 : string    # 比赛类型
    }
}

# 报名比赛人数改变, Zhenyu Yao, 2015.11.23
matchEnrollChange 101 {
    request {
        curNum 0 : integer
        fullNum 1 : integer
    }
}

# 回合信息
.roundInfo {
    phase 0 : integer                # 比赛的阶段, 打立出局, 定局积分
    curLunNum 1 : integer            # 定局积分的轮数
}

# 开始新局时候的信息, Zhenyu Yao, 2015.11.24
matchNewRoundInfo 102 {
    request {
        roundInfo 1 : roundInfo             # 回合信息
        roundCount 2 : integer              # 第几局
        curRank 3 : integer                 # 当前排名
        maxRank 4 : integer                 # 最大排名
        matchBase 5 : integer               # 当前基数
        curMatchOutIntegral 6 : integer     # 当前淘汰积分
        title 7 : string                    # 比赛标题
        curStageNum 8 : integer             # 当前阶段
        roomId 9 : integer                  # 所在的房间 ID
    }
}

# 当前比赛的分数信息, Zhenyu Yao, 2015.11.24
matchScoresInfo 103 {
    request {
        matchBase 0 : integer               # 当前基数
        curMatchOutIntegral 1 : integer     # 当前淘汰积分
    }
}

# 当前排名和最大排名, Zhenyu Yao, 2015.11.24
matchRankInfo 104 {
    request {
        curNum 0 : integer      # 当前排名
        maxNum 1 : integer      # 比赛人数
    }
}

# 等待分配桌子, Zhenyu Yao, 2015.11.24
matchWaitAllotDesk 105 {
    request {
    }
}

# 等待其他桌子结束, Zhenyu Yao, 2015.11.24
matchWaitDesksFinish 106 {
    request {
        stageName 1 : string            # 比赛阶段名
        curStageNum 2 : integer         # 当前阶段
        integral 3 : integer            # 当前积分
        roundNum 4 : integer            # 定局积分的轮数
        riseRule 5 : *string            # 晋级规则
        curMatchOutIntegral 6 : integer # 当前淘汰积分
        deskRank 7 : integer            # 本桌排名
        remainDeskNum 8 : integer       # 剩余没打完的桌子数
        riseIconUrl 9 : string          # 晋级 Icon 的链接
        riseBgUrl 10 : string           # 晋级背景的链接
    }
}

# 回到比赛牌局, Zhenyu Yao, 2015.12.17
matchComeBackGame 107 {
    request {
        strData 0 : string   # 字符串数据
        roomId 1 : integer   # 房间的 ID
        matchType 2 : string # 比赛类型
    }
}

# 回到比赛等待, Zhenyu Yao, 2015.12.17
matchComeBackWait 108 {
    request {
        roomId 100 : integer                # 房间 ID
        matchType 101 : string              # 比赛类型

        phase 0 : integer                   # 阶段类型
        roundInfo 1 : roundInfo             # 回合信息
        roundCount 2 : integer              # 第几局
        curRank 3 : integer                 # 当前排名
        maxRank 4 : integer                 # 最大排名
        matchBase 5 : integer               # 当前基数
        curMatchOutIntegral 6 : integer     # 当前淘汰积分
        title 7 : string                    # 比赛标题
        maxIntegral 9 : integer             # 最大积分
        minIntegral 10 : integer            # 最小积分
        riseIntegral 11 : integer           # 晋级积分
        curStageNum 12 : integer            # 当前比赛阶段
        fullNum 13 : integer                # 最多人数
        matchStage 14 : *matchStage         # 比赛阶段详细信息
        integral 15 : integer               # 当前积分
        deskRank 16 : integer               # 桌排名
        remainDeskNum 17 : integer          # 剩余桌子的数量
        riseIconUrl 18 : string             # 晋级 Icon 的链接
        riseBgUrl 19 : string               # 晋级背景的链接
    }
}

# 服务器强制取消报名, Zhenyu Yao, 2016.01.07
matchCancelEnroll 109 {
    request {
        result 0 : integer                  # 返回结果, 0 正确, 非 0 错误码
        matchTitle 1 : string               # 比赛标题
        matchType 2 : string                # 比赛类型
        curNum 3 : integer                  # 当前玩家数量
        fullNum 4 : integer                 # 满玩家数量
        isActive 5 : integer                # 服务器主动取消, 1 主动, 0 被动
    }
}

# 迟到开始比赛. Zhenyu Yao, 2015.11.23
lateMatchBeginMatch 110 {
    request {
        matchInfo 0 : matchInfo
    }
}


##############私人场协议 150+  

.recordInfo {
    moSelf 1 : integer          #自摸 次数   没有传 0 
    normal 2 : integer          #平胡 次数
    pointGun 3 : integer        #点炮 次数
    tianHu 4 : integer          #天湖 次数
    diHu 5 : integer            #地胡 次数
    sanLwuK 6 : integer         #三笼五坎 次数
    xingCount 7 : integer       #总醒数 次数
    hongHu 8 : integer          #红胡  	次数  
	dianHu 9 : integer          #点胡  	次数
	heiHu 10 : integer			#黑胡   次数	
	wangDiao 11 : integer       #王钓  	次数
	wangChuang 12 : integer     #王闯  	次数
	wangZha 13 : integer        #王炸   次数
	wangDiaoWang 14 : integer   #王钓王 次数
	wangChuangWang 15 : integer #王闯王 次数
	wangZhaWang 16 :integer     #王炸王 次数 

}

# 战绩表玩家信息
# .selfRoomRecordSimpleAgent {
#     userID 0 : integer              # 用户的 userID
#     nickName 1 : string             # 昵称
#     avatarID 2 : integer            # 头像 ID  
#     scoreCount 3 : integer          # 子数
#     recordDetails 4 : recordInfo    # 详细信息
#     rankReward 5 : *prop            # 奖励道具与相关值信息  nil 为无奖励
#     seatIndex 7 : integer
#     thirdConf 8 : thirdInfo         # 第三方信息
# }
# 战绩表玩家信息
.selfRoomRecordSimpleAgent {
    userID 0 : integer              # 用户的 userID
    nickName 1 : string             # 昵称
    avatarID 2 : integer            # 头像 ID
    scoreCount 3 : integer          # 子数
    recordDetails 4 : recordInfo    # 详细信息
    rankReward 5 : *prop            # 奖励道具与相关值信息  nil 为无奖励
    seatIndex 6 : integer           # 座位号
    isWinner 7 : integer            # 是否是大赢家，0否，1是
    code     8 : integer            # 用户ID
    isDeskOwner 9 : integer         # 是否是桌主，0否，1是
    rank       10 : integer         # 本场排名
    thirdConf 11 :thirdInfo         # 第三方信息
    winCount 12 : integer            # 赢的局数
    loseCount 13 : integer           # 负的局数
    pingCount 14 : integer          # 平的局数
}

# 战绩表记录数据结构
.selfRoomRecordData {
    startTime 0 : string                        # 开始时间
    deskRate 1 : integer                        # 桌子倍率
    gameCount 2 : integer                       # 总局数
    agentInfos 3 : *selfRoomRecordSimpleAgent   # 玩家数据集合
    deskOwnerUserID 4 : integer                 # 桌主的 userID
    deskPW 5 : string               # 房间号
    dissoluteNickName 6 : string    # 解散者的昵称
    endTime 8 : string                          # 结束时间
    groupInfoLogID 9 : integer                  # 战绩表ID
    tableSubNameGroup 10 : string                # 战绩表名
    deskCostType 11 : integer                   # 房间消费类型
    playerNum 12 : integer                      # 游戏人数类型 3/4人
    gameType 13 : integer                       #游戏类型
}

# 名堂配置
.mingTangConf {  
    mingTangDetails 1 : *integer            # 对应值定义在 headFile.MING_TANG_FAN_SHU_KIND    
}

#局数与建桌消耗 
.gameCountCost {
    count 0 : integer
    enrollCosts 1 : *enrollCost
    enrollCostsAA 2 : *enrollCost          #AA 消耗类型
    enrollCosts4 3 : *enrollCost   
    enrollCosts4AA 4 : *enrollCost
    enrollCostsKing 5 : *enrollCost        #多王消耗类型
    enrollCostsKingAA 6 : *enrollCost      #多王AA消耗类型
}

#黑名单信息提示  一定会有两个昵称 
.blackAgentInfo {
    nickName 1 : string                    #客户端提示 blackNickName 是 nickName 的黑名单用户 是否继续？若 nickName 是自己 返回 nickName = "您"
    blackNickName 2 : string               #
    blackSeatIndex 3 : integer             #并将该位置的玩家添加黑名单标示
    blackUserID 4 : integer
}

.agentInfoSelfRoom {           
    seatIndex 0 : integer           #   1到3 
    nickName 1 : string             #   昵称
    level 2 : integer               #   等级 
    goldCoin 3 : integer            #   金币
    avatarID 4 : integer            #   头像信息
    location 5 : string             #   位置信息
    winInfo 6 : integer             #   连胜信息  -1 为被终结  0 为无连胜  >0 为连胜次数
    automatic 7 : integer           #   是否掉线   1 为正常  2 为掉线 
    thirdConf 8 : thirdInfo         #   第三方信息    
    dissoluteAction 9 : integer     #   解散时的动作
    continueAction 10 : integer     #   续费时的动作  无动作为nil
    readyInfo 11 : integer          #   准备状态      1 为准备，2 或 nil 为没准备
    userID 12 : integer             #   
    isBlackTag 13 : integer         #   是否有黑名单标示  1 为是 nil 为否
    code 14 : integer               #   黑名单 ID
    isInBlackList 15 : integer      #   是否是获取方的黑名单用户  1 为是  nil 为否
    isNovice 16 : integer           #   是否是新人 1 为 是 nil 为否
}

#玩家进入桌子         
agentComeIn 150 {
    request {
        agentInfo 0 : agentInfoSelfRoom 
        blackListPrompt 1 : *blackAgentInfo  #黑名单提示     
    }
}

#玩家准备信息     
agentReadyInfo 151 {
    request {
        seatIndex 0 : integer      #玩家的位置 （服务器） 客户端需要转换
        readyInfo 1 : integer       # 1 为准备  2 为取消准备
    }
}

#玩家退出桌子
agentOutDesk 152 {
    request {
        seatIndex 0 : integer
        selfDeskID 1 : integer
    }
}

#被桌主踢后发送信息  / 金币不足 被系统踢掉
kickByOwner 153 {
    request {
        seatIndex 0 : integer
        selfDeskID 1 : integer
        reason 2 : integer
    }
}

#结算界面强制再来一局    (可能不用)
forceGameAgaint 154 {
    request {
        selfDeskID 0 : integer
        agentInfos 1 : *agentInfoSelfRoom   
    }

}

#解散桌子信息
destroyDesk 155 {
    request {
        selfDeskID 0 : integer
        inGaming 1 : integer        # 0 是非牌局中解散, 1 是牌局中解散
        destroyReason 2 : integer   #解散原因    0 桌主主动申请  1 桌主缺少货币被动解散
        recordData 3 : selfRoomRecordData    #结算是的数据
    }
}

# 更新桌子数据
.updateInfo {
    selfDeskID 0 : integer       #桌子号
    agentNum 1 : integer         #当前桌玩家人数
    selfDeskState 2 : integer    #当前桌状态
}

updateSelfDesk 156 {
    request {
        updateList 0 : *updateInfo
    }
}

#结算后进入等待或开局界面
enterSelfScene 157 {
    request {
        selfDeskID 0 : integer
        agentInfos 1 : *agentInfoSelfRoom    #若为空值则进入洗牌界面等待开局信息  有值则进入等待界面
        gameCount 2 : integer                #本场中当前局数
        remainCount 3 : integer              #剩余局数
        recordData 4 : selfRoomRecordData    #结算战绩数据
        sendTime 5 : integer                 #发送时间
        dissoluteTime 6 : integer            #桌子解散时间
        isNotContinue 7 : integer         #是否允许续费
        shuXingID 8 :integer              
    }
}

# 玩家上线
agentOnlineInDesk 158 {
    request {
        seatIndex 0 : integer       # 座位号
    }
}

# 玩家离线
agentOfflineInDesk 159 {
    request {
        seatIndex 0 : integer       # 座位号
    }
}

# 广播给其他玩家语音地址
broadcastVoiceUrl 160 {
    request {
        url 0 : string              # 语音地址
        seatIndex 1 : integer       # 该玩家的 座位号（服务端）
        userId 2 : integer          # 该玩家的 userId
        time 3 : integer            # 语音的时间, 单位毫秒
        
    }
}

#提示继续续费开局或等待桌主续费开局
notifyGameContinue 161 {
    request {
        createCount_Cost 0 : *gameCountCost                #若是桌主发送局数-消耗类型配置 ,否则发送nil 
    }
}

#通知续费成功
notifyContinueSuccess 162 {
    request {    
        remainCount 0 : integer               #剩余局数     桌主不通知 
        totalCount 1 : integer                #总局数
        sendTime 2 : integer                  #发送时间
        waitTime 3 : integer                  #等待时间 如果需要玩家确认, 那么必须存在这个值 
    }
}

#转发表情
transmitExpression 163 {
     request {
        seatIndex 0 : integer                   #座位号 (发送方)
        expressionID 1 : integer                #表情ID
    }
}

#解散桌子信息
dissoluteDeskInfo 164 {
    request {
        nickName 0 : string
        dissoluteAction 1 : integer
        sendTime 2 : integer
        seatIndex 3 : integer
        waitTime 4 : integer

    }
}

#通知续费询问结束 去除等待对话框
notifyContinueExit 165 {
    request {

    }
}

#使用房卡获得道具通知
useRoomCardReward 166 {
    request {
        nickName 0 : string   #房主昵称
        propCount 1 : *prop   #道具与相关值信息  只有 propType : int   propVal : int 
    }
}

# 发送广播给客户端
sendRadio 180 {
    request {
        content 0 : string    #内容
        showType 1 : integer  #展示方式，定义在head_file.radioConf
        radioType 2 : integer #广播类型，定义在head_file.radioConf
        duration 3 : integer  #持续时间，秒
        nickName 4 : string   #发送人的昵称
    }
}

# 发送玩家待处理事项给客户端
#data=
#{
#  "startTime" : "2016-01-01 00:00:00",    --开始时间
#  "endTime" : "2016-01-01 00:00:00",      --牌局结束的时间
#  "matterKey" : "key",  --事项的key，定义在head_file.UserMatter.matterKey
#  "matterValue" : "value",  --事项的value
#  "flag" : 0,  --事项的标记，定义在head_file.UserMatter.flag，即什么时候会去检测这个事项
#  "remark" : "备注",  --备注
#  "extra" : "json字符串"
#}
#并不是每个字段都是必须的，根据Matter的不同，每个字段的用法也不同
#SEND_USER_MATTER
sendUserMatter 181 {
    request {
        data 0 : string  #json字符串
    }
}

#min.luo 2016.8.10 告诉客户端，服务端验证失败
sendFirstRechargeVerify 182 {
    request {
        result 0 : integer  # 1: 充值验证成功 0: 验证失败
        text   1 : string   #显示在客户端上的文字
    }
}

# min.luo 2016.9.22 通知客户端充值结果
sendChargeResult 183 {
    request {
        result 0 : integer  # 1-充值成功, 0-充值失败
        extend 1 : string # 扩展数据
    }
}

#FLUSH_PLAYER_NICKNAME
flushPlayerNickName 184 {
    request {
        nickName 0 : string #昵称
    }
}

#shortMsg KF.QIN 2016.12.19
shortMessage 185 {
   request {      
        seatIndex 0 : integer   
        msgCode 1   :   integer
    }
}

#leaveNotify KF.QIN 2017.1.13
leaveNotify 186 {
   request {      
        seatIndex 0 : string   
        timeStamp 1 : integer  
        type 2 : integer    # 0 表示 levave  1;表示  active
    }
}

#checkInAwardItem KF.QIN 2017.2.20 签到活动奖励
.checkInAwardItem {
    amount 0 : integer  #道具的数量
    id     1 : integer  #道具的ID  定义在headFile.goodsTypeID
    text   2 : string   #道具的中文名
    day    3 : integer  #第X天    
}

#checkIn KF.QIN 2017.2.20
checkIn 187 {
   request {                        
        day               0 : integer   #  签到 天数            
        activityName      1 : string # 活动名称
        type              2 : integer # 1代表单次签到奖励，2代表连续签到奖励，3代表累积奖
        checkInAwards     3 : *checkInAwardItem   #    签到活动奖励
        timeStamp         4 : integer #签到时刻
	remarks           5 : string # 活动备注
    }
}

#展示奖励对话框
#SHOW_AWARD_BOX
showAwardBox 188 {
    request {
        noviceProp 0 : noviceProp #奖励内容
    }
}

#发送邮件信息给客户端（客户端自己保存）
.emailGoods {
    goodsTypeID          0 : integer     #物品类型
    amount               1 : integer     #物品数量
}
.emailList {
    ID              0 : integer     #邮件ID
    title           1 : string      #邮件标题
    sendTime        2 : string      #发送时间
    expireTime      3 : string      #截止时间
    fromNickName    4 : string      #发件人昵称
    toNickName      5 : string      #收件人昵称
    stateID         6 : integer     #邮件状态，0为未读，1为已读
    typeID          7 : integer     #邮件类型，定义在head_file.emailType中
    readTime        8 : string      #领取时间
    content         9 : string      #邮件内容
}

#SEND_EMAIL_TO_USER
sendEmailToUser 189 {
    request {
        emailList           0 : *emailList
    }
}

#interactiveExpression  
transferInteractiveExpression 190 {
   request {         
        fromSeatIndex 0 : integer   # 
        toSeatIndex 1 : integer     #
        itemId 2   :   integer
        num 3   :   integer
    }     
}



#更新任务状态
#UPDATE_MISSION_STATE
.missionList {
    configID 0 : integer  #任务配置ID
    icon 1 : string       #任务图标文件名，xxx.png
    name 2 : string       #任务名称
    award 3 : *itemStruct #奖励的道具，该字段只有itemId与num有效
    stateID 4 : integer   #任务状态ID，定义在headFile.missionStateID
    curNum 5 : string     #当前任务进度，考虑到今后不同的任务可能会有不同的数据类型，因此使用字符串
    targetNum 6 : string  #达成任务需要的数量，考虑到今后不同的任务可能会有不同的数据类型，因此使用字符串
    gotoMissionBtnType 7 : string #做任务按钮的类型，进入的房间不同的房间，null:不进入任何房间，rate：进入倍率，match：进入比赛列表界面，createNewSelf：进入包厢建桌界面，joinNewSelf进入包厢加入房间界面，lobby：进入大厅，比赛具体房间名，例如:RM_1_F_1
    extra 8 : string      #额外扩展参数，预留字段，不需要时为空字符串，如有，则为json字符串
    typeID 9 : integer    #任务类型，定义在headFile.missionType
    info 10 : string      #任务信息，描述
    sortNum 11 : integer  #排序值，越小越靠前
}
updateMissionState 200 {
    request {
        missionList 0 : *missionList #任务信息，可能同时刷新多个信息
    }
}





#通知客户端上传配置
uploadClientLog 210 {
    request {
        data 0 : string  #json字符串，目前客户端收到该消息可以不用判断data的值，收到消息上传日志即可，data是为了用于以后如果需要筛选日志时间段或者限制大小
    }
}

#俱乐部通知玩家加入俱乐部审核结果(只通知审核成功)
sendJoinClubResult 300 {
    request {
        result 0 : integer  # 0 成功， 1 失败
    }
}

#俱乐部通知玩家俱乐部房间列表变化(房间解散、玩家进出房间通知)
sendClubRoomStateChange 301 {
    request {
        clubID 0 : string                          #俱乐部ID
    }
}

#新包奖励
sendUpdateAward 302 {
    request {
        title 0 : string         # 标题
        content 1 : string       # 内容
        propList 2 : *prop   # 奖励道具列表
        endTime 3 : integer     # 活动结束时间
        isUpdate 4 : integer     # 是否下载更新 0下载，1已经下载了, 2领过奖励了
    }
}

#发送俱乐部成员被踢消息给被踢玩家
sendKickClubMemberInfo 304 {
    request {
        clubID 0 : string                          #俱乐部ID
        userID 1 : integer                         #被踢玩家userID
    }
}

#四人数醒模式续费通知大厅玩家
notifyLobbyContinue 211 {
    request {
        deskID 0 : integer
        deskPW 1 : string
        remainCount 2 : integer               #剩余局数     桌主不通知 
        totalCount 3 : integer                #总局数
        sendTime 4 : integer                  #发送时间
        waitTime 5 : integer                  #等待时间 如果需要玩家确认, 那么必须存在这个值 
        ownerNickName 6 : string              #桌主名字
    }
}

#h5测试用协议
.serverInfoH5{
    serverID 0 : integer      #--服务ID
    serverName 1 : string     #--服务名

}

testS2C 212 {
    request {
        serverInfo 0: serverInfoH5
    }
}

]] .. niuniu_protos2c .. pdk_proto.s2c)





return proto


