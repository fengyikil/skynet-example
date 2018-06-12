local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
require "skynet.manager"
local CMD = {} --消息表
function CMD.request(str)
    skynet.error(string.format("[cluste1 MSG] cluster1Sever get a request: %s", str))
    cluster.call("cluster2", ".cluster2Server", "request", "cluster1Sever respone")
end
skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
    	    local args = { ... }
    		print(args[1])
        local f = assert(CMD[cmd], cmd .. "not found")
        skynet.retpack(f(...))
    end)
    skynet.register(".cluster1Server")
end)