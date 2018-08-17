--[[
	head file server(服务器端头文件定义)
	create：mingyuan.xie
	create time: 2015.11.12

--]]

local headfile_server = {}
local hs = headfile_server



--线程名，必须跟文件名一样
hs.threadName = {
	AGENT_MATCH 			= "agent_match",	--比赛房agent
	DESK_MATCH 				= "desk_match",		--比赛房desk
	MATCH_GROUP				= "match_group",	--比赛组
	PLAYER					= "player",			--玩家
    AGENT                   = "agent",          --玩家代理
    DESK                    = "desk",           --桌子
    DESK_SELF               = "desk_self",      --桌子
    AGENT_SELF              = "agent_self",     --玩家代理
    NEW_AGENT_SELF          = "new_agent_self", --
    NEW_DESK_SELF           = "new_desk_self",  --
    AUTH                    = "auth",           --AUTH
}

hs.roomType = {
	MATCH = "MATCH",	--比赛房
	RATE = "RATE",	--倍率房
}

hs.matchType = {
	FULL 		= "FULL",	--人满赛
	TIMING 		= "TIMING",	--定时赛
}

------------------------Begin huang xiang rui 2015.11.18-----------------------
--比赛奖励
hs.matchAward_cfg_1_f_24 = {
--  名次  奖励类型        奖励数量
    [1] = {goodsTypeID={0},goodsAmount={100000},title="比赛奖励",content="恭喜您在比赛中获得第1名",awardText={"100000金币"}},
    [2] = {goodsTypeID={0},goodsAmount={50000},title="比赛奖励",content="恭喜您在比赛中获得第2名",awardText={"50000金币"}},
    [3] = {goodsTypeID={0},goodsAmount={20000},title="比赛奖励",content="恭喜您在比赛中获得第3名",awardText={"20000金币"}},
    [4] = {goodsTypeID={0},goodsAmount={10000},title="比赛奖励",content="恭喜您在比赛中获得第4名",awardText={"10000金币"}},
    [5] = {goodsTypeID={0},goodsAmount={10000},title="比赛奖励",content="恭喜您在比赛中获得第5名",awardText={"10000金币"}},
    [6] = {goodsTypeID={0},goodsAmount={10000},title="比赛奖励",content="恭喜您在比赛中获得第6名",awardText={"10000金币"}},
    [7] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第7名",awardText={"5000金币"}},
    [8] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第8名",awardText={"5000金币"}},
    [9] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第9名",awardText={"5000金币"}},
    [10] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第10名",awardText={"5000金币"}},
    [11] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第11名",awardText={"5000金币"}},
    [12] = {goodsTypeID={0},goodsAmount={5000},title="比赛奖励",content="恭喜您在比赛中获得第12名",awardText={"5000金币"}},
}

hs.emailExpireTime = 30  --邮件过期时间，天
hs.passwd = "LK_GLZP_2015"--密码

hs.request_interval=0.5 --检查http调用结果间隔，秒
hs.request_times=20--检查http调用结果次数

hs.loginUserGoodsID=101--登陆时需要查询的用户道具ID
hs.loginUserGoodsIDMapID=3--积分道具id映射（固定为3）
hs.lockRequestKey={
    exchangeGoods="LockRequest:ExchangeGoods",  --兑换商品
    redeem="LockRequest:Redeem",                --兑换码
}

--查询缓存超时时间
hs.dblogSelectCacheTimeout=60 --秒

--数据库名
hs.dbName={
    data="Zipai",
    gamelog="GameLog",
    mining="Mining",
    niuniu="glzp_niuniu",
    pdk="glzp_pdk",
    hzmj="glzp_hzmj",
    afdww="glzp_afdww",
    fanpai="glzp_fanpai",
    club="glzp_club",
}

--dblog队列模式
hs.dblogModel={
    rate="rate",
    match="match",
    newSelf="newSelf",
    gamelog="gamelog",
    login="login",
    item="item",
    other="other",
    club="club",
    clubSelfRecord="clubSelfRecord",
    groupAdminRecord="groupAdminRecord",
    roomSelfRecord="roomSelfRecord",
    roomCardLog="roomCardLog",
    data="data",
}
--dblog队列模式映射
hs.delogModelMap={
    rate="db_log1",
    gamelog="db_log1",

    match="db_log2",
    other="db_log2",
    club="db_log2",

    newSelf="db_log3",

    login="db_log4",
    item="db_log4",
    roomCardLog="db_log4",
    data="db_log4",

    clubSelfRecord="db_log5",
    groupAdminRecord="db_log5",
    roomSelfRecord="db_log5",

}

--dblog模式对应的数据库名
hs.delogModelDbName={
    rate=hs.dbName.gamelog,
    match=hs.dbName.gamelog,
    newSelf=hs.dbName.gamelog,
    gamelog=hs.dbName.gamelog,
    login=hs.dbName.data,
    item=hs.dbName.data,
    other=hs.dbName.data,
    club=hs.dbName.club,
    clubSelfRecord=hs.dbName.club,
    groupAdminRecord=hs.dbName.gamelog,
    roomSelfRecord=hs.dbName.gamelog,
    roomCardLog=hs.dbName.data,
    data=hs.dbName.data,
}

--redis分隔符号
hs.rdsSplitSymbol={
    split="#",--分隔符
    equal="@"--等号
}



--不同数据库对应的sql执行函数名，需要与上面hs.dbName配对
hs.launchDbFuncName={
    [hs.dbName.data]="launchSQL",
    [hs.dbName.gamelog]="launchGameLogSQL",
    [hs.dbName.mining]="launchMiningSQL",
    [hs.dbName.niuniu]="launchNiuNiuSQL",
    [hs.dbName.pdk]="launchPdkSQL",
    [hs.dbName.hzmj]="launchHzmjSQL",
    [hs.dbName.afdww]="launchAfdwwSQL",
    [hs.dbName.fanpai]="launchFanPaiSQL",
    [hs.dbName.club]="launchClubSQL",
}
--游戏模式 glzp czzp phz hgw hczp
hs.gameModel="glzp"

hs.waitStartTime=10 --等待服务启动时间，秒
--上锁时，给道具配置赋值为os.time()，解锁时赋值为0，如果发现上锁时间+过期时间大于当前时间，则不允许请求
hs.raffleConfConfigIDLockExpireTime=10--抽奖道具上锁过期时间，秒
hs.isDebug=true --正式服一定要改为false

--redis表名
hs.rdsTabName={
    User="User",--用户
    UserStatus="UserStatus",--用户信息
    UserShareAwardConfig="UserShareAwardConfig",--用户分享配置
    UserSpreaderRegAwardConfig="UserSpreaderRegAwardConfig",--用户推广注册奖励配置
    UserSpreaderSingleGamesAwardConfig="UserSpreaderSingleGamesAwardConfig",--推广用户单人游戏局数奖励配置
    UserSpreaderTotalGamesAwardConfig="UserSpreaderTotalGamesAwardConfig",--推广用户总游戏局数奖励配置
    UserSpreaderUserGamesReachAwardConfig="UserSpreaderUserGamesReachAwardConfig",--推广用户用户局数达标奖励配置
    RankList="RankList",--排行榜
    GoodsRaffle="GoodsRaffle",--道具抽奖
    NiuNiuRecordUserList="NiuNiuRecordUserList",--牛牛战绩用户列表key
    NewGroupAdminCreateList="NewGroupAdminCreateList",--包厢群主开房key列表
    NewGroupAdminCurRoomList="NewGroupAdminCurRoomList",--包厢群主当前房间列表
    NiuNiuRateCostDateCount="NiuNiuRateCostDateCount",--牛牛金币场日金币消耗
    NiuNiuMulGameLog="NiuNiuMulGameLog", --百人牛牛战绩
    NiuNiuCreateDeskDateCount="NiuNiuCreateDeskDateCount",--私人场常规倍率和特殊倍率建桌次数
    NiuNiuAdminCreateZset="NiuNiuAdminCreateZset", --牛牛代理开房
    UserTokenList="UserTokenList", --保存用户token
    NiuNiuBoxFraction = "NiuNiuBoxFraction", --斗牛夺宝，保存玩家临时积分
    FanPaiHeadCount="FanPaiHeadCount",  --翻牌机统计最大在线人数
    Email="Email", --用户邮件
    ExchangeLock="ExchangeLock", --兑换上锁
    UserItemLock="UserItemLock",  --用户道具上锁
    UserLoginLock="UserLoginLock", --用户登录上锁
    PayOrder="PayOrder",            --充值订单
    NewSpreaderStockLock="NewSpreaderStockLock",  --代理卡库存上锁
    BindNewSpreaderUserLock="BindNewSpreaderUserLock",  --绑定邀请码上锁
    BindNewSpreaderLock="BindNewSpreaderLock",  --绑定邀请码上锁
    CreatePayOrderMallLock="CreatePayOrderMallLock",  --商品下单时对商品上锁
    MallLock="MallLock",   --商品上锁，查询、更新字段时
    BatchClosePayOrderLock="BatchClosePayOrderLock", --关闭订单上锁
}   

--redis User 暂存已领取奖励key
hs.rdsReceivedAwardEmailListUserKey={
    AwardEmailList="AwardEmailList",--登录奖励邮件
    UserShareList="UserShareList",--登录奖励邮件
}

hs.orderExpireTime = 10 --订单超时时间，分钟
hs.closeExpireOrderTime = 15  --关闭超时订单的时间，需要比orderExpireTime大一些，保证订单完全过期了才能关闭，分钟

--畅天游帐号和网址
hs.CTUhost="wr.800617.com:6001"--"wr.800617.com:6001"--211.151.237.148:6001
hs.CTUurl="/submit.aspx"
hs.CTUtesthost="test.800617.com:6001"
hs.CTUtesturl="/submit.aspx"
hs.CTUtestun="1194"
hs.CTUtestpw="75f838"
hs.CTUCompanyID="1146"
hs.CTUUserName="lkyx"
hs.CTUInterfacePwd="d89be8"
hs.CTURequestKey="nem8k6"--"12AB56"
hs.CTUOrderSource=2
hs.CTUOrderSub="glzpApp"--账单号后缀，账单号由年月日时分秒CTUOrder表ID决定，例如201601010000001
hs.ecKey="72c1968b56b14503b030ca5a25a1787f"  --电子券key
hs.WeiXinAppOpenID="openid"                    --微信App open ID
hs.WeiXinPublicOpenID="openid"                    --微信公众号 open ID
hs.WeiXinAppID="wxe482ce5959dab949"                       --微信AppID      
hs.WeiXinSecret="a9cffaa7edf1a2931f1f5e7fb5c6ed85"--微信应用密钥AppSecret
hs.WeiXinQrAppID="wx629f1b2712511b52"                       --微信AppID      
hs.WeiXinQrSecret="6a40102df443575e5e0d121d9ba1cdd3"--微信应用密钥AppSecret
hs.WeiXinGrantType="authorization_code"     --微信授权类型
hs.WeiXinRedPaperKey="edg8p9BE1uolapAlpc4o79dlvN3Feny8"  --微信红包Key
hs.WeiXinRedPaperMchID="1338529801"  --微信红包商户ID
hs.WeiXinRedPaperMchID2="1338529801"
hs.WeiXinRedPaperClientIP="222.216.206.156"  --发送微信红包的IP
hs.WeiXinPublicAppID="wx843beecdf6d136c2"  --微信公众号Appid
hs.WeiXinPublicSecret="8bd594853eafa22cae678e2ff75d4965" --微信公众号Secret
hs.MWGateUserID="JI0189"--梦网短信平台用户ID
hs.MWGatePasswd="127625"--梦网短信平台密码
hs.avatarDollAppKey="39991605579edb743320989977d5af82"--阿凡达娃娃key
hs.avatarDollAppID="2017121816021555"--阿凡达娃娃appid
hs.avatarDollServerHost="api-open.rcnice.com"--阿凡达娃娃服务host
hs.avatarDollServerGetAccessTokenUrl="/grant/get/accessToken"--阿凡达娃娃鉴权url
hs.avatarDollAppSecret="ebd911b4eb2c9b4e2a5f621db88a0005"--阿凡达appsecret
hs.WX_PUBLIC_PAY_APPID="wx843beecdf6d136c2"     --微信公众号支付appid
hs.WX_PUBLIC_MCHID="1307674301"                 --微信公众号商户id
hs.WX_PUBLIC_APP_SECRET="8bd594853eafa22cae678e2ff75d4965"      --微信公众号密钥

hs.WX_SIGN_URL = "http://glzppay.gllkgame.com/onlinePay/weixinsign.php" -- 微信签名URL
hs.WX_NOTIFY_URL = "http://222.52.143.146:4012/wxpayCallBack" -- 微信通知URL (需要映射ip)
hs.WX_PREPAY_URL = "https://api.mch.weixin.qq.com/pay/unifiedorder"         --微信

hs.alipayPartnerID = "2088621536431331"    -- 支付宝商户PID
hs.alipaySellerID = "aiyudianzi1@sina.com"      -- 支付宝商户收款帐号
hs.alipayService = "mobile.securitypay.pay"
--Normal code
hs.ALIPAY_APP_ID = "1106359086"
hs.ALIPAY_APP_KEY = "o0BJyK4ZJWMukG8Z"
hs.ALIPAY_PID = "2088621536431331"
hs.ALIPAY_SIGN_URL = "http://glzppay.gllkgame.com/onlinePay/alipaysign.php" -- 支付宝签名URL
hs.ALIPAY_QR_URL = "http://glzppay.gllkgame.com/onlinePay/alipayqrpay.php"--"http://glzppay.gllkgame.com/onlinePay/alipayqrpay.php"
hs.ALIPAY_NOTIFY_URL = "http://222.52.143.146:4012/alipayCallBack" -- 支付宝通知URL (需要映射ip)
hs.ALIPAY_RECHAEGE_URL = "https://openapi.alipay.com/gateway.do"

hs.HUI_FU_BAO_PAY_URL = "https://pay.heepay.com/Payment/Index.aspx"  --汇付宝支付url

hs.changeNickName_lockNickNameKey="changeNickName_lockNickName"  --改昵称上锁昵称前缀
hs.changeNickName_lockUserIDKey="changeNickName_lockUserID"  --改昵称上锁用户ID前缀
hs.lockNickNameTime=3600--昵称锁定时间，秒
hs.dbpwd_key="lk20-15Zp"
hs.cfgPath="/var/lib/server/db_path"
hs.glmjHost="112.74.162.186:3020/ManagerNotify"
hs.userTokenKey="usrtk"
hs.tokenExpireTime=3*24*3600  --token过期时间
hs.wxPublicJsTicketKey = "glzp-ticketApi-key-23ac23dd" -- 请求js_ticket时后台签名的密钥
hs.WechatGameAppid = "wx93967ac3b0bbf830" -- 微信小游戏 appid
hs.WechatGameSecret = "746ab387317b76a67eb7048d8fc7a455" -- 微信小游戏 secret

------------------------End huang xiang rui 2015.11.18-----------------------


--比赛房状态
hs.roomMatchState = {
    CLOSED          = 1,    --关闭
    OPEN            = 2,    --开放
    KILLING         = 3,    --正在销毁
}


return headfile_server
