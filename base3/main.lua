local skynet = require "skynet"

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


local lua_path = skynet.getenv("lua_path")
print("lua_path is ",lua_path)
print("package.path is ",package.path )

-- 启动服务(启动函数)
skynet.start(function()
    -- 启动函数里调用Skynet API开发各种服务
    print("======Server start=======")
    -- skynet.newservice(name, ...)启动一个新的 Lua 服务(服务脚本文件名)
    s1  = skynet.newservice("service1")

   local ret = skynet.call(s1,"mymsg","h1","jj")  
   print("main ret is :"..ret)

    -- 退出当前的服务
    -- skynet.exit 之后的代码都不会被运行。而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。
    skynet.exit()
    end)
