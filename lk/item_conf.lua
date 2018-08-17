-- 道具配置的扩展文件
-- @author Zhenyu Yao
-- @date 2016.04.12

local item_conf = {}

--------------------------------------------------------------------------------
-- 种类配置
--------------------------------------------------------------------------------
item_conf.goodsKindID={
    ChargeCard=1,
    card=2,
    voucher=3,
    pass_ticket=4,
    voucher_ticket=5,
    currency=6,
    radio=7,
}

-- 道具类型
item_conf.itemVariety = {
    normal = "normal",      -- 普通道具
    timely = "timely",      -- 时效性道具
}

--------------------------------------------------------------------------------
-- 之前的一些历史遗留配置
--------------------------------------------------------------------------------
item_conf.goldCoin      = 0    -- 金币
item_conf.ticket        = 1    -- 奖券
item_conf.point         = 2    -- 
item_conf.pass_ticket   = 3    -- 入场券
item_conf.ice           = 101  -- 冰块
item_conf.fragrant      = 150  -- 桂花
item_conf.happy_lot     = 170  -- 福气
item_conf.CTU1          = 3001  --  畅天游冲值1元
item_conf.CTU5          = 3002  --  畅天游冲值5元
item_conf.CTU10         = 3003  --  畅天游冲值10元
item_conf.CTU50         = 3004  --  畅天游冲值50元
item_conf.CTU100        = 3005  --  畅天游冲值100元
item_conf.lkGoldCoin    = 102   -- 老K金币
item_conf.kCoin         = 103   -- K币
item_conf.exp           = 104
item_conf.level         = 105
item_conf.rmb           = 106
item_conf.roomcard      = 107   --  对战卡
item_conf.specialRoomCard = 1240 -- 群主对战卡
item_conf.zpKcoin       = 108   --  字牌K币
item_conf.unbindNewSpreader = 130 -- 解绑newSpreader
item_conf.sharePoint    = 200   --  分享积分
item_conf.radio         = 4001  --  喇叭
item_conf.radio10       = 4002  --  喇叭x10
item_conf.radio50       = 4003  --  喇叭x50
item_conf.changeNickNameCard = 4500  -- 改名卡
item_conf.minECodeItemID   = 5000  -- 电子券道具最小ID
item_conf.maxECodeItemID   = 5050  -- 电子券道具最大ID
item_conf.chargeCard50 = 3010 --50元话费充值卡凭证
item_conf.chargeCard100 = 3011 --100元话费充值卡凭证
item_conf.chargeCard500 = 3012 --500元话费充值卡凭证
item_conf.weiXinRedPaper1 = 2050  --微信1元红包
item_conf.weiXinRedPaper5 = 2051  --微信5元红包
item_conf.weiXinRedPaper10 = 2052  --微信10元红包
item_conf.weiXinRedPaper50 = 2053  --微信10元红包
item_conf.weiXinRedPaper100 = 2054  --微信10元红包
item_conf.weiXinGroupRedPaper1000 = 2070  --微信1000元分裂红包
item_conf.weiXinGroupRedPaper30 = 2071  --微信30元分裂红包
item_conf.weiXinGroupRedPaper50 = 2072  --微信50元分裂红包
item_conf.weiXinGroupRedPaper100 = 2073  --微信100元分裂红包
item_conf.weiXinGroupRedPaper5 = 2074  --微信5元分裂红包
item_conf.weiXinGroupRedPaper10 = 2075  --微信10元分裂红包
item_conf.pickaxe1        = 110       -- 挖矿道具1   尧山镐    对应区域 1 
item_conf.pickaxe2        = 111       -- 挖矿道具2   骆驼山镐  对应区域 2 
item_conf.pickaxe3        = 112       -- 挖矿道具3   象鼻山镐  对应区域 3
item_conf.pickaxe4        = 113       -- 挖矿道具4   靖江王城镐  对应区域 4
item_conf.faceTicket      = 1218      -- 表情券
item_conf.avatarDollDefaultCostItemID = 17 --阿凡达娃娃默认消耗道具ID
item_conf.avatarDollDefaultExchangeItemID = 1239 --阿凡达娃娃默认兑换获得道具ID

item_conf[0] = "goldCoin"
item_conf[1] = "ticket"
item_conf[2] = "point"
item_conf[3] = "pass_ticket"

item_conf["0"] = "金币"
item_conf["1"] = "奖券"
item_conf["2"] = "福气"
item_conf["3"] = "入场券"

--------------------------------------------------------------------------------
-- 最新的配置模板
--------------------------------------------------------------------------------

-- 中间的数字表示道具的 ID
item_conf["__10000__"] = {
    -- 道具名字
    chnName = "地球神牌★",

    -- 道具描述
    descr = "传说集齐七张神牌, 就能召唤出牌神",

    -- 效果描述
    affectDescr = "牌神可以实现你的一个愿望",

    -- 最大叠加量, 为 0 时表示无叠加上限
    maxOverlayNum = 50,

    -- 使用道具后, 道具的持续时间, 以小时为单位, 为 0 时表示生效后立即移除;
    -- 如果还未到持续时间, 但是已经到达截止日期, 那么道具也将移除.
    affectDuration = 3,

    -- 使用截止日期, 空字符串时, 表示无截止时限, 非时效性道具使用
    useExpire = "2016-12-30 00:00:00",

    -- 等级要求, 使用该道具需要的等级, 0 表示无等级限制
    requireLevel = 0,

    -- 售价, 为 nil 时表示无法回收
    recyclePrice = {
        itemId = 0,
        num = 1,
    },

    -- 道具图片的链接地址
    imgURL = "",

    -- 是否能够使用, 1 表示能够使用
    canUse = 0,

    -- 是否能够赠送, 1 表示能够赠送
    canSend = 0,

    -- 道具类型, 默认 normal
    variety = item_conf.itemVariety.normal,

    -- 持有时间, 0 表示无限期持有, 以小时为单位, 默认 0
    -- 只有在 variety 为 timely 时这个值才有效
    -- 注意: 一般时效性道具都是唯一的, 所以建议需要使用这个参数时 maxOverlayNum 设置 1
    keepDuration = 0,

    -- 是否可以合成, 1 表示能够合成, 0 表示不能
    canSynthesize = 0,

    -- 是否可以分解, 1 表示能够合成, 0 表示不能
    canDecompose = 0, 

    -- 判断是否在道具列表中可见, 1 可见, 0 不能
    isVisible = 1,

    ----------
    -- 预留: 是目前还未有实际用途的配置, 不定义也不会对程序造成影响
    ----------

    -- 预留, 道具类型
    kind = "card",

    -- 预留, 归属专属活动
    belongToActivity = "七星区字牌争夺赛",

    -- 预留, 遵守之前的配置
    keyName = "card ★",

    -- 使用后的处理配置，不需要为nil
    afterUseConf={
        --不需要发送邮件，email为nil
        email={
            typeID=0,               --类型，0为公告，1为奖励
            goodsID="0,101",        --奖励的道具ID
            goodsAmount="100,1",    --对应的奖励道具数量
            title="标题",               --邮件标题
            content="内容",             --邮件内容
            expireTime=30,          --邮件过期天数
        },
        --获得奖励，直接到帐，不需要为nil
        award={
            [1]={
                plusAmount=100,  --获得奖励道具数量
                goodsID=0,       --获得奖励道具ID
                userGoodsID=0,   --通常与goodsID相同
                remark="使用XXX道具",       --获得该奖励的原因
            },
        },
        needSendPhoneMsg=false,--是否需要发送手机短信
        --发送优惠券配置，不需要为nil
        sendCoupon={

        }
    },
    --使用限制
    useLimit={
        level={  --等级限制
            min=1,
            max=99,
        },
        authPhone=false,  --是否需要认证手机才能使用
    },
    --赠送限制
    sendLimit={
        --赠送方
        sender={
            level={    --等级限制
                min=1,
                max=99,
            },
            goldCoin={  --金币限制
                min=0,
                max=999999999,
            },
            authPhone=false,  --是否手机认证用户才能赠送
        }, 
        --获赠方
        getter={
            level={    --等级限制
                min=1,
                max=99,
            },
            goldCoin={  --金币限制
                min=0,
                max=999999999,
            },
            authPhone=false,  --是否手机认证用户才能接收
        },
    },
}

--------------------------------------------------------------------------------
-- 实际的道具属性配置
--------------------------------------------------------------------------------

item_conf["__0__"] = {
    chnName = "金币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "",
    requireLevel = 0,
    recyclePrice = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "goldCoin",
}

item_conf["__103__"] = {
    chnName = "K币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "",
    requireLevel = 0,
    recyclePrice = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "kCoin",
}

item_conf["__1__"] = {
    chnName = "奖券",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    belongToActivity = "",
    kind = "currency",
    keyName = "ticket",
}

item_conf["__3__"] = {
    chnName = "入场券",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 3,
    },
    belongToActivity = "",
    kind = "currency",
    keyName = "pass_ticket",
}


item_conf["__102__"] = {
    chnName = "老K金币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__103__"] = {
    chnName = "K币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__104__"] = {
    chnName = "经验值",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__105__"] = {
    chnName = "等级",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__106__"] = {
    chnName = "人民币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__107__"] = {
    chnName = "对战卡",
    descr = "使用对战卡可在牌友包厢开设专属房间，自定义牌桌规则，邀请好友同桌游戏。",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "",
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
    -- canSend = 1,
    isVisible = 1,

    --赠送限制
    -- sendLimit={
    --     --赠送方
    --     sender={
    --         level={    --等级限制
    --             min=1,
    --             max=99,
    --         },
    --         goldCoin={  --金币限制
    --             min=0,
    --             max=999999999,
    --         },
    --         authPhone=false,  --是否手机认证用户才能赠送
    --     }, 
    --     --获赠方
    --     getter={
    --         level={    --等级限制
    --             min=1,
    --             max=99,
    --         },
    --         goldCoin={  --金币限制
    --             min=0,
    --             max=999999999,
    --         },
    --         authPhone=false,  --是否手机认证用户才能接收
    --     },
    -- },
}

item_conf["__108__"] = {
    chnName = "K币",
    descr = "",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
}

item_conf["__110__"] = {
    chnName = "尧山镐头",
    descr = "凭此镐头可以在寻宝之旅的尧山免费寻宝一次，赢取丰厚大奖。",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = nil,
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
    isVisible = 1,
}

item_conf["__111__"] = {
    chnName = "骆驼山镐头",
    descr = "凭此镐头可以在寻宝之旅的骆驼山免费寻宝一次，赢取丰厚大奖。",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = nil,
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
    isVisible = 1,
}

item_conf["__112__"] = {
    chnName = "象鼻山镐头",
    descr = "凭此镐头可以在寻宝之旅的象鼻山免费寻宝一次，赢取丰厚大奖。",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = nil,
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
    isVisible = 1,
}

item_conf["__113__"] = {
    chnName = "靖江王城镐头",
    descr = "凭此镐头可以在寻宝之旅的靖江王城免费寻宝一次，赢取丰厚大奖。",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = nil,
    requireLevel = 0,
    recyclePrice = nil,
    imgURL = nil,
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 0,
    isVisible = 1,
}

item_conf["__4001__"] = {
    chnName = "小喇叭",
    descr = "可用于发送广播",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 1,
    isVisible = 0,
}

item_conf["__4500__"] = {
    chnName = "改名卡",
    descr = "可用于修改昵称",
    affectDescr = "",
    maxOverlayNum = 0,
    affectDuration = 0,
    useExpire = "2050-12-31 00:00:00",
    requireLevel = 0,
    recyclePrice = {
        itemId = 0,
        num = 1,
    },
    imgURL = "",
    belongToActivity = "",
    kind = "currency",
    keyName = "currency",
    canUse = 1,
    isVisible = 0,
}

return item_conf
