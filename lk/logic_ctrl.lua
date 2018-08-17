-- 比赛的一些判断
-- @author huang xiang rui
-- @date 2015.11.18

local skynet = require "skynet"
local hs = require "headfile_server"
local cluster = require "cluster"
require "skynet.manager"

local logic_ctrl={}
logic_ctrl.printFlag = true		-- printF打印开关
logic_ctrl.logFlag = false		-- printF记日志开关

local printFlag = logic_ctrl.printFlag
local logFlag = logic_ctrl.logFlag
local function printF(...)
    local logStr = ""
    if printFlag then
        logStr = logStr .. "  [LOGIC_CTRL]"..os.date("%Y-%m-%d %H:%M:%S",os.time())
        -- .. ct.getTime()
        print(logStr, ...)

        if logFlag then
            skynet.error(logStr, ...)
        end
    end
end

local function printE(...)
    local logStr = ""
    logStr = logStr .. "\n[ERROR LOGIC_CTRL]"
    print(logStr, ...)
    skynet.error(logStr, ...)
end

--红包文字 https_service
function logic_ctrl.getRedPaperText()
    local send_name=""
    local wishing=""

    if hs.gameModel == "glzp" then
        send_name="桂林字牌"
        wishing="恭喜获得 桂林字牌 友情红包！大家一起玩字牌，赢了红包都有份！"
    end
    if hs.gameModel == "czzp" then
        send_name="郴州字牌"
        wishing="恭喜获得 郴州字牌 友情红包！大家一起玩老K郴州字牌，赢了红包都有份！"
    end
    if hs.gameModel == "phz" then
        send_name="跑胡子"
        wishing="恭喜获得 跑胡子 友情红包！大家一起玩老K跑胡子，赢了红包都有份！"
    end
    if hs.gameModel == "hgw" then
        send_name="红拐弯"
        wishing="恭喜获得 红拐弯 友情红包！大家一起玩老K红拐弯，赢了红包都有份！"
    end
    if hs.gameModel == "hczp" then
        send_name="河池字牌"
        wishing="恭喜获得 河池字牌 友情红包！大家一起玩老K河池字牌，赢了红包都有份！"
    end

    return {send_name=send_name,wishing=wishing}
end

--获得UpdateNewSpreaderInfo函数名 db_service
function logic_ctrl.getUpdateNewSpreaderInfoFuncName()
    if hs.gameModel == "glzp" then
        return "updateNewSpreaderInfo_glzp"
    end
    if hs.gameModel == "czzp" then
        return "updateNewSpreaderInfo_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "updateNewSpreaderInfo_phz"
    end
    if hs.gameModel == "hgw" then
        return "updateNewSpreaderInfo_phz"
    end
    if hs.gameModel == "hczp" then
        return "updateNewSpreaderInfo_phz"
    end
    return ""
end

--获得login更新用户微信信息sql语句 login_service
function logic_ctrl.getUpdateUserWxInfoSql(args,uid)
    if hs.gameModel == "glzp" then
        return string.format("update User set thirdPartUnionID='%s',thirdPartAppOpenID='%s',thirdPartNickName='%s',thirdPartRefreshToken='%s',thirdAvatarID='%s' where ID=%d",args.extraData.weiXinData.thirdPartUnionID,args.extraData.weiXinData.thirdPartAppOpenID,args.extraData.weiXinData.thirdPartNickName,args.extraData.weiXinData.thirdPartRefreshToken,args.extraData.thirdAvatarID,uid)
    end
    if hs.gameModel == "czzp" then
        return string.format("update User set thirdPartUnionID='%s',thirdPartAppOpenID='%s',thirdPartNickName='%s',thirdPartRefreshToken='%s',thirdAvatarID='%s' where ID=%d",args.extraData.weiXinData.thirdPartUnionID,args.extraData.weiXinData.thirdPartAppOpenID,args.extraData.weiXinData.thirdPartNickName,args.extraData.weiXinData.thirdPartRefreshToken,args.extraData.thirdAvatarID,uid)
    end
    if hs.gameModel == "phz" then
        return string.format("update User set thirdPartUnionID='%s',thirdPartAppOpenID='%s',thirdPartNickName='%s',thirdPartRefreshToken='%s',thirdAvatarID='%s' where ID=%d",args.extraData.weiXinData.thirdPartUnionID,args.extraData.weiXinData.thirdPartAppOpenID,args.extraData.weiXinData.thirdPartNickName,args.extraData.weiXinData.thirdPartRefreshToken,args.extraData.thirdAvatarID,uid)
    end
    if hs.gameModel == "hgw" then
        return string.format("update User set thirdPartUnionID='%s',thirdPartAppOpenID='%s',thirdPartNickName='%s',thirdPartRefreshToken='%s',thirdAvatarID='%s' where ID=%d",args.extraData.weiXinData.thirdPartUnionID,args.extraData.weiXinData.thirdPartAppOpenID,args.extraData.weiXinData.thirdPartNickName,args.extraData.weiXinData.thirdPartRefreshToken,args.extraData.thirdAvatarID,uid)
    end
    if hs.gameModel == "hczp" then
        return string.format("update User set thirdPartUnionID='%s',thirdPartAppOpenID='%s',thirdPartNickName='%s',thirdPartRefreshToken='%s',thirdAvatarID='%s' where ID=%d",args.extraData.weiXinData.thirdPartUnionID,args.extraData.weiXinData.thirdPartAppOpenID,args.extraData.weiXinData.thirdPartNickName,args.extraData.weiXinData.thirdPartRefreshToken,args.extraData.thirdAvatarID,uid)
    end
    return ""
end

--获得执行checkSpreader函数名 login_service
function logic_ctrl.getCheckSpreaderFuncName()
    if hs.gameModel == "glzp" then
        return "checkSpreader_glzp"
    end
    if hs.gameModel == "czzp" then
        return "checkSpreader_czzp"
    end
    --使用phz
    if hs.gameModel == "phz" then
        return "checkSpreader_phz"
    end
    if hs.gameModel == "hgw" then
        return "checkSpreader_czzp"
    end
    if hs.gameModel == "hczp" then
        return "checkSpreader_czzp"
    end
    return ""
end

--获得登录服务获得用户微信信息函数名 login_service
function logic_ctrl.getGetWxUserInfoFuncName()
    if hs.gameModel == "glzp" then
        return "getWxUserInfo_glzp"
    end
    --使用czzp
    if hs.gameModel == "czzp" then
        return "getWxUserInfo_czzp"
    end
    if hs.gameModel == "phz" then
        return "getWxUserInfo_phz"
    end
    if hs.gameModel == "hgw" then
        return "getWxUserInfo_phz"
    end
    if hs.gameModel == "hczp" then
        return "getWxUserInfo_phz"
    end
    return ""
end

--获得新私人场插入GroupInfoLog函数名 gamelog_db
function logic_ctrl.getNewRoomSelfInsertRoomSelfGroupInfoLogFuncName()
    if hs.gameModel == "glzp" then
        return "InsertRoomSelfGroupInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertRoomSelfGroupInfoLog_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertRoomSelfGroupInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertRoomSelfGroupInfoLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertRoomSelfGroupInfoLog_czzp"
    end
    return ""
end

--获得新私人场插入GroupUserInfoLog函数名 gamelog_db
function logic_ctrl.getNewRoomSelfInsertRoomSelfGroupUserInfoLogFuncName()
    if hs.gameModel == "glzp" then
        return "InsertRoomSelfGroupUserInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertRoomSelfGroupUserInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertRoomSelfGroupUserInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertRoomSelfGroupUserInfoLog_glzp"
    end
    if hs.gameModel == "hczp" then
        return "InsertRoomSelfGroupUserInfoLog_glzp"
    end
    return ""
end

--获得新私人场插入videoInfoLog函数名 gamelog_db
function logic_ctrl.getNewRoomSelfInsertGameVideoInfoLogFuncName()
    if hs.gameModel == "glzp" then
        return "insertGameVideoInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "insertGameVideoInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "insertGameVideoInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "insertGameVideoInfoLog_glzp"
    end
    if hs.gameModel == "hczp" then
        return "insertGameVideoInfoLog_glzp"
    end
    return ""
end

--获得新私人场插入videoInfoLog函数名 gamelog_db
function logic_ctrl.getNewRoomSelfInsertGameVideoUserInfoLogFuncName()
    if hs.gameModel == "glzp" then
        return "insertGameVideoUserInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "insertGameVideoUserInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "insertGameVideoUserInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "insertGameVideoUserInfoLog_glzp"
    end
    if hs.gameModel == "hczp" then
        return "insertGameVideoUserInfoLog_glzp"
    end
    return ""
end

--获得新私人场获得战绩函数 gamelog_db
function logic_ctrl.getGetRoomSelfHistoryFuncName()
    if hs.gameModel == "glzp" then
        return "getRoomSelfHistory_glzp"
    end
    if hs.gameModel == "czzp" then
        return "getRoomSelfHistory_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "getRoomSelfHistory_phz"
    end
    if hs.gameModel == "hgw" then
        return "getRoomSelfHistory_phz"
    end
    if hs.gameModel == "hczp" then
        return "getRoomSelfHistory_czzp"
    end
    return ""
end

--获得新私人场获得战绩函数 gamelog_db
function logic_ctrl.getGetGroupAdminCreateHistoryType()
    if hs.gameModel == "glzp" then
        return 1
    end
    if hs.gameModel == "czzp" then
        return 0
    end
    --phz
    if hs.gameModel == "phz" then
        return 0
    end
    if hs.gameModel == "hgw" then
        return 0
    end
    if hs.gameModel == "hczp" then
        return 0
    end
    return 0
end

--获得修改昵称改名次数用完文本 item_handler
function logic_ctrl.getUseUpChangeNickNameCardText(goodsName)
    if hs.gameModel == "glzp" then
        return tostring(goodsName).."不足，无法修改昵称，是否充值"
    end
    if hs.gameModel == "czzp" then
        return "改名次数已用完，无法修改昵称"
    end
    if hs.gameModel == "phz" then
        return "改名次数已用完，无法修改昵称"
    end
    if hs.gameModel == "hgw" then
        return "改名次数已用完，无法修改昵称"
    end
    if hs.gameModel == "hczp" then
        return "改名次数已用完，无法修改昵称"
    end
    return ""
end

--获得短信验证码文本 player
function logic_ctrl.getAuthPhoneShortMsgText(rdsAuthCode)
    if hs.gameModel == "glzp" then
        return "验证码:"..tostring(rdsAuthCode).."，此验证码由桂林字牌发送，用于进行手机绑定，无需回复。"
    end
    if hs.gameModel == "czzp" then
        return "验证码:"..tostring(rdsAuthCode).."，此验证码由老K郴州字牌发送，用于进行手机绑定，无需回复。"
    end
    if hs.gameModel == "phz" then
        return "验证码:"..tostring(rdsAuthCode).."，此验证码由老K跑胡子发送，用于进行手机绑定，无需回复。"
    end
    if hs.gameModel == "hgw" then
        return "验证码:"..tostring(rdsAuthCode).."，此验证码由老K红拐弯发送，用于进行手机绑定，无需回复。"
    end
    if hs.gameModel == "hczp" then
        return "验证码:"..tostring(rdsAuthCode).."，此验证码由老K河池字牌发送，用于进行手机绑定，无需回复。"
    end
    return ""
end

--获得插入绑定推广号日志函数名 db_service
function logic_ctrl.getInsertNewSpreaderBindLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "InsertNewSpreaderBindLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertNewSpreaderBindLog_phz"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertNewSpreaderBindLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertNewSpreaderBindLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertNewSpreaderBindLog_phz"
    end
    return ""
end

--获得更新推广号的数据信息函数名 db_service4
function logic_ctrl.getUpdateSpreaderInfoFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "updateSpreaderInfo_glzp"
    end
    if hs.gameModel == "czzp" then
        return "updateSpreaderInfo_phz"
    end
    --phz
    if hs.gameModel == "phz" then
        return "updateSpreaderInfo_phz"
    end
    if hs.gameModel == "hgw" then
        return "updateSpreaderInfo_phz"
    end
    if hs.gameModel == "hczp" then
        return "updateSpreaderInfo_phz"
    end
    return ""
end

--获得设置新私人场推广号函数名 player
function logic_ctrl.getSetNewSpreaderFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "setNewSpreader_glzp"
    end
    if hs.gameModel == "czzp" then
        return "setNewSpreader_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "setNewSpreader_phz"
    end
    if hs.gameModel == "hgw" then
        return "setNewSpreader_czzp"
    end
    if hs.gameModel == "hczp" then
        return "setNewSpreader_czzp"
    end
    return ""
end

--获取更新房卡购买记录函数名 mall_service
function logic_ctrl.getUpdateRoomCardPurchaseLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "updateRoomCardPurchaseLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "updateRoomCardPurchaseLog_phz"
    end
    --phz
    if hs.gameModel == "phz" then
        return "updateRoomCardPurchaseLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "updateRoomCardPurchaseLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "updateRoomCardPurchaseLog_phz"
    end
    return ""
end

--获取扩展处理函数名 mall_service
function logic_ctrl.getExtendHandlyFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "extendHandly_glzp"
    end
    if hs.gameModel == "czzp" then
        return "extendHandly_phz"
    end
    --phz
    if hs.gameModel == "phz" then
        return "extendHandly_phz"
    end
    if hs.gameModel == "hgw" then
        return "extendHandly_phz"
    end
    if hs.gameModel == "hczp" then
        return "extendHandly_phz"
    end
    return ""
end

--获取更新结果函数名 mall_service
function logic_ctrl.getUpdateResultFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "updateResult_glzp"
    end
    if hs.gameModel == "czzp" then
        return "updateResult_phz"
    end
    --phz
    if hs.gameModel == "phz" then
        return "updateResult_phz"
    end
    if hs.gameModel == "hgw" then
        return "updateResult_phz"
    end
    if hs.gameModel == "hczp" then
        return "updateResult_phz"
    end
    return ""
end

--获取新私人场配置函数名 gamelog_db
function logic_ctrl.getGetRoomSelfConfigFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "getRoomSelfConfig_glzp"
    end
    if hs.gameModel == "czzp" then
        return "getRoomSelfConfig_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "getRoomSelfConfig_phz"
    end
    if hs.gameModel == "hgw" then
        return "getRoomSelfConfig_phz"
    end
    if hs.gameModel == "hczp" then
        return "getRoomSelfConfig_glzp"
    end
    return ""
end

--获取设置新私人场配置函数名 gamelog_db
function logic_ctrl.getSetRoomSelfConfigFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "setRoomSelfConfig_glzp"
    end
    if hs.gameModel == "czzp" then
        return "setRoomSelfConfig_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "setRoomSelfConfig_phz"
    end
    if hs.gameModel == "hgw" then
        return "setRoomSelfConfig_phz"
    end
    if hs.gameModel == "hczp" then
        return "setRoomSelfConfig_glzp"
    end
    return ""
end

--获取获得新私人场战绩函数名 redis_service
function logic_ctrl.getRedisGetRoomHistoryFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "getRoomHistory_glzp"
    end
    if hs.gameModel == "czzp" then
        return "getRoomHistory_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "getRoomHistory_phz"
    end
    if hs.gameModel == "hgw" then
        return "getRoomHistory_phz"
    end
    if hs.gameModel == "hczp" then
        return "getRoomHistory_glzp"
    end
    return ""
end

--获取插入新私人场战绩函数名 redis_service
function logic_ctrl.getInsertRoomSelfGameInfoFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "InsertRoomSelfGameInfo_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertRoomSelfGameInfo_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertRoomSelfGameInfo_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertRoomSelfGameInfo_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertRoomSelfGameInfo_glzp"
    end
    return ""
end

--获取同步新私人场战绩函数名 redis_service
function logic_ctrl.getSyncRoomSelfGameInfoFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "SyncRoomSelfGameInfo_glzp"
    end
    if hs.gameModel == "czzp" then
        return "SyncRoomSelfGameInfo_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "SyncRoomSelfGameInfo_phz"
    end
    if hs.gameModel == "hgw" then
        return "SyncRoomSelfGameInfo_phz"
    end
    if hs.gameModel == "hczp" then
        return "SyncRoomSelfGameInfo_glzp"
    end
    return ""
end

--获得插入黑名单函数名 db_service
function logic_ctrl.getInsertBlackListFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "insertBlackList_glzp"
    end
    if hs.gameModel == "czzp" then
        return "insertBlackList_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "insertBlackList_czzp"
    end
    if hs.gameModel == "hgw" then
        return "insertBlackList_czzp"
    end
    if hs.gameModel == "hczp" then
        return "insertBlackList_czzp"
    end
    return ""
end

--获得插入黑名单函数名 new_room_self gamelog_db
function logic_ctrl.getUpdateRoomSelfGroupInfoLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "UpdateRoomSelfGroupInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "UpdateRoomSelfGroupInfoLog_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "UpdateRoomSelfGroupInfoLog_czzp"
    end
    if hs.gameModel == "hgw" then
        return "UpdateRoomSelfGroupInfoLog_czzp"
    end
    if hs.gameModel == "hczp" then
        return "UpdateRoomSelfGroupInfoLog_czzp"
    end
    return ""
end

--获得插入新私人场记录函数名 new_room_self gamelog_db
function logic_ctrl.getInsertRoomSelfInfoLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "InsertRoomSelfInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertRoomSelfInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertRoomSelfInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertRoomSelfInfoLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertRoomSelfInfoLog_glzp"
    end
    return ""
end

--获得插入倍率记录函数名 room gamelog_db
function logic_ctrl.getInsertGameInfoLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "InsertGameInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertGameInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertGameInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertGameInfoLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertGameInfoLog_glzp"
    end
    return ""
end

--获得插入比赛记录函数名 room_match gamelog_db
function logic_ctrl.getInsertMatchInfoLogFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "InsertMatchInfoLog_glzp"
    end
    if hs.gameModel == "czzp" then
        return "InsertMatchInfoLog_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "InsertMatchInfoLog_phz"
    end
    if hs.gameModel == "hgw" then
        return "InsertMatchInfoLog_phz"
    end
    if hs.gameModel == "hczp" then
        return "InsertMatchInfoLog_phz"
    end
    return ""
end

--获得群主开房记录函数名 new_room_self gamelog_db
function logic_ctrl.getGetGroupAdminCreateHistoryFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "getGroupAdminCreateHistory_glzp"
    end
    if hs.gameModel == "czzp" then
        return "getGroupAdminCreateHistory_czzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "getGroupAdminCreateHistory_phz"
    end
    if hs.gameModel == "hgw" then
        return "getGroupAdminCreateHistory_phz"
    end
    if hs.gameModel == "hczp" then
        return "getGroupAdminCreateHistory_phz"
    end
    return ""
end

--获得同步群主开房记录函数名 redis
function logic_ctrl.getSyncGroupAdminCreateHistoryFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "SyncGroupAdminCreateHistory_glzp"
    end
    if hs.gameModel == "czzp" then
        return "SyncGroupAdminCreateHistory_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "SyncGroupAdminCreateHistory_phz"
    end
    if hs.gameModel == "hgw" then
        return "SyncGroupAdminCreateHistory_phz"
    end
    if hs.gameModel == "hczp" then
        return "SyncGroupAdminCreateHistory_phz"
    end
    return ""
end

--获得随机服务函数名 ct
function logic_ctrl.getRandomServiceFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "randomService_glzp"
    end
    if hs.gameModel == "czzp" then
        return "randomService_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "randomService_phz"
    end
    if hs.gameModel == "hgw" then
        return "randomService_phz"
    end
    if hs.gameModel == "hczp" then
        return "randomService_phz"
    end
    return ""
end

--获得指定服务函数名 ct
function logic_ctrl.getFindServiceFuncName()
    --glzp
    if hs.gameModel == "glzp" then
        return "findService_glzp"
    end
    if hs.gameModel == "czzp" then
        return "findService_glzp"
    end
    --phz
    if hs.gameModel == "phz" then
        return "findService_phz"
    end
    if hs.gameModel == "hgw" then
        return "findService_phz"
    end
    if hs.gameModel == "hczp" then
        return "findService_phz"
    end
    return ""
end

return logic_ctrl