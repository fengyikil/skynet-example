-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"
local manager = require "skynet.manager"
-- 这里可以编写各种服务处理函数
skynet.start(function()
	print("==========Service1 Start=========")
        skynet.dispatch("lua", function(session, address, msg1,msg2,msg3,...)
        	print("session  is :"..session.."\t address is "..address)
        	print("Service1 rec is :",msg1,msg2,msg3)
        	skynet.ret(skynet.pack("xxxx"))
        	end)
        manager.register("ssss")
end)
