local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
require "skynet.manager"

function test( )
     skynet.timeout(100,test)
     cluster.call("cluster1", ".cluster1Server", "request", "clustr2Sever call cluster1server , please answer!!!")
end

local CMD = {}

function CMD.request(str)
    print("cluster2 rec :"..str)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
       local f=CMD[cmd]
        skynet.retpack(f(...))
    end)

    skynet.register(".cluster2Server")
    test()
    -- skynet.fork(function ()
    --         skynet.timeout(300,function ()
    --         print("hello")
    --         cluster.call("cluster1", ".cluster1Server", "request", "clustr2Sever call cluster1server , please answer!!!")            
    --     end)
    -- end)    
end)