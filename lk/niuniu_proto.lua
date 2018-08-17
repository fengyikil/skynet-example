--[[
牛牛协议 400 +   
]]

local sprotoparser = require "sprotoparser"
local proto = {}

proto.c2s = [[

 #牌  
.card {
    cardID 0 : integer              #牌型规则：1 ~ 10 ： 1、2、3、4、5、6、7、8、9、10 ， j = 11,Q = 12,k = 13  ，小王 = 14 ，大王 = 15
    color 1 : integer               #花色规则： 方块 1，梅花 2 ，红桃 3，黑桃 4  大小王花色为 0    
}

 #牌值和结果    
.cardResult {
    cardList 0 : *card              #牌型
    resultVal 1 : integer           #牌值
    addFraction 2 : integer         #积分变化
    seatIndex 3 : integer           #位置
}

#第三方信息
.nnThirdInfo {

    thirdAvatarID 0 : string                #第三方头像地址   
    thirdNickName 1 : string                #第三方昵称地址
    thirdSex 2 : string                     #普通用户性别，1为男性，2为女性  
    thirdPartUnionID 3 : string             #第三方平台的 ID 
    longitude 4 : string                    #经度
    latitude 5 : string                     #纬度
}

#玩家信息
.nnAgentInfo {           
    seatIndex 0 : integer               #   1 到 3 
    nickName 1 : string                 #   昵称
    level 2 : integer                   #   等级
    goldCoin 3 : integer                #   金币
    avatarID 4 : integer                #   头像信息
    location 5 : string                 #   位置信息
    winInfo 6 : integer                 #   连胜信息  -1 为被终结  0 为无连胜  >0 为连胜次数
    automatic 7 : integer               #   是否托管 1 为托管
    thirdConf 8 : nnThirdInfo           #   第三方信息
    dissoluteAction 9 : integer         #   解散时的动作  无动作为nil 
    continueAction 10 : integer         #   续费时的动作  无动作为nil           
    userID 12 : integer                 #   userId
    isBlackTag 13 : integer             #   是否有黑名单标示  1 为是 nil 为否
    code 14 : integer                   #   黑名单 ID
    isInBlackList 15 : integer          #   是否是获取方的黑名单用户  1 为是  nil 为否
    isNovice 16 : integer               #   是否是新人 1 为 是 nil 为否
    state 17 : integer                  #   玩家状态 
    fraction 18 : integer               # 	玩家积分
    online 19 : integer                 #   玩家在线   
    betting 20 : integer                #   下注
    isBetMax 21 : integer               #   下最大注, 1 是开启
    costRate 22 : integer               #   看牌抢庄时附带赔率
    isNextGame 23 : integer             #   是否点击了下一局 1 为 是 nil 为否
    isRobot 24 : integer                #   是否机器人

}

#道具与相关值信息  
.nnProp {
    propType 2 : integer        #道具类型
    propVal 3 : integer         #值
}      

#局数于消耗配置
.nnGameCountCost {
    count 0 : integer           #局数
    costVal 1 : nnProp          #消耗类型和值
    costValAA 2 : nnProp        #AA 消耗类型和值
}

#建桌配置 
.nnCreateDeskInfo {  
    selectCount 0 : integer                 #局数             
    playerNum 1 : integer                   #组局人数
    huaPaiRule 2 : integer                  #花牌规则 1 为有花牌  2 为无花牌 ，默认有花牌
    dealerRule 3 : integer                  #庄家规则 1 抢庄 2 随机庄 3 定庄 ，默认抢庄
    fractionVal 4 : integer                 #起始积分      
    rate 5 : integer                        #倍率 预留 （以后可能会加倍率场）
    fullMax 6 : integer                     #牌桌的座位数
    specialGroup 7 : integer                #特殊牌型, headFile.nnSpecialGroup
    costType 8 : integer                    #付费方式, headFile.nnCostType
    countDown 9 : integer                   #倒计时, headFile.nnCountDownType
}

#游戏内各种倒计时时长 单位均为 秒
.nnIntervalTimeConf {
    accountTime 1 : integer                 #结算倒计时时长 
    robDealTime 2 : integer                 #抢庄倒计时时长 
    betTime 3 : integer                     #下注倒计时时长
    makeCardTime 4 : integer                #凑牛倒计时时长
    dissoluteTime 5 : integer               #解散倒计时时长
    readyRobTime 6: integer                 #金币场开始倒计时
    waitPlayerTime 7 : integer              #等待玩家进入
}

#房间动态改变的配置
.nnDynamicConf {                                             
    gameCountCostInfo 0 : *nnGameCountCost     #局数和对应消耗配置(通过配置动态改，所以每次都要返回)
    fractionConf 1 : *integer                  #起始积分配置
}

#桌子信息
.nnDeskInfo {    
    deskID 0 : integer
    agentInfos 1 : *nnAgentInfo
    createConf 2 : nnCreateDeskInfo
    deskPW 3 : string
    remainCount 4 : integer                     #剩余局数
    totalCount 5 : integer                      #总局数  
    intervalTimeConf 6 : nnIntervalTimeConf     #时间配置
    state 7 : integer                           #桌子状态
    dealerSeatIndex 8 : integer                 #庄家位置
    gameCount 9 : integer                       #局数信息
    betRateList 10 : *integer                   #下注倍率表 
    dissoluteStartTime 11 : integer             #解散发起时间
    dissoluteSeatIndex 12 : integer             #发起解散的玩家座位号
    dissoluteInRount 13 : integer               #是否在本局结束后解散 1为是             
}


#进入牛牛房间（大厅）
nnEnterRoom 400 {
    request { 

    }
    response {
        enterResult 0 : integer                    #定义在headFile.nnEnterRoomResult
        createConf 1 : nnCreateDeskInfo            #返回上次的建桌配置 或默认配置
        dynamicConf 2 : nnDynamicConf              #通过配置文件修改的动态配置
    }
}

#创建牛牛桌子
nnCreateDesk 401 {
    request {
        createConf 0 : nnCreateDeskInfo             #建桌配置
        thirdConf 1 : nnThirdInfo                   #第三方信息
    }
    response {
        createResult 0 : integer
        deskInfo 1 : nnDeskInfo
    }
}

#获取牌桌规则
nnGetDeskRules 402 {
    request {
         deskPW 0 : string                    #邀请码 
    }
    response {
        result 0 : integer                    #获取结果码  
        deskInfo 1 : nnDeskInfo
        enterCost 2 : nnProp                  #进桌消耗
    }
}

#进入牛牛桌子
nnEnterDesk 403 {
    request {
        deskPW 0 : string                       #邀请码  
        thirdConf 1 : nnThirdInfo               #第三方信息
    }
    response {
        enterResult 0 : integer
        deskInfo 1 : nnDeskInfo
        seatIndex 2 : integer
        cardResultInfo 3 : *cardResult
    }
}

#玩家请求准备或取消准备    
nnGetReady 404 {
    request {
        readyAction 1 : integer             #请求动作 1 准备  2 取消准备
    }
    response {
        readyResult 0 : integer           # 结果 ： 1 为成功 2 为失败
    }
}

#玩家取消 退出该桌 结算时返回
nnGetCancel 405 {
    request {
        seatIndex 0 : integer
    }      
    response {
        cancelResult 0 : integer
    }
}

#桌主请求游戏开始
nnRequestGaming 406 {
    request {   
        isRobotGaming 0 : integer      #是否是AI陪打      
    }
    response {
        gamingResult 0 : integer    
    }
}

#桌主解散桌子
nnOwnerDestroyDesk 407 {
    request {
        deskOwnerID 0 : integer        #桌主userID
    }
    response {
        destroyResult 0 : integer        
    }
}

#抢庄 
nnRobDeal 408 {
    request {
        seatIndex 0 : integer
        deskID 1 : integer
        gameCount 2 : integer     #局数信息
        robAction 3 : integer     #抢庄与否动作 定义在 headFile.nnRobAction
        costRate 4 : integer      #赔率 看牌抢庄时附带赔率
    }
    response {
        
    }
}

#下注   下注成功与否取决于下注转发
nnBetting 409 {
    request {
        rate 0 : integer
        seatIndex 1 : integer
        deskID 2 : integer
        userID 3 : integer
        gameCount 4 : integer     #局数信息
    }
    response {
        
    }
}

#选庄动画完成 通知服务端开始计时   暂时不用  （预留）
nnSelectDealComplete 410 {
    request {
        deskID 0 : integer
        gameCount 1 : integer     #局数信息
    }
}

#凑牛完成 
nnMakeCardComplete 411 {
    request {
        deskID 0 : integer     
        gameCount 1 : integer         
        seatIndex 2 : integer      
    }
    response {
        
    }
}

#申请解散/拒绝/同意 桌子信息
nnDissoluteInfo 412 {
    request {
        deskID 0 : integer
        seatIndex 1 : integer
        dissoluteAction 2 : integer     #headFile.nnDissoluteKey
    }
}


.nnCardInfoDetails {
     cardList 0 : *integer           # 牌型 (转换后) cL
     cardVar 1 : integer             # 牌值 cV
     addFraction 2 : integer         # 输赢 aF
     gameCount 3 : integer           # 当前局 gC
     isDealer 4 : integer            # 是否是庄家 1 为是 nil 为否 iD
}

# 战绩表玩家信息
.nnRecordSimpleAgent {
    thirdConf 0 : nnThirdInfo                   # 第三方信息
    code 1 : integer                            # ID 
    fractionTotal 2 : integer                   # 总积分输赢
    isOwner 3 : integer                         # 1 为房主 无值为非房主
    eachCountDetails 4 : *nnCardInfoDetails     # 牌型信息   
}


# 数据库信息
.nnDbInfo {
    groupInfoLogName 0 : string
    groupInfoLogID 1 : integer
    subTableName 2 : string
}

# 战绩表记录数据结构
.nnRecordData {
    startTime 0 : string                        # 开始时间       
    totalCount 1 : integer                      # 总局数
    deskPW 2 : string                           # 房间号
    dealerRule 3 : integer                      # 选庄方式 定义：headFile.nnSelectDealWay
    dbInfo 4 : nnDbInfo                         # 数据库信息
    fractionTotal 5 : integer                   # 总积分输赢
    recordSimpleAgent 6 : *nnRecordSimpleAgent  # 总玩家信息(具体战绩时才会有)
}

# 获得战绩记录的列表
nnGetRecordList 413 {          
    request {
        length 1 : integer      # 查询的记录长度
        beginTime 2 : string    # 查询的起始时间; 如果不传这个参数, 那么需要最新的数据;
    }
    response {
        datas 0 : *nnRecordData       # 返回的记录
    }
}

# 比较记录的时间
nnCompareRecordTime 414 {
    request {                             
        lastestTime 0 : string
        lastestCount 1 : integer     #客户端最新游戏局数
    }
    response {
        result 0 : integer          #0 最新时间, 1 不是最新时间
    }
}

#添加AI   
nnForceInsertRobot 415 {
    request {
        deskID 0 : integer
    }
    response {

    }
}

# 重回
nnComeback 416 {
    request {
    
    }
    response {
        result 0 : integer
        deskInfo 1 : nnDeskInfo
        cardResultInfo 2 : *cardResult
        seatIndex 3 : integer      
        cardList 4 : *card
        continueConfirm 5 : nnGameCountCost      #若重回时有该值 则弹出续费确认窗口
        gameCountCostInfo 6 : *nnGameCountCost   # 续费的局数选择配置 （只有桌主, 在续费状态时, 才会有）

    }
}

# 主动离开牌桌, 可以重回
nnLeaveDesk 417 {
    request {
    }
    response {
        result 0 : integer                  # headFile.nnLeaveDeskResult
    }
}

# 取消委托
nnCancelAutomatic 418 {
    request {
        deskID 0 : integer
        gameCount 1 : integer
    }
    response {
    }
}

# 下最大注
nnBetMax 419 {
    request {
        deskID 0 : integer
        gameCount 1 : integer
        action 2 : integer                  # 1 是开启, nil 取消
    }
    response {
    }
}

#获取指定的战绩数据
nnGetPointRecordData 420 {
    request {
        dbInfo 0 : nnDbInfo
    }
    response {
        datas 0 : string       # 返回的记录
    }
}

#告诉服务器当前玩家语音的地址
nnTellVoiceUrl 421 {
    request {
        url 0 : string      # 语音的地址
        time 1 : integer    # 语音的时间, 单位毫秒
    }
}

#发送聊天消息
nnSendChat 422 {
     request {
        chat 0 : string      # 文字内容
    }
}

#请求牌局中的战绩数据
nnGetRecordInGame 433 {
    request {
        gameCount 0 : integer #当前牌局的局数
    }

    response {
        recordDataInGame 0 : nnRecordSimpleAgent   #此玩家的牌局信息
    }
}

#桌主踢人
nnOwnerKick 434 {   
    request {
         kickSeatIndex 0 : integer
    }
    response {
        kickResult 0 : integer
    }
}

#下一局快速开始 KeyAction ： WAIT_DESK_NN
nnNextGame 435 {
    request {       
    }
    response {     
    }
}    

#桌主请求续费
nnGameContinue 436 {
    request {
        selectCount 0 : integer                 #局数 
    }
    response {
        result 0 : integer                      # 定义 h.nnGameContinueResult
    }
}

#非桌主续费确认 
nnGameContinueConfirm 437 {
    request {            
    }
}

#牛牛金币场
#快速开始
nnQuickGame 438 {
  request {
    rules 0 : integer                       # 规则（保留）
  }
  response {
    resultID 0 : integer                    # headFile.nnSearchResult
    roomID 1 : integer                      # 房间序号
    deskInfo 2 : nnDeskInfo                 # 桌子信息
    seatID 3 : integer                      # 座位序号
    cardResultInfo 4 : *cardResult          #
    waitTime 5 : integer                    # 等待时间
    robRateList 6 : *integer                # 抢庄倍率表
  }
}

#选择房间
nnSelectRoom 439 {
  request {
    rules 0 : integer                       # 规则（保留）
    rate 1 : integer                        # 底注/房间序号
  }
  response {
    resultID 0 : integer                    # headFile.nnSelectRateRoom
    roomID 1 : integer                      # 房间序号
    deskInfo 2 : nnDeskInfo                 # 桌子信息
    seatID 3 : integer                      # 座位序号
    cardResultInfo 4 : *cardResult          #
    waitTime 5 : integer                    # 等待时间
    robRateList 6 : *integer                # 抢庄倍率表
    roomName 7 : string                     #房间名
  }
}

#金币场房
.nnRateRoom_ {
  rule 0 : integer                          # 规则
  baseBet 1 : integer                       # 底注(倍率)
  name 2 : string                           # 房间名
  maxVal 3 : integer                        # 金币上限
  minVal 4 : integer                        # 金币下限
}

#规则房间倍率列表
.ruleRateList{
    baseBet 0 : integer                       # 底注(倍率)
    name 1 : string                           # 房间名
    maxVal 2 : integer                        # 金币上限
    minVal 3 : integer                        # 金币下限
}

#金币场房
.nnRateRoom {
  rule 0 : integer                          # 规则
  ruleRoomList 1 : *ruleRateList            # 规则房间倍率列表 
}

#获取金币场房间列表
nngetRateRooms 440 {
  request  {
  }
  response {
    resultID 0 : integer                    # headFile.nngetRateRooms
    rateRoomList 1 : *nnRateRoom            # 金币场房列表
  }
}

#领救济金 KeyAction ： WAIT_DESK_NN
nnGetRelieve 441 {
    request {
    }
    response {
        result 0 : integer          #救济金发放结果，定义在headFile.relieveResult
        useTimes 1 : integer        #使用了多少次救济金
        totalTimes 2 : integer      #每天有多少次使用次数
        minGoldCoin 3 : integer     #领取救济金的下限
        relieveGoldCoin 4 : integer #救济金金额
    }
}

#用户请求离开桌子 KeyAction ： WAIT_DESK_NN  
nnAskLeaveDesk 442 {
    request {
        userID 0 : integer          #用户ID 
        seatIndex 1 : integer       #用户桌子里的位置
        action 2 : integer          #退出还是换桌 1退出，2换桌 定义在headFile
    }
    response {
        isSuccess 0 : integer       #离开是否成功， 定义在headFile
        reason 1 : string           #失败原因
        gameState 2 : integer       # 1,2 1在游戏中，2不在游戏
    }
}

#interactiveExpression KF.QIN 2017.7.14
.nnExpression {
    itemId 0 : integer    # goodsID 物品ID    
    cost 1 : integer     # 消耗的券
    itemName 2 : string  #  物品名称
    itemInfo 3 : string  #  物品相关介绍信息
    itemType 4 : integer  #  动画类型
}

nnRequestInteractiveExpression 443 {
    request {
    }
    response {
    expressionList 0 : *nnExpression
    }
}

#获取游戏状态 用户请求离开桌子 KeyAction ： WAIT_DESK_NN 
nnGetGameState 445 {
    request {

    }
    response {
        gameState 0 : integer   # 1,2 1在游戏中，2不在游戏
    }
        
}

nnSendInteractiveExpression 444 {
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

.nnitemStruct {
    itemId 0 : integer  # 道具的 ID
    num 1 : integer     # 数量
    userGoodsID 2 : integer # UserGoods表ID
    expireTime 3 : string   #过期时间
    maxOverlayNum 4 : integer  #最大叠加数，0为不限制
    obtainTime 5 : string  #获得道具时间
}
# KeyAction ： WAIT_DESK_NN
nnGetItemInfo 446 {
    request {

        itemId 0 : integer

    }
    response {
        itemInfo 0 : *nnitemStruct
    }
}

#客户端后台
nnBackStage 447 {
    request {
    }
}


]]

proto.s2c = [[  

    #道具与相关值信息  
    .nnProp {
        propType 2 : integer        #道具类型
        propVal 3 : integer         #值
    }      

    #局数于消耗配置
    .nnGameCountCost {
        count 0 : integer           #局数
        costVal 1 : nnProp          #消耗类型和值
        costValAA 2 : nnProp        #AA 消耗类型和值
    }

    #第三方信息
    .nnThirdInfo {

        thirdAvatarID 0 : string                #第三方头像地址   
        thirdNickName 1 : string                #第三方昵称地址
        thirdSex 2 : string                     #普通用户性别，1为男性，2为女性  
        thirdPartUnionID 3 : string             #第三方平台的 ID 
        longitude 4 : string                    #经度
        latitude 5 : string                     #纬度
    }

    #玩家信息
    .nnAgentInfo {           
        seatIndex 0 : integer               #   1 到 3 
        nickName 1 : string                 #   昵称
        level 2 : integer                   #   等级
        goldCoin 3 : integer                #   金币
        avatarID 4 : integer                #   头像信息
        location 5 : string                 #   位置信息
        winInfo 6 : integer                 #   连胜信息  -1 为被终结  0 为无连胜  >0 为连胜次数
        automatic 7 : integer               #   是否掉线   1 为正常  2 为掉线
        thirdConf 8 : nnThirdInfo           #   第三方信息
        dissoluteAction 9 : integer         #   解散时的动作  无动作为nil 
        continueAction 10 : integer         #   续费时的动作  无动作为nil           
        userID 12 : integer                 #   userId
        isBlackTag 13 : integer             #   是否有黑名单标示  1 为是 nil 为否
        code 14 : integer                   #   黑名单 ID
        isInBlackList 15 : integer          #   是否是获取方的黑名单用户  1 为是  nil 为否
        isNovice 16 : integer               #   是否是新人 1 为 是 nil 为否
        state 17 : integer                  #   玩家状态 
        fraction 18 : integer               #   玩家积分   
        online 19 : integer                 #   玩家在线
        betting 20 : integer                #   下注
        isBetMax 21 : integer               #   下最大注, 1 是开启
        costRate 22 : integer               #   看牌抢庄时附带赔率
        isNextGame 23 : integer             #   是否点击了下一局 1 为 是 nil 为否
        isRobot 24 : integer                #   是否机器人
    }

    #牌    
    .card {
        cardID 0 : integer              #牌型规则：1 ~ 10 ： 1、2、3、4、5、6、7、8、9、10 ， j = 11,Q = 12,k = 13  ，小王 = 14 ，大王 = 15
        color 1 : integer               #花色规则： 方块 1，梅花 2 ，红桃 3，黑桃 4  大小王花色为 0    
    }
    
    #牌值和结果    
    .cardResult {
        cardList 0 : *card              #牌型
        resultVal 1 : integer           #牌值
        addFraction 2 : integer         #积分变化
        seatIndex 3 : integer           #位置
    }

    # 战绩表玩家信息
    .nnRecordSimpleAgent {
        seatState 0 : integer           # 空位或关闭时没有以下数据 
        thirdConf 1 : nnThirdInfo       # 第三方信息
        fractionTotal 2 : integer       # 总积分
        isOwner 3 : integer             # 是否是房主 1 为是  nil 为否
        code 4 : integer                # ID 
        winCount 5 : integer            # 赢次数
        lostCount 6 : integer           # 输次数
    }

    # 转发 玩家退出桌子 niuniu
    nnAgentOutDesk 400 {
        request {
            seatIndex 0 : integer
            deskID 1 : integer
            kickByOwner 2 : integer    #是否是被房主踢出 1 为是 nil 否
            reason 3 : integer         # 被踢出的原因, headFile.nnAgentOutDeskReason
            # 房卡不足时被踢出使用
            recordData 5 : *nnRecordSimpleAgent         # 结算时的数据
            startTime 6 : string                        # 开始时间
            deskPW 7 : string                           # 房间号
            dealerRule 8 : integer                      # 选庄方式 定义：headFile.nnSelectDealWay
            totalCount 9 : integer                      # 总局数
            # 在倍率房被踢出时告诉下一个要去的房的倍率
            roomRate 10 : integer
            roomRateName 11 : string                    #该倍率房的名称
        }
    }

    # 转发 解散桌子信息  
    nnDestroyDesk 401 {
        request {
            deskID 0 : integer
            recordData 1 : *nnRecordSimpleAgent       # 结算时的数据 
            isDestroy 2 : integer                     # 主动解散为 1, 正常牌局结束为 nil
            startTime 3 : string                      # 开始时间       
            deskPW 4 : string                         # 房间号
            dealerRule 5 : integer                    # 选庄方式 定义：headFile.nnSelectDealWay
            totalCount 6 : integer                    # 总局数
        }
    }

    #通知游戏开始 第一局桌主请求开始成功后会发送 结算倒计时结束后会发送 ，收到该消息后播放发牌动画
    nnNotifyGaming 402 {
        request {
            deskID 0 : integer
            gameCount 1 : integer       #当前是第几局  抢庄和下注要带局数信息防止网络延迟（跨局）
            remainCount 2 : integer     #剩余局数
            cardList 3 : *card          #牌型 (只看牌抢庄有)
        }
    }

    # 转发 抢庄信息
    nnTransmitRobDeal 403 {
        request {
            deskID 0 : integer
            seatIndex 1 : integer
            robAction 2 : integer
            costRate 3 : integer      
        }
    }

    #通知庄家位置  
    nnNotifyDealIndex 404 {
        request {
            deskID 0 : integer
            dealerSeatIndex 1 : integer    #庄家位置
            seatIndexs 2 : *integer          #抢庄玩家的座位号
        }
    }

    #  转发下注信息（收到自己的下注信息证明下注成功或下注倒计时结束无动作返回默认倍率），收到后才播放下注动画
    nnTransmitBet 405 {
        request {
            rate 0 : integer   
            deskID 1 : integer
            seatIndex 2 : integer
        }
    }

    #展示牌和计算结果 其他玩家的牌值和计算结果也一起发送
    nnSendCardAndResult 406 {   
        request {
            deskID 0 : integer
            cardResultInfo 1 : *cardResult    #牌值和结果
        }
    }   
   
    # 转发 玩家进入桌子 niuniu
    nnAgentInDesk 407 {
        request {
            seatIndex 0 : integer
            deskID 1 : integer
            agentInfo 2 : nnAgentInfo
        }
    }

    #转发准备信息
    nnTransmitReadyAction 408 {
        request {
            deskID 0 : integer
            seatIndex 1 : integer         #玩家的位置 
            readyAction  2 : integer      # 
        }
    }

    #转发凑牛完成 
    nnTransmitMakeCardComplete 409 {
        request {
            deskID 0 : integer
            seatIndex 1 : integer      #玩家的位置 
        }
    }

    #比较牌型大小 （凑牛全部完成）
    nnCompareCard 410 {
         request {
          deskID 0 : integer
        }
    }
    
    #转发解散/拒绝 桌子信息
    nnTransmitDissoluteInfo 411 {
        request {
            deskID 0 : integer
            seatIndex 1 : integer
            dissoluteAction 2 : integer     #headFile.nnDissoluteKey
            dissoluteStartTime 3 : integer

        }
    }

    #通知结算倒计时开始
    nnNotifyAccountTimeGo 412 {
        request {
            deskID 0 : integer
        }
    }

    #玩家上/下线处理
    nnAgentOnline 413 {   
        request {
            deskID 0 : integer
            onlineFlag 1 : integer          # headFile.nnOnline
            seatIndex 2 : integer           # 座位号
        }
    }

    #转发托管
    nnTransmitAutomatic 414 {
        request {
            deskID 0 : integer
            seatIndex 1 : integer           # 座位号
            automatic 2 : integer           # 托管, 1 是托管, nil 取消
        }
    }

    # 转发给其他玩家语音地址
    nnTransmitVoiceUrl 415 {
        request {
            url 0 : string              # 语音地址
            seatIndex 1 : integer       # 该玩家的 座位号（服务端）
            time 2 : integer            # 语音的时间, 单位毫秒     
        }
    }

    #转发聊天消息
    nnTransmitChat 416 {
         request {
            chat 0 : string             # 文字内容
            seatIndex 1 : integer       # 该玩家的 座位号（服务端）
        }
    }

    #确认本局结束后解散
    nnDissoluteInRount 417 {
         request {
        }
    }

    #转发下一局信息  KeyAction ： WAIT_DESK_NN
    nnTransmitNextGame 418 {
        request {
            seatIndex 0 : integer          #下局玩家位置   
        }
    }

    #进入等待界面 附带结算战绩消息
    nnEnterWaitScene 419 {
        request {
            deskID 0 : integer
            recordData 1 : *nnRecordSimpleAgent       # 结算时的数据 
            #isDestroy 2 : integer                    # 主动解散为 1, 正常牌局结束为 nil
            startTime 3 : string                      # 开始时间       
            deskPW 4 : string                         # 房间号
            dealerRule 5 : integer                    # 选庄方式 定义：headFile.nnSelectDealWay
            totalCount 6 : integer                    # 总局数
            gameCountCostInfo 7 : *nnGameCountCost    # 续费的局数选择配置 （只有桌主会有）
        }
        
    }

    #转发续费通知
    nnTransmitGameContinue 420 {
        request {
            continueConfirm 0 : nnGameCountCost        #续费确认
        }
    }

    nnGoldChangeRoom 421 {
        request {
            type 0 : integer  # 0金币不足,1前往低级场，2前往高级场
            prompt 1 : string # 提示信息
            button 2 : *string # button[1] 取消 button[2] 确定，从左到右，从上到下
        }
    }

    #进入开始倒计时
    nnReadyToStart 422 {
        request {
          deskID 0 : integer   # 桌子序号
        }
    }

    #发送下注限制
    nnBetLimits 423 {
        request {
          deskID 0 : integer    # 桌子序号
          limits 1 : *integer   # 可用的下注列表
        }
    }

    #开局消耗
    .nnPayInfo {
        cost 0 : integer        # 花费的数量
        goodsID 1 : integer     # 花费的道具
    }
    #发送抢庄限制
    nnRobLimits 424 {
        request {
          deskID 0 : integer    # 桌子序号
          limits 1 : *integer   # 可用的抢庄列表
          payInfo 2 : nnPayInfo # 抽水的金币
        }
    }

    #刷新牛牛用户道具
    #enumKeyAction:FLUSH_GOODS       enumEndPoint:NN_RATE_SERVER
    nnFlushGoods 425 {
        request {
            goodsID 0: integer    #用户金币
            goodsNum 1: integer   #道具数量
        }
    }
    
    #领救济金 KeyAction ： RELIEVE
    nnSendRelieve 426 {
        request {
            result 0 : integer          #救济金发放结果，定义在headFile.relieveResult
            useTimes 1 : integer        #使用了多少次救济金
            totalTimes 2 : integer      #每天有多少次使用次数
            minGoldCoin 3 : integer     #领取救济金的下限
            relieveGoldCoin 4 : integer #救济金金额
        }
    }

    #结算时刷新桌子中的玩家金币 KeyAction ：  FLUSH_AGENT_INFO enumEndPoint:NN_RATE_SERVER
    nnFlushDeskAgentInfo 427 {
        request {
            agentInfoList 0 : *nnAgentInfo #玩家信息
        }

    }
    
    
      #interactiveExpression  
    nnTransferInteractiveExpression 428 {
       request {         
            fromSeatIndex 0 : integer   # 
            toSeatIndex 1 : integer     #
            itemId 2   :   integer
            num 3   :   integer
        }     
    }

    #奖励的道具列表
    .propList {
        goodID 0 : integer #商品名称
        goodNum 1: integer   #商品数量
    }

    #牛牛牌值奖励 enumKeyAction: SEND_NIU_AWARD enumEndPoint:NN_RATE_SERVER
    nnSendCardValAward 429 {
        request {
            seatIndex 0 : integer   #座位号
            nickName 1 : string     #昵称
            cardVal 2 : integer     #牛数
            propList 3 : *propList  #道具列表

        }

    }


]]


return proto