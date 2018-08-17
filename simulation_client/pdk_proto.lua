--[[
	paodekuai proto 500+

	head_file: pdk.head_file
]]

local sprotoparser = require "sprotoparser"
local proto = {}

proto.c2s = [[

.dynamic_cfg {
    rc_config 0 : string #json { [game_count] = xxx }
}

#keyAction: ENTER_ROOM_PDK
pdk_enter_room 500 {
	request {

	}

	response {
		enterResult 0 : integer                    #定义在headFile.pdkEnterRoomResult
        cfg 1 : dynamic_cfg
	}
}

.user {
	uid 0: integer
	nickname 1: string
	chair_id 2: integer
	chip 3: integer
	user_game_specified_data 4: string
	is_robot 5 : integer
    gender 6: string
    unionID 7 : string
}

.table_config_info {
	config_info 0 : string #{chair_count:xxx, cell_score:xxx,XXXX}
}

.table_scene {
	table_id 0 : integer
	players 1: *user
	table_config 2: table_config_info
	game_specified_data 3: string					#游戏写入的简短场景信息
	master_id 4 : integer
	enter_code 5 : string
    rate_room_svr_id 6 : integer                      #只在金币房有效
}

.location {
    longitude 0 : string
    latitude 1 : string
}

# keyAction: CREATE_DESK_PDK
pdk_create_desk 501 {
	request {
		data 0 : string								#json
        location 1 : location
	}

	response {
		createResult 0 : integer
		table_scene 1 : table_scene
	}
}

# keyAction: ENTER_DESK_PDK
pdk_enter_desk 502 {
	request {
		enter_code 0 : string
        location 1 : location
	}

	response {
		enterDeskResult 0 : integer
		table_scene 1 : table_scene
	}
}

.card_info{
    num 0: integer
    type 1 : integer
}
# keyAction: REQUEST_PLAY_GAME_PDK
game_user_req_play_card 503 {
    request {
        card 0 :*card_info
    }
    response {
        error_code 0 : integer
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_user_req_pass 505 {
    request {

    }
    response {
        res 0 : boolean
        error_code 1: string
    }
}

.game_table_info {
    cell_score 0: string
    chair_count 1: integer
    config_info 2 : string
}

.game_user {
    uid 0: integer
    nickname 1: string
    chair_id 2: integer
    chip 3: integer
    user_state 4 : string
    cards 5 : *card_info
}

.game_table_scene {
    players 0: *game_user
    table_config 1 : game_table_info
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_user_get_table_scene 506 {
    request {

    }
    response {
        table_scene 0: game_table_scene
    }
}

.rdy_players {
    chair_id 0 : integer
    uid 1 : integer
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_user_req_get_ready_info 508 {
    request {

    }
    response {
        res 0 : boolean
        ready_player 1 : *rdy_players
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_request_user_req_dismiss_casino 511{
    request {
        chair_id 0 : integer
        casino_id 1 : string
    }
    response {
        code 0 : integer
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_user_req_dismiss_casino 512 {
    request {
        chair_id 0 : integer
        casino_id 1 : string
        is_agree 2 : integer #1:agree, 2:not agree
    }
    response {
        code 0 : integer
    }
}

.vote_info {
    uid 0 : integer
    chair_id 1 : integer
    is_agree 2 : integer
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_user_request_vote_dismiss_info 513 {
    request {
        chair_id 0 : integer
    }
    response {
        code 0 : integer #-1, 0
        player_vote 1 : *vote_info
        left_time 2 : integer
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
game_request_cut_card 514 {
    request {

    }
    response {
        error_code 0 : integer              #0成功 1失败
    }
}

#用于广播桌子语音和表情
# keyAction: REQUEST_PLAY_GAME_PDK
game_broadcast_table 515 {      
    request {
        content 0 : string
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
pdk_get_ready 516 {
	request {
		desk_id 0 : integer
	}
	response {
		error_code 0 : integer
	}
}

# keyAction: REQUEST_PLAY_GAME_PDK
pdk_exit_desk 517 {
	request {

	}
	response {
		error_code 0 : integer
	}
}

# keyAction: RECONNECT_PDK
pdk_come_back 518 {
	request {

	}
	response {
		error_code 0 : integer
		scene 1 : table_scene
	}
}

.GroupInfoLogID {
	db_tbl_name_postfix 0 : string
	ID 1 : integer
}

# keyAction: PDK_LOG
pdk_request_casino_user_join 519 {
	request {
		cnt 0 : integer
	}
	response {
		error_code 0 : integer
		GroupInfoLogIDs 1 : *GroupInfoLogID
	}
}

.casino_log_player_info {
	chip 0 : integer
	data 1 : string # json
}

.player_result_info {
    chair_id 0 : integer
    add_chip 1 : integer
}

.casino_result_info {
    create_time 0 : integer
    finish_time 1 : integer
    game_index 2 : integer
    player_result 3 : *player_result_info
}

# keyAction: PDK_LOG
pdk_request_casino_log 520 {
	request {
		ID 0 : GroupInfoLogID
	}
	response {
		error_code 0 :integer
		enter_code 1 : string
		create_time 2 : integer
		finish_time 3 : integer
		finish_cnt 4 : integer
		game_specified_data 5 : string
		players_info 6 : *casino_log_player_info
		casino_result_info 7 : *casino_result_info
	}
}

# keyAction: PDK_LOG
pdk_request_casino_playback_data 521 {
	request {
		ID 0 : GroupInfoLogID
		game_index 1 : integer
	}
	response {
		error_code 0 : integer
		data 1 : string
	}
}

.curr_casino_log {
	player_result 0 : *player_result_info
	start_time 1 : integer
}

# keyAction: REQUEST_PLAY_GAME_PDK
pdk_request_curr_casino_log 522 {
	request {

	}
	response {
		error_code 0 : integer
		logs 1 : *curr_casino_log
	}
}

# keyAction: PDK_INVITE_USER
pdk_invite_user 523 {
	request {
		userIDs 0 : *integer
		enter_code 1 : string
		nickname 2 : string
	}
	response {
		error_code 0 : integer
		fail_userIDs 1 : *integer
	}
}

.pdk_rate_room {
    id 0 : integer
    maxVal 1 : integer
    minVal 2 : integer
    title 3 : string
    tax 4 : integer
    baseBet 5 : integer
}

# keyAction: GET_RATE_ROOM_LIST
pdk_get_rate_rooms 524 {
    request {

    }
    response {
        error_code 0 : integer
        list 1 : *pdk_rate_room
    }
}

pdk_select_rate_room 525 {
    request {
        id 0 : integer
    }
    response {
        error_code 0 : integer
        table_scene 1 : table_scene
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
pdk_force_to_out_table 526 {
    request {
        chair_id 0 : integer
    }
    response {
        error_code 0: integer
    }
}

# keyAction: REQUEST_PLAY_GAME_PDK
pdk_rate_room_mandate 527 {
    request {

    }
    response {
        error_code 0 : integer
        chair_id 1 : integer
        curr_mandate_state 2 : boolean
    }
}

#领救济金 KeyAction ： RATE_ROOM_GET_RELIEVE
pdk_get_relieve 528 {
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

#组局房主踢出其他玩家请求
# keyAction: REQUEST_PLAY_GAME_PDK
pdk_room_owner_kick_player 529 {
    request {
        chair_id 0 : integer
    }
    response {
        error_code 0 : integer
    }
}

]]

proto.s2c = [[
.card_info{
    num 0: integer
    type 1 : integer
}
# keyAction: PUSH_PLAY_GAME_PDK
game_Client_Play_Card 500 {
    request {
        cards 0 : *card_info
        init_turn_chair_id 1 : integer
        cur_game_count 2: integer
    }
}
.playing_card_info {
    chair_id 0 : integer
    uid 1 : integer
    card 2 : *card_info
}
# keyAction: PUSH_PLAY_GAME_PDK
game_res_user_play_card 501 {
    request {
        cards 0 : playing_card_info
    }
}
.res_card_info {
    chair_id 0 : integer
    cards 1 : *card_info
}

# keyAction: PUSH_PLAY_GAME_PDK
game_res_game_start 502 {
    request {
        is_go_up 0 : boolean
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_turn_to_player_out_card 504 {
    request {
        chair_id 0: integer
        time_out 1: integer
    }
}
.balance_info{
    chair_id 0 : integer
    balance_chip 1 : integer
    chip 2 : integer
    boom 3 : integer #boom:1,win:1,lose:1
    leftnum 4 : integer
    broken 5 : boolean
    nick_name 6 : string
}

# keyAction: PUSH_PLAY_GAME_PDK
game_res_game_balance 505 {
    request {
        msg 0 : *balance_info
        all_pay_chair 1 : integer
        is_end 2 : boolean
        res_card 3 : *res_card_info
        is_force_end 4 : boolean
        winorlose_chair_id 5 : integer
        game_count 6 : integer  #当前第几局(用于组局)
        all_count 7 : integer
        rate_room_tax 8 : integer
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_left_one_card 506 {
    request {
        chair_id 0 : integer
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_res_boom_balance 507 {
    request {
        msg 0 : *balance_info
    }
}
.playerinfo {
    uid 0: integer
    nickname 1: string
    chair_id 2: integer
    chip 3: integer
}

.rdy_players {
    chair_id 0 : integer
    uid 1 : integer
}
# keyAction: PUSH_PLAY_GAME_PDK
game_res_player_get_ready_info 509 {
    request {
        ready_player 0 : *rdy_players
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_res_user_post_dismiss_vote 511 {
    request {
        is_agree 0 : integer #1:agree, 2:not agree
        chair_id 1 : integer
    }
}

.player_balance_info {
    uid 0 : integer
    add_chip 1 : integer
    buy_chip 2 : integer
    boom 3 : integer
    win 4 : integer
    lose 5 : integer
    max_win 6 : integer
    max_lose 7 : integer
    add_master_score 8 : integer
    nick_name 9 : string
}

# keyAction: PUSH_PLAY_GAME_PDK
game_res_casino_balance 512 {
    request {
        game_count 0 : integer
        player_info 1 : *player_balance_info
        all_count 2 : integer
        master_chair 3 : integer
        enter_code 4 : string
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_notify_offline 514 {
    request {
        chair_id 0 : integer
        uid 1 : integer
        is_offline 2 : boolean
    }
}

#用于广播桌子语音和表情
# keyAction: PUSH_PLAY_GAME_PDK
game_broadcast_table 516 {      
    request {
        content 0 : string
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_brocast_cut_card 517 {
    request {
        chair_id 0 : integer
    }
}

# keyAction: PUSH_PLAY_GAME_PDK
game_pdk_user_res_pass 519 {
	request {
		chair_id 0: integer
	}
}

.user {
	uid 0: integer
	nickname 1: string
	chair_id 2: integer
	chip 3: integer
	user_game_specified_data 4: string
	is_robot 5 : integer
    gender 6: string
    unionID 7 : string
}

.table_config_info {
	config_info 0 : string #{chair_count:xxx, cell_score:xxx,XXXX}
}

.table_scene {
	table_id 0 : integer
	players 1: *user
	table_config 2: table_config_info
	game_specified_data 3: string					#游戏写入的简短场景信息
	master_id 4 : integer
	enter_code 5 : string
    rate_room_svr_id 6 : integer                      #只在金币房有效
}

# keyAction: PUSH_PLAY_GAME_PDK
game_pdk_table_scene 520 {
	request {
		scene 0 : table_scene
	}	
}

# keyAction: PDK_INVITE_USER
pdk_invite_user 521 {
	request {
		enter_code 0 : string
		nickname 1 : string
	}
}

pdk_player_mandate 522 {
    request {
        chair_id 0 : integer
        is_mandate 1 : boolean
    }
}

pdk_need_take_relieve 523 {
    
}

# keyAction: PUSH_PLAY_GAME_PDK
pdk_player_kick_by_room_owner 524 {
    request {
        chair_id 0: integer
    }
}

]]

return proto