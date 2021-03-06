local skynet = require "skynet"

-- 启动服务(启动函数)
skynet.start(function()
    -- 启动函数里调用Skynet API开发各种服务
    print("======Server start=======")
    -- skynet.newservice(name, ...)启动一个新的 Lua 服务(服务脚本文件名)
    print("main slef is",skynet.self()) -- 返回当前服务的地址
    s1  = skynet.newservice("service1")

   local ret = skynet.call(s1,"lua","1","2","3")  
   print("main ret is :"..ret)

   local ret = skynet.call(s1,"lua","4","5","6")  
   print("main ret is :"..ret)
    -- 退出当前的服务
    -- skynet.exit 之后的代码都不会被运行。而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。
    skynet.exit()
    end)
