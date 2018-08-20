package.cpath = "luaclib/?.so;skynet-example/simulation_client/luaclib/?.so"
package.path = "lualib/?.lua;skynet-example/simulation_client/?.lua;"
local socket = require "client.socket"
local jpack = require "jpack"
local PASSWD = "LK_GLZP_2015"
local sfd = assert(socket.connect("127.0.0.1", 8888))
local file = io.open("./srMsg","w")
jpack.init(sfd,file)
local jmsg = require "jmsg"
jmsg.init(jpack)
local jtime = require "jtime"


jtime.createTime("heart",jpack.sendPackage,jmsg["heart"],1,10*1000)

print("Please input cmd:")
while true do
	--print(" while start")
	socket.usleep(100*1000)
	-- 接收服务器返回消息
	 jpack.recPackage()
	-- 读取用户输入消息
	local readstr = socket.readstdin()
	if readstr then
		if readstr == "exit" then
			os.exit()
		elseif jmsg[readstr] == nil then
			print("Cannot find the cmd!,Please input right cmd:")
		else
	
			-- for k,v in pairs(jmsg[readstr]) do
			-- 	print(k,v)
			-- end
			jpack.sendPackage(jmsg[readstr])
			print("please input next cmd:")
		end
	end
	jtime.exec()
end
