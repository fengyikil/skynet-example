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
local fd

msg= {}




local function word2String(word)

	if type(word) ~="number" then
		return nil
	end
	
	local str1,str2
	str1 = string.char(math.floor(word / 256))
	str2 = string.char(word % 256)

	return str1..str2
end

local function stringGetWord (str)
	local word = str:byte(1) * 256 + str:byte(2)
	return word
end



local function createPackage(msg, srcEndPoint, dstEndPoint, dstModule, keyAction)
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

local function rec_package(fd)
	local msg
	local r = socket.recv(fd)
	if r  ~= nil and r  ~= ""
		then 
		msg,sz = unpack_package(r)
	else
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
	return msg,msgHead
end

local function msg.init()
	fd = assert(socket.connect("127.0.0.1", 8888)) 	
end 

