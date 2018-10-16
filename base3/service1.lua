-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"
local manager = require "skynet.manager"
skynet.register_protocol {
  name = "mymsg",
  id = skynet.PTYPE_TEXT,
  pack = function(...) 
            local args={...}
            local data = ""
            for k,v in pairs(args) do
              data=data..v
             end
          return  data
        end,
  unpack = skynet.tostring,
} 


-- 这里可以编写各种服务处理函数
skynet.start(function()
	print("==========Service1 Start=========")
        skynet.dispatch("mymsg", function(session, address, msg)
        	print("mymsg session  is :"..session.."\t address is "..address)
        	print("mymsg Service1 rec is :",msg)
        	skynet.ret(skynet.pack("xxxx"))
        	end)
        manager.register("ssss")
end)
