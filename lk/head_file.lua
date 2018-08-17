--[[
	head file, server and client used in common.
	create by mingyuan.xie
	create time: 2015.9.28
--]]


local headFile = {}

 
headFile.MSG_HEAD_TAG = 0xabcd


--EndPoint design, 端点定义
headFile.enumEndPoint = {
	CLIENT 				= 1,	--客户端
	LOGIN_SERVER 		= 2,	--登陆
	GATE_SERVER			= 3,	--网关
	GAMEROOM_SERVER 	= 4,	--倍率房
	LOBBY_SERVER		= 5,	--大厅
	ROOM_MATCH_SERVER 	= 6,	--比赛房
    ROOM_SELF           = 7,    --私人场
    MALL                = 8,    --商城
    NEW_ROOM_SELF       = 9,    --新私人场
    MINING_SERVER       = 10,   --挖矿小游戏
    RADIO               = 11,   --广播
    EMAIL               = 12,   --邮件
    RANK                = 13,   --排行榜
    HTTPS               = 14,   --https服务
    OUTER_WEB           = 15,   --web服务
    MISSION             = 17,   --任务
    CLUB                = 18,   --俱乐部
    PHZ_KING            = 19,   --多王扯胡子
    NEW_ROOM_SELF_4     = 20,   --四人数醒服务
    NIUNIU_SERVER       = 40,   --牛牛服务
    NN_RATE_SERVER	= 41,	--牛牛金币场
    PDK_SERVER          = 50,   --paodekuai services
    PDK_RATE_SERVER     = 51,
	ROOM_CHALLENGE      = 100,  -- 连胜挑战房
	ROOM_CHALLENGE_MG   = 101,  -- 连胜挑战管理
}

--KeyAction design, 行为码
headFile.enumKeyAction = {
	BEGIN				= 0,	--begin
	AUTH 				= 1,	--认证
	CHOOSE_ROOM			= 2,	--选择房间
	AUTH_RESULT			= 3,	--认证结果
	ENTER_ROOM			= 4,	--进入房间
	PLAY_GAME			= 5,	--行牌
	OTHER_PLAY_ACT 		= 6,	--其他玩家的动作
	SET_HAND_CARDS 		= 7,	--设置手牌
	CANCEL_ACT          = 8,    --取消动作 
	CANDO_ACT           = 9,   	--可以执行的动作
	DISCARD_CARD        = 10,   --丢弃当前牌
	MO_CARD				= 11,   --通知摸牌
    CREATE_SELFROOM     = 12,   --创建私人桌   
    ENTER_SELFROOM      = 13,   --进入私人桌
    WAIT_SELFROOM       = 14,   --私人桌等待中的操作 准备 取消 踢人  
	LEAVE_DESK			= 100,	--离开桌子
	REMAIN_DESK			= 101,	--游戏结束后，继续留在桌子上游戏
	ACCOUNT				= 102,	--游戏结束，结算金币
	HEARTBEAT			= 103,	--heartbeat
	HEARTBEAT_REPLY		= 104,	--heartbeat reply
	COME_TO_LOBBY		= 105,	--回到大厅
    RELIEVE             = 106,  --救济金
    GET_RANK			= 108,	--请求金币排行榜
    RANK_BACK			= 109,	--返回金币排行榜
    GET_EMAIL_LIST      = 110,  --请求邮件列表
    EMAIL_LIST_BACK     = 111,  --返回邮件列表
    GET_EMAIL_INFO      = 112,  --请求邮件信息
    EMAIL_INFO_BACK     = 113,  --返回邮件信息
    GET_EMAIL_AWARD     = 114,  --请求邮件奖励
    EMAIL_AWARD_BACK    = 115,  --返回邮件奖励领取结果
    NET_MESSAGE			= 116,	--消息通知处理
    SEND_LOCATION_INFO  = 117,  --发送位置信息
    DELETE_EMAIL        = 118,  --删除邮件
    NEVER_READ_EMAIL    = 119,  --发送未读邮件数
    GET_SERVER_TIME     = 120,  --请求服务器时间
    PAY_MESSAGE         = 122,  --付费消息
    MATCH               = 123,  --比赛
    GET_ALL_MATCH       = 125,  --获取所有比赛大区和比赛列表
    GET_ONLINE_INFO     = 126,  --获取在线人数
    GET_MATCH_INTEGRAL  = 127,  --在比赛中获取积分信息
    GET_MATCH_GENERAL   = 128,  --获取比赛概况
    MATCH_ENROLL        = 129,  --比赛报名
    GET_ENROLL_NUM      = 130,  --获取已报名人数
    MATCH_CANCEL_ENROLL = 131,  --取消比赛报名
    GET_MATCH_DETAIL    = 132,  --获取比赛详情
    GET_AWARD           = 133,  --查看奖励方案
    HISTORY_VIDEO       = 134,  --历史记录
    CHANGE_GOLD_COIN    = 135,  --修改客户端金币显示
    MATCH_ROUND_INFO    = 136,  --比赛牌局内容
    GET_PLAYER_STATUS   = 137,  --大厅玩家的状态
    COME_BACK_GAME      = 138,  --请求回到游戏
    RECHARGE_K_CURRENCY = 139,  --请求扣除老K的货币
    GET_K_CURRENCY      = 140,  --请求获得老K货币
    GET_GOODS_LIST      = 141,  --请求获得商品列表
    EXCHANGE_GOODS      = 142,  --请求兑换商品
    GET_POINT           = 143,  --请求获得积分
    CHANGE_POINT        = 144,  --刷新玩家积分
    CHANGE_AVATAR       = 145,  --请求更改头像
    GET_AVATAR_LIST     = 146,  --请求获得头像列表
    FLUSH_CURRENCY      = 147,  --刷新货币
    GET_EXCHANGE_LIST   = 148,  --获得商品兑换记录
    SEND_RELIEVE        = 149,  --发送救济金
    DELETE_ALL_EMAILS   = 150,  --删除所有已读邮件
    POINT_2_GOLDCOIN    = 151,  --积分兑换金币
    MATCH_COME_BACK_ENROLLED = 152,     -- 定时赛报过名的玩家在开赛后进入比赛
    LATE_ENROLL = 153,                  -- 定时赛迟到报名
    GET_TIMING_MATCHES  = 154,          -- 获得报名定时赛的列表
    SEND_RED_PAPER      = 155,  --送红包
    FLUSH_GOODS         = 156,  --刷新道具
    REQUEST_SEND_RED_PAPER = 157,--请求赠送红包，获得赠送红包界面的信息
    TIMING_MATCH_ENROLL_LEAVE         = 158,  -- 定时赛, 请求离开房间信息界面
    ASK_REVIVE          = 159,  --询问客户端是否需要复活
    REQUEST_REVIVE      = 160,  -- 请求复活
    FOLLOW_MATCH        = 161,  -- 关注比赛
    UNFOLLOW_MATCH      = 162,  -- 取消比赛关注
    REQUEST_CANCEL_REVIVE = 163,  -- 请求取消复活
    USE_SAFE_BOX        = 164,  -- 使用保险柜
    GET_SAFE_BOX_INFO   = 165,  -- 获得保险柜信息
    SET_SAFE_PASSWORD   = 166,  -- 设置保险柜密码
    GET_ITEM_CONF       = 167,  -- 请求道具配置
    GET_ALL_ITEMS       = 168,  -- 获得所有的道具数据
    RECYCLE_ITEM        = 169,  -- 回收道具
    USE_REDEEM_CODE     = 170,  -- 使用兑换码
    USE_ITEM            = 171,  -- 使用道具
    GET_SELF_ROOM_RECORD_CONF = 172, --获取战绩配置
    GET_KIND_GOODS_LIST = 189,  -- 获得某个种类的商品数据
    GET_ITEM_INFO       = 190,  -- 获得某个道具的信息
    SEND_RADIO          = 191,  -- 发送广播
    GET_RECEIVED_EMAIL_LIST = 193,  -- 获取已领取邮件列表
    GET_RECEIVED_EMAIL_INFO = 194,  -- 获得已领取邮件信息
    GET_VISIBLE_RANKING     = 195,  -- 获得可见的排行榜
    GET_RANKING_AWARD_CONFIG  = 196,  -- 获得排行榜奖励配置
    GET_RANKING             = 197,  -- 获得排行榜
    GET_HISTORY_RANKING = 198, -- 获得上一次排行榜
    GET_ALL_EMAIL_AWARD = 199, -- 获得所有邮件奖励
    GET_FANXING_REWARD = 200, --获取翻醒奖励配置	
    GET_ALL_TIMING_MATCHES_INFO = 201,  -- 获得所有的定时赛数据
    SEND_USER_MATTER    = 202,  --发送用户处理事项
    DELETE_USER_MATTER  = 203,  --删除用户处理事项
    SEND_ITEMS          = 204,  --赠送道具
    ITEM_SYNTHETIZE    = 205,  -- 道具合成
    GET_ITEM_SYNTHETIZE_LIST = 206, -- 获取道具合成列表
    CHANGE_NICKNAME     = 207,  --修改昵称
    GET_CHANGE_NICKNAME_INFO = 208, --获得改名信息
    WRITE_MESSAGE_BOARD = 209,  --写留言板
    SEND_FIRST_RECHARGE_INVALID      = 210,  --min.luo 2016.8.10 通知客户端，服务端购买商品验证失败
    GET_USER_IS_GAME       = 211,  --min.luo 2016.8.10 查看用户是否还在游戏中
    GET_FIRST_LIST       = 212,  --min.luo 2016.8.12 获取首充列表
    GET_FIRST_TAG        = 213,  --min.luo 2016.8.12 不同礼包是否还有首冲
    RECHARGE_VALID      = 214,  --min.luo 2016.8.5 验证此商品是否能购买
    GET_ROOM_CARD_MID   = 215,  --min.luo 2016.8.26 请求房卡的 MID
    BIND_WEIXIN        = 216, -- 绑定微信
    GET_LOUDSPEAKER_MID_PRICE   = 217,  --min.luo 2016.9.9 请求喇叭的MID和价格
    SET_NEW_SPREADER   = 218,  -- 设置新私人场推广号
    SEND_CHARGE_RESULT      =219,       --min.luo 2016.9.22 通知客户端充值成功
    FIRST_BUY_ROOM_CARD     = 220,      --min.luo 2016.9.29 是否第一次购买房卡类型
    CREATE_360_ORDER    = 221,  --创建一个360订单号
    GET_360_PRODUCT     = 222,  --获得360商品
    CHECK_NICKNAME_VAILD= 223,  --检查昵称是否可用
    FLUSH_PLAYER_NICKNAME = 224,  --刷新客户端昵称
    USER_AUTH           = 225,  --用户认证
    GET_USER_AUTH       = 226,  --获取用户认证信息
    GET_SYSTEM_CONF       = 227,  --获取系统配置
    SHOW_AWARD_BOX      = 228,  --展示奖励对话框
    GET_UPDATE_AWARD = 229,  --获取更新包奖励
    GET_PAY_DATA = 230,     -- 获得支付数据
    SEND_COORDINATE_INFO = 231, -- 发送坐标信息
    FIND_COORDINATE_INFO = 232,   -- 查询坐标信息
    FIND_COORDINATE_INFO_CODE = 233, -- 查询坐标信息(code)
    GET_BLACKLIST_BYCODE = 289 ,  --根据code 获取黑名单列表
    GET_RECENT_PLAYER_LIST = 290, --获取最近对手记录
    DELETE_BLACKLIST = 291,       --删除黑名单
    SET_BLACKLIST = 292,          --加入黑名单
    GET_BLACKLIST = 293,          --获取黑名单
    SELFROOM_GETDATAS_MSG = 294,  --获取消息记录
    SELFROOM_GETLIST_MSG = 295 ,  --获取回放列表
    SELFROOM_COMPARETIME_MSG = 296 , --比较回放列表时间	
    MINING_ENTER        = 297,  --进入挖矿界面
    MINING_ACTTION      = 298,  --挖矿游戏中的所有操作
    FORWARD_ACTTION     = 299,  --转发类(非行牌)通道 表情等
    SHORT_MSG           = 300,  -- short mag(表情等)
    LEAVE_NOTIFY        = 301,  -- 挂机通知
    CHECK_IN            = 302,  -- 签到
    USER_SHARE          = 303, -- 用户分享
    GET_USER_SPREADER_LIST = 304, -- 获取玩家推广列表
    GET_USER_SHARE_INFO = 305, -- 获取玩家分享信息
    PURCHASE_ITEM       = 306,  --购买道具（商城中用K币兑换其他道具）
    GET_USER_GAMES_REACH_AWARD = 307, --获取累计玩家数量达标奖励
    GET_UNBIND_NEWSPREADER_INFO = 308, --获取解绑newSpreader的信息
    UNBIND_NEWSPREADER = 309,  --解绑
    ITEM_RAFFLE    = 320,  -- 道具抽奖
    GET_ITEM_RAFFLE_LIST = 321, -- 获取道具抽奖列表
    STATISTICS = 322, --统计
    GET_MISSION_LIST = 330,     -- 获得任务列表
    UPDATE_MISSION_STATE = 331,  --更新任务状态
    SHARE_GAME_MISSION = 332,   --分享游戏任务
    SEND_EMAIL_TO_USER  = 350,  --发送邮件信息给客户端（客户端自己保存）
    GET_CREATED_LIST = 351,     -- 获得当前建桌的列表
    QUICK_CREATE_SELF_DESK = 352,   -- 快速建桌, 建桌不打牌
    QUICK_DESTROY_DESK = 353,       -- 销毁建桌
    BATCH_QUICK_CREATE_SELF_DESK = 354,   -- 批量快速建桌, 建桌不打牌

    REQUEST_INTERACTIVE_EXPRESSION = 355,  -- 请求互动表情
    SEND_INTERACTIVE_EXPRESSION = 356,  -- 发送互动表情
    UPLOAD_CLIENT_LOG = 357,  --通知客户端上传日志
    GET_H5_GAME_URL = 380,       --获得拉起H5页面的url

    NOTIFY_UPDATE_AWARD = 381,       --通知客户端更新礼包
    GET_MINI_GAMES_PERMISSION = 390, --获得小游戏权限
    GET_MINI_GAMES_CONF = 391, --获得小游戏配置
    SYNC_MATCH_ONLINE_NUM = 395,   --同步比赛场在线人数
    GET_SYSTEM_NOTICE_EMAIL_LIST = 400, --系统公告邮件列表
    GET_SYSTEM_NOTICE_EMAIL_INFO = 401, --系统公告邮件信息
    MARK_ALL_EMAILS_READ = 402, --标记全部邮件已读
    DELETE_ALL_READ_EMAILS = 403, --删除全部已读邮件

    CREATE_RECORD_SHARE_LINK = 410,  --生成战绩分享链接
    GET_WECHAT_LOCTION = 411,   --获得小游戏地理位置
    GET_OUT_TRADE_NO = 420, --生成订单号
    NOTIFY_PAY_SUCCESS = 421, --通知服务端支付成功

    GET_ONE_CLUB_INFO                   = 450, -- 获取一个俱乐部的信息(房间列表等)
    GET_CAN_DISMISS_CLUB_ROOM_LIST      = 451, -- 获取可解散的空或缺人的房间列表
    CLUB_DISMISS_ROOM                   = 452, -- 俱乐部解散房间
    SET_AUTO_CREATE_ROOM_OPEN_OR_CLOSE  = 453, -- 俱乐部设置自动开房开启或者关闭
    GET_CLUB_CREATE_ROOM_RULE_INFO      = 454, -- 获取俱乐部创建房间规则,点击俱乐部的管理按钮的返回
    CLUB_MANUAL_CREATE_ROOM             = 455, -- 俱乐部手动创建房间    
    APPLY_JOIN_CLUB                     = 456, -- 申请加入俱乐部
    GET_CLUB_MEMBER_INFO_LIST           = 457, -- (只有群主有此功能) 1. 获取俱乐部成员信息列表  2. 搜索查找具体成员的信息
    GET_CLUB_APPROVAL_MEMBERS           = 458, -- 获取俱乐部待审核成员列表
    CLUB_APPROVAL_MEMBER                = 459, -- 俱乐部审核成员
    KICK_CLUB_MEMBER                    = 460, -- 踢掉俱乐部成员
    SET_CLUB_PERMISSION                 = 461, -- 设置俱乐部成员身份
    MODIFY_CLUB_INTRODUCER              = 462, -- 修改俱乐部介绍人
    GET_CLUB_RED_POINT_HINT             = 463, -- 获取俱乐部红点提示信息
    CLEAN_CLUB_RED_POINT_HINT           = 464, -- 清理俱乐部红点提示信息
    GET_ALL_CLUB_RED_POINT_HINT         = 465, -- 获取所有俱乐部（包括加入的和自己创建的）红点提示信息
    SELF_QUIT_CLUB                      = 466, -- 自己主动退出俱乐部，只有成员和副主席可以自主退出， 主席不能够退出
    GET_CLUB_MASTER_ITEM_NUM            = 467, -- 查看俱乐部主席某种道具数量
    CHECK_CLUB_ROOM_CAN_JOIN            = 468, -- 检查俱乐部的房间是否可以加入
    CREATE_CLUB                         = 469, -- 创建俱乐部
    GET_CLUB_LIST                       = 470, -- 获取俱乐部列表
    CHECK_CAN_DISSOLUTION_CLUB          = 471, -- 查看俱乐部是否可以解散
    CLUB_GET_VERIFICATION_CODE          = 472, -- 俱乐部获取验证码
    DISSOLUTION_CLUB                    = 473, -- 解散俱乐部
    SEARCH_CLUB                         = 474, -- 根据ID或者关键字搜索俱乐部
--    CLUB_QUERY_MY_GAME_RECORDS          = 475, -- 查询俱乐部我的战绩
    CLUB_QUERY_GAME_RECORDS             = 476, -- 查询俱乐部战绩
    GET_CLUB_GAME_LIST                  = 477, -- 获取俱乐部可以创建的游戏
    GET_CLUB_MANAGERS                   = 478, -- 获取指定俱乐部的管理员（包括主席）
    SEND_JOIN_CLUB_RESULT               = 479, -- 俱乐部通知玩家加入俱乐部审核结果(只通知审核成功)
    SEND_CLUB_ROOM_STATE_CHANGE         = 480, -- 俱乐部通知玩家俱乐部房间列表变化(房间解散、玩家进出房间通知)
    MODIFY_CLUB_REMARKS                 = 481, -- 修改俱乐部的备注
    QUERY_USER_RECORDS_BY_DAY           = 482, -- 查询所有玩家一天的战绩总和
    CLUB_INVITE_MEMBER                  = 483, -- 俱乐部邀请成员
    GET_USERINFO_BY_CODE                = 484, -- 根据用户code获取用户信息
    GET_CLUB_INTRODUCER_INFO            = 485, -- 获取玩家俱乐部介绍人信息
    FOUR_LOBBY_CONTINUE                 = 486, -- 4人模式续费通知大厅玩家
    SAVE_CLUB_ROOM_RULE                 = 487, -- 保存建桌配置
    SEND_KICK_CLUBMEMBER_INFO           = 488, -- 发送俱乐部成员被踢消息给被踢玩家
    GET_ALL_GOODS_ZONE_LIST             = 489, -- 获得所有商品分区列表
	TEST                                = 490,

    END                 = 500,  --end

    -- h5 700 起 add by sikun
    GET_JS_API_TICKET = 700,                   -- 获取分享票据
}

--login认证结果码 
headFile.enumAuthResult = {
	AUTH_NON 				= -1,
	AUTH_OK 				= 0,
	AUTH_USERNAME_NOT_EXIST = 1,    --用户名不存在
	AUTH_PASSWORD_ERR 		= 2,    --密码错误
	AUTH_LOGIN_ALREADY 		= 3,    --用户已登录
    AUTH_TOKEN_EXPIRE       = 4,    --token过期
    AUTH_GET_USER_INFO_FAIL = 5,    --获取用户信息失败
    AUTH_SERVER_CLOSE       = 6,    --服务器维护中
    AUTH_VERSION_EXPIRE     = 7,    --客户端版本过老
    AUTH_IF_BIND_LK         = 8,    --询问客户端是否要绑定老K账号
    AUTH_WEIXIN_TOKEN_EXPIRE= 9,    --微信token过期，使用code登录
    AUTH_BAN_3_DAYS         = 10,   --禁止3天登陆
    AUTH_BAN_FOREVER        = 11,   --永久禁止登陆
    BIND_LK_OK              = 12,   --绑定老K账号成功，重新登录
    MSG_SEND_FAIL           = 13,   --登录认证短信发送失败，请重试
    MSG_SEND_OK             = 14,   --短信发送成功
    AUTH_CODE_EXPIRE        = 15,   --登录短信验证码已过期
    AUTH_CODE_ERR           = 16,   --短信验证码不正确
    LOGINED_IN_OTHER_DEVICE = 18,   --已登录
    GET_SESSION_KEY         = 19,   --微信小游戏获取session_key

    errString = function(errcode)
        if headFile.enumAuthResult.AUTH_NON == errcode then
            return "登录失败！"
        elseif headFile.enumAuthResult.AUTH_USERNAME_NOT_EXIST == errcode then
            return "用户名不存在！"
        elseif headFile.enumAuthResult.AUTH_PASSWORD_ERR == errcode then
            return "用户名或密码错误！"
        elseif headFile.enumAuthResult.AUTH_LOGIN_ALREADY == errcode then
            return "用户已登录！"
        elseif headFile.enumAuthResult.AUTH_TOKEN_EXPIRE == errcode then
            return "身份信息过期，请重新登录！"
        elseif headFile.enumAuthResult.AUTH_GET_USER_INFO_FAIL == errcode then
            return "用户信息无法获取！"
        elseif headFile.enumAuthResult.AUTH_SERVER_CLOSE == errcode then
            return "服务器维护中！"
        elseif headFile.enumAuthResult.AUTH_VERSION_EXPIRE == errcode then
            return "请更新客户端！"
        elseif headFile.enumAuthResult.AUTH_IF_BIND_LK == errcode then
            return "请绑定账号！"
        elseif headFile.enumAuthResult.AUTH_WEIXIN_TOKEN_EXPIRE == errcode then
            return "微信 Token 过期！"
        elseif headFile.enumAuthResult.AUTH_BAN_3_DAYS == errcode then
            return "禁止3天登陆！"
        elseif headFile.enumAuthResult.AUTH_BAN_FOREVER == errcode then
            return "永久禁止登陆！"
        elseif headFile.enumAuthResult.BIND_LK_OK == errcode then
            return "绑定老K账号成功，重新登录！"
        elseif headFile.enumAuthResult.MSG_SEND_FAIL == errcode then
            return "登录认证短信发送失败，请重试！"
        elseif headFile.enumAuthResult.MSG_SEND_OK == errcode then
            return "短信发送成功！"
        elseif headFile.enumAuthResult.AUTH_CODE_EXPIRE == errcode then
            return "登录短信验证码已过期！"
        elseif headFile.enumAuthResult.AUTH_CODE_ERR == errcode then
            return "短信验证码不正确！"
        elseif headFile.enumAuthResult.SAME_DEVICE_LOGIN_FREQUENTLY == errcode then
            return "同一个设备频繁登录！"
        elseif headFile.enumAuthResult.LOGINED_IN_OTHER_DEVICE == errcode then
            return "已经在另外一个设备登录！"
        else
            return "登录失败, 未知错误！"
        end
    end,
}

--救济金消息 2015.10.20  huang xiang rui
headFile.enumRelieveResult = {
    USE_RELIEVE     = 0,    --使用了一次救济金
    USE_UP          = 1,    --救济金次数用完，无法进入房间
}

--GoodsVary表状态
headFile.goodsVaryStateID = {
    vaild              = 1,    --有效
    not_vaild          = 2,    --无效
}

--GoodsVary表状态
headFile.goodsVaryTypeID = {
    synthetize         = 1,    --合成
    decompose          = 2,    --分解
}

headFile.roomSelfHistoryLimit=10--私人房战绩条数
headFile.roomSelfRecentPlayerLimit=10--展示最近一起游玩的玩家
headFile.roomSelfBlackListLimit=10--黑名单最大人数
headFile.userMinCode=10000000--用户最小编号
headFile.userMaxCode=99999999--用户最大编号

--消息头
headFile.msgHead = {
	msgTag = headFile.MSG_HEAD_TAG,	--2字节 消息头标签
	src = 0,				--2字节 源端点
	dst = 0,				--2字节 目标端点
	dstModule = 0,			--2字节 目标模块
	keyAction = 0,			--2字节 动作
}

------------------------Begin  黄祥瑞 2015.10.13  增加判断第三方标识 --------------------------------------
--第三方平台
headFile.thirdPlatformID = {
    Zipai = 0,          --字牌自己的用户
    LK = 1,              --从老K平台来的用户
    LK_USER_ID = 2,      --传入的参数中，userName为老K的userID
    PC = 3,             --PC版
    YingYongBao = 4,    --应用宝
    Baidu = 5,          --百度
    AppStore = 6,       --App Store
    MiGu = 7,           --咪咕平台
    WeiXin = 8,         --微信用户
    QH360 = 9,          --360平台
    WeiXinQr = 10,      --微信扫码登录
    Phone = 11,         --手机号登录
    WeiXinPublic = 12,  --微信公众号
    WechatGame = 13,    --微信小游戏
    --中文
    [0]="字牌平台",
    [1]="老K账号",
    [2]="老KuserID",
    [3]="PC平台",
    [4]="应用宝平台",
    [5]="百度平台",
    [6]="AppStore",
    [7]="咪咕",
    [8]="微信",
    [9]="360",
    [10]="微信QR",
    [11]="手机",
    [12]="微信公众号",
    [13]="微信小游戏",
    --缩写
    ["0"]="zp",
    ["1"]="lk",
    ["2"]="lk",
    ["3"]="lk",
    ["4"]="yb",
    ["5"]="bd",
    ["6"]="ap",
    ["7"]="mg",
    ["8"]="wx",
    ["9"]="360",
    ["10"]="wxqr",
    ["11"]="phone",
    ["12"]="wxp",
    ["13"]="wechatGame",
}

--设备ID
headFile.deviceID = {
    Android=1,
    IOS=2,
    PC=3,
    H5_WX_PUBLIC=4,
    H5_WX_QR=5,
    WE_CHAT_GAME=6,
}

headFile.payTypeName={
    wx="wx",            --微信（小游戏，公众号，app）
    alipay="alipay",    --支付宝
}

headFile.shareAwardStateID={
    valid=1,--有效
    invalid=2,--无效
}

headFile.syncMatchOnlineNumTime = 10  --定时刷新比赛在线人数时间间隔

--任务状态
headFile.missionStateID={
    invalid=1,--不可领取，未达成，去完成
    going=2,--任务进行中
    valid=3,--可以领取
    over=4,--任务结束，已领取
}
--做任务按钮类型
headFile.gotoMissionBtnType={
    null="null",--不进入任何房间
    rate="rate",--进入倍率房
    match="match",--展示比赛界面
    createNewSelf="createNewSelf",--展示创建包厢界面
    joinNewSelf="joinNewSelf",--展示加入包厢界面
    lobby="lobby",--返回大厅
    showShareLayer="showShareLayer",--打开分享界面
    showShareInGift="showShareInGift",--打开邀请有礼界面
}
--任务类型
headFile.missionType={
    reachGameCount=1,--达成指定局数
    gameShare=2,--游戏分享
}

--发送任务消息的时机
headFile.sendMissionMsgMoment={
    rateBegin="rateBegin",--倍率开局
    matchBegin="matchBegin",--比赛开局
    newSelfBegin="newSelfBegin",--包厢开局
    now="now",--立即发送
}

--分享任务类型
headFile.missionShareType={
    rateResult="rateResult",            --倍率结算分享
    matchCertificate="matchCertificate",--比赛奖状分享
    newSelfResult="newSelfResult",      --包厢战绩分享
    matchEnroll="matchEnroll",          --比赛报名分享
    shareGame="shareGame",              --分享游戏
    inviteFriends="inviteFriends",      --邀请好友分享
    mingTangShare="mingTangShare",      --名堂分享
    shareInGift="shareInGift",            --邀请有礼
}

-- 小游戏展示的地方
headFile.MiNiShowPlace = {
    PLAZA = 1,  -- 大厅
    BOX = 2,    -- 盒子里
    ALL = 3,     -- 都展示
    NONE = 4,      -- 不创建按钮
}

--群主战绩筛选条件
headFile.groupAdminSelfRoomRecordSearchType={
    isAll=0,    --查询全部数据
    isWinner=1,  --查询大赢家
    isDeskOwner=2,  --查询桌主
}

headFile.emailExpireTime=30--邮件过期时间，天
headFile.weiXinUserReadDataFromWebPerDay=3--微信用户每隔多少天从微信网站读取一次数据

--第三方平台限制
headFile.thirdPlatformLimit = {
    allow=0,    --无限制
    limit=1,    --限制
}

--挖矿游戏清理排行榜配置
headFile.miningCleanRankConf = {
    cleanTime="00:00:00",--清理时间
    cleanWeekDay=0,--清理排行榜的日期，0为周日，1为周一，2为周二...
    cleanType=2--清理类型:1为每天清，2为每周清
}

--挖矿房间状态配置
headFile.miningRoomStateID={
    vaild=1,--有效
    invalid=2,--无效
}

--[[
h5游戏配置类型
]]
headFile.h5GameSystemConfigKind = {
    broadcast=1,  --广播配置
    createRoomCostConf = 2, -- 私人房建桌配置
    textConf=3,  --文本配置
}

--redis系统key
headFile.redisSystemKey={
    authPhoneAwardConf="authPhoneAwardConf",      --手机认证奖励配置
    authPhoneAwardText="authPhoneAwardText",	  --手机认证文字描述
    bindNewSpreaderAward="bindNewSpreaderAward",  --绑定推广号奖励
    bindNewSpreaderText="bindNewSpreaderText",    --绑定推广号文字描述
    bindNewSpreaderEmail="bindNewSpreaderEmail",  --绑定推广号邮件内容
    firstShareAwardText="firstShareAwardText",    --首次分享奖励的文字
    userSpreaderRegText="userSpreaderRegText",    --用户推广注册成功的用户奖励文字
    sharePointPriceText="sharePointPriceText",    --分享积分价值文本
    systemMaintenanceTime="systemMaintenanceTime",--系统维护时间
    newSpreaderUpdateLimit="newSpreaderUpdateLimit",--更新NewSpreader表的累计操作次数
    userDataUpdateLimit="userDataUpdateLimit",--更新UserData表的累计操作次数
    showUserShareRankBtn="showUserShareRankBtn",--是否在用户分享界面展示排行榜按钮
    userShareTextInfo="userShareTextInfo",      --活动时间
    userShareTextMsg="userShareTextMsg",      --首次分享奖励
    userShareTextRemark="userShareTextRemark",      --分享说明
    userShareTextNote="userShareTextNote",      --局数达标说明
    shareRankBtnText="shareRankBtnText", --分享界面排行榜按钮上的文字
    userShareEventStartTime="userShareEventStartTime", --用户分享活动开始时间
    userShareEventEndTime="userShareEventEndTime", --用户分享活动结束时间
    userShareClientText="userShareClientText",--用户分享客户端文本
    specialRoomCardSaleText="specialRoomCardSaleText", --群主卡促销文本
    authIdentityCardText="authIdentityCardText",--绑定身份证奖励
}

--排行榜右上角显示内容
headFile.rankingShowType = {
    provision = "provision", --显示条款
    history = "history", --显示历史记录按钮
    provisionhistory = "provisionhistory", --显示条款和历史记录按钮
}

--留言板记录状态
headFile.messageBoardStateID = {
    waiting=1,  --等待处理
    solved=2,   --已处理
}

--留言板配置
headFile.messageBoardConf = {
    timeLimit = 60,  --提交时间间隔，秒
    maxMessageLen=240,  --最大文字限制
}

--通用有效配置
headFile.confValidState={
    valid=1,--有效
    invalid=2,--无效
}

--微信红包配置
--该错误码会作为json字符串出现在useItem的extraData里面
--extraData="{"result" : 0}"
headFile.weiXinRedPaper = {
    result = {
        OK=0,               --使用成功
        NOT_BIND_WEIXIN=1,  --未绑定微信号
        NOT_SUBSCRIBE=2,    --未订阅公众号
        NOT_RELATED=3,      --未关联账号
        FAIL=4,             --其他错误
    },

}

--发送短信验证配置
headFile.shortMsgConf={
    expireTime=90,--过期和重发时间，秒
    rdsKey="ShortMsg",--redis键名
    authCodeLen=4,--验证码长度
}

--添加黑名单错误码
headFile.addBlackErrCode={
    OK=0,--成功
    FAIL=1,--未知错误
    ADD_SELF=2,--不能添加自己
    ADD_REPEAT=3,--不能重复添加
    NOT_FOUND=4,--用户不存在
    READ_DATA_ERR=5,--读取数据库信息失败
    LIST_FULL=6,--达到上限，不可继续添加
}

--用户状态信息ID
--[[
share={int=今日获得分享积分,time=今日时间（时分秒都为0）,text=累计获得的积分}
]]
headFile.userStatusTypeID = {
    share=1,--分享
}

--用户状态ID
headFile.userStateID = {
    normal=1,--正常状态
    loginLimit=2,--限制登陆
    rateLimit=3,--限制进入倍率房
    matchLimit=4,--限制进入比赛房
    privateLimit=5,--限制进入私人房
    gameLimit=6,--限制进入所有游戏房间
    ban3days=7,--禁止3天登录
    banforever=8,--永久禁止登录
}

--用户分享类型
headFile.userShareTypeID = {
    deskPW=1,--分享房间号
    shareBtn=2,--分享有礼按钮
}

--话费卡类型
--[[
使用话费卡凭证的useItem消息中
extraData为话费卡类型
extraData=
{
    "chargeCardType" : 1 #话费卡类型 headFile.chargeCardType
}
]]
headFile.chargeCardType = {
    CMCC = 1,--中国移动
    CTCC = 2,--中国电信
    CUCC = 3,--中国联通
}

--保险柜存取类型ID
headFile.safeBoxTypeID = {
    save=0, --存钱
    take=1  --取钱
}
headFile.useSafeBoxGoldCoinLimit=200000--使用保险柜金币限制
headFile.useSafeBoxPointLimit=0--使用保险柜积分限制
headFile.safeBoxSaveGoldCoinLeft = 200000--保险柜存钱后剩余金币限制
headFile.safeBoxSavePointLeft = 0--保险柜存钱后剩余积分限制
headFile.safeBoxPasswordLen = 30 --安全密码长度
headFile.recentPlayerNum = 10--保存最近多少名玩家ID
headFile.maxAiId = 5000

--保险柜结果码
headFile.safeBoxResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--玩家在游戏中，无法存取
    NOT_ENOUGH = 2,--余额不足
    INFO_FAIL = 3,--获取用户信息失败
    ARGS_ERR  = 4,--参数错误
    LOW_LIMIT = 5,--兑换金额过低
    FAIL = 6,--失败
    TOO_MUCH = 7,--取出的金额太多
    PASS_ERR = 8,--密码不正确
}

--兑换码结果
headFile.redeemResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--玩家在游戏中，无法兑换
    INFO_FAIL = 2,--获取用户信息失败
    ARGS_ERR  = 3,--参数错误
    EXPIRE   = 4,--兑换码已过期
    USED     = 5,--兑换码已使用
    OVER_TIMES = 6,--超过批次限制无法使用
    CODE_ERROR = 7,--兑换码不正确
}
--兑换码状态
headFile.redeemStateID = {
    Available      = 1,--有效
    Inavailable  = 2,--无效
    Used = 3,--已兑换
}

--认证类型
--[[
身份证认证json结构：
{
    "idCard" : "45xxxxxxx14",
    "name" : "张三"
}
手机认证json结构：//第一次填写手机号请求验证时authCode为nil，第二次发送验证码时authCode为验证码
{
    "phone" : "139xxxxxxx14"
    "authCode" : "xxxxxx"
}
全部认证信息json结构：
{
    "userID" : "xxxx"
}
------------------------------------
]]
headFile.authType = {
    idCard = "idCard",  --身份证认证
    phone = "phone",  --手机认证
    all = "all", --返回玩家的全部认证信息
}

--System表特殊Key
headFile.system_key = {
    adminUserName = "adminUserName",    --管理员账号，当该key存在于system表中时，其他账号不允许登陆
}

--老K平台货币类型
headFile.kCurrencyType = {
    kGoldCoin   = 0,        --老K金币
    kCoin       = 1,        --K币

    ["0"]="老K金币",
    ["1"]="K币"
}

--[[
headFile.changeNickNameConf.result作为changeNickName消息的额外参数(extraData)，返回具体错误信息码
]]
headFile.changeNickNameConf = {
    freeChangeNickNameTimes=1,  --免费改名次数
    nickNameMaxLength=16, -- 昵称最大长度
    result={
        currency_not_enough=1,--货币不足，无法修改昵称
    },
}

--商品类型ID
headFile.goodsTypeID = require "item_conf"
headFile.itemTypeID = headFile.goodsTypeID
headFile.itemVariety = headFile.goodsTypeID.itemVariety

--报名费区分
headFile.enrollCostUseType = {
    OR=0,       --或
    AND=1,      --和
}

--商品状态
headFile.goodsStateID = {
    onSale = 0,--出售中
    close = 1,--停止出售
}

--商品兑换状态
headFile.exchangeStateID = {
    examine = 0,--审核中
    fail    = 1,--失败
    ok      = 2,--兑换成功
}
--邮件标签页
headFile.emailTab = {
    systemNotice=1,    --系统公告列表
    systemEmail=2,      --系统邮件列表
    receivedEmail=3,        --已领取邮件列表
}
--邮件状态
headFile.emailStateID = {
    notRead = 0,    --未读
    Read    = 1,    --已读
    Expire  = 2,    --作废的邮件
}
--邮件类型
headFile.emailType = {
    Notice   = 0,      --公告
    Award    = 1,    --奖励
    Ad       = 2,   --广告
    MatchAward = 3, --比赛奖励邮件
    Important  = 4,   --重要邮件
}

--推广号状态
headFile.spreaderState = {
    valid = 1,      --有效
    invalid = 2,    --无效
}

--配置状态
headFile.confState = {
    valid = 1,      --有效
    invalid = 2,    --无效
}

--奖励邮件状态
headFile.awardEmailStateID = {
    valid = 1,      --有效
    invalid = 2,    --无效
}

--是否终止连胜
headFile.stopWin = {
    No = 0,      --否
    Yes = 1,    --是
}

--比赛标记
headFile.matchTag = {
    perMatch = 1,   --预赛
    finMatch = 2,   --决赛
}

--性别ID
headFile.sexID = {
    Male = 0,   --男
    Female = 1,   --女
}
--倍率房AI配桌控制
headFile.aiControl = {
    FREE = 0 ,                  --不控制AI配桌
    CONTROL = 1,                --完全控制 只能和AI配桌
}

--购买房卡记录表备注ID
headFile.roomCardPurchaseRemarkID={
    Buy=1,--购买
    Use=2,--使用
    Send=3,--赠送

    [1]="购买",
    [2]="使用",
    [3]="赠送",
}
--服务器状态
headFile.serverStateID={
    up=1,   --上线
    down=2, --下线
}
headFile.heartBeatTime = 25 --心跳间隔时间
headFile.encodeFlag=true  --加密开关
headFile.heartBeatFlag=true --心跳开关
headFile.heartBeatReconnectTimes=2--心跳重连次数
headFile.emailAmountLimit=20--登陆读取多少封邮件
headFile.cleanMemSleepTime=60 --清理内存睡眠时间，秒
headFile.cleanMemFlag=true--是否开启清理内存
headFile.checkServerStateFlag=true--是否开启服务器状态检查
headFile.checkServerStateTime=10--检查服务器状态时间间隔，秒
headFile.hotUpdateFlag=true--是否开启热更新检查
headFile.hotUpdateCheckTime=60--热更新检查间隔，秒
----------------------End 黄祥瑞 2015.10.013---------------------------

------Begin: mingyuan.xie added 2015.10.24 ------------
--进入房间结果码 
headFile.enterRoomResult = {
	SUCCESS				= 1,	--进入成功
	ROOM_FULL			= 2,	--房间满
	USER_IN_GAMING		= 3,    --玩家已经在游戏中
	CHANGE_ROOM_FAIL	= 4,	--换房间失败
    COME_BACK_FAILED    = 5,    --返回游戏失败
    COME_BACK_SELF_FAILED = 6,  --回到私人场错误
    ROOM_LOCKED = 7,            --房间已经被锁定
    GOLDLESS = 8,               --金币不足
    GOLDLESS_SAFEBOX = 9,       --金币不足,请从保险柜获取
}
------End: mingyuan.xie added 2015.10.24 ------------

--创建私人桌结果码   
headFile.createSelfDeskResult = {
    SUCCESS             = 1,    --创建成功
    FAIL                = 2,    --创建失败    --其他返回值有待加入
    GOLDLESS            = 3,    --金币不足
    TIME_OFTEN          = 4,    --建桌过于频繁
    KCOIN_LESS          = 5,    --Ｋ币不足
    ENROLL_LESS         = 6,    --建桌道具不足
    ROOM_LOCKED         = 7,    --房间已经被锁定
    CONF_NOFIND         = 8,    --配置错误 尝试退出大厅从新进入
    PROXY_LIMIT         = 9,    --代理开房的房数最大值
}

--进入私人桌结果码   
headFile.enterSelfDeskResult = {
    SUCCESS             = 1,    --进入成功
    FULL                = 2,    --人数已满 进入失败
    PWREEOR             = 3,    --密码错误 进入失败
    INDESKAREADY        = 4,    --已经在本桌中 进入失败
    UNKNOW              = 5,    --未知原因 进入失败     --其他返回值有待加入
    NOFIND              = 6,    --桌子不存在
    GOLDLESS            = 7,    --金币不足
    GAMING              = 8,    --游戏中
    ROOM_LOCKED         = 9,    --房间已经被锁定
    ENROLL_LESS         = 10,   --道具不足
    NO_PERMISSION       = 1000,   --您无权限加入此房间
}
--私人桌是否加密
headFile.selfDeskFlag = {
    OWNER               = 1,   --房主
    AA                  = 2,   --AA制
    PRIVILEGE           = 3,   --特权房间
    ENCREYPT            = 4,   --加密
    FREE                = 5,   --不加密
}

--私人桌房间标记
headFile.selfRoomFlag = {
    OWNER=1,                --桌主
    AA=2,                   --AA制
}

--玩家请求准备或取消准备
headFile.readyInfo = {
    READY_REQUEST = 1,
    READY_CANCEL = 2,
}
--玩家请求准备或取消准备是否成功
headFile.readyResult = {
    SUCCESS            = 1,  
    FAIL                = 2,                   
}

--玩家点取消退出桌子是否成功
headFile.cancelResult = {
    SUCCESS            = 1,     --成功
    GAMING             = 2,     --已经在游戏中 不能取消
    UNKNOW             = 3,     --未知 不能取消 
    NOINDESK           = 4,     --不在桌子中（已被踢除） 客户端强行返回大厅  
}
--桌主请求开局结果
headFile.requestGaming = {
    SUCCESS            = 1,     --成功
    GAMING             = 2,     --已经在游戏中 
    LACKAGENT          = 3,     --人数不够  有玩家退出
    NOOWNER            = 4,     --不是桌主 不能开始 
    UNKNOW             = 5,     --未知  
    OFFLINE            = 6,     --有人掉线
    NOREADY            = 7,     -- 有玩家没有准备
}
--桌主踢人是否成功
headFile.kickResult = {
    SUCCESS            = 1,     --成功
    GAMING             = 2,     --已经在游戏中 
    NOFIND             = 3,     --找不到该玩家 已掉线 或退出
    UNKNOW             = 4,     --未知 
}

--桌主解散桌子是否成功
headFile.destroyDeskResult = {
    SUCCESS            = 1,     --成功
    GAMING             = 2,     --已经在游戏中 
    UNKNOW             = 3,     --未知 
}
--退出私人房结果
headFile.leaveRoomSelfResult = {
    SUCCESS            = 1,     --成功
    GAMING             = 2,     --已经在游戏中 
    UNKNOW             = 3,     --未知  失败
}
-- 私人场桌子的状态
headFile.roomSelfDeskState = {
    GAMING              = 1,            --游戏中
    IDLE                = 2,            --等待
    REQUEST_CONTINUE    = 3,            --续费中 
    NOT_FULL            = 4,            --缺人
    FULL                = 5,            --满人 
    FREE                = 6,            --无人
    
}
--创建桌子时是否保存配置
headFile.saveDeskConf = {
    SAVE       = 1,            --保存
    NONE       = 2,            --不保存
}
--保存建桌配置结果
headFile.saveDeskConfResult = {
    SUCCESS            = 1,     --成功
    FAIL               = 2,     --失败
    WRONG_CHAR         = 3,     -- 错误的字符
}

-- 私人场玩家被踢出原因
headFile.agentKickedReason = {
    GOLDLESS            = 1,    --金币不足
    KICKSELF            = 2 ,   --自己退出  客户端不显示
    ENROLL_LESS         = 3,    --道具不足
    TIME_OUT            = 4,    --续费超时踢出玩家
}

-- 私人场散桌原因
headFile.destroyDeskReason = {
     GOLDLESS            = 0,    -- 金币不足
     OWNERRQUEST         = 1,    -- 桌主主动申请
     AGREE_DESTROY       = 2,    --同意解散
     ENROLL_LESS         = 4,    -- 道具不足

}
--是否掉线
headFile.agentAutomatic = {
    ONLINE              = 1,    --在线
    OFFLINE             = 2,    --掉线
}

--订单状态
headFile.onlinePayNotifyStatus = {
    wait = 0,   --等待处理
    over = 1,   --已处理
    error= 2,   --异常
}

--私人桌请求继续开局结果码
headFile.gameContinueResult = {
    SUCCESS            = 1,    --成功
    GOLDCOIN_LESS      = 2,    --金币不足
    KCOIN_LESS         = 3,    --Ｋ币不足
    ENROLL_LESS        = 4,    --建桌道具不足
    UNKNOW             = 5,    --未知
    ROOM_LOCKED        = 6,    --房间加锁
    SPECIAL_ROOM_CARD_LESS = 7 --专用对战卡不足
}

--私人桌建桌类型
headFile.createSelfDeskType = 
{
    COST = 1,                 --消耗型
    FREE = 2,                 --免费型  
    CONFIG_ERROR = 3,         --配置错误
}

--解散桌子动作信息
headFile.dissoluteKey = 
{
    REQUEST_DISSOLUTE = 1,     --申请解散
    REFUSE_DISSOLUTE = 2,      --不同意解散
    AGREE_DISSOLUTE = 3,       --同意解散
}

--获取牌桌规则结果码
headFile.getDeskRulesResult = {
    SUCCESS             = 1,    --获取成功
    FULL                = 2,    --人数已满 
    NOFIND              = 3,    --桌子不存在
    INDESKAREADY        = 4,    --已经在本桌中 
    UNKNOW              = 5,    --未知原因    
   
}

--续费询问返回动作码
headFile.gameContinueSelectKey = {
    AGREE_CONTINUE = 1,         --同意继续打
    REFUSE_CONTINUE = 2,        --不同意继续打 离开
}

------Begin: huang xiang rui added 2015.11.02 ------------
--排行类型
headFile.rankType = {
["TotalGoldCoinRank"]=1,--金币总量排行
["HistoryTopFanXingRank"]=2,--历史最高翻醒排行      
["WeekTopFanXingRank"]=3,--每周最高翻醒排行
["HistoryTopWinStreakRank"]=4,--历史最高连胜排行
["WeekTopWinStreakRank"]=5,--每周最高连胜排行       
["HistoryWinRateRank"]=6,--历史胜率排行
["WeekWinRateRank"]=7,--每周胜率排行
["TotalGamesRank"]=8,--游戏总局数排行
["TotalLevelExpRank"]=9,--等级经验值排行
["WeekCurWinStreakRank"]=10,--每周当前连胜排行
["HistoryCurWinStreakRank"]=11,--历史当前连胜排行
["SumFanXingRank"]=12,--累计翻醒排行
["DayWinGoldCoinRank"]=13,--每日赢金币排行         ←有数据
["DaySumFanXingRank"]=14,--每日累计翻醒排行         ←有数据
["DayTopWinStreakRank"]=15,--每日最高连胜排行        ←有数据
["DayCurWinStreakRank"]=16,--每日当前连胜排行
["DayTopFanXingRank"]=17,--每日最高翻醒排行          ←有数据
}

--结果码
headFile.resultCode = {
    OK          =   0,      --成功
    FAIL        =   1,      --失败
    WRITE_CONCACT_WAY =   3,--填写联系方式
    CONCACT_WAY_ERROR =   4,--联系方式不正确
    USE_SUCCESS = 5,        --实物兑换成功
    WRITE_RECHARGE_CARD = 6, --填写电话，充值卡用 
}

--最低老K金币兑换字牌金币额度
headFile.minExchangeLimit = 100000
--积分兑换金币比例参数，即1积分可兑换point2goldCoinRate个金币
headFile.point2goldCoinRate = 10000
--玩家身上携带最大金币
headFile.maxHaveLimit=1000000000
--当达到多少金币时需要将过多的金币存入保险柜
headFile.needSaveLimit=1500000000

--扣除老K货币结果码
headFile.rechargeResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--玩家在游戏中，无法扣除
    NON     = 2,--未知错误
    NOT_ENOUGH = 3,--余额不足
    EXPIRE  = 4,--token过期
    TIME_OUT = 5,--请求超时
    INFO_FAIL = 6,--获取用户信息失败
    ARGS_ERR  = 7,--参数错误
    LOW_LIMIT = 8,--兑换金额过低
    FAIL      = 9,--充值失败
    SOLE_OUT  = 10,--没有库存（兑换用）
}

--兑换结果码
headFile.exchangeResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--玩家在游戏中，无法扣除
    NOT_ENOUGH = 2,--余额不足
    INFO_FAIL = 3,--获取用户信息失败
    FAIL      = 4,--兑换失败，未知错误
    SOLE_OUT  = 5,--没有库存（兑换用）
    EXPIRE    = 6, --商品过期
}

--积分兑换金币结果码
headFile.point2goldCoinResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--玩家在游戏中，无法扣除
    ARGS_ERR = 2,--参数错误
    NOT_ENOUGH = 3,--余额不足
    FAIL    = 4,--失败
}

--送红包结果码
headFile.sendRedPaperResultCode = {
    OK      = 0,--成功
    GAMING  = 1,--在游戏中无法赠送
    ARGS_ERR = 2,--参数错误
    NOT_ENOUGH = 3,--余额不足
    FAIL    = 4,--失败
    SENDER_TIMES_USE_UP = 5,--赠送人赠送次数用完
    SENDER_LEVEL_ERR = 6,--赠送人的等级不足
    GETTER_TIMES_USE_UP = 7,--对方接收次数用完
    GETTER_LEVEL_ERR = 8,--对方等级不足
    NOT_EXISTS = 9,--对方用户不存在
    SEND_TO_SELF = 10,--不允许赠送给自己
    SENDER_NOT_AUTH=11,--赠送人未手机认证
    GETTER_NOT_AUTH=12,--获赠人未手机认证
}

--救济金结果
headFile.relieveResult = {
    GET     = 1,--领取成功
    USE_UP  = 2,--次数用完
}

--比赛报名记录的状态
headFile.matchEnrollStateID = {
    Enrolled  = 0,--已报名
    Started  = 1,--比赛已开始
    Over  = 2,--比赛结束
}

--UserMatter表配置
headFile.UserMatter = {
    stateID={
        notHandle=0,    --已处理
        handled=1       --未处理
    },
    flag={
        login=0,  --登陆
        logout=1, --离线
    },
    matterKey={
        newItem="newItem",--有新种类的道具
    }

    --[[
        newItem的说明：
        有效的字段是matterValue：新道具的种类
        extra：json字符串，
        {
            [
                {
                    "amount" : 数量,
                    "userGoodsID" : UserGoods表ID,
                    "goodsID" : Goods表ID,
                    "expireTime" : "2016-01-01 00:00:00",
                    "obtainTime" : "2016-01-01 00:00:00"
                }
            ]
        }
    ]]
}

--广播配置
--[[
useItem协议中的extraData，只需要一个字段:content，string类型，广播的文字
返回值的extraData中只有一个字段，result，int类型，结果码
]]
headFile.radioConf = {
    sendRadioPerTime=16, --一个人发送广播的间隔
    defaultDuration = 3,  --默认sleep时间，秒
    maxRadioNumInList = 2, --队列最大长度，超过不允许加入队列
    maxMessageLen=50,  --广播最大消息长度
    showType = {
        ROLL = 1,--滚动
        STAY = 2,--悬停
        POP = 3,--弹窗
    },
    radioType = {
        SYSTEM = 1,--系统广播
        PLAYER = 2,--玩家广播
    },
    result = {
        OK = 0,         --成功
        ARGS_ERR = 2,   --参数错误
        TEXT_ERR = 3,   --带有敏感词
        STATE_ERR = 4,  --玩家状态不正确
        INFO_ERR = 5,   --获取玩家信息失败
        FULL = 6,       --当前广播队列已满
        NOT_ENOUGH = 7, --道具不足
    },
    systemRadioSortNum=1,  --系统广播排序值
    playerRadioSortNum=10,  --玩家广播排序值
}

------End: huang xiang rui  added 2015.11.02 ------------

---Begin: guanying 合并gameData 2015.11.04    ------------

headFile.ACT_PRI = {
    -----用于权限比较和识别动作
	DISCARD = 1,    --放弃
	EAT = 2,		-- 吃
	BUMP = 3,		-- 碰
	
	OPEN_GEST_H = 4,	-- 手牌开招  
	OPEN_GEST_D_F = 5,	-- 桌面牌明开招
	OPEN_GEST_D_B = 6,	-- 桌面牌暗开招
	
	HU = 7,			-- 胡
    
	SWEEP = 8,	    -- 扫
	SWEEP_PASS = 9,     --过扫
	SWEEP_ALL_H = 10,    --手牌扫穿
	SWEEP_ALL_D = 11,	-- 桌面牌扫穿

	-----------以下用于记录 不用于比较权限
	MOCARD = 12,       --摸牌
	STILLCARD = 13,	   --弃牌
	PUTCARD = 14       --出牌
}
-- 被检查牌的类型,通知执行胡的动作  放入details 中
headFile.HU_TYPE = {
	MO_SELF = 1,     -- 自摸胡		客户端显示自摸 	
	NORMAL = 2,      -- 正常胡		客户端显示胡
	POINT_GUN = 3,   -- 点炮胡		客户端显示胡
	TIAN_HU = 4,	 --天胡			客户端显示天胡
	DI_HU = 5,		 --地胡			客户端显示地胡	
	SAN_LONG = 6,	 -- 三龙		客户端显示三龙
	WU_KAN = 7,		 --五坎			客户端显示五坎
}
--是否重招
headFile.OPEN_STYLE = {
	OPEN_SINGLE = 1,
	OPEN_DOUBLE = 2,
}
--胡牌时 牌飞的方向
headFile.HUCARD_DIRE = {
	DIRE_NIL = 0,         	   --天胡,三龙五坎没有飞牌
	DIRE_HANDCARD = 1,         --飞向手牌
	DIRE_DESKCARD = 2,		   --飞向桌面
        DIRE_SAOCHUAN = 3,         --扫穿胡牌
}
--倒计时区分
headFile.DOWN_TYPE = {
	DOWN_PLAYCARD = 1,         --出牌等待
	DOWN_SELECT = 2,		   --选择等待
}
--出牌是否合法
headFile.POPCARD_LEGAL = {
	POP_UNLEGAL = 0,           --不合法
	POP_LEGAL = 1, 			   --合法
}

-- 消费道具的类型
-- @author Zhenyu Yao, 2015.11.24
headFile.COST_TYPE = {
    GOLD_COIN               = "goldCoin",           --金币类型
    COMMON_TICKET           = "commonTicket",       --普通入场券
    GREAT_TICKET            = "greatTicket",        --大师赛入场券
    DIAMOND_TICKET          = "diamond",            --钻石
    PLATINUM                = "platinum",           --白金卡
    SPECIAL_TICKET          = "specialTicket",      --特殊入场券(比如为某公司定制的比赛，消耗特殊入场券，后面要定义一个特殊入场券列表)
}

----end
---------


------ mingyuan.xie added 2015.11.12 ------------
--比赛大区码
headFile.matchZoneCode = {
	ZONE_1		        = 1,	--新手赚金区
	ZONE_2				= 2,	--实物大奖区
	ZONE_3				= 3,	--红包大奖区
	ZONE_4		        = 4,	--冠名赛事区
	ZONE_5				= 5,	--公会赛专区
    ZONE_6              = 6,    --红牛活动区
    ZONE_7              = 7,    --上岛咖啡专区
    ZONE_8              = 8,    --高手赛事区
	-- END 				= 20,  min.luo 2016.7.18  去掉END字段
}

--客户端显示的比赛图标码
headFile.matchIcon = {
	GOLD_1				= 1,	--有金牌1的图标
	FARE_2				= 2,	--2元话费图标
	FARE_5				= 3,	--5元话费图标
	FARE_50				= 4,	--50元话费图标
	GOLD_TICKET			= 5,	--有金币和奖券的图标
	GOLD_DOLLAR 		= 6,	--金币上有美元符的图标
	GOLD_2000_W			= 7,	--金币上有2千万
	DOOR				= 8,	--门票图标
}

headFile.MatchPhase = {
    DA_LI_CHU_JU = 1,       -- 打立出局
    DING_JU_JI_FEN = 2,     -- 定局积分
}

-- 比赛报名错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchEnroll = {
    MATCHING = 1,           -- 比赛中
    ALREADY_IN = 3,         -- 已经报了名
    FULL = 4,               -- 人数已满
    NO_COINS = 5,           -- 钱不够
    NO_TIME = 6,            -- 时间没到
    NOT_TIME_MATCH = 7,     -- 非定时赛功能
    TIME_MATCH_CLOSE = 8,   -- 定时赛关闭
    TIME_MATCH_NO_ONE = 9,  -- 定时比赛正在关闭, 报名人数不足
    WRONG_STAGE_NUM = 10,   -- 错误的阶段
    NO_ENROLLED = 11,       -- 之前没有报名
    ENROLL_TIMEOUT = 12,    -- 超过报名时间
    LESS_THAN_INTEGRAL = 13, -- 小于淘汰积分
    LESS_THAN_ABORT_NUM = 14, -- 小于截止人数
    NO_FIT_WHITE_LIST = 15, -- 不符合白名单逻辑
    OUT_RANGE_INDEX = 16,       -- 索引越界
    OPEN_MAX = 17,           -- 超过比赛打开的最大数量
    NO_INIT = 18,           -- 比赛还未初始化完成
    WEEDED = 19,            -- 已经被淘汰
    LOCKED = 20,           -- 比赛被锁定   feng.qin added for match lock 2016.6.6
    NO_ITEMS = 21,           -- 缺道具

    errString = function(errcode)
        if errcode == headFile.ErrCode_MatchEnroll.MATCHING then
            return "比赛中"
        elseif errcode == headFile.ErrCode_MatchEnroll.ALREADY_IN then
            return "已经报了名"
        elseif errcode == headFile.ErrCode_MatchEnroll.FULL then
            return "人数已满"
        elseif errcode == headFile.ErrCode_MatchEnroll.NO_COINS then
            return "金币不够"
         elseif errcode == headFile.ErrCode_MatchEnroll.NO_ITEMS then
            return "道具不够"
        elseif errcode == headFile.ErrCode_MatchEnroll.NO_TIME then
            return "时间没到"
        elseif errcode == headFile.ErrCode_MatchEnroll.NOT_TIME_MATCH then
            return "非定时赛功能"
        elseif errcode == headFile.ErrCode_MatchEnroll.TIME_MATCH_CLOSE then
            return "定时赛关闭"
        elseif errcode == headFile.ErrCode_MatchEnroll.TIME_MATCH_NO_ONE then
            return "定时比赛正在关闭, 报名人数不足"
        elseif errcode == headFile.ErrCode_MatchEnroll.WRONG_STAGE_NUM then
            return "错误的阶段"
        elseif errcode == headFile.ErrCode_MatchEnroll.NO_ENROLLED then
            return "之前没有报名"
        elseif errcode == headFile.ErrCode_MatchEnroll.ENROLL_TIMEOUT then
            return "超过报名时间"
        elseif errcode == headFile.ErrCode_MatchEnroll.LESS_THAN_INTEGRAL then
            return "小于淘汰积分"
        elseif errcode == headFile.ErrCode_MatchEnroll.LESS_THAN_ABORT_NUM then
            return "小于截止人数"
        elseif errcode == headFile.ErrCode_MatchEnroll.OPEN_MAX then
            return "超过比赛打开的最大数量"
        elseif errcode == headFile.ErrCode_MatchEnroll.NO_INIT then
            return "比赛还未初始化完成"
        elseif errcode == headFile.ErrCode_MatchEnroll.WEEDED then
            return "已经被淘汰"
        elseif errcode == headFile.ErrCode_MatchEnroll.LOCKED then
            return "比赛被锁定，暂时不能报名"
        end
        return "未知错误码"
    end,
}

--  报名条件限制
-- @author KF.Qin 2017.4.6
headFile.TipsType_MatchEnroll = {    
    PERSON_FIT = 1,         -- 个人符合条件
    PERSON_NOTFIT = 2,      -- 个人不符合条件
    SERVER_ERROR = 3,       -- 服务器内部程序出错

}

--  报名条件限制
-- @author KF.Qin 2017.4.6
headFile.Tips_MatchEnroll = { 
    UNKNOWN = 1 ,       -- 未知错误
    FIT = 2 ,           -- 符合
    NO_ITEMS = 3,       -- 道具不足
    NOTIN_WHITELIST = 4,-- 不在白名单
    LEVEL_LESS = 5,     -- 等级太低
    LEVEL_MORE = 6,     -- 等级太高
    ERROR_SPREADER = 7, -- 错误推广码
    COINS_LESS = 8 ,    -- 金币太少
    COINS_MORE = 9 ,    -- 金币太多
    NO_PHONE = 10,      -- 没有绑定老K平台手机（弃用，兼容）
    ERROR_NEWSPREADER = 11,--错误邀请码
    NO_APPPHONE = 12,   -- APP上没有绑定手机
    NO_ID = 13,         -- 没有绑定身份证
    RECHARGE_LESS = 14 ,-- 充值不足
    RECHARGE_MORE = 15 ,-- 充值过多
    ITEMS_COINS_LESS = 16 ,-- 报名道具中金币不足
}



-- 比赛取消报名错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchCancelEnroll = {
    MATCHING = 1,           -- 比赛中
    NO_IN = 2,              -- 不在报名列表中
    NO_INIT = 3,            -- 准备比赛

    errString = function(errcode)
        if headFile.ErrCode_MatchCancelEnroll.MATCHING == errcode then
            return "比赛中"
        elseif headFile.ErrCode_MatchCancelEnroll.NO_IN == errcode then
            return "不在报名列表中"
        elseif headFile.ErrCode_MatchCancelEnroll.NO_INIT == errcode then
            return "比赛还未初始化完成"
        end
        return "未知错误码"
    end
}

-- 开始比赛错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchBegin = {
    MATCHING = 1,           -- 正在比赛
    NO_FULL = 2,            -- 人数未满
    NOT_TIME_MATCH = 3,     -- 不是计时赛

    errString = function(errcode)
        if headFile.ErrCode_MatchBegin.MATCHING == errcode then
            return "比赛中"
        elseif headFile.ErrCode_MatchBegin.NO_FULL == errcode then
            return "人数未满"
        elseif headFile.ErrCode_MatchBegin.NOT_TIME_MATCH == errcode then
            return "非定时赛功能"
        end
        return "未知错误码"
    end
}

-- 比赛复活错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchRevive = {
    CLOSE = 1,          -- 没开复活功能
    NO_MONEY = 2,       -- 没钱
    MAX_COUNT = 3,      -- 到达最大次数
    PHASE_WRONG = 4,    -- 错误的阶段
    NUMBER_WRONG = 5,   -- 错误的人数
    TIME_WRONG = 6,     -- 时间错误
    NO_MATCHING = 7,    -- 比赛还未开始
    NO_IN = 8,          -- 用户不在淘汰列表中
    WRONG_STAGE_NUM = 9,    -- 错误的阶段
    OUT_RANGE_INDEX = 10,   -- 索引越界
    WRONG_USER_STATE = 11,  -- 错误的用户状态
    LESS_THAN_INTEGRAL = 12,    -- 复活积分小于出局积分

    errString = function(errcode)
        if headFile.ErrCode_MatchRevive.CLOSE == errcode then
            return "没开复活功能"
        elseif headFile.ErrCode_MatchRevive.NO_MONEY == errcode then
            return "没钱"
        elseif headFile.ErrCode_MatchRevive.MAX_COUNT == errcode then
            return "到达最大次数"
        elseif headFile.ErrCode_MatchRevive.PHASE_WRONG == errcode then
            return "错误的阶段"
        elseif headFile.ErrCode_MatchRevive.NUMBER_WRONG == errcode then
            return "错误的人数"
        elseif headFile.ErrCode_MatchRevive.TIME_WRONG == errcode then
            return "超过规定时间"
        elseif headFile.ErrCode_MatchRevive.NO_IN == errcode then
            return "用户不在淘汰列表中"
        elseif headFile.ErrCode_MatchRevive.WRONG_STAGE_NUM == errcode then
            return "错误的阶段"
        elseif headFile.ErrCode_MatchRevive.OUT_RANGE_INDEX == errcode then
            return "索引越界"
        elseif headFile.ErrCode_MatchRevive.WRONG_USER_STATE == errcode then
            return "错误的用户状态"
        elseif headFile.ErrCode_MatchRevive.LESS_THAN_INTEGRAL == errcode then
            return "复活积分小于出局积分"
        end
        return "未知错误码"
    end
}

-- 录像视频的错误码
-- @author Zhenyu Yao
headFile.ErrCode_HistoryVideo = {
    WR = 1,         -- 读写文件错误
    DB = 2,         -- 数据库操作
    NO_MONEY = 3,   -- 钱不够

    errString = function(errcode)
        if headFile.ErrCode_HistoryVideo.WR == errcode then
            return "读写文件错误"
        elseif headFile.ErrCode_HistoryVideo.DB == errcode then
            return "数据库操作"
        elseif headFile.ErrCode_HistoryVideo.NO_MONEY == errcode then
            return "金币不足"
        end
        return "未知错误码"
    end
}

-- 比赛 clientConnect 返回错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchConnect = {
    MATCHING_NO_USER = 1, -- 比赛中, 但是没玩家
}

headFile.onlineType = {
    RATE            = 1,    --倍率房
    MATCH           = 2,    --比赛房
    SELF            = 3,    --私人房
}

-- 比赛房返回比赛结果
-- @author Zhenyu Yao, 2015.11.28
headFile.matchComeBackResult = {
    FAILED_GAMING = 1,          -- 回到当前牌局失败
    WAITING_DESKS = 2,          -- 等待其他的桌子结束牌局
    MATCH_NO_BEGIN = 3,         -- 比赛还没有开始
    COME_BACK_GAMING = 0,       -- 回到当前的牌局
}

headFile.comeBackMatch_F = {
    YES             = 0,    --断线重连后重新回到比赛中
    NO              = 1,    --非重新回到比赛
}

headFile.matchType = {
    FULL             = "FULL",      --人满赛
    TIMING           = "TIMING",    --定时赛
}

--私人场表前缀
headFile.newRoomSelfPreTableName = {
    NewRoomSelf="NewRoomSelf",--跑胡子私人场
    HgwRoomSelf="NewRoomSelf",--红拐弯私人场
}

--畅天游结果码
headFile.useItemResultCode={
    OK=0,
    ARGS_ERR=1,--参数错误
    INFO_FAIL=2,--获取玩家信息失败
    GAMING=3,--玩家在游戏中无法充值
    NOT_AUTH=4,--玩家手机未认证
    ORDER_FAIL=5,--发送订单失败
    PHONE_ERR=6,--号码错误
    RMB_ERR=7,--金额不正确
    ACCOUNT_ERR=8,--帐户错误
    IP_ERR=9,--授权IP不正确
    KEY_ERR=10,--key参数错误
    MONEY_ERR=11,--帐户余额异常
    PAUSE_PHONE=12,--号码暂停使用
    BLACK_PHONE=13,--号码是黑名单
    ORDER_REPEAT=14,--订单号重复
    NOT_ENOUGH=15,--余额不足
    PRODUCT_ERR=16,--没有该产品
    SYSTEM_ERR=17,--系统错误
    EXPIRE=18,--道具过期
    CAN_NOT_USE=19,--该道具不能使用
    }

    headFile.useItemResultCode[0]=headFile.useItemResultCode.OK
    headFile.useItemResultCode[1001]=headFile.useItemResultCode.ARGS_ERR
    headFile.useItemResultCode[1002]=headFile.useItemResultCode.PHONE_ERR
    headFile.useItemResultCode[1003]=headFile.useItemResultCode.RMB_ERR
    headFile.useItemResultCode[1004]=headFile.useItemResultCode.ACCOUNT_ERR
    headFile.useItemResultCode[1005]=headFile.useItemResultCode.ACCOUNT_ERR
    headFile.useItemResultCode[1006]=headFile.useItemResultCode.IP_ERR
    headFile.useItemResultCode[1007]=headFile.useItemResultCode.KEY_ERR
    headFile.useItemResultCode[2002]=headFile.useItemResultCode.MONEY_ERR
    headFile.useItemResultCode[2001]=headFile.useItemResultCode.PAUSE_PHONE
    headFile.useItemResultCode[2003]=headFile.useItemResultCode.BLACK_PHONE
    headFile.useItemResultCode[2004]=headFile.useItemResultCode.ORDER_REPEAT
    headFile.useItemResultCode[2005]=headFile.useItemResultCode.NOT_ENOUGH
    headFile.useItemResultCode[2006]=headFile.useItemResultCode.PRODUCT_ERR
    headFile.useItemResultCode[9999]=headFile.useItemResultCode.SYSTEM_ERR

--畅天游订单状态
headFile.CTUOrderState={
    OK=0,
    FAIL=1,
    WAIT=2,     --等待处理
}
headFile.qh360ProductStateID={
	vaild=1,
    invalid=2,
}

-- 支付类型
headFile.PAY_KIND = {
    WEIXIN = 1,
    ALI = 2,
    QR_WEIXIN = 3,
    QR_ALI = 4,
    H5_WEIXIN = 5,
}

headFile.pay3rdType = {
    WFT = 1,    -- 威富通
    HFB = 2,    -- 汇付宝
    H5 = 3,     -- H5 支付
}

-- 房间类型
-- @author Zhenyu Yao, 2015.12.22
headFile.roomType = {
    LOBBY = 0,              -- 大厅
    RATE = 1,               -- 倍率房
    MATCH = 2,              -- 比赛房
    SELF_ROOM = 3,          -- 私人场
    NEW_SELF_ROOM = 4,      -- 新私人场
    NEW_SELF_ROOM_R = 5,    -- 红拐弯新私人场	
    ROOM_NIUNIU = 6,        -- 牛牛
    NIUNIU_RATE = 7,        -- 牛牛金币场
    ROOM_PDK = 10,           -- paodekuai
    PDK_RATE = 51,

    type2Str=function(rmTp)
        if rmTp == tostring(headFile.roomType.LOBBY) then
            return "lobby"
        end
        if rmTp == tostring(headFile.roomType.RATE) then
            return "rate"
        end
        if rmTp == tostring(headFile.roomType.MATCH) then
            return "match"
        end
        if rmTp == tostring(headFile.roomType.SELF_ROOM) then
            return "self"
        end
        if rmTp == tostring(headFile.roomType.NEW_SELF_ROOM) then
            return "newSelf"
        end
	if rmTp == tostring(headFile.roomType.NEW_SELF_ROOM_R) then
            return "hgwSelf"
        end
	if rmTp == tostring(headFile.roomType.ROOM_NIUNIU) then
            return "niuniu"
        end
	if rmTp == tostring(headFile.roomType.ROOM_PDK) then
            return "pdk"
        end
	if rmTp == tostring( headFile.roomType.PDK_RATE ) then
		    return "pdk_rate"
        end
    end
}

-- 获得报名人数错误的错误码
-- @author Zhenyu Yao
headFile.ErrCode_MatchGetEnrollNum = {
    MATCHING = -1,      -- 比赛中
}

------add guanying 强制踢玩家下线的错误码
headFile.ErrCode_KickOffLine = { 
    REQUEST_UNLEG     = 0,  --请求违法
    HEART_BEAT_TIME_OUT = 1, --心跳超时
}

------add guanying 倍率房增加AI的时段控制
headFile.addAiControl = {
    [100] = {{0,6,2},{7,23,2}},
    [200] = {{0,6,2},{7,23,2}},
    [500] = {{0,6,2},{7,23,2}},
    [1000] = {{0,6,2},{7,23,2}},
    [2000] = {{0,6,2},{7,23,2}},
    [5000] = {{0,6,2},{7,23,2}},
    [10000] = {{0,6,2},{7,23,2}},
    [20000] = {{0,6,2},{7,23,2}},
    [50000] = {{0,6,2},{7,23,2}},
    [100000] = {{0,6,2},{7,23,2}},
}

-- 定时赛离开报名界面错误码
-- @author Zhenyu Yao
headFile.ErrCode_TimingMatchEnrollLeave = {
    NO_ENROLLED = 1,    -- 未报名
    MATCHING = 2,       -- 比赛开始
    NO_CONNECT = 3,     -- 没有连接
    NO_FULL_MATCH = 4,  -- 人满赛不支持

    errString = function(ec)
        if headFile.ErrCode_TimingMatchEnrollLeave.NO_ENROLLED == ec then
            return "玩家未报名"
        elseif headFile.ErrCode_TimingMatchEnrollLeave.MATCHING == ec then
            return "比赛已经开始"
        elseif headFile.ErrCode_TimingMatchEnrollLeave.NO_CONNECT == ec then
            return "没有连接"
        elseif headFile.ErrCode_TimingMatchEnrollLeave.NO_FULL_MATCH == ec then
            return "人满赛不支持"
        else
            return "未知错误"
        end
    end,
}

-- 关注比赛
-- @author Zhenyu Yao
headFile.ErrCode_FollowMatch = {
    CLOSE = 1,      -- 比赛关闭
    FOLLOWED = 2,   -- 请求关注时, 已经关注过
    UNFOLLOWED = 3, -- 请求取消关注时, 还未关注过
    WRONG_MATCH_TYPE = 4,   -- 错误的比赛类型

    errString = function(code)
        if headFile.ErrCode_FollowMatch.CLOSE == code then
            return "比赛已经关闭"
        elseif headFile.ErrCode_FollowMatch.FOLLOWED == code then
            return "已经关注过"
        elseif headFile.ErrCode_FollowMatch.UNFOLLOWED == code then
            return "还未关注过"
        elseif headFile.ErrCode_FollowMatch.WRONG_MATCH_TYPE == code then
            return "错误的比赛类型"
        else
            return "未知错误"
        end
    end,
}

-- 道具回收
-- @author Zhenyu Yao
headFile.ErrCode_RecycleItem = {
    NUMBER_NO_MATCH         = 1,        -- 数量不匹配
    CAN_NOT_RECYCLE         = 2,        -- 不能回收
    NO_ITEM_CONF            = 3,        -- 没有道具配置
    EXPIRE                  = 4,        -- 道具过期

    errString = function(code)
        if headFile.ErrCode_RecycleItem.NUMBER_NO_MATCH == code then
            return "数量不匹配"
        elseif headFile.ErrCode_RecycleItem.CAN_NOT_RECYCLE == code then
            return "不能回收"
        elseif headFile.ErrCode_RecycleItem.NO_ITEM_CONF == code then
            return "没有道具配置"
        elseif headFile.ErrCode_RecycleItem.EXPIRE == code then
            return "道具过期"
        else
            return "未知错误"
        end
    end,
}

--360平台支付商品
headFile.qh360PayProduct = {
    ["glzp1"]={                         --商品product_id
        name="10万金币"
    },
    ["glzp5"]={
        name="50万金币"
    },
    ["glzp10"]={
        name="100万金币"
    },
    ["glzptest"]={
        name="测试用100万金币"
    },
}

--分享链接游戏类型定义
headFile.shareLinkGameType = {
    newself="newself",  --私人场包厢
    niuniu="niuniu",    --牛牛私人场
    hzmj="hzmj",    --红中麻将私人场
    csmj="csmj",    --长沙麻将私人场
    pdk="pdk",    --跑得快私人场
}

--财务变化类型
headFile.currencyRemarkID = {
    Null=0, --未知，无
    SafeBox=1, --存储保险柜
    RelieveGoldCoin=2, --救济金
    RateGame=3,             --倍率游戏输赢
    SelfGame=4,             --旧私人场输赢
    UseItem=5,         --使用道具
    Exchange=6,        --兑换中心兑换道具
    GameAward=7,        --游戏奖励
    EventAward=8,       --活动奖励
    RegisterAward=9,        --注册奖励
    EmailAward=10,      --领取邮件奖励
    Recharge=11,           --充值
    RedeemCode=12,     --使用兑换码
    Mining=13,        --挖矿
    NewSelf=14,        --新私人场游戏
    Web=15,             --后台操作
    NiuNiuSelf=16,       --牛牛私人场游戏
    NiuNiuRate=17,       --牛牛倍率游戏
    PdkSelf=18,       --跑得快私人场
    PdkRate=19,           --跑得快倍率
}

--[[*****************************************************************************
说明：http web port,目前可用范围 3010 ~ 3100，3100之后端口不能使用，如该段范围用完需重新讨论分配。
作者：mingyuan.xie
时间：2016.8.3
*********************************************************************************]]
headFile.httpWebPort = {
    APPSTORE_WEB_PORT   = 3010,
    CTU_WEB_PORT        = 3011,
    RECHARGE_WEB_PORT   = 3012,
    LOGIN_WEB_PORT      = 3013,
    QH360_WEB_PORT      = 3014,
    HTTP_WEB_PORT       = 3015,
    CREATE_ROOM_WEB_PORT= 3016,
    AVATAR_CLAW_WEB_PORT= 5017,
    ERROR_LOG_PORT      = 8083,
    DATA_SHARER1        = 5051,
    DATA_SHARER2        = 5052,
    DATA_SHARER3        = 5053,
    DATA_SHARER4        = 5054,
    DATA_SHARER5        = 5055,
    DATA_SHARER6        = 5056,
    END                 = 9200,
}

--min.luo 2016.8.15 商品状态 
headFile.statusTag = {
    GIFT_SHELVE     = 1,      --商品上架
    GIFT_UNSHELVE     = 2, --商品下架
    GIFT_WAIT       = 3,        --等待中
}

--min.luo 2016.8.15 错误码设置
headFile.errorCode = {
    OK              = 0,        --成功
    REQUEST_ERR     = -1,       --请求错误
    PURCHASE_ERR       = -2,        --等待中
    TIME_ERR        = -3,        --不在时间范围内 
}

--min.luo 2016.8.15 商品标签
headFile.tagType = {
    NULL            = 0,        --无标签
    HOT_TYPE        = 1,        --热门
    PRIVILEGE_TYPE      = 2,    --优惠
    SECKILL_TYPE        = 3,    --秒杀
    ROOM_CARD_TYPE      = 4,    --房卡(独立类型,用于区分)     
}

--销售种类ID
headFile.saleTypeID = {
    GOLD_COIN = 1,--金币
    ROOM_CARD = 2,--房卡
    ITEM      = 3,--道具
    K_Coin    = 4,--K币
    SPECIAL_ROOM_CARD = 5,--群主房卡
    WA_WA_COIN = 6, --阿凡达娃娃币
    VOUCHER = 7, --代金券
    --ATHLETICS_TICKET = 8,--竞技券
}

--代理上架商品状态
headFile.newSpreaderShopIsOnSale = {
    invalid=0,   --未上架
    valid=1,   --已上架
}

--min.luo 2016.9.9 特殊商品标签,商城内外都可以购买
headFile.specialTagType = {
    NULL_TYPE           = 0,    --空类型
    GOLD_COIN           = 0,    --金币
    ROOM_CARD_TYPE      = 1,    --房卡
    LOUDSPEAKER_TYPE    = 2,    --喇叭
    CHANGE_NICKNAME     = 3,    --改名卡
    ZP_K_COIN           = 4,    --字牌K币
    UNBIND_NEWSPREADER  = 5,    --解绑newSpreader
    FACE_TICKET         = 6,    --表情券
    SPECIAL_ROOM_CARD   = 7,    --群主房卡

    --转换成对应的道具ID
    change2goodsID=function(typeID)
        if typeID == headFile.specialTagType.NULL_TYPE then
            return headFile.goodsTypeID.goldCoin
        elseif typeID == headFile.specialTagType.NULL_TYPE then
            return headFile.goodsTypeID.goldCoin
        elseif typeID == headFile.specialTagType.ROOM_CARD_TYPE then
            return headFile.goodsTypeID.roomcard
        elseif typeID == headFile.specialTagType.LOUDSPEAKER_TYPE then
            return headFile.goodsTypeID.radio
        elseif typeID == headFile.specialTagType.CHANGE_NICKNAME then
            return headFile.goodsTypeID.changeNickNameCard
        elseif typeID == headFile.specialTagType.ZP_K_COIN then
            return headFile.goodsTypeID.zpKcoin
        elseif typeID == headFile.specialTagType.UNBIND_NEWSPREADER then
            return headFile.goodsTypeID.unbindNewSpreader
        elseif typeID == headFile.specialTagType.FACE_TICKET then
            return headFile.goodsTypeID.faceTicket
        elseif typeID == headFile.specialTagType.SPECIAL_ROOM_CARD then
            return headFile.goodsTypeID.specialRoomCard
        end
    end
}


-- 进入挖矿小游戏返回码
-- @author Zhenyu Yao
headFile.miningEnterResult = {
    SUCCESS = 0,        -- 成功
    CLOSE = 1,          -- 游戏关闭
}

-- 挖矿返回码
-- @author Zhenyu Yao
headFile.miningDigResult = {
    SUCCESS = 0,                -- 成功
    WRONG_REGION_IDX = 1,       -- regionIdx 参数错误
    WRONG_COST_IDX = 2,         -- costIdx 参数错误
    NO_GOLD_COINS = 3,          -- 金币不足
    NO_ITEMS = 4,               -- 道具不足, 暂时不用, 预留以后使用其他道具挖矿
    UNKNOW = 5,                 -- 未知  （逻辑错误）
}

--min.luo 2016.9.22 特殊奖励邮件配置
headFile.paySpecialEmail = {
    roomCard = {        --房卡特殊奖励
        goodsID = "107",        --道具ID
        goodsAmount = "2",      --道具数量
        title = "邀请码送对战卡",   --邮件标题
        content = "您填写了邀请码，获赠2张对战卡，请查收",  --邮件内容
    },
}

--min.luo 邮件通知类型
headFile.sendEmailType = {
    GOLD_COIN_TYPE = 1,     --金币通知邮件
    ROOM_CARD_TYPE = 2,     --房卡通知邮件

}
headFile.qh360PayCallBackUrl="http://112.74.60.38:3014/qh360PayCallBack"

--min.luo 2016.9.22 首次购买房卡系列,赠送房卡数量
headFile.rewardRoomCardNumb = 2         --首次购买房卡，额外奖励两张房卡

--min.luo 2016.10.10 根据tag赠送道具类型
headFile.SpecialTimesTag = {
    SPREADER_BIND   = 1,        --绑定推广号
}

headFile.SpecialTimesRemark = {
    SPREADER_DES    = 1,     --第一次绑定推广号

    [1] = "第一次绑定推广号,赠送对战卡",
}

headFile.SpecialTimesDef = {
    SPREADER_NUM   = 1,     --绑定推广号,系统送一次
}

headFile.maxBlackUserNumber = 50  --黑名单数量最大限制
headFile.maxOpponentNumber = 30   --对手记录数量最大限制


--技术细节类型定义，每新增一种数字顺延，并定义字符串转数字和数字转字符串的枚举，change函数可以相互转换
headFile.recordDetailsType={
    moSelf="1",
    normal="2",
    pointGun="3",
    tianHu="4",
    diHu="5",
    sanLwuK="6",
    xingCount="7",
    dianHu="8",
    hongHu="9",
    wuHu="10",
    duiDuiHu="11",
    daZiHu="12",
    xiaoZiHu="13",
    haiDiHu="14",
    shuaHou="15",
    tingHu="16",
    hongWu="17",
    huangFan="18",
    daTuanYuan="19",
    qiHangXi="20",
    xiangXiangXi="21",
    yin="22",
    hongGuaiWan="23",
	heiHu = "24",				--黑胡   	
	wangDiao = "25",           --王钓
	wangChuang = "26",         --王闯
	wangZha = "27",            --王炸
	wangDiaoWang = "28",       --王钓王 
	wangChuangWang = "29",     --王闯王
	wangZhaWang = "30",        --王炸王  
    ----------------------
    ["1"]="moSelf",
    ["2"]="normal",
    ["3"]="pointGun",
    ["4"]="tianHu",
    ["5"]="diHu",
    ["6"]="sanLwuK",
    ["7"]="xingCount",
    ["8"]="dianHu",
    ["9"]="hongHu",
    ["10"]="wuHu",
    ["11"]="duiDuiHu",
    ["12"]="daZiHu",
    ["13"]="xiaoZiHu",
    ["14"]="haiDiHu",
    ["15"]="shuaHou",
    ["16"]="tingHu",
    ["17"]="hongWu",
    ["18"]="huangFan",
    ["19"]="daTuanYuan",
    ["20"]="qiHangXi",
    ["21"]="xiangXiangXi",
    ["22"]="yin",
    ["23"]="hongGuaiWan",
    ["24"]="heiHu" ,		     --黑胡   	
	["25"]="wangDiao",           --王钓
	["26"]="wangChuang",        --王闯
	["27"]="wangZha",            --王炸
	["28"]="wangDiaoWang",       --王钓王 
	["29"]="wangChuangWang",     --王闯王
	["30"]="wangZhaWang",        --王炸王  
    change=function(type)
        return headFile.recordDetailsType[type]
    end,
}
--[[
分享类型
]]
headFile.statisticsType = {
    matchShare="matchShare",--比赛分享统计
}

-- 桌子的消耗类型
headFile.deskCostType = {
    AA = 1,         -- AA 制
    OWNER = 2,      -- 房主
    MASTER = 3,     -- 群主
}

--互动表情发送的结果
headFile.interactiveExpression = {
    SUCCESS = 1,
    FAIL = 2,
    NOT_FOUND = 3,  -- 表情不存在找到
    COINS_LESS = 4  -- 券不够
}

--互动表情动画枚举
headFile.interactiveExpressionAnimation = {
    ZHA_DAN = 1,
    QIAO_DA = 2,
    QIN_WEN = 3,   
    XIAN_HUA = 4   
}

-- 俱乐部房间的状态， 1 空， 2缺， 3 满未战， 4 战斗中
headFile.clubRoomState = {
    EMPTY_ROOM              = 1,  -- 空
    LACK_PLAYER_ROOM        = 2,  -- 缺，
    FULL_PLAYER_ROOM        = 3,  -- 满未战，
    FIGHT_ROOM              = 4,  -- 战斗中
}

-- 俱乐部创建房间自动手动类型
headFile.clubAutoManualCreateRoom = {
    MANUAL      = 0,    
    AUTO        = 1,
}

-- 俱乐部自动开房开启或关闭
headFile.enumIsAutoCreateRoom = {
    CLOSE               = 0, -- 关闭自动开房
    OPEN                = 1, --  开启自动开房
}

-- 俱乐部成员身份
headFile.clubPermission = {    
    MASTER =  1,   -- 主席
    MANAGER = 2,   -- 副主席
    MEMBER = 3,     -- 成员
}

-- 俱乐部的一些操作，用于记录数据库日志
headFile.clubOperationType = {
    CREATE_CLUB         = 1,    -- 创建俱乐部
    DISSOLUTION_CLUB    = 2,    -- 解散俱乐部
    JOIN_CLUB           = 3,    -- 申请加入
    AGREE_JOIN_CLUB     = 4,    -- 同意加入
    QUIT_CLUB           = 5,    -- 主动退出俱乐部
    KICK_OUT_CLUB       = 6,    -- 被踢出俱乐部
    SET_MANAGER         = 7,    -- 设为副主席
    SET_MEMBER          = 8,    -- 取消副主席（设为普通成员）
}


-- 游戏的类型
-- @author guanying
headFile.gameType = {                   
    GLZP = 1,              -- 桂林字牌
    PHZ_KING = 2,          -- 多王跑胡子
    GLZP_4 = 3,            -- 桂林字牌四人数醒
}

-- 游戏 ID 定义
headFile.GAME_ID = {
    WaWa = 0,           -- 娃娃机
    ZiPai = 1,          -- 字牌
    NiuNiu = 2,         -- 牛牛
    PaoDeKuai = 3,      -- 跑得快
    HongZhong = 4,      -- 红中
    ChangSha = 5,       -- 长沙
    H5HongZhong = 6,    -- H5红中
    WORLD_CUP = 7,      --世界杯
    GLPaoPai = 8,       -- 桂林跑牌
    MiNiGame = 9,       -- 挖矿小游戏
    ZZMJ = 10,          -- 转转麻将
    FanPai = 11,        -- 翻翻乐
    CLUB = 12,         
    HGW = 13,            -- 红拐弯
    LDZP = 14,
    HANSHOU = 15,
    DUOWANG = 16,
    GLMJ = 17,
    H5GLMJ = 18,      --H5桂柳麻将
    H5NNMJ = 19,      -- H5南宁麻将
    NNMJ = 20,        -- 南宁麻将
    AnHuaPaoHuZi = 21,   -- 安化跑胡子
    ZipaiForClub = 3004,   -- 桂林字牌俱乐部游戏ID（之前俱乐部先使用的是改id，已经存入俱乐部相关数据，暂不用ZiPai）
    
}

--多王扯胡子名堂定义
-- @author guanying
headFile.MING_TANG_FAN_SHU_KIND = {
	hongHu = 1,             --红胡    
	dianHu = 2,             --点胡  
	heiHu = 3,				--黑胡   	
	wangDiao = 4,           --王钓
	wangChuang = 5,         --王闯
	wangZha = 6,            --王炸
	wangDiaoWang = 7,       --王钓王 
	wangChuangWang = 8,     --王闯王
	wangZhaWang = 9,        --王炸王  
}


headFile.mgRoomPw = {
    [0] = 010,
	[1] = 025,
	[2] = 050,
	[3] = 075,
	[4] = 100,
	[5] = 125,
	[6] = 150,
	[7] = 175,
	[8] = 200,
	[9] = 225,
	[10] = 250,
	[11] = 275,
	[12] = 300,
	[13] = 325,
	[14] = 350,
	[15] = 375,
	[16] = 400,
	[17] = 425,
	[18] = 450,
	[19] = 475,
	[20] = 500,

	[21] = 525,
	[22] = 550,
	[23] = 575,
	[24] = 600,
	[25] = 625,
	[26] = 650,
	[27] = 675,
	[28] = 700,
	[29] = 725,
	[10] = 750,
	[11] = 775,
	[12] = 800,
	[13] = 825,
	[14] = 850,
	[15] = 875,
	[16] = 900,
	[17] = 925,
	[18] = 950,
	[19] = 975,
	[20] = 999,

}

--特殊道具跳转的位置
headFile.specialSkipSeat ={
    exchangeGoods   = 1, --兑换奖品    跳转至大厅的“兑奖中心”-“兑换奖品”界面           
    matchList       = 2, --比赛列表    跳转至大厅的“比赛”列表            
    rateList        = 3, --倍率  直接开始匹配倍率场游戏         
    roomSelfCreate  = 4, --包厢创建    跳转至大厅的私人场创建房间界面         
    treasureHunt    = 5, --寻宝之旅    跳转至“寻宝之旅”游戏界面           
    activity        = 6, --活动  跳转大厅的“活动”弹窗         
    taskList        = 7, --任务列表    跳转至大厅的“任务”列表            
    rankingList     = 8, --排行帮 跳转至大厅的“排行榜”界面           

}


return headFile
