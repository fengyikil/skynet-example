-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"

-- 这里可以编写各种服务处理函数
function test( )
	print("Service2 send")
	--skynet.send("ssss", "lua", "hello")
	local ret=skynet.call("ssss", "lua", "hello1","hello2","hello3")
	print("ret is :"..ret)
	skynet.timeout(100, test) 
end
skynet.start(function()
	print("==========Service2 Start=========")
        -- 这里可以编写服务代码，使用skynet.dispatch消息分发到各个服务处理函数（后续例子再说）
         skynet.dispatch("lua", function(msg,...)
        	print("Service2 rec is"..msg)
        	
        	end)

        skynet.timeout(100, test) 

        end)
