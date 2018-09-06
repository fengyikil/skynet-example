-- local ok, socket = pcall(require, "socket")
local socket = require "client.socket"
local crypt=require "crypt" 
local sproto = require "sproto"
local proto = require "glzp.proto"
local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local host1 = sproto.new(proto.c2s):host "package"
local request1 = host:attach(sproto.new(proto.s2c))

local h = require "glzp.head_file"  

local PASSWD = "LK_GLZP_2015"

local jpack= {}
local send_count = 0
local recv_count = 0

local function debug( ... )
	jpack.file:write( ... )
	jpack.file:flush()
end  
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

local function unpack_package(text)
	local size = #text
	--print("unpack_package size is:",size)
	if size < 2 then
		return nil, 0
	end
	local s = text:byte(1) * 256 + text:byte(2)

	--print("unpack_package data size is:",s)

	if size < s+2 then
		return nil, 0
	end

	return text:sub(3,2+s), s
end

local function print_send_package(msg)
	send_count = send_count +1
	msg=crypt.aesdecode(msg,PASSWD,"")

     --消息头
     local head = {
		msgTag = 0,			--2字节 消息头标签
		src = 0,			--2字节 源端点
		dst = 0,			--2字节 目标端点
		dstModule = 0,		--2字节 目标模块
		keyAction = 0,		--2字节 动作
	}
	head.msgTag = stringGetWord(msg)
	if head.msgTag == 0xabcd then
		head.src = stringGetWord(string.sub(msg,3,4))
		head.dst = stringGetWord(string.sub(msg,5,6))
		head.dstModule = stringGetWord(string.sub(msg,7,8))
		head.keyAction = stringGetWord(string.sub(msg,9,10))
		msg = string.sub(msg, 11, #msg)
	else
		print("recv Tag is erro!")
	end
	
	debug(string.format("*************** SEND  <Count> : %d  <Head> : { src = %d, dst = %d, dstModule = %d, keyAction = %d, msgTag = %d } <Time> : %s ****************\n\n",send_count,head.src,head.dst,head.dstModule,head.keyAction,head.msgTag,os.date("%X")))
	-- debug(string.format("msg1 len is %d\n",#msg1))
	local type,name,data=host1:dispatch(msg)
	debug("type = "..tostring(type).."\n")
	if type == "REQUEST"
	then
	debug("name = "..tostring(name).."\n")
	else
	debug("session = "..tostring(name).."\n")
	end

	if next(data) ~= nil
	then
		debug("{\n")
		for k,v in pairs(data) do
			debug("\t",tostring(k)," = ",tostring(v),"\n")
		end
		debug("}")
    end
	debug("\n\n")
end

local function print_rec_package(head,msg)
	recv_count = recv_count +1

	debug(string.format("*************** RECV  <Count> : %d  <Head> : { src = %d, dst = %d, dstModule = %d, keyAction = %d, msgTag = %d } <Time> : %s ****************\n\n",recv_count,head.src,head.dst,head.dstModule,head.keyAction,head.msgTag,os.date("%X")))

	local type,name,data,respond_func,session=host:dispatch(msg)
	debug("type = "..tostring(type).."\n")
	-- debug("session = "..tostring(session).."\n")
	if type == "REQUEST"
	then
	debug("name = "..tostring(name).."\n")
	else
	debug("session = "..tostring(name).."\n")
	end

	if next(data) ~= nil
	then
		debug("{\n")
		for k,v in pairs(data) do
			debug("\t",tostring(k)," = ",tostring(v),"\n")
		end
		debug("}")
    end
	debug("\n\n")
end



function jpack.createPackage(type,data,srcEndPoint, dstEndPoint, dstModule, keyAction)
	local  head = {}
	head.msgTag = h.MSG_HEAD_TAG
	head.src = srcEndPoint
	head.dst = dstEndPoint
	head.dstModule = dstModule
	head.keyAction = keyAction
	-- h5客户端那边需要，正式服一定要同步 add by sikun
	-- head.rawMsgSize = #msg

	--打印要发的消息
	
	return {head,type,data}
end

local  g_count = 0

function jpack.sendPackage(t)
	local head = t[1]
	local mtype = t[2]
	local data = t[3]
local  msg = request(mtype,data,g_count)
	g_count = g_count +1
local pack = word2String(head.msgTag)
	pack = pack..word2String(head.src)
	pack = pack..word2String(head.dst)
	pack = pack..word2String(head.dstModule)
	pack = pack..word2String(head.keyAction)
	pack=pack .. msg
	pack=crypt.aesencode(pack,PASSWD,"")

	print_send_package(pack)
	local package = string.pack(">s2", pack)
	socket.send(jpack.sFd, package)
end



function jpack.recPackage()
	local msg
	local sz
	local r = socket.recv(jpack.sFd)
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
		msgHead.src = stringGetWord(string.sub(msg,3,4))
		msgHead.dst = stringGetWord(string.sub(msg,5,6))
		msgHead.dstModule = stringGetWord(string.sub(msg,7,8))
		msgHead.keyAction = stringGetWord(string.sub(msg,9,10))
		msg = string.sub(msg, 11, sz)
		sz = sz - 10
	else
		print("recv Tag is erro!")
	end
	
	print_rec_package(msgHead,msg)
end

function jpack.init(sFd,file) --socket, 发送file, 接收file
	jpack.sFd = sFd
	jpack.file = file
end

return jpack


