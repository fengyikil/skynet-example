-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"
local manager = require "skynet.manager"

-- 这里可以编写各种服务处理函数
function test( )
	print("Service2 call")
	local ret=skynet.call("SEV1", "lua", "hello1","hello2","hello3") 
	print("Service2 ret is :"..ret.."\n")
	skynet.timeout(100, test) 
end
skynet.start(function()
	print("==========Service2 Start=========")
        -- 这里可以编写服务代码，使用skynet.dispatch消息分发到各个服务处理函数（后续例子再说）
        skynet.dispatch("lua", function(...)
            args={...}
            print("Service2: rec args num: " .. #args)
        	end)

        skynet.timeout(100, test) 
        manager.register("SEV2")

        end)
