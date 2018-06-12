local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local cluster = require "cluster"
require "skynet.manager"
local CMD = {} --消息表
function CMD.request(str)
	print("cluster1 rec :"..str)
    cluster.call("cluster2", ".cluster2Server", "request", "cluster1Sever respone")
end
skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)   	   
        local f=CMD[cmd]
        skynet.retpack(f(...))
    end)
    skynet.register(".cluster1Server")
end)