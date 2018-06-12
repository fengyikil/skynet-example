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
    skynet.error(string.format("[cluste2 MSG] cluster2Sever get a request: %s", str))
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd], cmd .. "not found")
       -- f(...) -- suggest use skynet.retpack,it will auto response
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