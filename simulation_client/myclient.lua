package.cpath = "luaclib/?.so;skynet-example/simulation_client/luaclib/?.so"
package.path = "lualib/?.lua;skynet-example/simulation_client/?.lua;"

-- local ok, socket = pcall(require, "socket")
local socket = require "client.socket"
local crypt=require "crypt" 
local sproto = require "sproto"
local proto = require "proto"
local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))
local h = require "head_file"  

local PASSWD = "LK_GLZP_2015"
local fd = assert(socket.connect("127.0.0.1", 8888))

-- 工具函数


local function print_request(name, args)
	print("REQUEST", name)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_response(session, args)
	print("RESPONSE", session)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_package(t, ...)
	if t == "REQUEST" then
		print_request(...)
	else
		assert(t == "RESPONSE")
		print_response(...)
	end
	print("\n\n")
end

local function send_package(fd, pack)
	local package = string.pack(">s2", pack)
	socket.send(fd, package)
end
local function unpack_package(text)
	local size = #text
	print("unpack_package size is:",size)
	if size < 2 then
		return nil, 0
	end
	local s = text:byte(1) * 256 + text:byte(2)

	print("unpack_package data size is:",s)

	if size < s+2 then
		return nil, 0
	end

	return text:sub(3,2+s), s
end
function word2String(word)

	if type(word) ~="number" then
		return nil
	end
	
	local str1,str2
	str1 = string.char(math.floor(word / 256))
	str2 = string.char(word % 256)

	return str1..str2
end
function stringGetWord (str)
	local word = str:byte(1) * 256 + str:byte(2)
	return word
end

function loadMsgHead (msg, srcEndPoint, dstEndPoint, dstModule, keyAction)
	local msgHeadData = {}
	msgHeadData.msgTag = h.MSG_HEAD_TAG
	msgHeadData.src = srcEndPoint
	msgHeadData.dst = dstEndPoint
	msgHeadData.dstModule = dstModule
	msgHeadData.keyAction = keyAction

	-- h5客户端那边需要，正式服一定要同步 add by sikun
	msgHeadData.rawMsgSize = #msg

	local strTemp = word2String(msgHeadData.msgTag)
	strTemp = strTemp..word2String(msgHeadData.src)
	strTemp = strTemp..word2String(msgHeadData.dst)
	strTemp = strTemp..word2String(msgHeadData.dstModule)
	strTemp = strTemp..word2String(msgHeadData.keyAction)
    strTemp=strTemp .. msg
    strTemp=crypt.aesencode(strTemp,PASSWD,"")

	return strTemp, msgHeadData
end
print("connect ok")


login_session=1
local  function send_login()

	--print("send_login")
	login_session = login_session+1
	local data = {
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
	}


	local str = request('auth', data, login_session)
	local str1 = loadMsgHead(str,h.enumEndPoint.CLIENT,h.enumEndPoint.LOGIN_SERVER,0,h.enumKeyAction.AUTH)

	local package = string.pack(">s2", str1)

	socket.send(fd, package)
end

local function recv()
	local msg
	local r = socket.recv(fd)
	if r  ~= nil and r  ~= ""
	then 
		 msg,sz = unpack_package(r)
	else
		--print("recv none")
		return nil
	end
 
    msg=crypt.aesdecode(msg,PASSWD,"")

     --消息头
	local msgHead = {
		msgTag = 0,			--2字节 消息头标签
		src = 0,			--2字节 源端点
		dst = 0,			--2字节 目标端点
		dstModule = 0,		--2字节 目标模块
		keyAction = 0,		--2字节 动作
	}
	msgHead.msgTag = stringGetWord(msg)
	if msgHead.msgTag == 0xabcd then
		print("recv Tag is right!")
		msgHead.src = stringGetWord(string.sub(msg,3,4))
		msgHead.dst = stringGetWord(string.sub(msg,5,6))
		msgHead.dstModule = stringGetWord(string.sub(msg,7,8))
		msgHead.keyAction = stringGetWord(string.sub(msg,9,10))
		msg = string.sub(msg, 11, sz)
		sz = sz - 10
	else
		print("recv Tag is erro!")
	end
	print_package(host:dispatch(msg))
end 


while true do


	--print(" while start")
	socket.usleep(1000*1000)
	-- 接收服务器返回消息
	recv()


	-- 读取用户输入消息
	local readstr = socket.readstdin()
	if readstr then
		if readstr == "l" then
			send_login()
		elseif  readstr == "o" then
		else
			print("please input right cmd!")
		end
	end

end