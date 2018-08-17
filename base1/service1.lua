-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"
local manager = require "skynet.manager"

skynet.register_protocol {
  name = "mymsg",
  id = skynet.PTYPE_TEXT,
 -- pack = function(m) return tostring(m) end,
   pack = function(...) return ... end,

  unpack = skynet.tostring,
}  

-- 这里可以编写各种服务处理函数
skynet.start(function()
	print("==========Service1 Start=========")
        skynet.dispatch("lua", function(session, address, msg1,msg2,msg3,...)
        	print("session  is :"..session.."\t address is "..address)
        	print("Service1 rec is :",msg1,msg2,msg3)
        	skynet.ret(skynet.pack("xxxx"))
        	end)

        skynet.dispatch("mymsg", function(session, address, msg1,msg2,msg3,...)
        	print("mymsg session  is :"..session.."\t address is "..address)
        	print("mymsg Service1 rec is :",msg1,msg2,msg3)
        	skynet.ret(skynet.pack("xxxx"))
        	end)
        manager.register("ssss")
end)
