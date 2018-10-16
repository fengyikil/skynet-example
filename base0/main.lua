local skynet = require "skynet"

local lua_path = skynet.getenv("lua_path")
print("lua_path is ",lua_path)
print("package.path is ",package.path )
-- 启动服务(启动函数)
skynet.start(function()
    -- 启动函数里调用Skynet API开发各种服务
     print("main slef is",skynet.self()) -- 返回当前服务的地址
    -- 退出当前的服务
    -- skynet.exit 之后的代码都不会被运行。而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。
    skynet.exit()
    end)
