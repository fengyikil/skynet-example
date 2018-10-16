-- package.cpath = "luaclib/?.so;skynet-example/simulation_client/luaclib/?.so"
-- package.path = "lualib/?.lua;skynet-example/simulation_client/?.lua;"

-- package.cpath = "luaclib/?.so;/root/svn/glzp/dev/luaclib/?.so;"
-- package.path = "lualib/?.lua;/root/svn/glzp/dev/lualib/?.lua;skynet-example/simulation_client/?.lua;"

package.cpath = "luaclib/?.so;/root/svn/glzp/test/luaclib/?.so;"
package.path = "lualib/?.lua;/root/svn/glzp/test/lualib/?.lua;skynet-example/simulation_client/?.lua;"

local socket = require "client.socket"
local jpack = require "jpack"
local PASSWD = "LK_GLZP_2015"
local sfd = assert(socket.connect("127.0.0.1", 8888))
local file = io.open("skynet-example/simulation_client/client.log","w")
local jmsg = require "jmsg"
local jtime = require "jtime"

jpack.init(sfd,file)
jmsg.init(jpack)

--心跳消息定时发送
jtime.createTime("heart",jpack.sendPackage,jmsg["heart"],1,20*1000)

print("Please input cmd:")
while true do
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
			jpack.sendPackage(jmsg[readstr])
			print("please input next cmd:")
		end
	end
	jtime.exec()
end
