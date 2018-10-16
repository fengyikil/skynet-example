local skynet = require "skynet"


function f1()
   print("f1 start")
end
function f2()
   print("f2 start")
   skynet.yield()
   print("f2 over")
end
function f3()
   print("f3 start")
   skynet.wait()
   print("f3 over")
end
-- 启动服务(启动函数)
skynet.start(function()
    -- 测试sleep
    print("======Server start sleep=======")
    skynet.sleep(200)
    print("======Server sleep over=======")
    -- 测试 fork
    skynet.fork(f1)
    skynet.sleep(1)
    print("main back from f1")
    -- 测试 yield
    skynet.fork(f2)
    skynet.yield()
    print("main back from f2")
    skynet.yield()
    print("main back from f2")
    -- 测试 wait wakeup
    co=skynet.fork(f3)
    skynet.yield()
    print("main back from f3")
    skynet.wakeup(co) --唤醒并不是立马执行，而是等本协程让出后才能执行。
    skynet.yield()
    print("main back from f3")
   --  -- 退出当前的服务
   --  -- skynet.exit 之后的代码都不会被运行。而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。
    skynet.exit()
    end)
